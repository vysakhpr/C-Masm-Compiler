assume cs:code,ds:data
data segment
cmc_msg0 db 10,10,"My name is ",13," Vysakh and iam a ",9," good student",10,"$"
cmc_out db '        $'
cmc_in db '        $'
cmc_temp db 01
data ends
code segment
start:
mov dx,data
mov ds,dx
lea dx,cmc_msg0
mov ah,09h
int 21h
mov ah,4ch
int 21h
code ends
end start
