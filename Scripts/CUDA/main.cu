#include "aligner.h"
#include <helper_cuda.h>
#include <time.h>
//__global__ void kernel(float* MAT,char* a,char* b,int *k){
__global__ void kernel(float* MAT,char** a,int *k,double *len){
  int col = blockIdx.y*blockDim.y+threadIdx.y;
  int row = blockIdx.x*blockDim.x+threadIdx.x;
  if(col>row){
    MAT[row*int(*len)+col] = aligner::kmdist(a[row],a[col],k);
  }
}
//aligner::compare(ex1,ex2,m);
void compare(float* MAT,float* HMAT,double size,double len,char* r[],int k);
unsigned long vecsize(double f);
int main(int argc, char const *argv[]) {
  string file = argv[1];
  int K = atoi(argv[2]);
  aligner objAl(file);
  double len = objAl.length();
  objAl.getReads();
  double size = len*len;
  //vector<float> h_mat(size);
  float* h_mat;
  h_mat = (float*)malloc(int(size*sizeof(float)));
  //dev_array<float> d_mat(size);
  float* d_mat;
  checkCudaErrors(cudaMalloc((void**)&d_mat,int(size*sizeof(float))));
  checkCudaErrors(cudaMemcpy(d_mat,h_mat,int(size*sizeof(float)),cudaMemcpyHostToDevice));
  compare(d_mat,h_mat,size,len,objAl.h_reads,K);
  for(int i = 0;i<int(len);i++){
    for(int j = 0;j<(len);j++){
      printf("%f  ", h_mat[i*int(len)+j]);
    }
    printf("\n");
  }
  return 0;
}
unsigned long vecsize(double f){
  unsigned long s = 0;
  for(int i = 0;i<f;i++){s+=i;}
  return s;
}
//Call to the global function and make everything
void compare(float* MAT,float* HMAT,double size,double len,char* r[],int k){
  char **d_reads, **d_tmp;
  checkCudaErrors(cudaMalloc((void**)&d_reads,len*sizeof(char*)));
  d_tmp = (char**)malloc(len*sizeof(char*));
  int slen = 0;
  for(int i=0;i<len;i++){
    slen = strlen(r[i]);
    checkCudaErrors(cudaMalloc(&(d_tmp[i]),slen*sizeof(char)));
    checkCudaErrors(cudaMemcpy(d_tmp[i],r[i],slen*sizeof(char),cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(d_reads+i,&(d_tmp[i]),sizeof(char*),cudaMemcpyHostToDevice));
  }
  int *d_k;
  int* ptr_max_len = &k;
  checkCudaErrors(cudaMalloc((void**)&d_k,int(sizeof(int))));
  checkCudaErrors(cudaMemcpy(d_k,ptr_max_len,int(sizeof(int)),cudaMemcpyHostToDevice));
  double *d_len;
  double* d_tmp_len = &len;
  checkCudaErrors(cudaMalloc((void**)&d_len,int(sizeof(double))));
  checkCudaErrors(cudaMemcpy(d_len,d_tmp_len,int(sizeof(double)),cudaMemcpyHostToDevice));
  dim3 threadsPerBlock(len, len);
  dim3 blocksPerGrid(1, 1);
  if (len*len > 1024){
    threadsPerBlock.x = 32;
    threadsPerBlock.y = 32;
    blocksPerGrid.x = ceil(double(len)/double(threadsPerBlock.x));
    blocksPerGrid.y = ceil(double(len)/double(threadsPerBlock.y));
  }
  //para tomar el tiempo
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  //funcion paralela
  cudaEventRecord(start,0);
  kernel<<<blocksPerGrid,threadsPerBlock>>>(MAT,d_reads,d_k,d_len);
  cudaDeviceSynchronize();
  cudaEventRecord(stop,0);
  cudaEventSynchronize(stop);
  float timer = 0;
  cudaEventElapsedTime(&timer,start,stop);
  cout << "Elapsed parallel time:" << timer/1000 << "seconds" << endl;
  checkCudaErrors(cudaMemcpy(HMAT,MAT,int(size*sizeof(float)),cudaMemcpyDeviceToHost));
  cudaDeviceSynchronize();
}
//MAT.get(&HMAT[0],size);
/*
int max_len, num_str;
num_str = 6;
char* tmp[num_str];
max_len = k;
int *d_max_len;
int* ptr_max_len = &k;
checkCudaErrors(cudaMalloc((void**)&d_max_len,sizeof(int)));
checkCudaErrors(cudaMemcpy(d_max_len,ptr_max_len,sizeof(int),cudaMemcpyHostToDevice));
for(int i=0;i<num_str;i++){
  tmp[i] = (char*) malloc(max_len*sizeof(char));
}
char* ex1 = "abb";
char* ex2 = "abd";
char* ex3 = "abc";
char* ex4 = "aaa";
char* ex5 = "aab";
char* ex6 = "bbb";
char* ex7 = "bba";
tmp[0] = ex1;
tmp[1] = ex2;
tmp[2] = ex3;
tmp[3] = ex4;
tmp[4] = ex5;
tmp[5] = ex6;
char* ex, *d_ex1, *d_ex2;
ex = (char*) malloc(max_len*num_str*sizeof(char));
ex1 = (char*) malloc(max_len*num_str*sizeof(char));
int n = 0;
for(int i=0;i<num_str;i++){
  for(int j = 0;j<max_len;j++){
    ex[n] = tmp[i][j];
    ex1[n] = tmp[i][j];
    n++;
  }
}
int s = max_len*num_str*sizeof(char);
checkCudaErrors(cudaMalloc((void**)&d_ex1,s));
checkCudaErrors(cudaMemcpy(d_ex1,ex,s,cudaMemcpyHostToDevice));
checkCudaErrors(cudaMalloc((void**)&d_ex2,s));
checkCudaErrors(cudaMemcpy(d_ex2,ex1,s,cudaMemcpyHostToDevice));
double *d, *d_d;
d = (double*)malloc(int(sizeof(double)));
*d = 1.0;
checkCudaErrors(cudaMalloc((void**)&d_d,int(sizeof(double))));
checkCudaErrors(cudaMemcpy(d_d,d,int(sizeof(double)),cudaMemcpyHostToDevice));
//lo anterior funciona
char** d_tmp;
checkCudaErrors(cudaMalloc((void**)&d_tmp,s));
checkCudaErrors(cudaMemcpy(d_tmp,tmp,s,cudaMemcpyHostToDevice));
*/
