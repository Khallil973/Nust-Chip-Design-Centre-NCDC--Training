# # #Excercise 2

# # #Task 1
# .data
# byte_arr: .byte 0x01, 0x02, 0x03, 0x04, 0x05
# word_arr: .word 0, 0, 0, 0, 0

# .text
# main:
#     la   a0, byte_arr   
#     la   a1, word_arr

#     # Convert byte[0] to word[0]
#     lb   t0, 0(a0)        # Sign-extend byte
#     sw   t0, 0(a1)        # Store word

#     # Convert byte[1] to word[1]
#     lb   t0, 1(a0)
#     sw   t0, 4(a1)

#     # Convert byte[2] to word[2]
#     lb   t0, 2(a0)
#     sw   t0, 8(a1)

#     # Convert byte[3] to word[3]
#     lb   t0, 3(a0)
#     sw   t0, 12(a1)

#     # Convert byte[4] to word[4]
#     lb   t0, 4(a0)
#     sw   t0, 16(a1)

#     # Exit
#     li   a7, 10
#     ecall
    
    
    
# #Task 2
# # Initialize registers with character values (ASCII codes)
# li a0, 's'        # a0 = 's' (0x73)
# li a1, 't'        # a1 = 't' (0x74)
# li a2, 'r'        # a2 = 'r' (0x72)
# li a3, 'i'        # a3 = 'i' (0x69)
# li a4, 'n'        # a3 = 'n' (0x6e)
# li a5, 'g'        # a3 = 'g' (0x67)

# # Convert to uppercase by subtracting 0x20
# addi a0, a0, -0x20  # 'S' (0x53)
# addi a1, a1, -0x20  # 'T' (0x54)
# addi a2, a2, -0x20  # 'R' (0x52)
# addi a3, a3, -0x20  # 'I' (0x49)
# addi a4, a4, -0x20  # 'N' (0x78)
# addi a5, a5, -0x20  # 'G' (0x71)

# # Store results in memory 
# #Store at address 0x100 
# li t0, 0x100       # Base address
# sb a0, 0(t0)       # Store 'S'
# sb a1, 1(t0)       # Store 'T'
# sb a2, 2(t0)       # Store 'R'
# sb a3, 3(t0)       # Store 'I'
# sb a4, 4(t0)       # Store 'N'
# sb a5, 5(t0)       # Store 'G'
# sb x0, 4(t0)       # Null

# # Exit
# li a7, 10
# ecall


#Task 3
# # Initialize registers with character values (ASCII codes)
# li a0, 's'        # a0 = 's' (0x73)
# li a1, 't'        # a1 = 't' (0x74)
# li a2, 'r'        # a2 = 'r' (0x72)
# li a3, 'i'        # a3 = 'i' (0x69)
# li a4, 'n'        # a4 = 'n' (0x6E)
# li a5, 'g'        # a5 = 'g' (0x67)

# # Convert to uppercase by subtracting 0x20
# addi a0, a0, -0x20  # 'S' (0x53)
# addi a1, a1, -0x20  # 'T' (0x54)
# addi a2, a2, -0x20  # 'R' (0x52)
# addi a3, a3, -0x20  # 'I' (0x49)
# addi a4, a4, -0x20  # 'N' (0x78)
# addi a5, a5, -0x20  # 'G' (0x71)

# # Store REVERSED in memory at address 0x100
# li t0, 0x100       # Base address
# sb a5, 0(t0)       # Store 'G' (last char first)
# sb a4, 1(t0)       # Store 'N'
# sb a3, 2(t0)       # Store 'I'
# sb a2, 3(t0)       # Store 'R'
# sb a1, 4(t0)       # Store 'T'
# sb a0, 5(t0)       # Store 'S' (first char last)
# sb x0, 6(t0)       # Null

# # Exit
# li a7, 10
# ecall




#Task 4
.data
arr: .word 5, 2, 7 

.text
main:
    # Load array address
    la t0, arr       

    # Load all 3 numbers
    lw a0, 0(t0)       # a0 = 5 (A)
    lw a1, 4(t0)       # a1 = 2 (B)
    lw a2, 8(t0)       # a2 = 7 (C)

    # Sorting Logic
    # Compare and swap A and B if A > B
    blt a0, a1, skip1  # Skip if A <= B
    mv t1, a0          # Swap A and B
    mv a0, a1
    mv a1, t1
skip1:

    # Compare and swap B and C if B > C
    blt a1, a2, skip2  # Skip if B <= C
    mv t1, a1          # Swap B and C
    mv a1, a2
    mv a2, t1
skip2:

    # Re-compare A and B (in case C was smallest)
    blt a0, a1, skip3  # Skip if A <= B
    mv t1, a0          # Swap A and B
    mv a0, a1
    mv a1, t1
skip3:

    # Store sorted numbers
    sw a0, 0(t0)       # Smallest (2)
    sw a1, 4(t0)       # Middle (5)
    sw a2, 8(t0)       # Largest (7)

    # Exit
    li a7, 10
    ecall