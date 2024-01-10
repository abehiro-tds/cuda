#include <stdlib.h>
#include <stdio.h>

#define SIZE 256

__global__ void arrayadd(float *fOut, float *fInA, float *fInB){
  int id = threadIdx.x+blockIdx.x*blockDim.x;
  fOut[id]=fInA[id]+fInB[id];
}

int main(int argc, char** argv){
  int i;
  printf("GPU:\n");
  srand(0);
  cudaSetDevice(0);
  float *h_InA, *h_InB, *h_Out;
  h_InA=(float*)malloc(sizeof(float)*SIZE);
  h_InB=(float*)malloc(sizeof(float)*SIZE);
  h_Out=(float*)malloc(sizeof(float)*SIZE);
  for(i=0; i<SIZE; i++)   h_InA[i]=(float)(rand()%10)/10.0f;
  for(i=0; i<SIZE; i++)   h_InB[i]=(float)(rand()%10)/10.0f;
  printf("InA: "); for(i=0; i<SIZE; i++)printf(" %.2f",h_InA[i]); printf("\n");
  printf("InB: "); for(i=0; i<SIZE; i++)printf(" %.2f",h_InB[i]); printf("\n");

  float *d_InA, *d_InB, *d_Out;
  cudaMalloc((void**)&d_InA, sizeof(float)*SIZE);
  cudaMalloc((void**)&d_InB, sizeof(float)*SIZE);
  cudaMalloc((void**)&d_Out, sizeof(float)*SIZE);
  cudaMemcpy(d_InA, h_InA, sizeof(float)*SIZE, cudaMemcpyHostToDevice);
  cudaMemcpy(d_InB, h_InB, sizeof(float)*SIZE, cudaMemcpyHostToDevice);

  arrayadd<<< 16, 16 >>>(d_Out, d_InA, d_InB);

  cudaMemcpy(h_Out, d_Out, sizeof(float)*SIZE, cudaMemcpyDeviceToHost);
  printf("Out: "); for(i=0; i<SIZE; i++)printf(" %.2f", h_Out[i]); printf("\n");

  free(h_InA); free(h_InB); free(h_Out);

  cudaFree(d_InA); cudaFree(d_InB); cudaFree(d_Out);
  return 0;
}
