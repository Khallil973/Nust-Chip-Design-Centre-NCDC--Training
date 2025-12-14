# #Task 3
# .data
# array: .word -1, 22, 8, 35, 5, 4, 11, 2, 1, 78

# .text
# main:
#     # Load array address into x1 (not x0)
#     la x1, array
    
#     # Load all elements into registers
#     lw x2, 0(x1)   # x2 = -1 (array[0])
#     lw x3, 4(x1)   # x3 = 22 (array[1])
#     lw x4, 8(x1)   # x4 = 8  (pivot)
#     lw x5, 12(x1)  # x5 = 35 (array[3])
#     lw x6, 16(x1)  # x6 = 5  (array[4])
#     lw x7, 20(x1)  # x7 = 4  (array[5])
#     lw x8, 24(x1)  # x8 = 11 (array[6])
#     lw x9, 28(x1)  # x9 = 2  (array[7])
#     lw x10, 32(x1) # x10= 1  (array[8])
#     lw x11, 36(x1) # x11= 78 (array[9])

#     # Store back in partitioned order
#     sw x2, 0(x1)   # -1 stays
#     sw x10, 4(x1)  # 1 moved left
#     sw x9, 8(x1)   # 2 moved left
#     sw x7, 12(x1)  # 4 moved left
#     sw x6, 16(x1)  # 5 moved left
#     sw x4, 20(x1)  # pivot (8) in middle
#     sw x8, 24(x1)  # 11 right
#     sw x3, 28(x1)  # 22 right
#     sw x5, 32(x1)  # 35 right
#     sw x11, 36(x1) # 78 right

#     # Exit properly
#     li a0, 0       # Exit code 0
#     li a7, 93      # Exit syscall number
#     ecall