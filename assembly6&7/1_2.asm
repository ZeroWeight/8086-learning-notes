;ʵ�������ݶ�

DATA SEGMENT
    HEAD DB 0DH, 0AH, 'D/A         A/D', 0DH, 0AH, '$'        ;��ͷ
    INFO DB 'Please input c to get the datas, e to exit:'        ;��ʾ
    LINE DB 0DH, 0AH, '$'                        ;����
    SPACE DB '         $'                        ;�ո�
DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS
MAIN PROC FAR

START:
    MOV AX,DATA
    MOV DS,AX            ;��������
    
    MOV BX, 0            ;����

DISPLAY:

    MOV BL,BH            ;?
    INC BH            ;��¼��������
    MOV CX, 20            ;���ڼ���
    MOV AH, 9
    LEA DX, HEAD
    INT 21H               ;��ʾ��ͷ 
ONE_LINE:
    MOV AL, BL   
    MOV DX, 280H        
    OUT DX, AL                   ;��������DAC
    
    CALL SHOW                   ;��ʾ
    CALL DELAY            ;��ʱ
    
    MOV AH, 9
    LEA DX, SPACE
    INT 21H                   ;����ո�
    
    MOV DX, 289H
    OUT DX, AL                 ;ADC����ת��
    
    CALL DELAY            ;��ʱ
    
    MOV DX, 289H
    IN AL, DX            ;��ȡת�����
    
    CALL SHOW            ;��ʾ
    
    MOV AH, 9
    LEA DX, LINE
    INT 21H                    ;����
    
    ADD BL, 0FH          ;? 
    LOOP ONE_LINE             ;�����һ��
    
    MOV AH, 9
    LEA DX, INFO
    INT 21H            ;��ʾ��Ϣ
    
ENTER:    
    MOV AH, 1
    INT 21H               ;��ȡ����
    CMP AL, 'C'
    JZ DISPLAY
    CMP AL, 'c'    
    JZ DISPLAY            ;����
    CMP AL, 'E'
    JZ EXIT
    CMP AL, 'e'
    JZ EXIT            ;�˳�
    JMP ENTER
    
EXIT:    
    MOV AH,4CH
    INT 21H            ;�˳�
    
DELAY PROC                    
    PUSH AX
    PUSH BX
    PUSH CX
    MOV CX, 0FFFH        ;��ʱ����
WAIT:   
    LOOP WAIT
    
    POP CX
    POP BX
    POP AX
    RET
DELAY ENDP

;==========��ʾAL�������,��ѹ��BCDתASCII��==========
SHOW PROC 
    PUSH AX
    AND AL, 0F0H        ;��ȡ��λ
    SHR AL, 1
    SHR AL, 1
    SHR AL, 1
    SHR AL, 1            ;�Ѹ�λ������λ
    CMP AL, 09H        
    JBE DIG2            ;С�ڵ���9��ת
    ADD AL, 07H            ;������ĸ
DIG2:
    ADD AL, 30H            ;תASCII�룬��1H+30H=31H('1'),��0AH+07H+30H=41H('A')
    MOV DL, AL
    MOV AH, 2
    INT 21H            ;��ʾ���
    POP AX
    
    AND AL, 0FH            ;��ȡ��λ
    CMP AL, 09H
    JBE DIG1
    ADD AL, 07H            ;������ĸ
DIG1:
    ADD AL, 30H            ;תASCII��
    MOV DL, AL
    MOV AH, 2
    INT 21H            ;��ʾ���
    MOV DL, 'H'            ;��ʾ˵��Ϊʮ������
    MOV AH, 2
    INT 21H            ;��ʾ���
    RET
SHOW ENDP

MAIN ENDP
CODE ENDS
    END START
