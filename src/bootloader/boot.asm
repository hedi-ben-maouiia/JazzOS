; ORG is telling the assembler that we do all our addressing relative to that address
ORG  0x7C00   

; In the start we start with 16-bits
BITS 16    

JMP SHORT main ; jump inside the file and this to ignore the header and jump to the main directly   
NOP

; Disk Header value 
bdb_oem:                   DB      'MSWIN4.1'
bdb_bytes_per_sector:      DW      512
bdb_sectors_per_cluster:   DB      1 
bdb_reserved_sectors:      DW      1 
bdb_fat_count:             DB      2
bdb_dir_entries_count:     DW      0E0h
bdb_total_sectores:        DW      2880
bdb_media_descriptor_type: DB      0F0h 
bdb_sectors_per_fat:       DW      9
bdb_sectors_per_track:     DW      18
bdb_heads:                 DW      2
bdb_hidden_sectors:        DD      0 
bdb_large_sector_count:    DD      0 

ebr_drive_number:          DB      0 
                           DB      0 
ebr_signature:             DB      29h 
ebr_volume_id:             DB      12h,34h,56h,78h 
ebr_volume_label:          DB      'JAZZ OS    '
ebr_system_id:             DB      'FAT12   '


main:
    ; we initialize every thing to zero for reset 
    MOV  ax,0
    MOV  ds,ax       ; ds = data segment register 
    MOV  es,ax       ; es = extra segment register 
    MOV  ss,ax       ; ss = stack segment register 
     
    MOV  sp,0x7C00   ; sp = stack pointer 
    
    MOV [ebr_drive_number],dl
    MOV ax,1
    MOV cl,1
    MOV bx,0x7E00    ; pointer to buffer on our disk 
    CALL disk_read
    
    MOV  si,os_boot_msg 
    CALL print
    HLT              ; To stop the cpu 

halt:
    JMP halt

;input = LBA index in ax 
;cx [bits 0-5]:  sector number 
;cx [bits 6-15]: cylinder 
;dh = head
lba_to_chs:
    PUSH ax
    PUSH dx 
    
    XOR dx,dx 
    DIV word [bdb_sectors_per_track] ;(LBA % sectors per track ) <- sector 
    
    INC dx  ;sector 
    MOV cx,dx 
    
    XOR dx,dx
    ;head = (LBA/sectors per track) % number of heads 
    ;cylinder: (LBA / sectors per track) / number of heads 

    DIV word [bdb_heads]

    MOV dh,dl ; head 

    MOV ch,al 
    SHL ah,6 
    OR cl,ah ; cylinder

    POP ax 
    MOV dl,al 
    POP ax 

    RET

disk_read:
    PUSH ax
    PUSH bx 
    PUSH cx 
    PUSH dx 
    PUSH di 
    
    CALL lba_to_chs
    
    MOV ah,02h 
    MOV di,3 ; counter 
retry:
    STC     ; set a carry 
    INT 13h 
    JNC done_read 

    CALL disk_reset
    
    DEC di 
    TEST di,di 
    JNZ retry 

fail_disk_read:
    MOV si,read_failure
    CALL print 
    HTL 
    JMP halt 

done_read:
    POP di 
    POP dx 
    POP cx
    POP bx
    POP ax 


disk_reset:
    PUSHA 
    MOV ah,0
    STC 
    INT 13h
    JC fail_disk_read
    POPA 
    RET

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
os_boot_msg:  DB 'Our OS has booted!', 0x0D, 0x0A, 0

read_failure: DB 'Faild to read disk!', 0x0D, 0x0A, 0

; Times repeat what i tell number of times and ($-$$) give us how much byte our program take 
TIMES 510-($-$$) DB 0 
DW 0AA55h
