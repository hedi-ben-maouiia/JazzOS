#include "stdint.h" 
#include "stdio.h" 

void _cdecl cstart_(){
    puts("Hello world from C!\r\n");
    printf("Formatted %% %c %s\r\n", 'T',"hello");
    printf("%s","what's up\r\n");
    printf("%d\r\n",2323);
    printf("%x\r\n",15);
}
