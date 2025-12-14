.data

.text
.globl main

main:
    li a0, -6       # first number
    li a1, 4        # second number
    jal ra, multiply

    # Exit properly
    li a7, 10
    ecall           

multiply:
    add t0, a0, x0      # t0 = a
    add t1, a1, x0      # t1 = b
    addi a2, x0, 0      # result = 0
    addi t2, x0, 0      # negative flag = 0

    # Check if a is negative
    slt t3, t0, x0      # t3 = 1 if t0 < 0
    beq t3, x0, check_b
    sub t0, x0, t0      # a = -a
    xori t2, t2, 1      # toggle negative

check_b:
    # Check if b is negative
    slt t3, t1, x0      # t3 = 1 if t1 < 0
    beq t3, x0, loop_mul
    sub t1, x0, t1      # b = -b
    xori t2, t2, 1      # toggle negative

loop_mul:
    beq t1, x0, done_mul  # if b == 0, exit loop
    add a2, a2, t0      # result += a
    addi t1, t1, -1     # b--
    j loop_mul

done_mul:
    beq t2, x0, end_mul
    sub a2, x0, a2      # result = -result

end_mul:
    jr ra               # return to caller

