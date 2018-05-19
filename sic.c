#include <stdio.h>
#include <stdlib.h>
/* change to whatever you like: */
#define MAX_PHYSICAL_MEMORY 4096
static long M[MAX_PHYSICAL_MEMORY] = {56, 54, 36, 55, 55, 6, 55, 52, 9, 55,
                                      53, 12, 52, 52, 15, 51, 51, 18, 51, 53,
                                      21, 52, 51, 24, 53, 53, 27, 53, 55, 30,
                                      55, 55, 33, 55, 54, 0, 0, 0, 39, 51,
                                      51, 42, 51, 52, 45, 0, 51, 48, 0, 0,
                                      0, 0, 0, 1, 1, 0, 10};
int main() {
    int i = 0;
    char *format;
    while (M[i] || M[i + 1] || M[i + 2]){
        if ((M[M[i]] -= M[M[i + 1]]) < 0) {
            i = M[i + 2];}
        else {
            i += 3;
        }
    }
    for (i = 0; i < MAX_PHYSICAL_MEMORY; ++i)
    {
        printf("%d ", M[i]);
    }
    printf("\n");
    return 0;
}