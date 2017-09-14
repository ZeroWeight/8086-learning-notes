DATA SEGMENT
KEEPIP DW 0
KEEPCS DW 0
DATA ENDS

STACK SEGMENT
    DB 100 DUP(?)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK
START: 

    MOV AX,DATA    
    MOV DS,AX
    MOV ES,AX
;设置8253工作方式
    MOV DX,293H
    MOV AL,00110111B
    OUT DX,AL
    
    MOV DX,290H
    MOV AL,90
    OUT DX,AL
    OUT DX,AL

;设置8255工作方式
    MOV DX,283H         ;设置控制字
    MOV AL,10000000B
    OUT DX,AL       

;修改中断矢量表
    MOV AH,35H                ;读出原中断矢量表信息
    MOV AL,0BH
    INT 21H
    MOV KEEPIP,BX            ;保存原中断矢量表信息
    MOV KEEPCS,ES
        
    PUSH DS                    ;修改中断矢量表
    MOV DX,OFFSET INTR
    MOV AX,SEG INTR
    MOV DS,AX
    MOV AH,25H
    MOV AL,0BH
    INT 21H
    POP DS
        
;打开IRQ3的屏蔽
    IN AL,21H
    AND AL,011110111B
    OUT 21H,AL           
    
    MOV BL,0
MAIN:                                   ;消息循环
    HLT
    MOV AH,1
    INT 16H            ;有键盘输入，则退出消息循环
    JNE EXIT
    JMP MAIN

EXIT:
;恢复IRQ3的屏蔽
    IN  AL,21H
    OR  AL,00001000B
    OUT 21H,AL
        
;恢复中断矢量表
    PUSH DS
    MOV DX,KEEPIP
    MOV AX,KEEPCS
    MOV DS,AX
    MOV AH,25H
    MOV AL,0BH
    INT 21H
    POP DS
    
    MOV AH,4CH                ;返回DOS
    INT 21H


;------------------中断服务子程序-----------------------
INTR PROC
;关掉两个管

    MOV DX,282H
    MOV AL,00H
    OUT DX,AL

    CMP BL,0
    JNZ OUT1
OUT0:
    MOV DX,280H
    MOV AL,3FH
    OUT DX,AL        ;A口输出
    MOV DX,282H
    MOV AL,01H
    OUT DX,AL
    MOV BL,1
    JMP END_INTR
OUT1:   
;输出1    
    MOV DX,280H
    MOV AL,06H
    OUT DX,AL
    MOV DX,282H
    MOV AL,02H
    OUT DX,AL
    MOV BL,0
    JMP END_INTR
 
END_INTR:
    MOV AL,20H                    ;发出EOI信号
    OUT 0A0H,AL
    OUT 20H,AL
IRET
INTR ENDP
;-----------------------------------------------------

CODE ENDS
END START    








