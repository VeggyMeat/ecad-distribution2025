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
    li t0, 0      # Q
    li t1, 0      # R

    beq a0, x0, done   # if the dividend is 0 finish now
    beq a1, x0, done   # if the divisor is 0 finish now

    li t2, -1    # n = -1
    mv t3, a0    # T = N (dividend) -- we'll shift this down to count bits
count_length:
    addi t2, t2, 1   # n += 1
    srli t3, t3, 1    # T >>= 1
    bne t3, x0, count_length

loop:
    slli t1, t1, 1    # R <<= 1
    li  t4, 1
    sll t4, t4, t2   # mask = 1 << n
    and t5, a0, t4
    srl t5, t5, t2   # extract N[n]
    or  t1, t1, t5   # R[0] = N[n]
    bltu t1, a1, else # if R < D (unsigned) then skip subtraction
    sub t1, t1, a1   # R -= D
    or  t0, t0, t4   # Q[n] = 1
else:
    addi t2, t2, -1  # n -= 1
    bge t2, x0, loop # while n >= 0
done:
    mv a0, t0 # load return value Q
    mv a1, t1 # load return value R
    # load every register you stored above
    lw   ra, 28(sp)
    lw   s0, 24(sp)
    # ...
    addi sp, sp, 32      # Free up stack space
    ret

