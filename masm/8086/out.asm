assume cs:code,ds:data
data segment
cmc_out db '        $'
cmc_in db '        $'
cmc_temp db 01
data ends
code segment
start:
mov dx,data
mov ds,dx
mov ah,4ch
int 21h
code ends
end start
