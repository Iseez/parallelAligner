#include "reader.h"
#include "matrix.h"
int main(int argc, char const *argv[]) {
  string file = "/home/iseez/Documents/Paralelo/alignment/Data/example.fasta";
  fasta objFasta(file);
  double len = objFasta.length();
  objFasta.getReads();
  for(int i = 0;i<len;i++)
    printf("%s\n", objFasta.reads->at(i).c_str());
  matrix objMatrix;
  string a = "abcdef";
  objMatrix.veckm(a,3);
  for(int i = 0;i<3;i++)
    printf("%s\n", objMatrix.vec->at(i).c_str());
  std::cin.get();
  return 0;
}
