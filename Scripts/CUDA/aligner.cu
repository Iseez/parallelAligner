#include "aligner.h"

__host__ aligner::aligner(){}
__host__ aligner::aligner(string name){
  fileName = name;
}
__host__ aligner::~aligner(){}

__host__ double aligner::length(){
    double counter = 0;
    ifstream file(fileName.c_str());
    string data;
    while(getline(file,data)){
        if(data[0] == '>')counter++;
    }
    noReads =  counter;
    return counter;
}
__host__ void aligner::getReads(){
  reads = new vector<string>(noReads);
  h_reads = new char*[int(noReads)];
  headers =  new vector<string>(noReads);
  ifstream file(fileName.c_str());
  stringstream buffer;
  buffer << file.rdbuf();
  string data,id,seq;
  double indx = 0;
  while (getline(buffer, data)) {
    if(data.empty())
        continue;
    if(data[0] == '>') {
      if(!id.empty())
        {reads->at(indx) = seq;
        h_reads[int(indx)] = (char*)malloc((seq.size()+1)*sizeof(char));
        strcpy(h_reads[int(indx)],seq.c_str());
        h_reads[seq.size()] = '\0';
        headers->at(indx) = id;
        indx++;}
      id = data.substr(1);
      seq.clear();
    }
    else {
      seq += data;
    }
  }
  if(!id.empty()){
    reads->at(indx) = seq;
    h_reads[int(indx)] = (char*)malloc((seq.size()+1)*sizeof(char));
    strcpy(h_reads[int(indx)],seq.c_str());
    h_reads[seq.size()] = '\0';
    headers->at(indx) = id;
  }
}
__device__ void aligner::swapp(char* a,int id1,int id2,int k){
  char c;
  for(int i=0;i<k;i++){
    c = a[id1+i];
    a[id1+i] = a[id2+i];
    a[id2+i] = c;
  }
}
__device__ bool minstr(char* a,char* b,int k){
  for(int i =0;i<k;i++){
    if(a[i] < b[i]){return true;}
    if(a[i] > b[i]){return false;}
  }
  return false;
}
__device__ void alphsort(char* arr,int size,int k){
  char *tmp1,*tmp2;
  tmp2 = (char*)malloc(k*sizeof(char));
  tmp1 = (char*)malloc(k*sizeof(char));
  for(int i = 0;i<(size*k);i+=k){
    for(int l = 0;l<(size-1)*k;l+=k){
      for(int j = 0;j<k;j++)
        {tmp1[j] = arr[j+l];
        tmp2[j] = arr[j+l+k];}
      if(minstr(tmp2,tmp1,k))
      {aligner::swapp(arr,l,l+k,k);
      }
    }
  }
  free(tmp2);free(tmp1);
  /*
  if (l >= r){return;}
  char* pivot;
  pivot = (char*)malloc(k);
  int n = 0;
  for(int i = r*k;i<(r+1)*k;i++){
    pivot[n] = arr[i];
    n++;
  }
  int cnt = l;
  char* tmp;
  tmp = (char*)malloc(k);
  for(int i = l*k;i<r*k;i+=k){
    for(int j = 0;j<k;j++)
      {tmp[j] = arr[j+i];}
    if(minstr(tmp,pivot,k)){
      aligner::swapp(arr,cnt,i,k);
      cnt+=k;
    }
    alphsort(arr, l, cnt-(2*k),k);
    alphsort(arr, cnt, r,k);
  */
}
__device__ int cmpr(char* a,char* b,int k){
  for(int i =0;i<k;i++){
    if(a[i] < b[i]){return 0;} //a es menor
    if(a[i] > b[i]){return 1;} //b es mayor
  }
  return 2; //son iguales
}

__device__ double aligner::compare(char* v1 , char* v2,int* k){
  int len1 = 0,len2=0;
  double res = 0;
  int dk = *k;
  while (v1[len1] !='\0') {
    len1++;}
  while (v2[len2] !='\0') {
    len2++;}
  int size1 = len1/dk;
  int size2 = len2/dk;
  alphsort(v1,size1,dk);
  alphsort(v2,size2,dk);
  int i = 0,j=0;
  char *tmp1, *tmp2;
  tmp1 = (char*)malloc(dk*sizeof(char));
  tmp2 = (char*)malloc(dk*sizeof(char));
  int mm;
  while (i<len1&&j<len2) {
    for(int c=0;c<dk;c++){
      tmp1[c] = v1[c+i];
      tmp2[c] = v2[c+j];
    }
    mm = cmpr(tmp1,tmp2,dk);
    if(mm == 2){
      i+=dk;
      j+=dk;
      res++;
    }
    else{
        if (mm==0){i+=dk;}
        else{j+=dk;}
    }
  }
  free(tmp1);free(tmp2);
  return res;
}
/*  //COnfirmación del sort
  vector<string> res1(v1.size());
  vector<string> res2(v2.size());
  alphabaticallySort(v1,res1);
  alphabaticallySort(v2,res2);
  int i = 0,j = 0;
  double k = 0;
  while(i<res1.size() && j<res2.size()){
    if (res1[i] == res2[j]){
      i++;
      j++;
      k++;
    }else{
      if(res1[i]<res2[j]){
        i++;
      }else{
        j++;
      }
    }
  }
  *res = k;
}*/
__device__ float aligner::kmdist(char* A, char* B,int* k){
  float d = 1;
  int dk = *k;
  double m;
  double l;
  int len1 = 0,len2=0;
  while (A[len1] !='\0') {
    len1++;}
  while (B[len2] !='\0') {
    len2++;}
  char *v1,*v2;
  v1 = (char*)malloc((len1-dk+1)*dk*sizeof(char));
  v2 = (char*)malloc((len2-dk+1)*dk*sizeof(char));
  aligner::veckm(A,v1,dk);
  aligner::veckm(B,v2,dk);
  printf("%s\n",v1);
  m = aligner::compare(v1,v2,k);
  if(len1<len2){
    l = len1;}
  else{l = len2;}
  d -= m/(l-dk+1);
  free(v1);free(v2);
  return d;
}
__device__ void aligner::veckm(char *A,char *a,int k) {
  //Define size of string and size of array of substring
  int Size = 0;
  while (A[Size] != '\0') Size++;
  int n=0;
  for (int i=0; i < Size-(k-1); i++) {
    //Substrings obtainment
    for (int j = i; j < i+k ; j++){
      a[n] = A[j];
      n++;
    }
  }
}
