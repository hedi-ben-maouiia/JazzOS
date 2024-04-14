; ORG is telling the assembler that we do all our addressing relative to that address
ORG  0x7C00   

; In the start we start with 16-bits
BITS 16    

main:
    ; we initialize every thing to zero for reset 
    MOV  ax,0
    MOV  ds,ax       ; ds = data segment register 
    MOV  es,ax       ; es = extra segment register 
    MOV  ss,ax       ; ss = stack segment register 
     
    MOV  sp,0x7C00   ; sp = stack pointer 
    MOV  si,os_boot_msg 
    CALL print
    HLT              ; To stop the cpu 

halt:
    JMP halt

print: 
    PUSH si         ; si have the string that we want to printed on screen 
    PUSH ax
    PUSH bx 

print_loop:
    LODSB           ; LODSB is instruction to load a single byte from the current location 
    OR al,al        ; al hase the value that we want to print on the screen 
    JZ done_print

    MOV ah,0x0E     ; 0x0E represent printing value to the screen (system call ) 
    MOV bh,0 
    INT 0x10        ; 0x10 is a vedio interrept code 
    
    JMP print_loop

done_print:
    POP bx
    POP ax
    POP si 
    RET

; I define the string i want to print when we boot 
os_boot_msg: DB 'Our OS has booted!', 0x0D, 0x0A, 0

; Times repeat what i tell number of times and ($-$$) give us how much byte our program take 
TIMES 510-($-$$) DB 0 
DW 0AA55h
