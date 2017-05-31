DATA SEGMENT
     DIVID DW 60
     MY_STR DB 'gq',0DH,'$'
     
     MESS2 DB 'PROGRAM DONE!',0DH,'$'
     CRLF  DB 0DH,0AH,'$'
DATA ENDS
STACK1 SEGMENT PARA STACK
      DB 100 DUP(?)
STACK1 ENDS
CODE SEGMENT
     ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK1
DOUBLE PROC
START:MOV AX,DATA
      MOV DS,AX
      MOV ES,AX
      MOV DX,3FBH
      MOV AL,80H
      OUT DX,AL
      MOV AX,DIVID
      MOV DX,3F8H
      OUT DX,AL
      MOV AL,AH
      MOV DX,3F9H
      OUT DX,AL
      MOV AL,0BH
      MOV DX,3FBH
      OUT DX,AL
      MOV DX,3FCH
      MOV AL,00000011B
      OUT DX,AL
      MOV DX,3F9H
      MOV AL,0
      OUT DX,AL

KEEP_TRY:MOV DX,3FDH
         IN AL,DX
         TEST AL,1EH
         JNE  ERROR
         TEST AL,1
         JNZ  RECEIVE
         TEST AL,20H
         JZ KEEP_TRY
         MOV AH,1
         INT 16H
         JZ KEEP_TRY
         MOV AH,1
         INT 21H
         MOV DX,3F8H
         OUT DX,AL
         CMP AL,20H
         JE EXIT
         CMP AL,'S'
         JE SEND_STR
		 CMP AL,'s'
         JE SEND_STR
         CMP AL,'R'
         JE RE_STR
         CMP AL,'r'
         JE RE_STR
         JMP KEEP_TRY

RECEIVE: MOV DX,3F8H
         IN AL,DX
         CMP AL,20H
         JE EXIT
         CMP AL,'S'
         JE RE_STR        
         CMP AL,'R'
         JE SEND_STR
         JMP KEEP_TRY

ERROR:   MOV DX,3F8H
         IN AL,DX
         MOV AL,'?'
         MOV AH,14
         INT 10H
         JMP KEEP_TRY
         
SEND_STR:CALL SEND
         JMP KEEP_TRY
RE_STR:  CALL REC
         JMP KEEP_TRY
         
EXIT:    LEA DX,MESS2
         MOV AH,9
         INT 21H
         MOV AH,4CH
         INT 21H
DOUBLE     ENDP

SEND PROC                   
     LEA SI,MY_STR
S_WAIT:MOV DX,3F8H
       MOV AL,[SI]
       OUT DX,AL
       CMP AL,'$'
       JE S_DONE
       INC SI
       JMP S_WAIT
S_DONE:RET
SEND ENDP

REC PROC                     
REC_WAIT:
    MOV DX,3FDH
    IN AL,DX
    TEST AL,1EH
    JNE  ERROR
    TEST AL,1
    JZ REC_WAIT
    MOV DX,3F8H
    IN AL,DX
    CMP AL,'$'
    JE REC_DONE
    MOV AH,0EH
    INT 10H
    JMP REC_WAIT
REC_DONE:
    LEA DX,CRLF
    MOV AH,9
    INT 21H
    RET
REC ENDP

CODE     ENDS
END      START