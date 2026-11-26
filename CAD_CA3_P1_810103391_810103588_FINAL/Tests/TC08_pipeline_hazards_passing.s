# TC08: Working pipeline forwarding, load-use stalls, branch/jump hazards -> PASS
        # EX/MEM and MEM/WB forwarding + double hazard priority
        addi  $a0, $zero, 10
        addi  $a0, $zero, 20
        add   $s0, $a0, $a0      # 40
        # Store data forwarding (dist 1) and base forwarding (dist 2)
        addi  $t0, $zero, 200
        addi  $t1, $zero, 0x33
        sw    $t1, 0($t0)        # dmem[50] = 0x33
        # Load-use stall -> ALU and SW
        lw    $s1, 0($zero)      # dmem[0] = 0x22
        add   $s2, $s1, $t1      # 0x22 + 0x33 = 0x55
        lw    $s3, 4($zero)      # 0x07
        sw    $s3, 4($t0)        # dmem[51] = 0x07
        # Loop using bne (non-consecutive branches)
        addi  $t2, $zero, 5
        addi  $s4, $zero, 0
    loop:
        add   $s4, $s4, $t2
        addi  $t2, $t2, -1
        bne   $t2, $zero, loop   # 5+4+3+2+1 = 15
        # JAL + JR
        jal   fn
        addi  $s5, $zero, 11
        halt
    fn:
        add   $s6, $ra, $zero
        jr    $ra
