DATA SEGMENT
X DW 0EEFFH	;THE VALUE 0F X
Y DW 0FFEEH 	;THE VALUE OF Y
P DW 0FFFFH	;X+Y
M DW 0FFFFH	;X-Y
;Z=X+Y
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
MOV AX,X
MOV DX,Y
;ADD METHOD
ADD AL,DL
ADC AH,DH
MOV P,AX
;SUB METHOD
MOV AX,X
SUB AL,DL
SBB AH,DH
MOV M,AX

MOV AH,04CH
INT 021H
CODE ENDS
END START