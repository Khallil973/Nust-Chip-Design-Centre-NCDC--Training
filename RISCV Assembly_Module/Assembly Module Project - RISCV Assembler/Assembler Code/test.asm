#addi x1, x0, 10
#addi x2, x0, 20
#add x3, x1, x2
#loop:
#addi x3, x3, -1
#bne x3, x0, loop


#addi x1, x0, 5       // counter = 5
#loop:
#addi x1, x1, -1
#bne x1, x0, loop


#addi x1, x0, 100
#jal x0, target
#addi x2, x0, 200   // should be skipped
#target:
#addi x3, x0, 300


#addi x1, x0, 1
#bne x1, x0, far
#addi x2, x0, 2
# Fill with many NOPs
#.rept 3000
#addi x0, x0, 0
#.endr
#far:
#addi x3, x0, 3


#addi x1, x0, 12
#jalr x0, x1, 0   // PC = x1


#beq x1, x2, FAR


# test_addi_min_max.asm
#addi x5, x0, -2048   # smallest valid imm
#addi x6, x0, 2047    # largest valid imm
#addi x7, x0, 0       # zero imm

main:
jal ra,boot
jal ra, multiply
jal x0, exit
boot:
jalr x0,ra,0
multiply:
jalr x0,ra,0
exit:
