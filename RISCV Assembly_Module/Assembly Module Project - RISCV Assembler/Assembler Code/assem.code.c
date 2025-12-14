#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>
#include <stdbool.h>

#define MAX_LINE_LENGTH 256
#define MAX_LABELS 1000
#define MAX_SYMBOLS 1000

// Instruction formats
typedef enum {
    R_TYPE, I_TYPE, S_TYPE, B_TYPE, U_TYPE, J_TYPE
} InstructionFormat;

// Symbol table entry
typedef struct {
    char name[50];
    uint32_t address;
} Symbol;

// Label table
typedef struct {
    char name[50];
    uint32_t address;
} Label;

// Assembler state
typedef struct {
    Symbol symbols[MAX_SYMBOLS];
    Label labels[MAX_LABELS];
    int symbol_count;
    int label_count;
    uint32_t current_address;
    bool in_data_section;
} AssemblerState;

// Function prototypes
int parse_immediate(const char *imm_str, AssemblerState *state);
void trim_whitespace(char *str);
void process_instruction(AssemblerState *state, char *line, uint32_t *output);
void first_pass(AssemblerState *state, FILE *input);
void second_pass(AssemblerState *state, FILE *input, FILE *output);
void trim_token(char *s);
int get_register_number(const char *reg_name);
bool is_assembler_directive(const char *directive);
void handle_assembler_directive(AssemblerState *state, char *line);

// Register names and their numbers
typedef struct {
    char name[10];
    int number;
} RegisterMapping;

RegisterMapping register_map[] = {
    {"x0", 0}, {"zero", 0},
    {"x1", 1}, {"ra", 1},
    {"x2", 2}, {"sp", 2},
    {"x3", 3}, {"gp", 3},
    {"x4", 4}, {"tp", 4},
    {"x5", 5}, {"t0", 5},
    {"x6", 6}, {"t1", 6},
    {"x7", 7}, {"t2", 7},
    {"x8", 8}, {"s0", 8}, {"fp", 8},
    {"x9", 9}, {"s1", 9},
    {"x10", 10}, {"a0", 10},
    {"x11", 11}, {"a1", 11},
    {"x12", 12}, {"a2", 12},
    {"x13", 13}, {"a3", 13},
    {"x14", 14}, {"a4", 14},
    {"x15", 15}, {"a5", 15},
    {"x16", 16}, {"a6", 16},
    {"x17", 17}, {"a7", 17},
    {"x18", 18}, {"s2", 18},
    {"x19", 19}, {"s3", 19},
    {"x20", 20}, {"s4", 20},
    {"x21", 21}, {"s5", 21},
    {"x22", 22}, {"s6", 22},
    {"x23", 23}, {"s7", 23},
    {"x24", 24}, {"s8", 24},
    {"x25", 25}, {"s9", 25},
    {"x26", 26}, {"s10", 26},
    {"x27", 27}, {"s11", 27},
    {"x28", 28}, {"t3", 28},
    {"x29", 29}, {"t4", 29},
    {"x30", 30}, {"t5", 30},
    {"x31", 31}, {"t6", 31}
};

int get_register_number(const char *reg_name) {
    for (int i = 0; i < (int)(sizeof(register_map) / sizeof(RegisterMapping)); i++) {
        if (strcmp(register_map[i].name, reg_name) == 0) {
            return register_map[i].number;
        }
    }
    return -1; // Not found
}

void trim_token(char *s) {
    if (!s) return;
    size_t len = strlen(s);
    size_t start = 0;
    while (start < len && isspace((unsigned char)s[start])) start++;
    size_t end = len;
    while (end > start && isspace((unsigned char)s[end - 1])) end--;
    size_t newlen = end - start;
    if (start > 0 && newlen > 0) memmove(s, s + start, newlen);
    s[newlen] = '\0';
}

uint32_t encode_r_type(uint8_t opcode, uint8_t funct3, uint8_t funct7,
                      uint8_t rd, uint8_t rs1, uint8_t rs2) {
    return ((uint32_t)funct7 << 25) | ((uint32_t)rs2 << 20) |
           ((uint32_t)rs1 << 15) | ((uint32_t)funct3 << 12) |
           ((uint32_t)rd << 7) | opcode;
}

