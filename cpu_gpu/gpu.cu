#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define N 2048
#define BS 32

long start_time,end_time;
int ha[N*N],hb[N*N],hc[N*N];

__global__ void transpose(int *a,int *b, int *c){
  int i;
  int idx=blockDim.x*blockIdx.x+threadIdx.x;
  int idy=blockDim.y*blockIdx.y+threadIdx.y;
  int id =idy*N+idx;

  c[id]=0;
  for(i=0;i<N;i++)
    c[id]+=a[idy*N+i] * b[(i*N) + idx];
}

void init_array(int *data){
  for(int i=0;i<N*N;i++){
    data[i]=rand();
  }
}
  

int main(int argc, char *argv[]){
  int *da,*db,*dc;

  cudaMalloc(&da,N*N*sizeof(int));
  cudaMalloc(&db,N*N*sizeof(int));
  cudaMalloc(&dc,N*N*sizeof(int));
  init_array((int*)ha);
  init_array((int*)hb);

  start_time=clock();
  cudaMemcpy(da,(int*)ha, N*N*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(db,(int*)hb, N*N*sizeof(int), cudaMemcpyHostToDevice);
  dim3 dimGrid(N/BS, N/BS);
  dim3 dimBlock(BS, BS);
  transpose<<<dimGrid, dimBlock>>>(da,db,dc);
  cudaMemcpy((int*)hc, dc, N*N*sizeof(int), cudaMemcpyDeviceToHost);
  end_time=clock();

  printf("time:%f\n",(double)(end_time-start_time)/CLOCKS_PER_SEC);

  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);

  return 0;
}

