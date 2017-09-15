DATA SEGMENT
KEEP_IP DW 0
KEEP_CS DW 0  
FLAG DB 0      
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
    MOV AL, 10110000B
    OUT DX, AL

    MOV DX, 283H
    MOV AL, 00001001B
    OUT DX, AL       
    
    
    MOV AH, 35H      
    MOV AL, 0BH 
    INT 21H
    MOV KEEP_IP, BX  
    MOV KEEP_CS, ES  
    
   
    PUSH DS 
    MOV DX, OFFSET INTR
    MOV AX, SEG INTR 
    MOV DS, AX 
    MOV AH, 25H   
    MOV AL, 0BH 
    INT 21H 
    POP DS 

    MOV AL, 0F7H       
    OUT 21H, AL

WAIT_FOR:    
    MOV BL, FLAG
    CMP BL, 1
    JZ ISINT           
    JMP WAIT_FOR
   
ISINT:                 
    CMP CL, 0FFH
    JZ EXIT            
    MOV DL, CL         
    MOV AH, 2
    INT 21H    
    MOV FLAG, 0        
    JMP WAIT_FOR       
        
EXIT:
    
    MOV AL, 0FFH       
    OUT 21H, AL     

    
    PUSH DS  
    MOV DX, KEEP_IP    
    MOV AX, KEEP_CS 
    MOV DS, AX 
    MOV AH, 25H 
    MOV AL, 0BH 
    INT 21H 
    POP DS 
    MOV AH,4CH
    INT 21H
    
INTR PROC
    MOV FLAG, 1        
    MOV DX, 280H
    IN AL, DX
    MOV CL, AL         
    MOV AL, 20H        
    OUT 20H, AL      
    IRET        
INTR ENDP
    
MAIN ENDP
CODE ENDS
    END START
