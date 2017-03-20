; Experiment 1 (Tutorial Guide, p.12)

name my_program

data segment
buffer1 db 0,1,2,3,4,5,6,7,8,9,0ah,0bh,0ch,0dh,0eh,0fh
buffer2 db 10h dup(0)
mess db 'HAVE DONE',13,10,'$'
data ends

stack segment para stack
db 100 dup(?)
stack ends

code segment
assume cs:code, ds:data, es:data, ss:stack

start: mov ax, data
mov ds, ax
mov es, ax
lea si, buffer1
lea di, buffer2
mov cx, 10h
next: mov al, [si]
mov [di], al
inc si
inc di
dec cx
jnz next
lea dx, mess
mov ah, 9
int 21h
mov ah, 4ch
int 21h

code ends

end start
