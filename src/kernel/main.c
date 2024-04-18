#include "stdint.h" 
#include "stdio.h" 

void _cdecl cstart_(){
    puts("Hello world from C!");
    printf("Formatted %% %c %s\r\n", 'T',"hello");
    printf("%s","what's up");
    printf("%d",2323);
}
