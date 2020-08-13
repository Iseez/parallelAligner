#include "reader.h"
#include "comparison.h"
#include <time.h>

int main(int argc, char const *argv[]) {
  string file = "/home/iseez/Documents/Paralelo/alignment/Data/prueba100.fasta";//argv[1];
  int K = 4;//atoi(argv[2]);
  fasta objFasta(file);
  double len = objFasta.length();
  float** mat = new float*[int(len)];
  for(int i = 0;i < len;i++){
    mat[i] = new float[int(len)];
    for(int j = 0;j<len;j++)
      {mat[i][j] = 0;}
  }
  objFasta.getReads();
  comparison objComp;
  //float kd = objComp.kmdist(objFasta.reads->at(0),objFasta.reads->at(1),K);
  //float kd;
  clock_t startS = clock();
  for(int i = 0;i < len;i++){
    for(int j = i +1; j < len; j++){
      mat[i][j] = objComp.kmdist(objFasta.reads->at(i),objFasta.reads->at(j),K);
    }
  }
  clock_t endS = clock();
  printf("Elapsed Time from serial implementation:%f seconds\n", double(endS-startS)/double (CLOCKS_PER_SEC));
  std::cin.get();
  return 0;
}
