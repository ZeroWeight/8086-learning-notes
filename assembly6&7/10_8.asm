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
;����8253������ʽ
    MOV DX,293H
    MOV AL,00110111B
    OUT DX,AL
    
    MOV DX,290H
    MOV AL,90
    OUT DX,AL
    OUT DX,AL

;����8255������ʽ
    MOV DX,283H         ;���ÿ�����
    MOV AL,10000000B
    OUT DX,AL       

;�޸��ж�ʸ����
    MOV AH,35H                ;����ԭ�ж�ʸ������Ϣ
    MOV AL,0BH
    INT 21H
    MOV KEEPIP,BX            ;����ԭ�ж�ʸ������Ϣ
    MOV KEEPCS,ES
        
    PUSH DS                    ;�޸��ж�ʸ����
    MOV DX,OFFSET INTR
    MOV AX,SEG INTR
    MOV DS,AX
    MOV AH,25H
    MOV AL,0BH
    INT 21H
    POP DS
        
;��IRQ3������
    IN AL,21H
    AND AL,011110111B
    OUT 21H,AL           
    
    MOV BL,0
MAIN:                                   ;��Ϣѭ��
    HLT
    MOV AH,1
    INT 16H            ;�м������룬���˳���Ϣѭ��
    JNE EXIT
    JMP MAIN

EXIT:
;�ָ�IRQ3������
    IN  AL,21H
    OR  AL,00001000B
    OUT 21H,AL
        
;�ָ��ж�ʸ����
    PUSH DS
    MOV DX,KEEPIP
    MOV AX,KEEPCS
    MOV DS,AX
    MOV AH,25H
    MOV AL,0BH
    INT 21H
    POP DS
    
    MOV AH,4CH                ;����DOS
    INT 21H


;------------------�жϷ����ӳ���-----------------------
INTR PROC
;�ص�������

    MOV DX,282H
    MOV AL,00H
    OUT DX,AL

    CMP BL,0
    JNZ OUT1
OUT0:
    MOV DX,280H
    MOV AL,3FH
    OUT DX,AL        ;A�����
    MOV DX,282H
    MOV AL,01H
    OUT DX,AL
    MOV BL,1
    JMP END_INTR
OUT1:   
;���1    
    MOV DX,280H
    MOV AL,06H
    OUT DX,AL
    MOV DX,282H
    MOV AL,02H
    OUT DX,AL
    MOV BL,0
    JMP END_INTR
 
END_INTR:
    MOV AL,20H                    ;����EOI�ź�
    OUT 0A0H,AL
    OUT 20H,AL
IRET
INTR ENDP
;-----------------------------------------------------

CODE ENDS
END START    