uint32_t encode_i_type(uint8_t opcode, uint8_t funct3, uint8_t rd,
                      uint8_t rs1, int32_t imm) {
    uint32_t imm_11_0 = ((uint32_t)imm & 0xFFFu) << 20;
    return imm_11_0 | ((uint32_t)rs1 << 15) | ((uint32_t)funct3 << 12) |
           ((uint32_t)rd << 7) | opcode;
}

uint32_t encode_s_type(uint8_t opcode, uint8_t funct3, uint8_t rs1,
                      uint8_t rs2, int32_t imm) {
    uint32_t imm_11_5 = ((uint32_t)imm & 0xFE0u) << 20;
    uint32_t imm_4_0  = ((uint32_t)imm & 0x1Fu) << 7;
    return imm_11_5 | ((uint32_t)rs2 << 20) | ((uint32_t)rs1 << 15) |
           ((uint32_t)funct3 << 12) | imm_4_0 | opcode;
}

uint32_t encode_b_type(uint8_t opcode, uint8_t funct3, uint8_t rs1,
                      uint8_t rs2, int32_t imm) {
    // imm is byte offset relative to current PC; must be even (LSB=0)
    if (imm < -4096 || imm > 4094 || (imm & 0x1)) {
        fprintf(stderr, "Error: Branch offset 0x%x out of range or not aligned\n", imm);
        exit(EXIT_FAILURE);
    }
    uint32_t uimm = (uint32_t)imm;
    uint32_t imm_12   = (uimm & 0x1000u) >> 12;
    uint32_t imm_10_5 = (uimm & 0x07E0u) >> 5;
    uint32_t imm_4_1  = (uimm & 0x001Eu) >> 1;
    uint32_t imm_11   = (uimm & 0x0800u) >> 11;

    return (imm_12 << 31) | (imm_10_5 << 25) | ((uint32_t)rs2 << 20) |
           ((uint32_t)rs1 << 15) | ((uint32_t)funct3 << 12) |
           (imm_4_1 << 8) | (imm_11 << 7) | opcode;
}

uint32_t encode_u_type(uint8_t opcode, uint8_t rd, int32_t imm) {
    return ((uint32_t)imm & 0xFFFFF000u) | ((uint32_t)rd << 7) | opcode;
}

uint32_t encode_j_type(uint8_t opcode, uint8_t rd, int32_t imm) {
    if (imm < -1048576 || imm > 1048574 || (imm & 0x1)) {
        fprintf(stderr, "Error: Jump offset 0x%x out of range or not aligned\n", imm);
        exit(EXIT_FAILURE);
    }
    uint32_t uimm = (uint32_t)imm;
    uint32_t imm_20    = (uimm & 0x100000u) >> 20;
    uint32_t imm_10_1  = (uimm & 0x0007FEu) >> 1;
    uint32_t imm_11    = (uimm & 0x000800u) >> 11;
    uint32_t imm_19_12 = (uimm & 0x0FF000u) >> 12;

    return (imm_20 << 31) | (imm_10_1 << 21) | (imm_11 << 20) |
           (imm_19_12 << 12) | ((uint32_t)rd << 7) | opcode;
}

bool is_assembler_directive(const char *directive) {
    const char *directives[] = {
        ".text", ".data", ".bss", ".global", ".globl", ".section", 
        ".align", ".space", ".skip", ".word", ".half", ".byte", 
        ".ascii", ".asciz", ".string", ".include", ".macro",
        ".endm", ".if", ".else", ".endif", ".equ",
        ".set", ".extern", ".main", ".end", NULL
    };
    
    for (int i = 0; directives[i] != NULL; i++) {
        if (strcmp(directive, directives[i]) == 0) {
            return true;
        }
    }
    return false;
}

