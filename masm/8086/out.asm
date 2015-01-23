assume cs:code,ds:data
data segment
cmc_msg0 db 0ah,0dh,"the sum is $"
cmc_msg1 db 0ah,0dh," $"
cmc_out db '        $'
a dw 02
b dw 02
sum dw 02
diff dw 02
cmc_t0 dw 02
cmc_t1 dw 02
cmc_t2 dw 02
data ends
code segment
start:
mov dx,data
mov ds,dx
mov ax,45
mov cmc_t0,ax
mov ax,cmc_t0
mov a,ax
mov ax,55
mov cmc_t0,ax
mov ax,cmc_t0
mov b,ax
mov ax,a
mov cmc_t0,ax
mov ax,b
mov cmc_t1,ax
mov ax,cmc_t0
mov bx,cmc_t1
add ax,bx
mov cmc_t2,ax
mov ax,cmc_t2
mov a,ax
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
mov ah,4ch
int 21h
code ends
end start
