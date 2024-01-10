#include <time.h>
#include <stdio.h>
#include <stdlib.h>

time_t time(time_t*);
//time_t start_time, end_time;
long start_time, end_time;


#define N 2048
int a[N][N],b[N][N],c[N][N];

void init_array(int *data){
  for(int i=0; i<N*N; i++){
    data[i]=rand();
  }
}

   
int main(int argc, char *arg[]){

  printf("Calculation on CPU.\n");
  init_array((int*)a);
  init_array((int*)b);
  init_array((int*)c);

  //start_time=time(NULL);
  start_time=clock();
  
  for(int i=0;i<N;i++){
    for(int j=0;j<N;j++){
      for(int k=0;k<N;k++){
        c[i][j]+=a[i][k]*b[k][j];
      }
    }
  }

  //end_time=time(NULL);
  end_time=clock();

  printf("time:%f\n",((double)end_time-start_time)/CLOCKS_PER_SEC);

  return 0;
}

