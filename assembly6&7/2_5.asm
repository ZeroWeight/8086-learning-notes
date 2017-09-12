;实验七内容二


DATA SEGMENT
SIG DB 0
KEEP_IP DW 0
KEEP_CS DW 0  
FLAG DB 0                        ;中断标志
DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS

MAIN PROC FAR
START:
    MOV AX,DATA
    MOV DS,AX

    
    MOV DX, 283H            ;初始化8255
    MOV AL, 10101000B              ;方式控制字，方式1，A口输入
    OUT DX, AL

    MOV DX, 283H
    MOV AL, 11001000B
    OUT DX, AL                     ;位控字，D4写入1，也就是INTEA写入1，允许中断
    
    
    MOV AH, 35H                 ;保护中断矢量 
    MOV AL, 0BH 
    INT 21H
    MOV KEEP_IP, BX                ;存放 IP值 
    MOV KEEP_CS, ES                ;存放 CS值 
    
    
   
    PUSH DS 
    MOV DX, OFFSET INTR             ;装载中断矢量 
    MOV AX, SEG INTR 
    MOV DS, AX 
    MOV AH, 25H   
    MOV AL, 0BH 
    INT 21H 
    POP DS 

    MOV AL, 0F7H                 ;清除对IRQ3的屏蔽 
    OUT 21H, AL

WAIT_FOR:    
    MOV BL, FLAG
    CMP BL, 1
    JZ ISINT                       ;有中断
    JMP WAIT_FOR
   
ISINT:                            ;响应中断之后步
    MOV FLAG, 0                    ;消除标志
    JMP WAIT_FOR                ;下一次循环
        
EXIT:
    
    MOV AL, 0FFH                 ;恢复屏蔽 
    OUT 21H, AL     

    
    PUSH DS  
    MOV DX, KEEP_IP             ;恢复中断矢量 
    MOV AX, KEEP_CS 
    MOV DS, AX 
    MOV AH, 25H 
    MOV AL, 0BH 
    INT 21H 
    POP DS 
    MOV AH,4CH
    INT 21H
    
INTR PROC
    MOV FLAG, 1                  ;中断标志 
    XOR SIG,0FFH
    MOV AL, SIG
    MOV DX, 280H
    OUT DX,AL
    MOV AL, 20H                  ;EOI命令，中断结束 
    OUT 20H, AL      
    IRET        
INTR ENDP
    
MAIN ENDP
CODE ENDS
    END START
