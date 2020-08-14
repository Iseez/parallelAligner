#include "reader.h"
#include "comparison.h"
#include <time.h>
#include <omp.h>

int main(int argc, char const *argv[]) {
  omp_set_num_threads(16);
  string file = argv[1];
  int K = atoi(argv[2]);
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
  int j;
  double startS = omp_get_wtime();
  #pragma omp parallel for private(j) shared(mat,len)
  for(int i = 0;i<int(len);i++){
    for(j = i +1; j < len; j++){
      mat[i][j] = objComp.kmdist(objFasta.reads->at(i),objFasta.reads->at(j),K);
    }
  }
  double endS = omp_get_wtime();
  printf("Elapsed Time from serial implementation:%f seconds\n", double(endS-startS));
  std::cin.get();
  return 0;
}
