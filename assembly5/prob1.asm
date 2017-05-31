DATA  SEGMENT
       MESS1  DB        'RECEIVING:','$'
       MESS2  DB        'WRONG INPUT!',0DH,0AH,'$'
       MESS3  DB        'HAVE DONE',0DH,0AH,'$'
       MESS4  DB        0DH,0AH,'$'
DATA  ENDS
		
       STACK  SEGMENT
              DB        100 DUP(?)
       STACK  ENDS
	   
        CODE  SEGMENT
              ASSUME    CS:CODE,DS:DATA,ES:DATA,SS:STACK
      START:
              MOV       AX,DATA
              MOV       DS,AX
              MOV       ES,AX   
              MOV       DX,3FBH
			  MOV       AL,80H      
              OUT       DX,AL    
              MOV       DX,3F9H
			  MOV		AL,0
              OUT       DX,AL
              MOV  	    DX,3F8H
			  MOV       AX,60H       
              OUT       DX,AL			           
              MOV       DX,3FBH
              MOV       AL,00001011B  
			  OUT       DX,AL          
              MOV       DX,3FCH
			  MOV       AL,13H           
              OUT       DX,AL
			  MOV       DX,3F9H
              MOV       AL,0           					
              OUT       DX,AL
   WAIT_FOR:
              MOV       DX,3FDH
              IN        AL,DX
              TEST      AL,00011110B
              JNZ       ERROR
              TEST      AL,1      	      
              JNZ       RECEIVE		
              TEST      AL,00100000B
              JZ        WAIT_FOR	
              MOV       AH,1
              INT       21H
              CMP       AL,20H
              JE        STOPWORK
              MOV       CL,AL       
              MOV       DX,3F8H
              OUT       DX,AL       
              JMP       WAIT_FOR
    RECEIVE:
              LEA       DX,MESS1
              MOV       AH,9
              INT       21H         
              MOV       DX,3F8H
              IN        AL,DX
              MOV       DL,AL
              MOV       AH,02H      
              INT       21H
              LEA       DX,MESS4
              MOV       AH,09H
              INT       21H
              JMP       WAIT_FOR
      ERROR:                        
              LEA       DX,MESS2
              MOV       AH,9
              INT       21H         
              JMP       WAIT_FOR
     STOPWORK:
              LEA       DX,MESS3
              MOV       AH,9
              INT       21H
              MOV       AH,4CH      
              INT       21H
        CODE  ENDS
              END       START
