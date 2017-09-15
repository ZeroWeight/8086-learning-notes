DATA SEGMENT
    HEAD DB 0DH, 0AH, 'D/A         A/D', 0DH, 0AH, '$'
    INFO DB 'Please input c to get the datas, e to exit:'
    LINE DB 0DH, 0AH, '$'
    SPACE DB '         $'
DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS
MAIN PROC FAR

START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV BX, 0

DISPLAY:

    MOV BL,BH 
    INC BH
    MOV CX, 20
    MOV AH, 9
    LEA DX, HEAD
    INT 21H
ONE_LINE:
    MOV AL, BL   
    MOV DX, 280H        
    OUT DX, AL       
    
    CALL SHOW        
    CALL DELAY       
    
    MOV AH, 9
    LEA DX, SPACE
    INT 21H          
    
    MOV DX, 289H
    OUT DX, AL       
    
    CALL DELAY       
    
    MOV DX, 289H
    IN AL, DX        
    
    CALL SHOW        
    
    MOV AH, 9
    LEA DX, LINE
    INT 21H          
    
    ADD BL, 0FH      
    LOOP ONE_LINE    
    
    MOV AH, 9
    LEA DX, INFO
    INT 21H          
    
ENTER:    
    MOV AH, 1
    INT 21H          
    CMP AL, 'C'
    JZ DISPLAY
    CMP AL, 'c'    
    JZ DISPLAY       
    CMP AL, 'E'
    JZ EXIT
    CMP AL, 'e'
    JZ EXIT          
    JMP ENTER
    
EXIT:    
    MOV AH,4CH
    INT 21H          
    
DELAY PROC                    
    PUSH AX
    PUSH BX
    PUSH CX
    MOV CX, 0FFFH    
WAIT:   
    LOOP WAIT
    
    POP CX
    POP BX
    POP AX
    RET
DELAY ENDP


SHOW PROC 
    PUSH AX
    AND AL, 0F0H    
    SHR AL, 1
    SHR AL, 1
    SHR AL, 1
    SHR AL, 1       
    CMP AL, 09H        
    JBE DIG2        
    ADD AL, 07H     
DIG2:
    ADD AL, 30H     
    MOV DL, AL
    MOV AH, 2
    INT 21H         
    POP AX
    
    AND AL, 0FH     
    CMP AL, 09H
    JBE DIG1
    ADD AL, 07H     
DIG1:
    ADD AL, 30H     
    MOV DL, AL
    MOV AH, 2
    INT 21H         
    MOV DL, 'H'     
    MOV AH, 2
    INT 21H         
    RET
SHOW ENDP

MAIN ENDP
CODE ENDS
    END START
