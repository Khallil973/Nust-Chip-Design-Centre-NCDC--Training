.globl factorial

.data
n: .word 8      

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# Factorial function implementation
factorial:
    # Initialize result to 1 (handles 0! = 1 case)
    li t0, 1           # t0 = result (starts at 1)
    
    # Handle special case where n = 0 or 1
    li t1, 1           # t1 = 1 for comparison
    ble a0, t1, end    # if n <= 1, return 1
    
    # Initialize loop counter (i = 2)
    li t1, 2           # t1 = i = 2
    
fact_loop:
    mul t0, t0, t1     # result = result * i
    addi t1, t1, 1     # i = i + 1
    ble t1, a0, fact_loop # continue if i <= n
    
end:
    mv a0, t0          # move result to return register (a0)
    jr ra              # return to caller