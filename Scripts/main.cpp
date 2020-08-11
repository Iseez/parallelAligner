#include "reader.h"
#include "matrix.h"

float kmdist(string A,string B,int k);
int main(int argc, char const *argv[]) {
  string file = argv[1];//"/home/iseez/Documents/Paralelo/alignment/Data/example.fasta";
  fasta objFasta(file);
  long double** mat; 
  double len = objFasta.length();
  objFasta.getReads();
  float kd = kmdist(objFasta.reads->at(0),objFasta.reads->at(1),4);
  printf("%f\n", kd);
  std::cin.get();
  return 0;
}

float kmdist(string A, string B,int k){
  double m = 10;
  matrix str1;
  matrix str2;
  float d = 1;
  str1.veckm(A,k);
  str2.veckm(B,k);
  double l;
  if(A.size()<B.size()){
    l = A.size();}
  else{l = B.size();}
  d -= m/(l-k+1);
  return d;
}
