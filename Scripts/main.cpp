#include "reader.h"
#include "comparison.h"

int main(int argc, char const *argv[]) {
  string file = argv[1];//"/home/iseez/Documents/Paralelo/alignment/Data/example.fasta";
  int K = atoi(argv[2]);
  fasta objFasta(file);
  long double** mat;
  double len = objFasta.length();
  objFasta.getReads();
  comparison objComp;
  float kd = objComp.kmdist(objFasta.reads->at(0),objFasta.reads->at(1),K);
  printf("%f\n", kd);
  std::cin.get();
  return 0;
}
