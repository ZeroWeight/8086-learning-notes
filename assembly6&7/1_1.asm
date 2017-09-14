;ʵ��������һ

DATA SEGMENT

;==============���Ҳ����ݱ��ȡ����128��=========================== 
BUFFER    DB    127,133,139,146,152,158,164,170,176,182,187,193        
    DB    198,203,208,213,217,221,226,229,233,236,239,242
    DB    245,247,249,251,252,253,254,254,254,254,254,253
    DB    252,251,249,247,245,242,239,236,233,229,226,221
    DB    217,213,208,203,198,193,187,182,176,170,164,158
    DB    152,146,139,133,127,121,115,108,102,96,90,84,78
    DB    72,67,61,56,51,46,41,37,33,28,25,21,18,15,12,9,7
    DB    5,3,2,1,0,0,0,0,0,1,2,3,5,7,9,12,15,18,21,25,28
    DB    33,37,41,46,51,56,61,67,72,78,84,90,96,102,108,115,121
    
;===========================��ʾ����=================================     
MESS DB 'please input 1 for sawt-wave, 2 for tria-wave, 3 for sine-wave, 4 to exit, other for not:', 0DH, 0AH, '$'

DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS

MAIN PROC FAR

START:
    MOV AX,DATA
    MOV DS,AX                ;��������    
    MOV AH,9
    LEA DX, MESS
    INT 21H                ;��ʾ��ʾ��Ϣ    
    MOV BH, 0                ;����    
ENTER1:
    MOV AH, 0
    INT 16H                ;��ȡ������ַ�
SELECT_WAVE:
    CMP AL, 31H
    JZ STW                       ;��ݲ�
    CMP AL, 32H    
    JZ TW                         ;���ǲ�
    CMP AL, 33H
    JZ SW                         ;���Ҳ�
    CMP AL, 34H
    JZ EXIT                ;�˳�
    MOV AL, BH
    JMP SELECT_WAVE            ;����

STW:                       ;��ݲ�    
    MOV DX, 280H
    MOV BH, 1                    ;1�����ݲ�
STW_NEXT:
    MOV AL, BL    
    OUT DX, AL                ;�������BL����0������0FFH��Ѹ�ٽ���0
    CALL DELAY                ;��ʱ
    INC BL                ;BLΪ����������ͬ����0~0FFH�仯
    MOV AH, 1
    INT 16H                ;?
    JNZ ENTER1                      ;ɨ�����룬1��/����
    JMP STW_NEXT            ;ѭ��    

TW:                             ;���ǲ�
    MOV DX, 280H
    MOV BH, 2                    ;2�������ǲ�
TW_UP:
    INC BL
    MOV AL, BL
    OUT DX, AL                ;�������BL����0������0FFH
    CALL DELAY                ;��ʱ
    MOV AH, 1
    INT 16H                
    JNZ ENTER1                      ;ɨ������
    CMP BL, 0FFH
    JZ TW_DOWN                ;������ת�½�
    JMP TW_UP                ;δ����������
TW_DOWN:
    DEC BL
    MOV AL, BL
    OUT DX, AL                ;�������BL����0FFH�𲽽���0
    CALL DELAY                ;��ʱ
    MOV AH, 1
    INT 16H                
    JNZ ENTER1                      ;ɨ������
    CMP BL, 0
    JZ TW_UP                ;������ת����
    JMP TW_DOWN                ;δ����������
    
SW:                           ;���Ҳ�
    MOV DX, 280H
    MOV CH, 127                    ;��������
    LEA SI, BUFFER            ;���������
SW_NEXT:    
    MOV AL, [SI]
    OUT DX, AL                ;�������ֵ
    CALL DELAY                ;��ʱ
    INC SI                ;������һ������
    DEC CH                ;������һ
    JNZ SW_NEXT                ;δ����������
    MOV AH, 1
    INT 16H                
    JNZ ENTER1                      ;ɨ������
    JMP SW                ;�����һ���Ҳ�
    
DELAY PROC                ;��ʱ
    MOV CL, 0FFH            ;��ʱ����        
D_WAIT:    
    DEC CL
    JNZ D_WAIT
    RET
DELAY ENDP
    
EXIT:                    ;�˳�
    MOV AH,4CH
    INT 21H
    
MAIN ENDP  
  
CODE ENDS
    END START
