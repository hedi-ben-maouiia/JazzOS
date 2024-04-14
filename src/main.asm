; ORG is telling the assembler that we do all our addressing relative to that address
ORG  0x7C00   

; In the start we start with 16-bits
BITS 16    

main:
    ; To stop the cpu 
    HLT        

halt:
    JMP halt


; Times repeat what i tell number of times and ($-$$) give us how much byte our program take 
TIMES 510-($-$$) DB 0 
DW 0AA55h
