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
    OUT DX, AL   
SCAN:    
    MOV DX, 280H
    IN AL, DX    
    
    CMP AL, 11000000B
    JZ TOFLASH   
    
    CMP AL, 10000000B
    JZ L_MOVE    
    
    CMP AL, 01000000B
    JZ R_MOVE    
    
    MOV DX, 282H
    OUT DX, AL   
    
    MOV AH, 1
    INT 16H      
    JZ SCAN      
    
    MOV AH, 0
    INT 16H      
    CMP AL, 20H
    JZ TOEXIT    
    JMP SCAN 
        
L_MOVE:          
    MOV DX, 282H
    MOV BL, 10000000B
    MOV AL, BL
    OUT DX, AL   
R_LEFT:    
    ROL BL, 1    
    MOV AL, BL
    MOV DX, 282H
    OUT DX, AL   
    
    CALL DELAY   
    
    MOV DX, 280H
    IN AL, DX    
    CMP AL, 10000000B
    JNZ SCAN          
    
    MOV DX, 282H
    OUT DX, AL        
    MOV AH, 1
    INT 16H           
    JZ R_LEFT         
    
    MOV AH, 0
    INT 16H
    CMP AL, 20H       
    JZ EXIT
    
    JMP R_LEFT

TOFLASH:              
    JMP FLASH
TOEXIT:
    JMP EXIT
      
R_MOVE:               
    MOV DX, 282H
    MOV BL, 10000000B        
    MOV AL, BL
    OUT DX, AL        
    
R_RIGHT: 
    ROR BL, 1         
    MOV AL, BL
    MOV DX, 282H
    
    CALL DELAY         
    
    MOV DX, 280H
    IN AL, DX          
    CMP AL, 01000000B        
    JNZ SCAN           
    
    MOV DX, 282H
    OUT DX, AL         
    MOV AH, 1        
    INT 16H            
    JZ R_RIGHT         
    MOV AH, 0
    INT 16H
    CMP AL, 20H        
    JZ EXIT            
    
    JMP R_RIGHT

TOSCAN:
    JMP SCAN
FLASH:                 
    MOV DX, 282H
    MOV AL, 0
    OUT DX, AL         
    
    CALL DELAY
    
    MOV DX, 282H
    MOV AL, 0FFH
    OUT DX, AL         

    MOV DX, 280H
    IN AL, DX
    CMP AL, 11000000B
    JNZ TOSCAN         
    
    CALL DELAY
    
    MOV DX, 282H
    OUT DX, AL         
    MOV AH, 1
    INT 16H             
    JZ FLASH            
    MOV AH, 0
    INT 16H
    CMP AL, 20H         
    JZ EXIT             
    
    JMP FLASH
                     
EXIT:                   
    MOV AH,4CH
    INT 21H
    
DELAY PROC              
    PUSH BX
    PUSH CX
    MOV BX, 0FH
WAITB:
    MOV CX, 0FFFFH
WAITC:
    DEC CX
    JNZ WAITC           
    DEC BX
    JNZ WAITB           
    POP CX
    POP BX
    RET
DELAY ENDP

MAIN ENDP
CODE ENDS
    END START
