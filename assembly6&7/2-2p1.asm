;ʵ�������ݶ�ѡ��һ


DATAS SEGMENT
KEEP_IP DW 0
KEEP_CS DW 0  
FLAG DB 0                        ;�жϱ�־
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

    
    MOV DX, 283H                ;��ʼ��8255
    MOV AL, 10110000B              ;��ʽ�����֣���ʽ1��A������
    OUT DX, AL

    MOV DX, 283H
    MOV AL, 00001001B
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

WAIT_FOR1:                        ;�ȴ�����һλ
    MOV BL, FLAG
    CMP BL, 1
    JZ WAIT_FOR2                   ;���ж�
    JMP WAIT_FOR1
   
WAIT_FOR2:                        ;�ȴ����ڶ�λ
    CMP CL, 0FFH
    JZ EXIT
    MOV DL, CL                    ;��ʾ
    MOV AH, 2
    INT 21H  
    MOV BH,    CL                     ;����һλ������BH��
    MOV FLAG, 0                    ;������־
    JMP WAIT2
WAIT2:
    MOV BL, FLAG
    CMP BL, 1
    JZ CHECK                       ;���ж�
    JMP WAIT2   

CHECK:

    CMP CL, 0FFH
    JZ EXIT
    MOV DL, CL                    ;��ʾ
    MOV AH, 2
    INT 21H  
    CMP BH,PASSWORD                ;�Ƚϵ�һλ
    JNZ ERROR
    CMP CL,PASSWORD+1            ;�Ƚϵڶ�λ
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
    MOV DX, 280H
    IN AL, DX
    MOV CL, AL                    ;��AL���ݱ�����CL
    MOV AL, 20H                  ;EOI����жϽ��� 
    OUT 20H, AL      
    IRET        
INTR ENDP
    
MAIN ENDP
CODES ENDS
    END START
