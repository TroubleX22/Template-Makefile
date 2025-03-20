#ifdef __cplusplus
#include <iostream>

class Printer {
public:
    void operator()(const char *input, int number) {
        std::cout << input << ':' << number << std::endl;
    }
};

Printer print;

#else
#include <stdio.h>

typedef int (*Printer)(const char *restrict, ...);

Printer _print = printf;

void print(const char* input, int number) {
    _print("%s:%d\n", input, number);
}

#endif

#include "other.h"

void writeOut(const char *input, int number) {
    print(input, number);
}