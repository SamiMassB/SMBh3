# TC03: Bug #2 - lui fails to shift left by 16 bits and sign-extends imm -> FAIL
        lui   $s0, 0x0001        # expected 0x00010000, buggy: 0x00000001
        nop 5
        lui   $s1, 0x1234        # expected 0x12340000, buggy: 0x00001234
        nop 5
        lui   $s2, 0x7fff        # expected 0x7fff0000, buggy: 0x00007fff
        nop 5
        lui   $s3, 0x8000        # expected 0x80000000, buggy: 0xffff8000
        nop 5
        lui   $s4, 0xabcd        # expected 0xabcd0000, buggy: 0xffffabcd
        nop 5
        halt
