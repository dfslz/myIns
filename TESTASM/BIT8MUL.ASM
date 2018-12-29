    sst #0f0h
    mov R1, #02h
    mov R2, #05h

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
    jmp mend

mend:
    end
