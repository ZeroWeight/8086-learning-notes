;实验七内容二选作一


DATAS SEGMENT
KEEP_IP DW 0
KEEP_CS DW 0  
FLAG DB 0                        ;中断标志
PASSWORD DB 0F0H, 0FH 
OK DB 'OK',0DH, 0AH, '$'
NO DB 'NO',0DH, 0AH, '$'
DATAS ENDS

STACKS SEGMENT
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

MAIN PROC FAR
START:
    MOV AX,DATAS
    MOV DS,AX

    
    MOV DX, 283H                ;初始化8255
    MOV AL, 10110000B              ;方式控制字，方式1，A口输入
    OUT DX, AL

    MOV DX, 283H
    MOV AL, 00001001B
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

WAIT_FOR1:                        ;等待读第一位
    MOV BL, FLAG
    CMP BL, 1
    JZ WAIT_FOR2                   ;有中断
    JMP WAIT_FOR1
   
WAIT_FOR2:                        ;等待读第二位
    CMP CL, 0FFH
    JZ EXIT
    MOV DL, CL                    ;显示
    MOV AH, 2
    INT 21H  
    MOV BH,    CL                     ;将第一位保存在BH中
    MOV FLAG, 0                    ;消除标志
    JMP WAIT2
WAIT2:
    MOV BL, FLAG
    CMP BL, 1
    JZ CHECK                       ;有中断
    JMP WAIT2   

CHECK:

    CMP CL, 0FFH
    JZ EXIT
    MOV DL, CL                    ;显示
    MOV AH, 2
    INT 21H  
    CMP BH,PASSWORD                ;比较第一位
    JNZ ERROR
    CMP CL,PASSWORD+1            ;比较第二位
    JNZ ERROR
    
    MOV AH, 9
    LEA DX, OK                 
    INT 21H
    JMP WAIT_FOR1

ERROR:
    MOV AH, 9
    LEA DX, NO                 
    INT 21H
    JMP WAIT_FOR1
        
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
    MOV DX, 280H
    IN AL, DX
    MOV CL, AL                    ;将AL数据保存在CL
    MOV AL, 20H                  ;EOI命令，中断结束 
    OUT 20H, AL      
    IRET        
INTR ENDP
    
MAIN ENDP
CODES ENDS
    END START
