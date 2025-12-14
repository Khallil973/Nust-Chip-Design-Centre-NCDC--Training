.data
msg_div: .asciiz "Division result done\n"

.text
.globl main

main:
    li a0, -17      # dividend
    li a1, 5        # divisor

    jal ra, divide   # call divide(a0, a1)

    # a2 = quotient
    # a3 = remainder
    li a7, 4         # syscall: print string
    la a0, msg_div
    ecall

    # Exit program
    li a7, 10
    ecall

divide:
    add t0, a0, x0      # dividend
    add t1, a1, x0      # divisor
    addi a2, x0, 0      # quotient = 0
    addi a3, x0, 0      # remainder = 0
    addi t2, x0, 0      # negative flag = 0

    # if (a0 < 0) → make positive
    slt t3, t0, x0
    beq t3, x0, check_div_b
    sub t0, x0, t0
    xori t2, t2, 1

check_div_b:
    slt t3, t1, x0
    beq t3, x0, div_loop
    sub t1, x0, t1
    xori t2, t2, 1

div_loop:
    slt t3, t0, t1      # if (t0 < t1) break
    bne t3, x0, div_done
    sub t0, t0, t1      # dividend -= divisor
    addi a2, a2, 1      # quotient++
    j div_loop

div_done:
    add a3, t0, x0      # remainder = leftover dividend
    beq t2, x0, div_end
    sub a2, x0, a2      # apply sign to quotient

div_end:
    jr ra
