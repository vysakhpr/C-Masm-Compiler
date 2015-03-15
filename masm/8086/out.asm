assume cs:code,ds:data
data segment
cmc_out db '        $'
cmc_in db '        $'
cmc_temp db 01
cmc_t0 dw 02
data ends
code segment
start:
mov dx,data
mov ds,dx
mov ax,2
mov cmc_t0,ax
mov ah,4ch
int 21h
code ends
end start
