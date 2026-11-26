# TC01: Baseline R-type, I-type arithmetic/comparison, and memory ops (no hazards) -> PASS
        addi  $t0, $zero, 15
        nop 5
        addi  $t1, $zero, -6
        nop 5
        add   $s0, $t0, $t1      # 9
        nop 5
        addu  $s1, $t0, $t1      # 9
        nop 5
        sub   $s2, $t0, $t1      # 21
        nop 5
        subu  $s3, $t1, $t0      # 0xffffffeb (-21)
        nop 5
        and   $s4, $t0, $t1      # 10
        nop 5
        or    $s5, $t0, $t1      # 0xffffffff (-1)
        nop 5
        xor   $s6, $t0, $t1      # 0xfffffff5 (-11)
        nop 5
        nor   $s7, $t0, $t1      # 0
        nop 5
        slt   $a0, $t1, $t0      # 1 (-6 < 15)
        nop 5
        sltu  $a1, $t1, $t0      # 0 (0xfffffffa < 15 unsigned)
        nop 5
        slti  $a2, $t1, -1       # 1 (-6 < -1)
        nop 5
        sltiu $a3, $t0, -1       # 1 (15 < 0xffffffff)
        nop 5
        lw    $v0, 0($zero)      # data50[0] = 0x22
        nop 5
        sw    $s2, 200($zero)    # dmem[50] = 21 (0x15)
        nop 5
        lw    $v1, 200($zero)    # 21 (0x15)
        nop 5
        halt
