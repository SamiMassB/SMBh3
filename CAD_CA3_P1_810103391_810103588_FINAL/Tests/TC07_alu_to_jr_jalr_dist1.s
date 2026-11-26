# TC07: Bug #6 - ALU->jr / ALU->jalr at distance 1 fails to stall in ID -> FAIL
        addi  $t0, $zero, L_wrong
        addi  $t1, $zero, L_right
        nop 4
        # Test 1: addi -> jr (dist 1)
        addi  $t0, $zero, L_right
        jr    $t0                # expected jump to L_right, buggy jumps to L_wrong!
        addi  $s0, $zero, 888
    L_wrong:
        addi  $s1, $zero, 999    # buggy lands here!
        j     L_test2
    L_right:
        addi  $s2, $zero, 55     # expected 55
    L_test2:
        # Test 2: add -> jalr (dist 1) with $t2 preloaded to L_wrong2
        addi  $t2, $zero, L_wrong2
        addi  $t3, $zero, L_right2
        nop 4
        add   $t2, $t3, $zero
        jalr  $s3, $t2           # expected jump to L_right2, buggy jumps to L_wrong2!
        addi  $s4, $zero, 77
        halt
    L_wrong2:
        addi  $s5, $zero, 999    # buggy lands here!
        halt
    L_right2:
        addi  $s6, $zero, 66
        jr    $s3
