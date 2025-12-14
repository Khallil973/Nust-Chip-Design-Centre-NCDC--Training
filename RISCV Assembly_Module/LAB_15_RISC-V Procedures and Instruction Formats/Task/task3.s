
.data
array: .word -1, 22, 8, 35, 5, 4, 11, 2, 1, 78
length: .word 10

.text
.globl main

main:
    la a0, array        # Load array address
    li a1, 0            # low index = 0
    lw a2, length       # high index = length-1
    addi a2, a2, -1
    
    jal ra, quicksort   # Call quicksort
    
    # Exit program
    li a7, 10
    ecall

# QuickSort function
# a0: array address
# a1: low index
# a2: high index
quicksort:
    addi sp, sp, -16        # Allocate stack space
    sw ra, 0(sp)            # Save return address
    sw a1, 4(sp)            # Save low
    sw a2, 8(sp)            # Save high
    
    bge a1, a2, end_sort    # If low >= high, return
    
    jal ra, partition       # Call partition
    sw a0, 12(sp)          # Save pivot index
    
    # Recursive call for left partition
    lw a1, 4(sp)           # Load low
    lw a2, 12(sp)          # Load pivot index
    addi a2, a2, -1        # pivot_index - 1
    jal ra, quicksort
    
    # Recursive call for right partition
    lw a1, 12(sp)          # Load pivot index
    addi a1, a1, 1         # pivot_index + 1
    lw a2, 8(sp)           # Load high
    jal ra, quicksort
    
end_sort:
    lw ra, 0(sp)           # Restore return address
    addi sp, sp, 16        # Deallocate stack space
    ret

# Partition function
# a0: array address
# a1: low index
# a2: high index
# Returns: pivot index in a0
partition:
    # Calculate address of pivot (last element)
    slli t0, a2, 2         # high * 4 (word offset)
    add t0, a0, t0         # address of array[high]
    lw t1, 0(t0)           # t1 = pivot value
    
    addi t2, a1, -1        # i = low - 1 (smaller element index)
    mv t3, a1              # j = low (current element index)
    
partition_loop:
    bge t3, a2, end_partition_loop  # Exit if j >= high
    
    # Calculate address of array[j]
    slli t4, t3, 2         # j * 4
    add t4, a0, t4         # address of array[j]
    lw t5, 0(t4)           # t5 = array[j]
    
    bgt t5, t1, skip_swap  # If array[j] > pivot, skip
    
    addi t2, t2, 1         # i++
    
    # Swap array[i] and array[j]
    slli t6, t2, 2         # i * 4
    add t6, a0, t6         # address of array[i]
    lw t0, 0(t6)           # temp = array[i]
    sw t5, 0(t6)           # array[i] = array[j]
    sw t0, 0(t4)           # array[j] = temp
    
skip_swap:
    addi t3, t3, 1         # j++
    j partition_loop
    
end_partition_loop:
    # Swap array[i+1] and array[high] (pivot)
    addi t2, t2, 1         # i++
    slli t0, t2, 2         # i * 4
    add t0, a0, t0         # address of array[i]
    
    slli t3, a2, 2         # high * 4
    add t3, a0, t3         # address of array[high]
    
    lw t4, 0(t0)           # temp = array[i]
    lw t5, 0(t3)           # temp2 = array[high]
    sw t5, 0(t0)           # array[i] = array[high]
    sw t4, 0(t3)           # array[high] = temp
    
    mv a0, t2              # Return pivot index (i)
    ret