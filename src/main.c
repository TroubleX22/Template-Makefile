#include "other.h"
#include "first.h"

int main(int argc, char* argv[]) {
    int y = 1;
    int x[y];
    x[0] = add(4, 5);

    writeOut((argc > 1) ? argv[1] : "Roul", x[0]);

    return 0;
}