void handle_assembler_directive(AssemblerState *state, char *line) {
    char directive[32];
    
    char line_copy[MAX_LINE_LENGTH];
    strncpy(line_copy, line, MAX_LINE_LENGTH - 1);
    line_copy[MAX_LINE_LENGTH - 1] = '\0';
    
    if (sscanf(line_copy, "%31s", directive) != 1) {
        return; // Empty line or couldn't parse directive
    }
    
    // Remove any trailing colon from directive (if present)
    if (directive[strlen(directive)-1] == ':') {
        directive[strlen(directive)-1] = '\0';
    }
    
    if (strcmp(directive, ".data") == 0) {
        state->in_data_section = true;
        printf("Info: Switching to data section\n");
    } else if (strcmp(directive, ".text") == 0) {
        state->in_data_section = false;
        printf("Info: Switching to text section\n");
    } else if (strcmp(directive, ".global") == 0 || strcmp(directive, ".globl") == 0) {
        printf("Info: Found global directive: %s\n", line);
        // Global directives don't affect address
    } else if (strcmp(directive, ".main") == 0) {
        printf("Info: Found .main directive\n");
    } else if (strcmp(directive, ".word") == 0) {
        if (state->in_data_section) {
            // Count words by counting commas + 1
            int comma_count = 0;
            char *ptr = line_copy;
            while ((ptr = strchr(ptr, ',')) != NULL) {
                comma_count++;
                ptr++;
            }
            state->current_address += (comma_count + 1) * 4;
            printf("Info: .word directive - advancing by %d words\n", comma_count + 1);
        }
    } else {
        printf("Info: Found directive '%s' (not fully implemented)\n", directive);
    }
}

int parse_immediate(const char *imm_str, AssemblerState *state) {
    // Check if it's a label
    for (int i = 0; i < state->label_count; i++) {
        if (strcmp(state->labels[i].name, imm_str) == 0) {
            // For branches and jumps, calculate the offset from current address
            return (int)state->labels[i].address - (int)state->current_address;
        }
    }
    
    // Handle hexadecimal
    if (imm_str[0] == '0' && (imm_str[1] == 'x' || imm_str[1] == 'X')) {
        return (int)strtol(imm_str, NULL, 16);
    }
    
    // Handle decimal
    if (isdigit((unsigned char)imm_str[0]) || imm_str[0] == '-') {
        return atoi(imm_str);
    }

    fprintf(stderr, "Warning: Unknown label '%s', assuming 0 for now\n", imm_str);
    return 0;
}

