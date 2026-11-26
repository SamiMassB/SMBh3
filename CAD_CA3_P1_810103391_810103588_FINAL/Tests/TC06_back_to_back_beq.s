# TC06: Bug #5 - Taken beq/bne immediately followed by beq redirects PC to 0x04 -> FAIL
        addi  $k0, $k0, 1        # PC = 0x00 (runs once)
        addi  $k1, $k1, 1        # PC = 0x04 (expected 1; buggy jumps here repeatedly!)
        addi  $t0, $zero, 4
        addi  $t1, $zero, 4
        nop 4
        beq   $t0, $t1, L_ok     # taken branch
        beq   $t0, $zero, L_bad  # flushed slot is beq (even NOT-taken triggers bug!)
        addi  $s0, $zero, 888    # flushed
    L_ok:
        addi  $s1, $zero, 55     # expected 55, buggy: never reached (0)
        halt
    L_bad:
        addi  $s2, $zero, 999
        halt
