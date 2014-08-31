%include "include/x86inc.asm"


;SECTION_RODATA


SECTION_TEXT


INIT_XMM
cglobal buildFinalMask_sse2, 8, 9, ?, s1p, s2p, m1p, dstp, stride, width, height, thresh, x
    dec threshd
    movd xmm4, threshd
    punpcklbw xmm4, xmm4
    punpcklwd xmm4, xmm4
    punpckldq xmm4, xmm4
    punpcklqdq xmm4, xmm4

    pxor xmm5, xmm5
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [s1pq + xq]
    movdqa xmm1, [s2pq + xq]
    movdqa xmm2, xmm0
    psubusb xmm0, xmm1
    psubusb xmm1, xmm2
    por xmm0, xmm1
    psubusb xmm0, xmm4
    pcmpeqb xmm0, xmm5
    pand xmm0, [m1pq + xq]
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add s1pq, strideq
    add s2pq, strideq
    add m1pq, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal absDiff_sse2, 6, 7, 3, srcp1, srcp2, dstp, stride, width, height, x
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [srcp1q + xq]
    movdqa xmm1, [srcp2q + xq]
    movdqa xmm2, xmm0
    psubusb xmm0, xmm1
    psubusb xmm1, xmm2
    por xmm0, xmm1
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add srcp1q, strideq
    add srcp2q, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal absDiffAndMinMask_sse2, 6, 7, 3, srcp1, srcp2, dstp, stride, width, height, x
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [srcp1q + xq]
    movdqa xmm1, [srcp2q + xq]
    movdqa xmm2, xmm0
    psubusb xmm0, xmm1
    psubusb xmm1, xmm2
    por xmm0, xmm1
    pminub xmm0, [dstpq + xq]
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add srcp1q, strideq
    add srcp2q, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal absDiffAndMinMaskThresh_sse2, 7, 8, 5, srcp1, srcp2, dstp, stride, width, height, thresh, x
    dec threshd
    movd xmm3, threshd
    punpcklbw xmm3, xmm3
    punpcklwd xmm3, xmm3
    punpckldq xmm3, xmm3
    punpcklqdq xmm3, xmm3

    pxor xmm4, xmm4
.yloop:
    xor xq, xq ; thresh/r6 could be reused instead
.xloop:
    movdqa xmm0, [srcp1q + xq]
    movdqa xmm1, [srcp2q + xq]
    movdqa xmm2, xmm0
    psubusb xmm0, xmm1
    psubusb xmm1, xmm2
    por xmm0, xmm1
    pminub xmm0, [dstpq + xq]
    psubusb xmm0, xmm3
    pcmpeqb xmm0, xmm4
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add srcp1q, strideq
    add srcp2q, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal checkOscillation5_sse2, 10, 11, 10, p2p, p1p, s1p, n1p, n2p, dstp, stride, width, height, thresh, x
    pxor xmm6, xmm6

    dec threshd
    movd xmm7, threshd
    punpcklbw xmm7, xmm7
    punpcklwd xmm7, xmm7
    punpckldq xmm7, xmm7
    punpcklqdq xmm7, xmm7

    pcmpeqb xmm9, xmm9
    psrlw xmm9, 15
    movdqa xmm8, xmm9
    psllw xmm8, 8
    por xmm9, xmm8
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [p2pq + xq]
    movdqa xmm2, [p1pq + xq]
    movdqa xmm1, xmm0
    movdqa xmm3, xmm2
    movdqa xmm8, [s1pq + xq]
    pminub xmm0, xmm8
    pmaxub xmm1, xmm8
    movdqa xmm8, [n1pq + xq]
    pminub xmm2, xmm8
    pmaxub xmm3, xmm8
    movdqa xmm8, [n2pq + xq]
    pminub xmm0, xmm8
    pmaxub xmm1, xmm8
    movdqa xmm4, xmm3
    movdqa xmm5, xmm1
    psubusb xmm4, xmm2
    psubusb xmm5, xmm0
    psubusb xmm4, xmm7
    psubusb xmm5, xmm7
    psubusb xmm2, xmm9
    psubusb xmm0, xmm9
    psubusb xmm1, xmm2
    psubusb xmm3, xmm0
    pcmpeqb xmm1, xmm6
    pcmpeqb xmm3, xmm6
    pcmpeqb xmm4, xmm6
    pcmpeqb xmm5, xmm6
    por xmm1, xmm3
    pand xmm4, xmm5
    pand xmm1, xmm4
    movdqa [dstpq + xq], xmm1
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add p2pq, strideq
    add p1pq, strideq
    add s1pq, strideq
    add n1pq, strideq
    add n2pq, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal calcAverages_sse2, 6, 7, 1, s1p, s2p, dstp, stride, width, height, x
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [s1pq + xq]
    pavgb xmm0, [s2pq + xq]
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add s1pq, strideq
    add s2pq, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal checkAvgOscCorrelation_sse2, 9, 10, 6, s1p, s2p, s3p, s4p, dstp, stride, width, height, thresh, x
    dec threshd
    movd xmm2, threshd
    punpcklbw xmm2, xmm2
    punpcklwd xmm2, xmm2
    punpckldq xmm2, xmm2
    punpcklqdq xmm2, xmm2

    pxor xmm3, xmm3
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm5, [s1pq + xq]
    movdqa xmm0, xmm5
    movdqa xmm1, xmm5
    movdqa xmm5, [s2pq + xq]
    pminub xmm0, xmm5
    pmaxub xmm1, xmm5
    movdqa xmm5, [s3pq + xq]
    pminub xmm0, xmm5
    pmaxub xmm1, xmm5
    movdqa xmm5, [s4pq + xq]
    pminub xmm0, xmm5
    pmaxub xmm1, xmm5
    psubusb xmm1, xmm0
    movdqa xmm4, [dstpq + xq]
    psubusb xmm1, xmm2
    pcmpeqb xmm1, xmm3
    pand xmm1, xmm4
    movdqa [dstpq + xq], xmm1
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add s1pq,strideq
    add s2pq,strideq
    add s3pq,strideq
    add s4pq,strideq
    add dstpq,strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal or3Masks_sse2, 7, 8, 1, s1p, s2p, s3p, dstp, stride, width, height, x
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [s1pq + xq]
    por xmm0, [s2pq + xq]
    por xmm0, [s3pq + xq]
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add s1pq, strideq
    add s2pq, strideq
    add s3pq, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal orAndMasks_sse2, 6, 7, 2, s1p, s2p, dstp, stride, width, height, x
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [s1pq + xq]
    movdqa xmm1, [dstpq + xq]
    pand xmm0, [s2pq + xq]
    por xmm1, xmm0
    movdqa [dstpq + xq], xmm1
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add s1pq, strideq
    add s2pq, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal andMasks_sse2, 6, 7, 1, s1p, s2p, dstp, stride, width, height, x
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [s1pq + xq]
    pand xmm0, [s2pq + xq]
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add s1pq, strideq
    add s2pq, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    RET


