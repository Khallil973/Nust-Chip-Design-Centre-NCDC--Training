.globl f

f:
    # Input: a0 = x value (-3 to 3),  a1 = pointer to output array
    # Returns: f(x) in a0
    
    # Add 3 to convert input range (-3 to 3) to array indices (0 to 6)
    addi t0, a0, 3
    
    # Multiply index by 4 (size of each element) using shift
    slli t0, t0, 2
    
    # Load base address of function values array
    la t1, function_values
    
    # Calculate address of the function value
    add t1, t1, t0
    
    # Load the function value
    lw t2, 0(t1)
    
    # Store the result in output array
    sw t2, 0(a1)
    
    # Set return value
    mv a0, t2
    
    # Return
    jr ra

# Predefined function values
.data
function_values:
    .word  6    # f(-3)
    .word 61    # f(-2)
    .word 17    # f(-1)
    .word -38   # f(0)
    .word 19    # f(1)
    .word 42    # f(2)
    .word 5     # f(3)