name 2015011493_zw

data segment

buffer1 db 0,1,2,3,4,5,6,7,8,9,0ah,0bh,0ch,0dh,0eh,0fh  ;just a count
buffer2 db 10h dup(0)
mess db 'HAVE DONE',13,10,'$'    ;"HAVE DONE\r\n"
data ends

stack segment para stack; 
db 100 dup(?)
stack ends;

code segment
assume cs:code, ds:data, es:data, ss:stack;Reg for visit data block

start: mov ax, data
mov ds, ax
mov es, ax		; set up the user data segment

lea si, buffer1		; maybe like a pointer in C
lea di, buffer2
mov cx, 10h

next: mov al, [si]	; load the *si (data in buffer1)
mov [di], al		; *di=al
			; may just like the exchange?
inc si
inc di
			;++si,++di
dec cx			;cx--

jnz next		;cpy buffer1 to buffer2

lea dx, mess		;prepare for output
mov ah, 9
int 21h			;when ah == 9 means output the string in ds:dx
	
mov ah, 4ch
int 21h			;when ah == 4c means return (al);

code ends

end start
