

DATA SEGMENT
X DB 038H
Y DB 023H
XY DW 0FFFFH;X*Y
DATA ENDS

STACK SEGMENT PARA STACK
DB 10 DUP (?)
STACK ENDS

CODE SEGMENT
ASSUME DS:DATA,ES:DATA,SS:STACK,CS:CODE
START:
MOV AX,DATA
MOV DS,AX
MOV ES,AX
MOV AX,STACK
MOV SS,AX

;DATA READ IN
MOV DL,X
MOV DH,000H
MOV CL,Y
MOV AX,00000H
L1:
ADD AL,DL
DAA 
XCHG AL,AH
ADC AL,0
DAA
XCHG AH,AL
DEC CL
XCHG AL,CL
DAS
XCHG AL,CL
JNZ L1
MOV XY,AX

MOV AH,04CH
INT 021H
CODE ENDS
END START