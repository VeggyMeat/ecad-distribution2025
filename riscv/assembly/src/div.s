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
    li t0, 0
    beq a1, zero, exit  # if divisor is 0, return 0
loop:
    sub a0, a0, a1  # a0 = a0 - a1
    blt t0, t1, exit 
    add t0, t0, 1 # t0 = t0 + 1
    beq a0, a0, loop
exit: 
    lw a1, 0(a0) # load remainder
    lw a0, 0(t0) # load quotient

    # load every register you stored above
    lw   ra, 28(sp)
    lw   s0, 24(sp)
    # ...
    addi sp, sp, 32      # Free up stack space
    ret

