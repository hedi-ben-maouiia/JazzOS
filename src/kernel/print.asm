BITS 16 

section _TEXT class=CODE

global _x86_Video_WriteCharTeletype 
_x86_Video_WriteCharTeletype:
        PUSH bp
        MOV bp,sp 

        PUSH bx

        MOV ah,0x0e 
        MOV al,[bp+4]
        MOV bh,[bp+6]
        
        INT 0x10 
        
        POP bx 
        MOV sp,bp 

        POP bp 

        RET
