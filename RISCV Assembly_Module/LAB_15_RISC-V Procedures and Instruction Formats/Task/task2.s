#Bubble Sort
.data
array:  .word 12, 5, 7, 3, 19, 1, 25, 8, 2, 10, 4, 15   # 12 elements
n:      .word 12                                        # array length

    .text
    .globl _start
_start:
    # load n into s0
    la   t0, n
    lw   s0, 0(t0)          # s0 = n (12)

    addi s2, s0, -1         # passes = n-1

outer_loop:
    blt  s2, x0, done_sort  # if passes < 0 -> done

    li   s1, 0              # i = 0

inner_loop:
    bge  s1, s2, next_pass  # if i >= passes -> break inner

    la   t1, array          # base address of array
    slli t2, s1, 2          # offset = i*4
    add  t3, t1, t2         # t3 = &array[i]

    lw   t4, 0(t3)          # t4 = array[i]
    lw   t5, 4(t3)          # t5 = array[i+1]

    ble  t4, t5, no_swap    # if array[i] <= array[i+1] -> skip swap

    # swap
    sw   t5, 0(t3)
    sw   t4, 4(t3)

no_swap:
    addi s1, s1, 1
    j    inner_loop

next_pass:
    addi s2, s2, -1
    j    outer_loop

done_sort:
    # nothing printed, results are in memory
    j    done_sort          # stop here 