INIT_XMM
cglobal checkSceneChange_sse2, 6, 7, 3, s1p, s2p, height, width, stride, diffp, x
    pxor xmm1, xmm1
.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [s1pq + xq]
    psadbw xmm0, [s2pq + xq]
    paddq xmm1, xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add s1pq, strideq
    add s2pq, strideq
    dec heightq
    jnz .yloop

    movdqa xmm2, xmm1
    psrldq xmm1, 8
    paddq xmm2, xmm1
    movq [diffpq], xmm2

    RET


INIT_XMM
cglobal verticalBlur3_sse2, 5, 8, 8, srcp, dstp, stride, width, height, x, srcpp, srcnp
    mov srcppq, srcpq
    sub srcppq, strideq
    mov srcnpq, srcpq
    add srcnpq, strideq

    ; 0x0002, for rounding
    pcmpeqb xmm6, xmm6
    psrlw xmm6, 15
    psllw xmm6, 1

    pxor xmm7, xmm7

    xor xq, xq
.toploop:
    movdqa xmm0, [srcpq + xq]
    pavgb xmm0, [srcnpq + xq]
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .toploop

    add srcppq, strideq
    add srcpq, strideq
    add srcnpq, strideq
    add dstpq, strideq

    sub heightq, 2 ; the main loop processes 2 lines fewer than the height

.yloop:
    xor xq, xq
.xloop:
    movdqa xmm0, [srcppq + xq]
    movdqa xmm1, [srcpq + xq]
    movdqa xmm2, [srcnpq + xq]
    movdqa xmm3, xmm0
    movdqa xmm4, xmm1
    movdqa xmm5, xmm2
    punpcklbw xmm0, xmm7
    punpcklbw xmm1, xmm7
    punpcklbw xmm2, xmm7
    punpckhbw xmm3, xmm7
    punpckhbw xmm4, xmm7
    punpckhbw xmm5, xmm7
    ; add bottom to top
    paddw xmm0, xmm2
    paddw xmm3, xmm5
    ; multiply center by 2
    psllw xmm1, 1
    psllw xmm4, 1
    ; add center to sum
    paddw xmm0, xmm1
    paddw xmm3, xmm4
    ; add 2 to sum
    paddw xmm0, xmm6
    paddw xmm3, xmm6
    ; divide by 4
    psrlw xmm0, 2
    psrlw xmm3, 2
    packuswb xmm0, xmm3
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .xloop

    add srcppq, strideq
    add srcpq, strideq
    add srcnpq, strideq
    add dstpq, strideq
    dec heightq
    jnz .yloop

    xor xq, xq
.bottomloop:
    movdqa xmm0, [srcppq + xq]
    pavgb xmm0, [srcpq + xq]
    movdqa [dstpq + xq], xmm0
    add xq, 16
    cmp xq, widthq
    jl .bottomloop

    RET
