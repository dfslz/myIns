    mov R0, #00h
    mov R1, #06h    ;被除数16位
    mov R2, #02h    ;除数8位
    mov R3, #08h    ;用于判断除法是否结束
    ;保存符号位
    sst #0f6h
    inc #01h
    push R0
    mov A, R0
    mov R0, #80h
    and A, R0   ;取得R0符号位
    mov R0, A
    dec #01h
    push R0     ;压栈符号位
    dec #01h
    push R0     ;余数符号位
    inc #02h
    pop R0  ;恢复R0
    jz  c1ok    ;不需要对被除数取补
    mov A, R0
    not A
    mov R0, A
    mov A, R1
    not A
    mov R1, A   ;取反
    mov A, R1
    mov R1, #01h
    add A, R1
    mov R1, A
    mov A, R0
    mov R0, #00h
    adc A, R0
    mov R0, A   ;加一
c1ok:
    push R2 ;保护R2
    mov A, R2
    mov R2, #80h
    and A, R2
    sst #0f6h
    pop R2  ;取被除数符号位
    add A, R2
    mov R2, A;1+1=0,1+0=0+1=1,0+0=0
    push R2
    inc #01h
    pop R2  ;恢复R2
    mov A, R2
    and A, #80h
    jz  c2ok    ;不需要取补
    mov A, R2
    not A
    mov R2, #01h
    add A, R2
    mov R2, A   ;取补结束
c2ok:
    test R2
    jz  divZero
    mov A, R0
    sub A, R2
    jc  lp  ;有借位，不会溢出
    jmp overflow   ;被除数高8位大于除数，结果必定溢出
lp:
    mov A, R2
    sub A, R2
    ;上面两步只为清0进位
    rl  R1
    rlc R0
    jc  borrow  ;移位后有借位，必定大于除数
    mov A, R3
    mov R3, #01h
    sub A, R3
    mov R3, A   ;计数器减一
    mov A, R0
    sub A, R2
    jc  isOver  ;移位后没有借位，但是相减后有借位，必定小于除数
ok:
    mov A, R2
    sub A, R2
    ;上面两步也是清除进位
    mov A, R0
    sub A, R2
    mov R0, A
    mov A, R1
    or  A, #01h ;商1
    mov R1, A
    jmp isOver
isOver:
    test R3
    jz  dend    ;R3为0则除法结束
    jmp lp      ;未结束则重复循环

borrow: ;处理有借位的时候计数器依然需要减一
    mov A, R3
    mov R3, #01h
    sub A, R3
    mov R3, A
    jmp ok

overflow:
    mov R0, #0ffh
    mov R1, #0ffh
    jmp over

divZero:
    mov R0, #07fh
    mov R1, #07fh
    jmp over

dend:
    sst #0f6h
    pop R3
    test R3
    jz  remainder    ;结果为正数，不需要取补
    mov A, R1
    not A
    mov R1, A
    mov A, R1
    mov R1, #01h
    add A, R1
    mov R1, A
remainder:  ;处理余数符号位
    sst #0f5h
    pop R3
    test R3
    jz  over    ;余数为正
    mov A, R0
    mov R0, #01h
    not A
    add A, R0
    mov R0, A
over:
    end

