assume cs:code,ds:data
data segment
var1 dw 02
var2 dw 02
var3 dw 02
data ends
code segment
start:mov ax,data
      mov ds,ax

      mov ah,02h
      mov dl,12h
      int 21h

      mov ah,4Ch
      int 21h
 code ends
 end start

