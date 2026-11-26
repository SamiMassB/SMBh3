# TC04: Bug #3 - sll, srl, sra ignore shamt and shift by rs[4:0] (=0) -> FAIL
        # Build 0x80000015 cleanly using sllv (without lui)
        addi  $t0, $zero, 1
        nop 5
        addi  $t1, $zero, 31
        nop 5
        sllv  $t2, $t0, $t1      # 0x80000000
        nop 5
        ori   $t2, $t2, 0x0015   # 0x80000015
        nop 5
        addi  $t3, $zero, 4
        nop 5
        # Fixed shifts (all fail, output 0x80000015 unchanged)
        sll   $s0, $t2, 4        # expected 0x00000150
        nop 5
        srl   $s1, $t2, 4        # expected 0x08000001
        nop 5
        sra   $s2, $t2, 4        # expected 0xf8000001
        nop 5
        sra   $s3, $t2, 31       # expected 0xffffffff
        nop 5
        # Variable shifts (all pass!)
        sllv  $s4, $t2, $t3      # 0x00000150
        nop 5
        srlv  $s5, $t2, $t3      # 0x08000001
        nop 5
        srav  $s6, $t2, $t3      # 0xf8000001
        nop 5
        halt
