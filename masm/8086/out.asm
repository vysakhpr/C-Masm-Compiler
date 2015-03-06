assume cs:code,ds:data
data segment
cmc_msg0 db 0ah,0dh,"$"
cmc_msg1 db 0ah,0dh,"$"
cmc_msg2 db 0ah,0dh,"$"
cmc_msg3 db 0ah,0dh,"$"
cmc_msg4 db 0ah,0dh,"The number is greater than five$"
cmc_msg5 db 0ah,0dh,"The number is less than or equal to five$"
cmc_out db '        $'
cmc_in db '        $'
cmc_temp db 01
cmc_t0 dw 02
a dw 02
cmc_t1 dw 02
cmc_t2 dw 02
data ends
code segment
start:
mov dx,data
mov ds,dx
lea si,cmc_in
mov dl,00h
ins1:
mov ah,01h
int 21h
cmp al,0dh
jz insert1
sub al,30h
mov [si],al
inc dl
inc si
jmp ins1
insert1:
dec si
mov cx,0000h
mov bx,0001h
in1:
mov al,[si]
mov ah,00h
dec si
mov cmc_temp,dl
mul bx
mov dl,cmc_temp
add cx,ax
mov ax,000ah
mov cmc_temp,dl
mul bx
mov dl,cmc_temp
mov bx,ax
dec dl
jnz in1
mov a,cx
lea dx,cmc_msg0
mov ah,09h
int 21h
lea di,cmc_out
add di,0007h
mov ax,a
mov bx,000ah
out1: xor dx,dx
div bx
add dx,0030h
dec di
mov [di],dl
test ax,ax
jnz out1
mov ah,09h
mov dx, offset cmc_out
int 21h
lea si,cmc_out
mov cx,08h
ou1: mov al,32
mov [si],al
inc si
dec cx
jnz ou1
mov al,36
mov [si],al
lea dx,cmc_msg1
mov ah,09h
int 21h
mov ax,44
mov cmc_t0,ax
mov ax,cmc_t0
mov a,ax
lea dx,cmc_msg2
mov ah,09h
int 21h
lea di,cmc_out
add di,0007h
mov ax,a
mov bx,000ah
out2: xor dx,dx
div bx
add dx,0030h
dec di
mov [di],dl
test ax,ax
jnz out2
mov ah,09h
mov dx, offset cmc_out
int 21h
lea si,cmc_out
mov cx,08h
ou2: mov al,32
mov [si],al
inc si
dec cx
jnz ou2
mov al,36
mov [si],al
lea dx,cmc_msg3
mov ah,09h
int 21h
mov ax,a
mov cmc_t0,ax
mov ax,5
mov cmc_t1,ax
mov ax,cmc_t0
mov bx,cmc_t1
cmp ax,bx
jg cmc_rel0
mov cmc_t2,0000h
jmp cmc_rel1
cmc_rel0:mov cmc_t2,0001h
cmc_rel1:
cmp cmc_t2,0001h
jnz cmc_if0
lea dx,cmc_msg4
mov ah,09h
int 21h
jmp cmc0
cmc_if0:
cmc0:
lea dx,cmc_msg5
mov ah,09h
int 21h
cmc1:
mov ah,4ch
int 21h
code ends
end start
