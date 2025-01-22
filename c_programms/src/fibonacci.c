#include <stdio.h>

int fibonacci(int n) {
    if (n <= 1) {
        return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int main(int argc, char**argv) {
	int n = 25;
    printf("Fibonacci(%d) = %d\n", n, fibonacci(n));
    return 0;
}
