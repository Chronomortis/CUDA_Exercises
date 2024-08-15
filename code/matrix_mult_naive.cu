#include <iostream>
#include <cmath>
#include <stdio.h>
#include <algorithm>
#define M 4
#define N 4

__global__ void matrix_multiplication(int *a,int *b, int *c,int divisor ,int row, int column,int n) 
{
	int index = threadIdx.x + blockDim.x * blockIdx.x;
	if(index < n) 
	{
	
		int res_row = index / column;
		int res_column = index % column;
		for(int i = 0; i < divisor; i++) 
		{
			c[index] += a[res_row * divisor + i] * b[column * i + res_column];
		}
		printf("C Index %i Value: %i\n",index,c[index]);
	}
}




int main() 
{
int *a,*b,*c; // host pointers
int *d_a,*d_b,*d_c; //device pointers.
int divisor,count = 1;

// Finding the greatest common denominator.
while(count < sqrt(M) && count < sqrt(N)) 
{
	if(M % count == 0 && N % count == 0) 
	{
		divisor = count;
	}	
	count++;
}
int size_c = (M / divisor) * (N / divisor);
printf("Size C Value: %i\n Divisor Value: %i\n",size_c,divisor);
a = (int *) malloc(N * sizeof(int));
b = (int *) malloc(M * sizeof(int));
c = (int *) malloc(size_c * sizeof(int));

for(int i = 0; i < M; i++) 
{
	b[i] = i + 2;
	std::cout << b[i] << "a member of matrix B" << std::endl;
}
for(int j = 0; j < N; j++) 
{
	a[j] = j + 1;
	std::cout << a[j] << "a member of matrix A" << std::endl;
}

cudaMalloc((void **)&d_a, N * sizeof(int));
cudaMalloc((void **)&d_b, M * sizeof(int));
cudaMalloc((void **)&d_c, size_c * sizeof(int));

cudaMemcpy(d_a,a, N * sizeof(int),cudaMemcpyHostToDevice);
cudaMemcpy(d_b,b, M * sizeof(int),cudaMemcpyHostToDevice);


matrix_multiplication<<<( ((M + N - 1) / 32) + 1),32>>>(d_a,d_b,d_c,divisor,(N / divisor),(M / divisor),size_c);
cudaMemcpy(c,d_c, size_c * sizeof(int), cudaMemcpyDeviceToHost);

cudaDeviceSynchronize();
for(int i = 0; i < size_c; i++) 
{
	if(i % (N / divisor) == 0 && i != 0) {std::cout << std::endl;}
	std::cout << c[i] << " ";
}
std::cout << "\n";
free(a);
free(b);
free(c);

cudaFree(d_a);
cudaFree(d_b);
cudaFree(d_c);
return 0;




}
