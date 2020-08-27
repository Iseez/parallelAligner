#include "aligner.h"
#include <helper_cuda.h>
#include <time.h>
//__global__ void kernel(float* MAT,char* a,char* b,int *k){
__global__ void kernel(float* MAT,char** a,int *k){
  int index = threadIdx.x + (blockIdx.x * blockDim.x);
  float ff = aligner::kmdist(a[0],a[0],k);
  printf("%f\n", ff);
  MAT[index] = index;
}
//aligner::compare(ex1,ex2,m);
void compare(dev_array<float> MAT,vector<float> HMAT,long size,double len,char* r[],int k);
unsigned long vecsize(double f);
int main(int argc, char const *argv[]) {
  string file = argv[1];
  int K = atoi(argv[2]);
  aligner objAl(file);
  double len = objAl.length();
  objAl.getReads();
  unsigned long size = vecsize(len);
  vector<float> h_mat(size);
  dev_array<float> d_mat(size);
  compare(d_mat,h_mat,size,len,objAl.h_reads,K);
  return 0;
}
unsigned long vecsize(double f){
  unsigned long s = 0;
  for(int i = 0;i<f;i++){s+=i;}
  return s;
}
//Call to the global function and make everything
void compare(dev_array<float> MAT,vector<float> HMAT,long size,double len,char* r[],int k){
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
  int threads = size;
  int blocks = 1;
  if(size > 1024){
    blocks = ceil(size/1024);
  }
  //para tomar el tiempo
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  //funcion paralela
  cudaEventRecord(start,0);
  //kernel<<<1,1>>>(MAT.getData(),d_ex1,d_ex2,d_max_len);
  kernel<<<1,1>>>(MAT.getData(),d_reads,d_k);
  cudaDeviceSynchronize();
  cudaEventRecord(stop,0);
  cudaEventSynchronize(stop);
  float timer = 0;
  cudaEventElapsedTime(&timer,start,stop);
  cout << "Elapsed parallel time:" << timer/1000 << "seconds" << endl;
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
