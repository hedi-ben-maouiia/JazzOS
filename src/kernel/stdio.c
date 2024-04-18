#include "stdio.h"
#include "print.h"

void putc(char c){
    x86_Video_WriteCharTeletype(c,0);
}

void puts(const char *s){
    while(*s){
        putc(*s);
        s++;
    }
}

void puts_f(const char far* s){
    while(*s){
        putc(*s);
        s++;
    }
}

void _cdecl printf(const char* fmt,...){
    int* argp = (int*) &fmt;
    int state = PRINTF_STATE_START;
    int length = PRINTF_LENGTH_START;
    int radix = 10;
    bool sign = false;

   argp++;
   while(*fmt){
       case PRINTF_STATE_START:
           if(*fmt == "%"){
               state = PRINTF_STATE_LENGTH;
           } else {
               putc(*fmt);
           }
           break;
       case PRINTF_STATE_LENGTH:
           if(*fmt == 'h'){
               lenght = PRINTF_LENGTH_SHORT;
               state = PRINTF_STATE_SHORT;
           }else if(*fmt == 'l'){
               length = PRINTF_LENGTH_LONG;
               state = PRINTF_STATE_LONG;
           }else {
               goto PRINTF_STATE_SPEC_;
           }
           break;
       case PRINTF_STATE_SHORT:
           if(*fmt == 'h'){
               length = PRINTF_LENGTH_SHORT_SHORT;
               state = PRINTF_STATE_SPEC;
           }else{
               goto PRINTF_STATE_SPEC_;
           }
           break;
       case PRINTF_STATE_LONG:
           if(*fmt == 'l'){
               length = PRINTF_LENGTH_LONG_LONG;
               state = PRINTF_STATE_SPEC;
           }else{
               goto PRINTF_STATE_SPEC_;
           }
           break;
        case PRINTF_STATE_SPEC:
            PRINTF_STATE_SPEC_:
                switch(*fmt){
                    case 'c':
                        putc((char)*argp);
                        argp++;
                        break;
                    case 's':
                        if(length == PRINTF_LENGTH_LONG || length == PRINTF_LENGTH_LONG_LONG){
                            puts_f(*(const char far**)argp);
                            argp += 2;
                        }else {
                            puts(*(const char **)argp);
                            argp++;
                        }
                        break;
                    case '%':
                        putc('%');
                        break;
                    case 'd':
                    case 'i':
                        radix = 10;
                        sign = true;
                        argp = printf_number(argp,length,sign,radix);
                        break;
                    case 'u':
                        radix = 10;
                        sign = false;
                        argp = printf_number(argp,length,sing,radix);
                        break;
                    case 'X':
                    case 'x':
                    case 'p':
                        radix = 16;
                        sign = false;
                        argp = printf_number(argp,length,sign,radix);
                        break;
                    case 'o':
                        radix = 8;
                        sign = false;
                        argp = printf_number(argp,length,sign,radix);
                        break;
                    default:
                        break;
                }
                state = PRINTF_STATE_START;
                length = PRINTF_LENGTH_START;
                radix = 10;
                sign = false;
                break;
   }
}

const char possible_chars[] = "0123456789abcdef";

int * printf_number(int * argp,int length,bool sign,int radix){
    char buffer[32];
    uint64_t number;
    int number_sign = 1;
    int pos = 0;

    switch(length){
        case PRINTF_LENGTH_SHORT_SHORT:
        case PRINTF_LENGTH_SHORT:
        case PRINTF_LENGTH_START:
            if(sign){

            }
        case PRINTF_LENGTH_LONG:
        case PRINTF_LENGTH_LONG_LONG:
    }
}
