.import utils.s

.text
main:
    # Allocate array of size 10 (40 bytes)
    li a0 40
    jal malloc
    mv t0 a0   # t0 = array pointer

    # Initialize counters
    li t1 0    # index counter
    li t2 10   # size limit

loop:
    # Check if we're done FIRST
    bge t1 t2 end_loop
    
    # Store 0 at current position (0(t0))
    sw x0 0(t0)
    
    # Increment pointer and index
    addi t0 t0 4
    addi t1 t1 1
    
    j loop

end_loop:
    # Exit
    li a0 0
    jal exit