#include <stdio.h>
int i = 2, f = 1,n=0;
int factorial(int n)
{

    if (n < 0)
        return -1;
    while (i <= n)
    {
        f = f * i;
        i = i + 1;
    }
    return f;
}

int main()
{
    scanf("%d", &n);
    n = factorial(n);
    printf("%d", n);
    return 0;
}
