;exp 6 part I

DATA SEGMENT

;==============正弦波数据表格，取样点256个=========================== 
BUFFER    DB    127,133,139,146,152,158,164,170,176,182,187,193        
    DB    198,203,208,213,217,221,226,229,233,236,239,242
    DB    245,247,249,251,252,253,254,254,254,254,254,253
    DB    252,251,249,247,245,242,239,236,233,229,226,221
    DB    217,213,208,203,198,193,187,182,176,170,164,158
    DB    152,146,139,133,127,121,115,108,102,96,90,84,78
    DB    72,67,61,56,51,46,41,37,33,28,25,21,18,15,12,9,7
    DB    5,3,2,1,0,0,0,0,0,1,2,3,5,7,9,12,15,18,21,25,28
    DB    33,37,41,46,51,56,61,67,72,78,84,90,96,102,108,115,121
	DB    127,133,139,146,152,158,164,170,176,182,187,193        
    DB    198,203,208,213,217,221,226,229,233,236,239,242
    DB    245,247,249,251,252,253,254,254,254,254,254,253
    DB    252,251,249,247,245,242,239,236,233,229,226,221
    DB    217,213,208,203,198,193,187,182,176,170,164,158
    DB    152,146,139,133,127,121,115,108,102,96,90,84,78
    DB    72,67,61,56,51,46,41,37,33,28,25,21,18,15,12,9,7
    DB    5,3,2,1,0,0,0,0,0,1,2,3,5,7,9,12,15,18,21,25,28
    DB    33,37,41,46,51,56,61,67,72,78,84,90,96,102,108,115,121
    
;===========================提示输入=================================     
MESS DB 'please input 1 for sawt-wave, 2 for tria-wave, 3 for sine-wave, 4 to exit, other for not:', 0DH, 0AH, '$'

DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS

MAIN PROC FAR

START:
    MOV AX,DATA
    MOV DS,AX 
    MOV AH,09H
    LEA DX, MESS
    INT 21H		;display the message    
    XOR CH,CH
	MOV DX,0280H	;address
ENTER1:
    XOR AH,AH
    INT 16H		;character read in with block
SELECT_WAVE:
    CMP AL, 31H
    JZ STW
    CMP AL, 32H    
    JZ TW
    CMP AL, 33H
    JZ SW
    CMP AL, 34H
    JZ EXIT
    MOV AL, CH	;or: keep the original waveform
    JMP SELECT_WAVE

STW:   
    MOV CX,0100H
STW_NEXT:
    MOV AL, BL    
    OUT DX, AL	;count for BL 
    CALL DELAY
    INC CL
    MOV AH, 01H
    INT 16H	;keyboard readin without block
    JNZ SELECT_WAVE
    JMP STW_NEXT   

TW:
    MOV CX,0200H
TW_UP:
    INC CL
    MOV AL, CL
    OUT DX, AL
    CALL DELAY
    MOV AH, 01H
    INT 16H                
    JNZ ENTER1
    CMP BL, 0FFH
    JZ TW_DOWN
    JMP TW_UP
TW_DOWN:
    DEC CL
    MOV AL, CL
    OUT DX, AL
    CALL DELAY
	MOV AH, 01H
    INT 16H                
    JNZ ENTER1
    CMP CL, 0
    JZ TW_UP
    JMP TW_DOWN
    
SW:
    MOV CX,0300H
    XOR BX,BX
    LEA SI, BUFFER
SW_NEXT:
    MOV AL, [SI+BX]
    OUT DX, AL
    CALL DELAY
	INC BL
    MOV AH, 01H
    INT 16H                
    JNZ ENTER1
    JMP SW_NEXT
    
DELAY PROC
    XOR AL,AL       
D_WAIT:    
    DEC AL
    JNZ D_WAIT
    RET
DELAY ENDP
    
EXIT:
    MOV AX,4C00H
    INT 21H
    
MAIN ENDP  
  
CODE ENDS
    END START
