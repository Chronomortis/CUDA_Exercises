#include <iostream>
using namespace std;

#define N 512
/*CUDA Intro:
Host = CPU
Device = GPU
The var. within those can't (normally) be dereferenced or passed to the other

To handle GPU/device memory: cudaFree(),cudaMemcpy() and cudaMalloc() can be used.

Kernel Launch Configurations: 

 */

__global__ void add(int *a, int *b, int *c) // Basically a function that is executed from the GPU.
{
	// blockIdx.x works because block size is 1 and amount of threads are also 1 with a thread ID of 0.
	c[blockIdx.x] == a[blockIdx.x] + b[blockIdx.x];

}

int main(void) // I don't know about the void part. 
{
	int *a, *b, *c; // Pointers for host
	int *d_a,*d_b,*d_c; // Pointers for the device.
	int size = N * sizeof(int);
	
	// Allocate memory space on GPU for the vectors. Don't know about void ** part.
	
	cudaMalloc((void **) &d_a, size);
	cudaMalloc((void **) &d_b, size);
	cudaMalloc((void **) &d_c, size);

	
	// Allocating memory on CPU and initializing a & b vectors with random numbers with the amount of N.
	a = (int *)malloc(size);
	b = (int *)malloc(size);
	c = (int *)malloc(size);
	random_ints(a,N);
	random_ints(b,N);

	//Copying data from the host(CPU) to the device(GPU).
	cudaMemcpy(d_a, a, size, cudaMemcpyHosttoDevice);
	cudaMemcpy(d_b, b, size, cudaMemcpyHosttoDevice); // Parameters for cudaMemcpy = GPU pointer, CPU pointer, size of the copying, the direction of the copying.
	
	// Launching the add() kernel from the GPU. Kernel takes in var. from the GPU. 
	add<<<N,1>>>(d_a,d_b,d_c) 
	
	// Copy results back to the CPU.
	cudaMemcpy(c,d_c,size,cudaMemcpyDevicetoHost);


	// Cleanup:
	free(a);
	free(b);
	free(c);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	return 0;






}
