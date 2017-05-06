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
MOV AX,0920H
INT 21H
OUT 20H,AL
IRET 
INTER ENDP

START:
MOV AX,DATA
MOV DS,AX
MOV ES,AX
CLI
MOV AH 0350BH
INT 21H
MOV KEEP_IP,BX
MOV KEEP_CS,ES
PUSH DS
MOV DX,OFFSET INTER
MOV AX,SEG INTER
MOV DS,AX
MOV AH,0250BH
INT 21H
POP DS

IN AL,21H
AND AL,0F7H
OUT 21H,AL

MOV DX,0283H
MOV AL,037H
OUT DX,AL
MOV DX,280H
XOR AL,AL
OUT DX,AL
MOV AL,010H
OUT DX,AL
MOV DX,0283H
MOV AL,077H
OUT DX,AL
MOV DX,0281H
XOR AL,AL
OUT DX,AL
MOV AL,10H
OUT DX,AL

STI
L1:
CMP NUM,10
JNZ L1

MOV DX,OFFSET MESS2
MOV AH,09H
INT 21H


IN AL,21H
OR AL,008H
OUT 21H,AL

PUSH DS
MOV DX,KEEP_IP
MOV AX,KEEP_CS
MOV DS,AX
MOV AX,0250BH
INT 21H
POP DS

MOV AX,4C00H
INT 21H

CODE ENDS
END START