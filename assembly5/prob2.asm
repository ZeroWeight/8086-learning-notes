DATAS  SEGMENT              
DIVID  DW    60H
DATAS  ENDS

STACKS  SEGMENT   STACK      
    DW    128 DUP(?)  
STACKS  ENDS

CODES  SEGMENT               
ASSUME    CS:CODES,DS:DATAS
SUB1  PROC      FAR
  
START:  MOV       AX,DATAS
        MOV       DS,AX
;设置波特率为1200
        MOV       AL,80H
        MOV       DX,3FBH
        OUT       DX,AL
        MOV       AX,DIVID
        MOV       DX,3F8H
        OUT       DX,AL       
        MOV       AL,AH
        MOV       DX,3F9H
        OUT       DX,AL        
        MOV       AL,00001011B
        MOV       DX,3FBH     
        OUT       DX,AL
        MOV       AL,00000011B
        MOV       DX,3FCH
        OUT       DX,AL
        MOV       AL,0
        MOV       DX,3F9H
        OUT       DX,AL   
WAIT_FOR:
        MOV       DX,3FDH
        IN        AL,DX
        TEST      AL,1EH 
        JNZ       ERROR
        TEST      AL,1 
        JNZ       RECEIVE
        TEST      AL,20H 
        JZ        WAIT_FOR 
        MOV       AH,1	
        INT       16H         
        JZ        WAIT_FOR
        MOV       AH,1 
        INT       21H
        CMP       AL,0DH
        JNZ       SENDCHAR    
        MOV       AL,0AH 
        MOV       AH,0EH
        INT       10H
        
SENDCHAR:  
        MOV       DX,3F8H
        OUT       DX,AL
        CMP       AL,20H
        JNZ       NO_STOP
        MOV       AH,4CH
        INT       21H
NO_STOP:  
        JMP       WAIT_FOR    
RECEIVE:
        MOV       DX,3F8H
        IN        AL,DX
        CMP       AL,20H
        JNZ       CHAR
        MOV       AH,4CH
        INT       21H
CHAR:   PUSH      AX         
        MOV       AH,0EH
        INT       10H
        POP       AX
        CMP       AL,0DH
        JNZ       WAIT_FOR
        MOV       AL,0AH
        MOV       AH,0EH    
        INT       10H
        JMP       WAIT_FOR
ERROR:  MOV       DX,3F8H
        IN        AL,DX
        MOV       AL,'?'      
        MOV       AH,14
        INT       10H
        JMP       WAIT_FOR
SUB1  ENDP

CODES  ENDS
END    START
