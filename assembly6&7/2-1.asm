;ʵ��������һ


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
    OUT DX, AL                   ;�����֣���ʽ0��A���룬C���
    
NEXT:    
    MOV DX, 280H
    IN AL, DX                ;��A��                    
    MOV DX, 282H
    OUT DX, AL                ;дC��
    MOV AH, 1
    INT 16H                ;�������Ƿ���
    JZ NEXT                ;û�������ɨ��
    MOV AH, 0
    INT 16H                ;������                    
    CMP AL, 20H
    JZ EXIT                ;�ո��˳�
    JMP NEXT
                 
EXIT:    
    MOV AH,4CH
    INT 21H

MAIN ENDP
CODE ENDS
    END START
