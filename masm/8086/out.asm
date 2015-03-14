assume cs:code,ds:data
data segment
cmc_msg0 db "$"
cmc_msg1 db "$"
cmc_out db '        $'
cmc_in db '        $'
cmc_temp db 01
cmc_t0 dw 02
i dw 02
data ends
code segment
start:
mov dx,data
mov ds,dx
mov ax,5
mov cmc_t0,ax
mov ax,cmc_t0
mov i,ax
mov ax,10
mov cmc_t0,ax
lea dx,cmc_msg0
mov ah,09h
int 21h
lea dx,cmc_msg1
mov ah,09h
int 21h
mov ah,4ch
int 21h
code ends
end start
