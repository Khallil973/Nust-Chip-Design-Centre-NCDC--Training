.data
a: .word 56        # a
b: .word 98        # b
result: .word 0    # Memory location to store result

.text
.globl main

main:
    # Load addresses and values of a and b
    la t0, a        # Load address of a into t0
    lw t1, 0(t0)    # Load value of a into t1
    la t0, b        # Load address of b into t0
    lw t2, 0(t0)    # Load value of b into t2

loop:
    # Check if b == 0, if yes, exit loop
    beq t2, zero, end_loop
    
    # temp = b
    mv t3, t2       # t3 = temp = b
    
    # Calculate a % b using repeated subtraction
    mv t4, t1       # t4 = a (will become remainder)
    mv t5, t2       # t5 = b
mod_loop:
    blt t4, t5, mod_done  # If remainder < divisor, done
    sub t4, t4, t5        # Subtract divisor from remainder
    j mod_loop
mod_done:
    
    # b = a % b (which is now in t4)
    mv t2, t4
    
    # a = temp (which is in t3)
    mv t1, t3
    
    j loop          # Repeat the process

end_loop:
    # Store result (GCD is in t1)
    la t0, result
    sw t1, 0(t0)
    
    # Exit program
    li a7, 10
    ecall