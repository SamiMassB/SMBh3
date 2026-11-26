# TC_ALL: One-shot diagnostic for all six Version 1 bugs plus regression signatures.
# Run once, then inspect shadow_dmem[60:78].
# Each bug writes a compact signature to data memory.
# The back-to-back branch test is intentionally last because the buggy CPU
# redirects to PC=0x04 and repeats the program. Earlier signatures remain valid.

        # Run counter: correct CPU leaves dmem[75]=1; buggy branch #5 makes it >1.
        addi  $k1, $zero, 0      # PC=0x00: executed only on initial entry
        addi  $k1, $k1, 1        # PC=0x04: repeated by bug #5
        add   $at, $zero, $zero
        sw    $k1, 300($zero)    # dmem[75] = run counter

        # Bug #1: logical immediates are sign-extended instead of zero-extended.
        addi  $t0, $zero, -1
        addi  $t1, $zero, 0x1234
        andi  $s0, $t0, 0x8001
        ori   $s1, $t1, 0x8000
        xori  $s2, $t0, 0xffff
        sw    $s0, 240($zero)    # dmem[60]: expected 00008001, buggy ffff8001
        sw    $s1, 244($zero)    # dmem[61]: expected 00009234, buggy ffff9234
        sw    $s2, 248($zero)    # dmem[62]: expected ffff0000, buggy 00000000

        # Bug #2: LUI does not shift the immediate left by 16.
        lui   $s0, 0x0001
        lui   $s1, 0x1234
        lui   $s2, 0x7fff
        lui   $s3, 0x8000
        lui   $s4, 0xabcd
        sw    $s0, 252($zero)    # dmem[63]
        sw    $s1, 256($zero)    # dmem[64]
        sw    $s2, 260($zero)    # dmem[65]
        sw    $s3, 264($zero)    # dmem[66]
        sw    $s4, 268($zero)    # dmem[67]

        # Bug #3: fixed shifts ignore shamt; variable shifts remain healthy.
        addi  $t0, $zero, 1
        addi  $t1, $zero, 31
        sllv  $t2, $t0, $t1
        ori   $t2, $t2, 0x0015  # t2 = 80000015
        sll   $s0, $t2, 4
        srl   $s1, $t2, 4
        sra   $s2, $t2, 4
        sra   $s3, $t2, 31
        sw    $s0, 272($zero)    # dmem[68]: expected 00000150, buggy 80000015
        sw    $s1, 276($zero)    # dmem[69]: expected 08000001, buggy 80000015
        sw    $s2, 280($zero)    # dmem[70]: expected f8000001, buggy 80000015
        sw    $s3, 284($zero)    # dmem[71]: expected ffffffff, buggy 80000015

        # Bug #4: WB-to-ID bypass leaks a write to $zero at distance 3.
        addi  $zero, $zero, 77
        add   $k0, $at, $at
        add   $k0, $at, $at
        addi  $s2, $zero, 0xaa
        sw    $s2, 288($zero)    # dmem[72]: expected 000000aa, buggy 000000f7
        add   $k0, $at, $at      # flush the transient $zero bypass condition
        add   $k0, $at, $at
        add   $k0, $at, $at
        add   $k0, $at, $at

        # Bug #6a: ALU result immediately consumed by JR. Both paths reconverge.
        addi  $t0, $zero, L_jr_wrong
        nop 4
        addi  $t0, $zero, L_jr_right
        jr    $t0
        addi  $s5, $zero, 0x0777 # must be flushed
    L_jr_wrong:
        addi  $s5, $zero, 0x0666 # buggy path
        j     L_jr_common
    L_jr_right:
        addi  $s5, $zero, 0x0055 # correct path
    L_jr_common:
        sw    $s5, 292($zero)    # dmem[73]: expected 00000055, buggy 00000666

        # Bug #6b: ALU result immediately consumed by JALR.
        addi  $t2, $zero, L_jalr_wrong
        addi  $t3, $zero, L_jalr_right
        nop 4
        add   $t2, $t3, $zero
        jalr  $s3, $t2
        addi  $s6, $zero, 0x0777 # must be flushed
    L_jalr_wrong:
        addi  $s6, $zero, 0x0666 # buggy path
        j     L_jalr_common
    L_jalr_right:
        addi  $s6, $zero, 0x0042 # correct path
    L_jalr_common:
        sw    $s6, 296($zero)    # dmem[74]: expected 00000042, buggy 00000666

        # Passing regression signatures: forwarding and load-use stall.
        addi  $a0, $zero, 10
        addi  $a0, $zero, 20
        add   $s0, $a0, $a0
        sw    $s0, 308($zero)    # dmem[77] = 00000028
        lw    $s1, 0($zero)      # data50[0] = 00000022
        add   $s2, $s1, $s0
        sw    $s2, 312($zero)    # dmem[78] = 0000004a

        # Bug #5 must be last: taken BEQ followed immediately by BEQ.
        addi  $t0, $zero, 4
        addi  $t1, $zero, 4
        nop 4
        beq   $t0, $t1, L_branch_ok
        beq   $t0, $zero, L_branch_bad
        addi  $s7, $zero, 0x0777 # must be flushed
    L_branch_ok:
        addi  $s7, $zero, 55
        sw    $s7, 304($zero)    # dmem[76]: expected 00000037, buggy stays 0
        halt
    L_branch_bad:
        addi  $s7, $zero, 999
        sw    $s7, 304($zero)
        halt
