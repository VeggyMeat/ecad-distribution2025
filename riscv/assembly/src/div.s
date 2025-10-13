.macro DEBUG_PRINT reg
csrw 0x800, \reg
.endm
	
.text
.global div              # Export the symbol 'div' so we can call it from other files
.type div, @function
div:
    addi sp, sp, -32     # Allocate stack space

    # store any callee-saved register you might overwrite
    sw   ra, 28(sp)      # Function calls would overwrite
    sw   s0, 24(sp)      # If t0-t6 is not enough, can use s0-s11 if I save and restore them
    # ...

    # do your work
    li t0, 0 # number of bits in N
    mv t1, a0 # load dividend
    li t2, 0 # 0
    beq t1, t2, done_0 # if the dividend is 0 finish now
    beq a1, t2, done_0 # if the divisor is 0 finish now
count_length:
    addi t0, t0, 1 # add one to the number of bits
    srli t1, t1, 1 # half the dividend
    bne t1, t2, count_length # if dividend equal to 0 we've got the right count

    li t1, 0 # Q = 0
    li t2, 0 # R = 0
    li t3, 1 # 1
    li t4, -1 # -1
    srl t6, t3, t0 # mask equal to 1 with N 0s
loop:
    sub t0, t0, t3 # i -= 1
    beq t0, t4, done # if i == -1 then we're done
    slli t2, t2, 1 # R := R << 1
    slli t6, t6, 1 # mask right shifted one spot
    and t5, t6, a0 # get the ith bit of N
    srl t5, t5, t0 # shift it to the least significant bit
    add t2, t2, a5 # R(0) := R + N(i)
    blt t2, a1, loop # if R < D then continue
    sub t2, t2, a1 # R := R - D
    add t1, t1, t6 # Q(i) := 1
    beq t0, t0, loop # loop
done_0:
    li t1, 0 # Q = 0
    li t2, 0 # R = 0
done:
    mv a0, t1 # load return value Q
    mv a1, t2 # load return value R
    # load every register you stored above
    lw   ra, 28(sp)
    lw   s0, 24(sp)
    # ...
    addi sp, sp, 32      # Free up stack space
    ret

