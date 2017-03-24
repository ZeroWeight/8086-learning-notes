name prob13

data segment
buffer1 db 10h dup(0)		
;calloc(10);
mess db 'HAVE DONE',13,10,'$'
;"HAVE DONE\r\n"
data ends

stack segment para stack
db 10 dup(0)			
;when using DEBUG, the size of stack 
;is no less than 6
stack ends

code segment
assume cs:code, ds:data, es:data, ss:stack
;Reg for visit data block

start: mov ax, data
mov ds, ax
mov es, ax		
; set up the user data segment
lea di, buffer1	
; a pointer in C

mov cx, 0ah
mov al,30h
loop1: mov [di], al	
; *di=al
inc al
inc di			
;++al,++di
loop loop1		
;cpy al to buffer2

mov cx,06h
mov al,41h
loop2: mov [di],al
inc al
inc di
loop loop2

lea dx, mess		
;prepare for output
mov ah, 9
int 21h			
;when ah == 9 means output the string in ds:d
mov ah, 4ch
int 21h			
;when ah == 4c means return (al);

code ends

end start
