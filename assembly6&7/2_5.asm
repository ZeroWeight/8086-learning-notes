;ʵ�������ݶ�


DATA SEGMENT
SIG DB 0
KEEP_IP DW 0
KEEP_CS DW 0  
FLAG DB 0                        ;�жϱ�־
DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS

MAIN PROC FAR
START:
    MOV AX,DATA
    MOV DS,AX

    
    MOV DX, 283H            ;��ʼ��8255
    MOV AL, 10101000B              ;��ʽ�����֣���ʽ1��A������
    OUT DX, AL

    MOV DX, 283H
    MOV AL, 11001000B
    OUT DX, AL                     ;λ���֣�D4д��1��Ҳ����INTEAд��1�������ж�
    
    
    MOV AH, 35H                 ;�����ж�ʸ�� 
    MOV AL, 0BH 
    INT 21H
    MOV KEEP_IP, BX                ;��� IPֵ 
    MOV KEEP_CS, ES                ;��� CSֵ 
    
    
   
    PUSH DS 
    MOV DX, OFFSET INTR             ;װ���ж�ʸ�� 
    MOV AX, SEG INTR 
    MOV DS, AX 
    MOV AH, 25H   
    MOV AL, 0BH 
    INT 21H 
    POP DS 

    MOV AL, 0F7H                 ;�����IRQ3������ 
    OUT 21H, AL

WAIT_FOR:    
    MOV BL, FLAG
    CMP BL, 1
    JZ ISINT                       ;���ж�
    JMP WAIT_FOR
   
ISINT:                            ;��Ӧ�ж�֮��
    MOV FLAG, 0                    ;������־
    JMP WAIT_FOR                ;��һ��ѭ��
        
EXIT:
    
    MOV AL, 0FFH                 ;�ָ����� 
    OUT 21H, AL     

    
    PUSH DS  
    MOV DX, KEEP_IP             ;�ָ��ж�ʸ�� 
    MOV AX, KEEP_CS 
    MOV DS, AX 
    MOV AH, 25H 
    MOV AL, 0BH 
    INT 21H 
    POP DS 
    MOV AH,4CH
    INT 21H
    
INTR PROC
    MOV FLAG, 1                  ;�жϱ�־ 
    XOR SIG,0FFH
    MOV AL, SIG
    MOV DX, 280H
    OUT DX,AL
    MOV AL, 20H                  ;EOI����жϽ��� 
    OUT 20H, AL      
    IRET        
INTR ENDP
    
MAIN ENDP
CODE ENDS
    END START
