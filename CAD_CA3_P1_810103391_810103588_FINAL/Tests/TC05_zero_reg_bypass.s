# TC05: Bug #4 - WB->ID / RegisterFile bypass leaks writes to $zero at distance 3 -> FAIL
        # Part A: non-$zero filler at distance 1, 2, 3
        addi  $zero, $zero, 77
        addi  $s0, $zero, 0xaa   # dist 1 -> 0xaa (OK)
        nop 4
        addi  $zero, $zero, 77
        add   $k0, $k1, $k1
        addi  $s1, $zero, 0xaa   # dist 2 -> 0xaa (OK)
        nop 4
        addi  $zero, $zero, 77
        add   $k0, $k1, $k1
        add   $k0, $k1, $k1
        addi  $s2, $zero, 0xaa   # dist 3 (WB->ID) -> expected 0xaa, buggy: 77+0xaa = 0xf7!
        nop 4
        # Part B: nop filler (sll $zero,$zero,0) cascades 77 << (77 & 31) = 0x9a000 at nop 5!
        addi  $zero, $zero, 77
        nop 5
        addi  $s3, $zero, 0xaa   # expected 0xaa, buggy: 0x0009a0aa!
        nop 4
        # Part C: dist 3 into beq $zero causes false branch!
        addi  $t0, $zero, 5
        nop 4
        addi  $zero, $zero, 5
        add   $k0, $k1, $k1
        add   $k0, $k1, $k1
        beq   $zero, $t0, L_bad  # expected NOT taken ($zero=0 != 5), buggy: taken!
        addi  $s4, $zero, 1      # expected 1, buggy: 0
        halt
    L_bad:
        addi  $s5, $zero, 999    # expected 0, buggy: 999
        halt
