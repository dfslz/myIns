    mov R0, #10h
    mov R1, #00h    ;被除数16位
    mov R2, #0ffh    ;除数8位
    mov R3, #08h    ;用于判断除法是否结束
    mov A, R0
    sub A, R2
    jc  lp
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
    jmp dend

dend:
    end
