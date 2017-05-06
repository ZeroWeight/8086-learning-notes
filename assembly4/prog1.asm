;IRQ3 
DATA SEGMENT
NUM DB 0
MESS1 DB 'PRESSED',0DH,0AH,'$'
MESS2 DB 'DONE',0DH,0AH,'$'
KEEP_CS DW 0
KEEP_IP DW 0
DATA ENDS

STACK SEGMENT PARA STACK
DW 10 DUP(?)
STACK ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK

INTER PROC
INC NUM
MOV DX,OFFSET MESS1
MOV AH,0920H
INT 21H
OUT 20H,AL
IRET
INTER ENDP

START:
CLI
MOV AX,DATA
MOV ES,AX
MOV DS,AX
MOV AX,STACK
MOV SS,AX
;INTER No. GET AND PROTECT
MOV AH,0350BH
INT 21H
MOV KEEP_IP,BX
MOV KEEP_CS,ES
PUSH DS
;SET THE INTER TABLE 
MOV DX,OFFSET INTER
MOV AX,SEG INTER
MOV DS,AX
MOV AH,250BH
INT 21H
POP DS
;SET THE INTER MASK
IN AL,21H
AND AL,0F7H;CANCEL MASK IRQ3
OUT 21H,AL

L1:
CMP NUM,10
JNZ L1

MOV DX,OFFSET MESS2
MOV AH,09H
INT 21H

;END AND RECOVER
;RECOVER THE INTER MASK
IN AL,21H
OR AL,008H
OUT 21H,AL
;RECOVER THE INTER TABLE
PUSH DS
MOV DX,KEEP_IP
MOV AX,KEEP_CS
MOV DS,AX
MOV AH,250BH
INT 21H
POP DS

MOV AX,04C00H
INT 21H
CODE ENDS
END START