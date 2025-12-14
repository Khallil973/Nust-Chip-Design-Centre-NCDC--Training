#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 255

#define MAX_LEN 16


struct tnode {
    struct tnode* left;   // used when in tree
    struct tnode* right;  // used when in tree
    int isleaf;
    char symbol;
};

struct code {
    int symbol;
    char strcode[MAX_LEN];
};

/* Global variable */
struct tnode* root = NULL;  // tree of symbols

/* Allocate a new tree node */
struct tnode* talloc() {
    struct tnode* p = (struct tnode*)malloc(sizeof(struct tnode));
    if (p != NULL) {
        p->left = p->right = NULL;
        p->symbol = 0;
        p->isleaf = 0;
    }
    return p;
}

/*
    Build the Huffman decoding tree from the symbol-code pairs
*/
void build_tree(FILE* fp) {
    char symbol;
    char strcode[MAX_LEN];
    int items_read;
    int i, len;
    struct tnode* curr = NULL;

    while (!feof(fp)) {
	items_read = fscanf(fp, "%c %15s\n", &symbol, strcode);

        if (items_read != 2) break;

        curr = root;
        len = strlen(strcode);

        for (i = 0; i < len; i++) {
            if (strcode[i] == '0') {
                if (curr->left == NULL) {
                    curr->left = talloc();
                }
                curr = curr->left;
            } else if (strcode[i] == '1') {
                if (curr->right == NULL) {
                    curr->right = talloc();
                }
                curr = curr->right;
            }
        }

        // Assign symbol at leaf
        curr->isleaf = 1;
        curr->symbol = symbol;
        printf("Inserted symbol: %c\n", symbol);
    }
}

/*
    Decode the encoded input using the tree and write output
*/
void decode(FILE* fin, FILE* fout) {
    char c;
    struct tnode* curr = root;

    while ((c = getc(fin)) != EOF) {
        if (c == '0') {
            curr = curr->left;
        } else if (c == '1') {
            curr = curr->right;
        }

        if (curr->isleaf) {
            fputc(curr->symbol, fout);
            curr = root;  // restart for next symbol
        }
    }
}

/*
    Free tree memory
*/
void freetree(struct tnode* root) {
    if (root == NULL)
        return;
    freetree(root->left);
    freetree(root->right);
    free(root);
}

int main() {
    const char* IN_FILE = "encoded.txt";
    const char* CODE_FILE = "code.txt";
    const char* OUT_FILE = "decoded.txt";
    FILE* fout;
    FILE* fin;

    // Allocate root
    root = talloc();

    // Build decoding tree
    fin = fopen(CODE_FILE, "r");
    if (!fin) {
        perror("Error opening code.txt");
        return 1;
    }
    build_tree(fin);
    fclose(fin);

    // Decode file
    fin = fopen(IN_FILE, "r");
    fout = fopen(OUT_FILE, "w");
    if (!fin || !fout) {
        perror("Error opening encoded.txt or decoded.txt");
        return 1;
    }
    decode(fin, fout);
    fclose(fin);
    fclose(fout);

    // Free resources
    freetree(root);

    return 0;
}
