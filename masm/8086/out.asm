assume cs:code,ds:data
data segment
cmc_msg0 db 0ah,0dh,"Hello"$"
cmc_out db '        $'
cmc_t0 dw 02
a dw 02
b dw 02
cmc_t1 dw 02
data ends
code segment
start:
mov dx,data
mov ds,dx
mov ax,10
mov cmc_t0,ax
mov ax,cmc_t0
mov a,ax
mov ax,15
mov cmc_t0,ax
mov ax,cmc_t0
mov b,ax
mov ax,a
mov cmc_t0,ax
mov ax,b
mov cmc_t1,ax
lea dx,cmc_msg0
mov ah,09h
int 21h
mov ah,4ch
int 21h
code ends
end start