void process_instruction(AssemblerState *state, char *line, uint32_t *output) {
 char mnemonic[16], rd[16], rs1[16], rs2[16], imm[32];
    int imm_val;

    // First check if this is an assembler directive
    char first_word[32];
    if (sscanf(line, "%31s", first_word) != 1) {
        fprintf(stderr, "Error: Could not parse line '%s'\n", line);
        exit(EXIT_FAILURE);
    }
    
    // Check if it's a directive (including those with dots)
    if (first_word[0] == '.' || is_assembler_directive(first_word)) {
        handle_assembler_directive(state, line);
        *output = 0; // No machine code for directives
        state->current_address += 0; // Don't advance address for directives
        return;
    }
    // Extract mnemonic
    if (sscanf(line, "%15s", mnemonic) != 1) {
        fprintf(stderr, "Error: Could not parse instruction '%s'\n", line);
        exit(EXIT_FAILURE);
    }

    // Handle jump instructions with labels
    if (strcmp(mnemonic, "jal") == 0) {
        // Parse: jal rd, label
        if (sscanf(line, "%*s %15[^,], %31s", rd, imm) == 2) {
            trim_token(rd); trim_token(imm);
            int rd_num = get_register_number(rd);
            if (rd_num < 0) {
                fprintf(stderr, "Error: Unknown register in '%s'\n", line);
                exit(EXIT_FAILURE);
            }
            imm_val = parse_immediate(imm, state);
            *output = encode_j_type(0x6F, rd_num, imm_val);
        }
        // Parse: jal label (pseudo-instruction, defaults to jal ra, label)
        else if (sscanf(line, "%*s %31s", imm) == 1) {
            trim_token(imm);
            int rd_num = get_register_number("ra");
            if (rd_num < 0) {
                fprintf(stderr, "Error: Unknown register 'ra'\n");
                exit(EXIT_FAILURE);
            }
            imm_val = parse_immediate(imm, state);
            *output = encode_j_type(0x6F, rd_num, imm_val);
        }
        else {
            fprintf(stderr, "Error: Invalid jal instruction format '%s'\n", line);
            exit(EXIT_FAILURE);
        }
    }
    // Handle branch instructions with labels
    else if (strcmp(mnemonic, "beq") == 0 || strcmp(mnemonic, "bne") == 0 ||
             strcmp(mnemonic, "blt") == 0 || strcmp(mnemonic, "bge") == 0 ||
             strcmp(mnemonic, "bltu") == 0 || strcmp(mnemonic, "bgeu") == 0) {
        
        if (sscanf(line, "%*s %15[^,], %15[^,], %31s", rs1, rs2, imm) == 3) {
            trim_token(rs1); trim_token(rs2); trim_token(imm);
            int rs1_num = get_register_number(rs1);
            int rs2_num = get_register_number(rs2);
            if (rs1_num < 0 || rs2_num < 0) {
                fprintf(stderr, "Error: Unknown register in '%s'\n", line);
                exit(EXIT_FAILURE);
            }
            imm_val = parse_immediate(imm, state);
            
            // Determine funct3 based on mnemonic
            uint8_t funct3 = 0;
            if (strcmp(mnemonic, "beq") == 0) funct3 = 0x0;
            else if (strcmp(mnemonic, "bne") == 0) funct3 = 0x1;
            else if (strcmp(mnemonic, "blt") == 0) funct3 = 0x4;
            else if (strcmp(mnemonic, "bge") == 0) funct3 = 0x5;
            else if (strcmp(mnemonic, "bltu") == 0) funct3 = 0x6;
            else if (strcmp(mnemonic, "bgeu") == 0) funct3 = 0x7;
            
            *output = encode_b_type(0x63, funct3, rs1_num, rs2_num, imm_val);
        }
        else {
            fprintf(stderr, "Error: Invalid branch instruction format '%s'\n", line);
            exit(EXIT_FAILURE);
        }
    }
    // Handle jalr instructions with labels
    else if (strcmp(mnemonic, "jalr") == 0) {
        // format: jalr rd, offset(rs1)
        if (sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rd, imm, rs1) == 3) {
            trim_token(rd); trim_token(rs1); trim_token(imm);
            int rd_num = get_register_number(rd);
            int rs1_num = get_register_number(rs1);
            if (rd_num < 0 || rs1_num < 0) {
                fprintf(stderr, "Error: Unknown register in '%s'\n", line);
                exit(EXIT_FAILURE);
            }
            imm_val = parse_immediate(imm, state);
            *output = encode_i_type(0x67, 0x0, rd_num, rs1_num, imm_val);
        }
        // format: jalr rd, rs1, offset (without parentheses)
        else if (sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {
            trim_token(rd); trim_token(rs1); trim_token(imm);
            int rd_num = get_register_number(rd);
            int rs1_num = get_register_number(rs1);
            if (rd_num < 0 || rs1_num < 0) {
                fprintf(stderr, "Error: Unknown register in '%s'\n", line);
                exit(EXIT_FAILURE);
            }
            imm_val = parse_immediate(imm, state);
            *output = encode_i_type(0x67, 0x0, rd_num, rs1_num, imm_val);
        }
        // format: jalr rs1 (defaults to jalr x1, rs1, 0)
        else if (sscanf(line, "%*s %15s", rs1) == 1) {
            trim_token(rs1);
            int rd_num = get_register_number("ra"); // Default to ra (x1)
            int rs1_num = get_register_number(rs1);
            if (rd_num < 0 || rs1_num < 0) {
                fprintf(stderr, "Error: Unknown register in '%s'\n", line);
                exit(EXIT_FAILURE);
            }
            imm_val = 0; // Default offset is 0
            *output = encode_i_type(0x67, 0x0, rd_num, rs1_num, imm_val);
        }
        else {
            fprintf(stderr, "Error: Invalid jalr instruction format '%s'\n", line);
            exit(EXIT_FAILURE);
        }
    }
    // Handle call instructions (pseudo-instruction for jal ra, label)
    else if (strcmp(mnemonic, "call") == 0) {
        if (sscanf(line, "%*s %31s", imm) == 1) {
            trim_token(imm);
            int rd_num = get_register_number("ra");
            if (rd_num < 0) {
                fprintf(stderr, "Error: Unknown register 'ra'\n");
                exit(EXIT_FAILURE);
            }
            imm_val = parse_immediate(imm, state);
            *output = encode_j_type(0x6F, rd_num, imm_val);
        }
        else {
            fprintf(stderr, "Error: Invalid call instruction format '%s'\n", line);
            exit(EXIT_FAILURE);
        }
    }
    // Handle ret instructions (pseudo-instruction for jalr x0, ra, 0)
    else if (strcmp(mnemonic, "ret") == 0) {
        int rd_num = 0; // x0
        int rs1_num = get_register_number("ra");
        if (rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register 'ra'\n");
            exit(EXIT_FAILURE);
        }
        imm_val = 0;
        *output = encode_i_type(0x67, 0x0, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: addi ----
    else if (strcmp(mnemonic, "addi") == 0 &&
        sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for I-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x0, rd_num, rs1_num, imm_val);
    }
    // ---- R-type: add ----
    else if (strcmp(mnemonic, "add") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x0, 0x00, rd_num, rs1_num, rs2_num);
    }
    // ---- R-type: sub ----
    else if (strcmp(mnemonic, "sub") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x0, 0x20, rd_num, rs1_num, rs2_num);
    }
    // ---- I-type: lw ----
    else if (strcmp(mnemonic, "lw") == 0 &&
             sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rd, imm, rs1) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        *output = encode_i_type(0x03, 0x2, rd_num, rs1_num, imm_val);
    }
    // ---- S-type: sw ----
    else if (strcmp(mnemonic, "sw") == 0 &&
             sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rs2, imm, rs1) == 3) {

        trim_token(rs2); trim_token(rs1); trim_token(imm);
        int rs2_num = get_register_number(rs2);
        int rs1_num = get_register_number(rs1);
        if (rs2_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for S-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_s_type(0x23, 0x2, rs1_num, rs2_num, imm_val);
    }
    // ---- U-type: lui ----
    else if (strcmp(mnemonic, "lui") == 0 &&
             sscanf(line, "%*s %15[^,], %31s", rd, imm) == 2) {
        trim_token(rd); trim_token(imm);
        int rd_num = get_register_number(rd);
        if (rd_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        *output = encode_u_type(0x37, rd_num, imm_val << 12);
    }
    // ---- U-type: auipc ----
    else if (strcmp(mnemonic, "auipc") == 0 &&
             sscanf(line, "%*s %15[^,], %31s", rd, imm) == 2) {
        trim_token(rd); trim_token(imm);
        int rd_num = get_register_number(rd);
        if (rd_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        *output = encode_u_type(0x17, rd_num, imm_val << 12);
    }
    // ---- R-type: and ----
    else if (strcmp(mnemonic, "and") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x7, 0x00, rd_num, rs1_num, rs2_num);
    }
    // ---- R-type: or ----
    else if (strcmp(mnemonic, "or") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x6, 0x00, rd_num, rs1_num, rs2_num);
    }
        // ---- R-type: xor ----
    else if (strcmp(mnemonic, "xor") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x4, 0x00, rd_num, rs1_num, rs2_num);
    }
    // ---- I-type: andi ----
    else if (strcmp(mnemonic, "andi") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for I-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x7, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: ori ----
    else if (strcmp(mnemonic, "ori") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for I-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x6, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: xori ----
    else if (strcmp(mnemonic, "xori") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for I-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x4, rd_num, rs1_num, imm_val);
    }
    // ---- R-type: sll ----
    else if (strcmp(mnemonic, "sll") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x1, 0x00, rd_num, rs1_num, rs2_num);
    }
    // ---- R-type: srl ----
    else if (strcmp(mnemonic, "srl") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x5, 0x00, rd_num, rs1_num, rs2_num);
    }
    // ---- R-type: sra ----
    else if (strcmp(mnemonic, "sra") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x5, 0x20, rd_num, rs1_num, rs2_num);
    }
    // ---- I-type: slli ----
    else if (strcmp(mnemonic, "slli") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < 0 || imm_val > 31) {
            fprintf(stderr, "Error: Shift amount %d out of range (must be 0..31)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x1, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: srli ----
    else if (strcmp(mnemonic, "srli") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < 0 || imm_val > 31) {
            fprintf(stderr, "Error: Shift amount %d out of range (must be 0..31)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x5, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: srai ----
    else if (strcmp(mnemonic, "srai") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < 0 || imm_val > 31) {
            fprintf(stderr, "Error: Shift amount %d out of range (must be 0..31)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x5, rd_num, rs1_num, imm_val | 0x400); // Set bit 10 for srai
    }
    // ---- R-type: mul (M extension) ----
    else if (strcmp(mnemonic, "mul") == 0 &&
             sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x0, 0x01, rd_num, rs1_num, rs2_num);
    }
    // ---- S-type: sh (store halfword) ----
    else if (strcmp(mnemonic, "sh") == 0 &&
            sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rs2, imm, rs1) == 3) {

        trim_token(rs2); trim_token(rs1); trim_token(imm);
        int rs2_num = get_register_number(rs2);
        int rs1_num = get_register_number(rs1);
        if (rs2_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for S-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_s_type(0x23, 0x1, rs1_num, rs2_num, imm_val);
    }
    // ---- S-type: sb (store byte) ----
    else if (strcmp(mnemonic, "sb") == 0 &&
            sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rs2, imm, rs1) == 3) {

        trim_token(rs2); trim_token(rs1); trim_token(imm);
        int rs2_num = get_register_number(rs2);
        int rs1_num = get_register_number(rs1);
        if (rs2_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for S-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_s_type(0x23, 0x0, rs1_num, rs2_num, imm_val);
    }
    // ---- I-type: slti (set less than immediate) ----
    else if (strcmp(mnemonic, "slti") == 0 &&
            sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for I-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x2, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: sltiu (set less than immediate unsigned) ----
    else if (strcmp(mnemonic, "sltiu") == 0 &&
            sscanf(line, "%*s %15[^,], %15[^,], %31s", rd, rs1, imm) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        if (imm_val < -2048 || imm_val > 2047) {
            fprintf(stderr, "Error: Immediate %d out of range for I-type (must be -2048..2047)\n", imm_val);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x3, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: lh (load halfword) ----
    else if (strcmp(mnemonic, "lh") == 0 &&
            sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rd, imm, rs1) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        *output = encode_i_type(0x03, 0x1, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: lhu (load halfword unsigned) ----
    else if (strcmp(mnemonic, "lhu") == 0 &&
            sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rd, imm, rs1) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        *output = encode_i_type(0x03, 0x5, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: lb (load byte) ----
    else if (strcmp(mnemonic, "lb") == 0 &&
            sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rd, imm, rs1) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        *output = encode_i_type(0x03, 0x0, rd_num, rs1_num, imm_val);
    }
    // ---- I-type: lbu (load byte unsigned) ----
    else if (strcmp(mnemonic, "lbu") == 0 &&
            sscanf(line, "%*s %15[^,], %31[^(](%15[^)])", rd, imm, rs1) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(imm);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        *output = encode_i_type(0x03, 0x4, rd_num, rs1_num, imm_val);
    }
    // ---- R-type: slt (set less than) ----
    else if (strcmp(mnemonic, "slt") == 0 &&
            sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x2, 0x00, rd_num, rs1_num, rs2_num);
    }
    // ---- R-type: sltu (set less than unsigned) ----
    else if (strcmp(mnemonic, "sltu") == 0 &&
            sscanf(line, "%*s %15[^,], %15[^,], %15s", rd, rs1, rs2) == 3) {

        trim_token(rd); trim_token(rs1); trim_token(rs2);
        int rd_num  = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        int rs2_num = get_register_number(rs2);
        if (rd_num < 0 || rs1_num < 0 || rs2_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_r_type(0x33, 0x3, 0x00, rd_num, rs1_num, rs2_num);
    }
    // ---- Pseudo: nop (addi x0, x0, 0) ----
    else if (strcmp(mnemonic, "nop") == 0) {
        *output = encode_i_type(0x13, 0x0, 0, 0, 0);
    }
    // ---- Pseudo: li (load immediate) ----
    else if (strcmp(mnemonic, "li") == 0 &&
             sscanf(line, "%*s %15[^,], %31s", rd, imm) == 2) {
        trim_token(rd); trim_token(imm);
        int rd_num = get_register_number(rd);
        if (rd_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        imm_val = parse_immediate(imm, state);
        
        // For small immediates, use addi
        if (imm_val >= -2048 && imm_val <= 2047) {
            *output = encode_i_type(0x13, 0x0, rd_num, 0, imm_val);
        } 
        // For larger immediates, use lui + addi
        else {
            // This is a pseudo-instruction that requires two instructions
            // just use lui with the upper 20 bits
            fprintf(stderr, "Warning: li with large immediate not fully implemented, using lui only\n");
            *output = encode_u_type(0x37, rd_num, (imm_val & 0xFFFFF000));
        }
    }
    // ---- Pseudo: mv (move) ----
    else if (strcmp(mnemonic, "mv") == 0 &&
             sscanf(line, "%*s %15[^,], %15s", rd, rs1) == 2) {
        trim_token(rd); trim_token(rs1);
        int rd_num = get_register_number(rd);
        int rs1_num = get_register_number(rs1);
        if (rd_num < 0 || rs1_num < 0) {
            fprintf(stderr, "Error: Unknown register in '%s'\n", line);
            exit(EXIT_FAILURE);
        }
        *output = encode_i_type(0x13, 0x0, rd_num, rs1_num, 0);
    }

    else if (strcmp(mnemonic, "la") == 0) {
        // Parse: la rd, symbol
        if (sscanf(line, "%*s %15[^,], %31s", rd, imm) == 2) {
            trim_token(rd); trim_token(imm);
            int rd_num = get_register_number(rd);
            if (rd_num < 0) {
                fprintf(stderr, "Error: Unknown register in '%s'\n", line);
                exit(EXIT_FAILURE);
            }
            
            uint32_t label_address = 0x10000000; // Typical data section base address
            
            // Use lui + addi (not auipc) for absolute addresses
            uint32_t upper = (label_address + 0x800) >> 12;
            int32_t lower = label_address - (upper << 12);
            
            // Output lui instruction
            *output = encode_u_type(0x37, rd_num, upper << 12); // lui rd, upper
            printf("Info: la %s, %s -> lui x%d, 0x%x\n", rd, imm, rd_num, upper);
            
        } else {
            fprintf(stderr, "Error: Invalid la instruction format '%s'\n", line);
            exit(EXIT_FAILURE);
        }
    }

    else {
        fprintf(stderr, "Error: Unknown instruction '%s'\n", line);
        exit(EXIT_FAILURE);
    }

    state->current_address += 4;
}
void first_pass(AssemblerState *state, FILE *input) {
    char line[MAX_LINE_LENGTH];
    state->current_address = 0;
    state->label_count = 0;
    state->in_data_section = false;

    while (fgets(line, MAX_LINE_LENGTH, input)) {
        // Remove comments
        char *comment = strchr(line, '#');
        if (comment) *comment = '\0';

        trim_whitespace(line);
        if (line[0] == '\0') continue;

        // Check for assembler directives
        char first_word[32];
        if (sscanf(line, "%31s", first_word) == 1) {
            if (is_assembler_directive(first_word)) {
                handle_assembler_directive(state, line);
                continue;
            }
        }

        size_t L = strlen(line);
        if (L > 0 && line[L - 1] == ':') {
            // label - collect regardless of section
            line[L - 1] = '\0';
            trim_whitespace(line); // Remove any trailing whitespace
            
            if (state->label_count >= MAX_LABELS) {
                fprintf(stderr, "Error: Too many labels\n");
                exit(EXIT_FAILURE);
            }
            // store label
            strncpy(state->labels[state->label_count].name, line, sizeof(state->labels[0].name) - 1);
            state->labels[state->label_count].name[sizeof(state->labels[0].name) - 1] = '\0';
            state->labels[state->label_count].address = state->current_address;
            printf("Info: Collected label '%s' at address 0x%08X\n", 
                   state->labels[state->label_count].name, 
                   state->labels[state->label_count].address);
            state->label_count++;
   } else if (state->in_data_section) {
        // Data section - check for labels and handle data directives
        size_t L = strlen(line);
        if (L > 0 && line[L - 1] == ':') {
            // label in data section
            line[L - 1] = '\0';
            trim_whitespace(line);
            
            if (state->label_count >= MAX_LABELS) {
                fprintf(stderr, "Error: Too many labels\n");
                exit(EXIT_FAILURE);
            }
            strncpy(state->labels[state->label_count].name, line, sizeof(state->labels[0].name) - 1);
            state->labels[state->label_count].address = state->current_address;
            printf("Info: Collected data label '%s' at address 0x%08X\n", 
                   state->labels[state->label_count].name, 
                   state->labels[state->label_count].address);
            state->label_count++;
        }
        else if (strstr(line, ".word") == line) {
            // Handle .word directive
            int word_count = 1;
            char *ptr = strchr(line, ',');
            while (ptr != NULL) {
                word_count++;
                ptr = strchr(ptr + 1, ',');
            }
            state->current_address += word_count * 4;
        }

        } else {
            // instruction line in text section
            state->current_address += 4;
        }
    }
    // Debug: print all collected labels
    printf("\nLabels collected in first pass:\n");
    for (int i = 0; i < state->label_count; i++) {
        printf("  %s: 0x%08X\n", state->labels[i].name, state->labels[i].address);
    }
    printf("\n");
}

void second_pass(AssemblerState *state, FILE *input, FILE *output) {
    char line[MAX_LINE_LENGTH];
    state->current_address = 0;
    state->in_data_section = false;

    while (fgets(line, MAX_LINE_LENGTH, input)) {
        char *comment = strchr(line, '#');
        if (comment) *comment = '\0';

        trim_whitespace(line);
        if (line[0] == '\0') continue;

        // Check for assembler directives
        char first_word[32];
        if (sscanf(line, "%31s", first_word) == 1) {
            if (is_assembler_directive(first_word)) {
                handle_assembler_directive(state, line);
                continue;
            }
        }

        size_t L = strlen(line);
        if (L > 0 && line[L - 1] == ':') {
            continue;
        }

        if (state->in_data_section) {
            continue;
        }

        uint32_t machine_code;
        process_instruction(state, line, &machine_code);
        if (machine_code != 0) { // Only write non-zero machine code (skip directives)
            fwrite(&machine_code, sizeof(uint32_t), 1, output);
            printf("0x%08X  // %s\n", machine_code, line);
        }
    }
}

void trim_whitespace(char *str) {
    if (!str) return;
    size_t len = strlen(str);
    size_t start = 0;
    while (start < len && isspace((unsigned char)str[start])) start++;
    size_t end = len;
    while (end > start && isspace((unsigned char)str[end - 1])) end--;

    size_t newlen = end - start;
    if (start > 0 && newlen > 0) memmove(str, str + start, newlen);
    str[newlen] = '\0';
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input.asm> <output.bin>\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *input = fopen(argv[1], "r");
    if (!input) {
        perror("Error opening input file");
        return EXIT_FAILURE;
    }

    AssemblerState state = {0};

    // First pass - collect labels
    first_pass(&state, input);

    // Reset file pointer for second pass
    rewind(input);

    // Second pass - generate machine code
    FILE *output = fopen(argv[2], "wb");
    if (!output) {
        perror("Error opening output file");
        fclose(input);
        return EXIT_FAILURE;
    }

    second_pass(&state, input, output);

    fclose(input);
    fclose(output);

    printf("Assembly completed successfully.\n");
    return EXIT_SUCCESS;
}