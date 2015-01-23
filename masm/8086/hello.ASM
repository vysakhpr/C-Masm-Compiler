DATA SEGMENT
NUM1 DW 65000
NUM2 DW 300
CMC_OUT DB '        $'
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:  MOV AX,DATA
MOV DS,AX

;------Display on screen------------
LEA DI,CMC_OUT
ADD DI,0007H
MOV AX,NUM1
MOV BX,000AH    ;BX=10 used as a constatnt in the following loop
OUT1:
XOR DX,DX
DIV BX      ;quotient in AX remainder in DX
ADD DX,0030H
DEC DI
MOV [DI],DL
TEST AX,AX  ;check if ax is 0
JNZ OUT1

MOV AH,09H
MOV DX,OFFSET CMC_OUT
INT 21H

LEA SI,CMC_OUT
MOV CX,0008H
OU1: MOV AL,32
MOV [SI],AL
INC SI
DEC CX
JNZ OU1
MOV AL,36
MOV [SI],AL





LEA DI,CMC_OUT
ADD DI,0007H
MOV AX,NUM2
MOV BX,000AH    ;BX=10 used as a constatnt in the following loop
OUT2:
XOR DX,DX
DIV BX      ;quotient in AX remainder in DX
ADD DX,0030H
DEC DI
MOV [DI],DL
TEST AX,AX  ;check if ax is 0
JNZ OUT2

MOV AH,09H
MOV DX,OFFSET CMC_OUT
INT 21H
;-----end the program--------------
MOV AH,4CH
INT 21H
CODE ENDS
END START

