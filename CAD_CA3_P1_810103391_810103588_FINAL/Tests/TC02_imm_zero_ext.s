# TC02: Bug #1 - andi, ori, xori sign-extend instead of zero-extend -> FAIL
        addi  $t0, $zero, -1     # 0xffffffff
        nop 5
        addi  $t1, $zero, 0x1234 # 0x00001234
        nop 5
        andi  $s0, $t0, 0x8001   # expected 0x00008001, buggy: 0xffff8001
        nop 5
        ori   $s1, $t1, 0x8000   # expected 0x00009234, buggy: 0xffff9234
        nop 5
        xori  $s2, $t0, 0xffff   # expected 0xffff0000, buggy: 0x00000000
        nop 5
        andi  $s3, $t0, 0x7fff   # positive imm (bit15=0) -> 0x00007fff (PASS)
        nop 5
        halt
