;ʵ��������һѡ��

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
    OUT DX, AL                    ;�����֣���ʽ0��A���룬C���
SCAN:    
    MOV DX, 280H
    IN AL, DX                ;��A��
    
    CMP AL, 11000000B
    JZ TOFLASH                   ;��K6=K7=1
    
    CMP AL, 10000000B
    JZ L_MOVE                   ;��K7=1
    
    CMP AL, 01000000B
    JZ R_MOVE                   ;��K6=1
    
    MOV DX, 282H
    OUT DX, AL                    ;дC��
    
    MOV AH, 1
    INT 16H                       ;�������Ƿ���
    JZ SCAN                ;û�У�����
    
    MOV AH, 0
    INT 16H                ;������
    CMP AL, 20H
    JZ TOEXIT                   ;Ϊ�ո��˳�    
    JMP SCAN 
        
L_MOVE:                                ;����
    MOV DX, 282H
    MOV BL, 10000000B
    MOV AL, BL
    OUT DX, AL                ;�������                
R_LEFT:    
    ROL BL, 1                ;����һλ
    MOV AL, BL
    MOV DX, 282H
    OUT DX, AL                ;����
    
    CALL DELAY                ;��ʱ
    
    MOV DX, 280H
    IN AL, DX                 ;��A��
    CMP AL, 10000000B
    JNZ SCAN                ;״̬�ı䣬����ɨ��
    
    MOV DX, 282H
    OUT DX, AL                ;???                
    MOV AH, 1
    INT 16H                       ;�������Ƿ���
    JZ R_LEFT                ;û�У�����ѭ��
    
    MOV AH, 0
    INT 16H
    CMP AL, 20H                   ;�Ƿ�Ϊ�ո�
    JZ EXIT
    
    JMP R_LEFT

TOFLASH:                ;����������ת�Ƶķ�Χ������������ת��JMP����ת��
    JMP FLASH
TOEXIT:
    JMP EXIT
      
R_MOVE:                                ;����
    MOV DX, 282H
    MOV BL, 10000000B        
    MOV AL, BL
    OUT DX, AL                ;7�ŵ���
    
R_RIGHT: 
    ROR BL, 1                ;����
    MOV AL, BL
    MOV DX, 282H
    OUT DX, AL                ;��������
    
    CALL DELAY                ;��ʱ
    
    MOV DX, 280H
    IN AL, DX                ;��A��
    CMP AL, 01000000B        
    JNZ SCAN                ;״̬�ı䣬����ɨ��
    
    MOV DX, 282H
    OUT DX, AL                ;???      
    MOV AH, 1        
    INT 16H                       ;�������Ƿ���
    JZ R_RIGHT                ;û�У�����ѭ��
    MOV AH, 0
    INT 16H
    CMP AL, 20H                   ;�Ƿ�Ϊ�ո�
    JZ EXIT                ;�˳�
    
    JMP R_RIGHT

TOSCAN:
    JMP SCAN
FLASH:                                ;��˸
    MOV DX, 282H
    MOV AL, 0
    OUT DX, AL                ;ȫ��
    
    CALL DELAY
    
    MOV DX, 282H
    MOV AL, 0FFH
    OUT DX, AL                ;ȫ��

    MOV DX, 280H
    IN AL, DX
    CMP AL, 11000000B
    JNZ TOSCAN                ;״̬�ı䣬����ɨ��
    
    CALL DELAY
    
    MOV DX, 282H
    OUT DX, AL              ;???     
    MOV AH, 1
    INT 16H                    ;�������Ƿ���       
    JZ FLASH                ;û�У�����ѭ��
    MOV AH, 0
    INT 16H
    CMP AL, 20H                   ;�Ƿ�Ϊ�ո�
    JZ EXIT                ;�˳�
    
    JMP FLASH
                     
EXIT:                    ;�˳�
    MOV AH,4CH
    INT 21H
    
DELAY PROC                        ;��ʱ�ϳ���������������
    PUSH BX
    PUSH CX
    MOV BX, 0FH
WAITB:
    MOV CX, 0FFFFH
WAITC:
    DEC CX
    JNZ WAITC                ;����ѭ��1
    DEC BX
    JNZ WAITB                ;����ѭ��2
    POP CX
    POP BX
    RET
DELAY ENDP

MAIN ENDP
CODE ENDS
    END START
