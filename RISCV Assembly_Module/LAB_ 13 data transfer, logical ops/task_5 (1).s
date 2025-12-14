.data
num:    .word 0x12345678  # Default number to manipulate
bitpos: .word 3           # Default bit position (0-31)

.text
.globl main

main:
    # Load default values
    la t0, num
    lw t1, 0(t0)      # t1 = number
    la t0, bitpos
    lw t2, 0(t0)      # t2 = bit position

    
    # 1. Toggle bit (using XOR)
    li t3, 1
    sll t3, t3, t2    # Create mask
    xor t3, t1, t3    # Toggled result in t3

    # 2. Check bit (using AND)
    li t4, 1
    sll t4, t4, t2    # Create mask
    and t4, t1, t4    # result in t4 (0 or 1<<bitpos)

    # 3. Set bit (using OR)
    li t5, 1
    sll t5, t5, t2    # Create mask
    or t5, t1, t5     # Set result in t5

    # 4. Clear bit (using AND with NOT)
    li t6, 1
    sll t6, t6, t2    # Create mask
    not t6, t6        # Invert mask
    and t6, t1, t6    # Clear result in t6

    # Exit
    li a7, 10
    ecall