    sst #0f0h
    mov R1, #0ffh
    mov R2, #03h

    inc #06h    ;保存符号位
    mov R3, #080h
    mov A, R1
    and A, R3
    mov R3, A   ;被乘数的符号位
    jz  c1ok    ;不需要去补码
    mov A, R1
    mov R1, #01h
    not A
    add A, R1
    mov R1, A
c1ok:
    push R3
    mov R3, #080h
    mov A, R2
    and A, R3
    jz  c2ok    ;不需要取补
    mov A, R2
    mov R2, #01h
    not A
    add A, R2
    mov R2, A
c2ok:
    pop R3
    add A, R3   ;符号位相加,0+0=0,1+1=0,0+1=1+0=1
    mov R3, A
    push R3     ;保护符号位
    sst #f0h    ;恢复栈地址

mymul:
    test R1
    jz  mulZero ;乘以0直接结束

    mov R0, #00h
    push R0
    inc #01h
    push R1
    inc #01h
    mov R1, #00h    ;清零结果单元

    test R2
    jz  mulZero ;乘0
calc:
    test R2
    jz  mend
    mov A, R2
    and A, #01h
    jz  change
    dec #01h
    pop R3
    mov A, R1
    add A, R3
    mov R1, A
    dec #01h
    pop R3
    mov A, R0
    adc A, R3
    mov R0, A
    inc #02h ;复位
change:
    dec #01h;找到低8位
    pop R3  ;出栈低8位
    rl  R3  ;左移
    push R3 ;压栈
    dec #01h  ;栈指针下移
    pop R3  ;出栈高8位
    rlc R3  ;带进位左移
    push R3 ;压栈高8位
    inc #02h ;栈顶指向低8位
    rr  R2  ;乘数右移
    jmp calc

mulZero:
    mov R0, #00h
    mov R1, #00h
    jmp over

mend:
    sst #0f0h
    inc #06h
    pop R3
    mov A, R3
    and A, #80h
    jz  over    ;符号位为0则结束
    mov A, R1
    not A
    mov R1, A
    mov A, R0
    not A
    mov R0, A   ;取反
    mov A, R1
    mov R1, #01h
    add A, R1
    mov R1, A
    mov A, R0
    mov R0, #00h
    adc A, R0
    mov R0, A
over:
    end
