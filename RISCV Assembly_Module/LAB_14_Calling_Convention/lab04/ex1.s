.globl pow inc_arr

.data
fail_message: .asciiz "%s test failed\n"
pow_string: .asciiz "pow"
inc_arr_string: .asciiz "inc_arr"

success_message: .asciiz "Tests passed.\n"
array:
    .word 1 2 3 4 5
exp_inc_array_result:
    .word 2 3 4 5 6

.text
main:
    li a0, 2
    li a1, 7
    jal ra pow
    li t0, 128
    beq a0, t0, next_test
    la a0, pow_string
    j failure

next_test:
    la a0, array
    li a1, 5
    jal ra inc_arr
    jal ra check_arr
    li a0, 4
    la a1, success_message
    ecall
    li a0, 10
    ecall

pow:
    addi sp, sp, -4
    sw s0, 0(sp)
    li s0, 1
pow_loop:
    beq a1, zero, pow_end
    mul s0, s0, a0
    addi a1, a1, -1
    j pow_loop
pow_end:
    mv a0, s0
    lw s0, 0(sp)
    addi sp, sp, 4
    jr ra

inc_arr:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    mv s0, a0
    mv s1, a1
    li t0, 0
inc_arr_loop:
    beq t0, s1, inc_arr_end
    slli t1, t0, 2
    add a0, s0, t1
    addi sp, sp, -4
    sw t0, 0(sp)
    jal ra helper_fn
    lw t0, 0(sp)
    addi sp, sp, 4
    addi t0, t0, 1
    j inc_arr_loop
inc_arr_end:
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    jr ra

helper_fn:
    addi sp, sp, -4
    sw s0, 0(sp)
    lw t1, 0(a0)
    addi s0, t1, 1
    sw s0, 0(a0)
    lw s0, 0(sp)
    addi sp, sp, 4
    jr ra

check_arr:
    la t0, exp_inc_array_result
    la t1, array
    addi t2, t1, 20
check_arr_loop:
    beq t1, t2, check_arr_end
    lw t3, 0(t0)
    lw t4, 0(t1)
    beq t3, t4, continue
    la a0, inc_arr_string
    j failure
continue:
    addi t0, t0, 4
    addi t1, t1, 4
    j check_arr_loop
check_arr_end:
    jr ra

failure:
    mv a3, a0
    li a0, 4
    la a1, fail_message
    ecall
    li a0, 10
    ecall
