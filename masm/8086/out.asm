assume cs:code,ds:data
data segment
cmc_msg0 db "Haha$"
cmc_out db '        $'
cmc_in db '        $'
cmc_temp db 01
cmc_t0 dw 02
i dw 02
cmc_t1 dw 02
cmc_t2 dw 02
cmc_t3 dw 02
cmc_t4 dw 02
cmc_t5 dw 02
data ends
code segment
start:
mov dx,data
mov ds,dx
mov ax,0
mov cmc_t0,ax
mov ax,cmc_t0
mov i,ax
cmc_loop_label_0:
cmc_continue_label_0:
mov ax,i
mov cmc_t0,ax
mov ax,10
mov cmc_t1,ax
mov ax,cmc_t0
mov bx,cmc_t1
cmp ax,bx
jl cmc_rel0
mov cmc_t2,0000h
jmp cmc_rel1
cmc_rel0:
mov cmc_t2,0001h
cmc_rel1:
cmp cmc_t2,0001h
jge cmc_nxt0
jmp cmc_if0
cmc_nxt0:
lea dx,cmc_msg0
mov ah,09h
int 21h
mov ax,i
mov cmc_t3,ax
mov ax,1
mov cmc_t4,ax
mov ax,cmc_t3
mov bx,cmc_t4
add ax,bx
mov cmc_t5,ax
mov ax,cmc_t5
mov i,ax
mov ax,i
mov cmc_t0,ax
mov ax,1
mov cmc_t1,ax
mov ax,cmc_t0
mov bx,cmc_t1
add ax,bx
mov cmc_t2,ax
mov ax,cmc_t2
mov i,ax
jmp cmc_loop_label_0
jmp cmc0
cmc_if0:
cmc0:
mov ah,4ch
int 21h
code ends
end start
