;实验七内容三

DATAS SEGMENT
DATAS ENDS

STACKS SEGMENT
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

MAIN PROC FAR   
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV DX, 283H
    MOV AL, 10000000B   	;控制字，方式0，A口C口输出
    OUT DX, AL
	
NEXT:
    MOV DX, 282H
    MOV AL, 01H
    OUT DX, AL         		;C口输出01H
    MOV DX, 280H
    MOV AL, 3FH
    OUT DX, AL          	;A口向数码管显示‘0’
    
    CALL DELAY
    
    MOV DX, 280H
    MOV AL, 06H
    OUT DX, AL          	;A口向数码管显示‘1’
    MOV DX, 282H
    MOV AL, 02H
    OUT DX, AL          	;C口输出02H

    CALL DELAY
    
    MOV AH, 1        
    INT 16H
    JZ NEXT
    CMP AL, 20H            	;检测空格
    JZ EXIT
    JMP NEXT
      
EXIT:
    MOV AH,4CH
    INT 21H
    
DELAY PROC
    MOV CX, 0FFH
D_WAIT:    LOOP D_WAIT
    RET
DELAY ENDP

MAIN ENDP
CODES ENDS
    END START
