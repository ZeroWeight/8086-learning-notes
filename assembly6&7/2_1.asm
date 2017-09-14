;实验七内容一


DATA SEGMENT
DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS
 
MAIN PROC FAR
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV DX, 283H
    MOV AL, 10010000B	
    OUT DX, AL           		;控制字，方式0，A输入，C输出
	
NEXT:    
    MOV DX, 280H
    IN AL, DX				;读A口					
    MOV DX, 282H
    OUT DX, AL				;写C口
    MOV AH, 1
    INT 16H				;检测键盘是否按下
    JZ NEXT				;没有则继续扫描
    MOV AH, 0
    INT 16H				;读按键					
    CMP AL, 20H
    JZ EXIT				;空格退出
    JMP NEXT
                 
EXIT:    
    MOV AH,4CH
    INT 21H

MAIN ENDP
CODE ENDS
    END START
