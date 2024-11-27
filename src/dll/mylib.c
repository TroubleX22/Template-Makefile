#include <stdio.h>

__declspec(dllexport) void message(char* input) {
    printf("Hello %s\n",input);
}