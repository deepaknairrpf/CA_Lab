#include <stdio.h>
#include <stdlib.h>
#include<time.h>

int main()
{
	for(int i=0;i<4096;i++)
		printf("memory[%d] = 32'd%d;\n",i,rand()%10000000);
}