assume cs:code,ds:data
data segment
cmc_msg0 db "Greater than five$"
cmc_msg1 db "Less than five$"
cmc_msg2 db "Equal to five$"
cmc_out db '        $'
cmc_in db '        $'
cmc_temp db 01
i dw 02
cmc_t1 dw 02
cmc_t0 dw 02
cmc_t2 dw 02
cmc_t3 dw 02
cmc_t4 dw 02
cmc_t5 dw 02
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
mov i,cx
mov ax,i
mov cmc_t0,ax
mov ax,5
mov cmc_t1,ax
mov ax,cmc_t0
mov bx,cmc_t1
cmp ax,bx
jg cmc_rel0
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
jmp cmc0
cmc_if0:
mov ax,i
mov cmc_t3,ax
mov ax,5
mov cmc_t4,ax
mov ax,cmc_t3
mov bx,cmc_t4
cmp ax,bx
jl cmc_rel2
mov cmc_t5,0000h
jmp cmc_rel3
cmc_rel2:
mov cmc_t5,0001h
cmc_rel3:
cmp cmc_t5,0001h
jge cmc_nxt1
jmp cmc_if1
cmc_nxt1:
lea dx,cmc_msg1
mov ah,09h
int 21h
jmp cmc0
cmc_if1:
lea dx,cmc_msg2
mov ah,09h
int 21h
cmc0:
mov ah,4ch
int 21h
code ends
end start
