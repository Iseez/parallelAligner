#include "reader.h"
#include "matrix.h"
int main(int argc, char const *argv[]) {
  string file = argv[1];//"/home/iseez/Documents/Paralelo/alignment/Data/example.fasta";
  fasta objFasta(file);
  double len = objFasta.length();
  objFasta.getReads();
  for(int i = 0;i<len;i++)
    printf("%s\n", objFasta.reads->at(i).c_str());
  matrix objMatrix;
  string a = "ggtaagtcctctagtacaaacacccccaatattgtgatataattaaaattatattcatattctgttgccagaaaaaacacttttaggctatattagagccatcttctttgaagcgttgtc";
  string b(begin(objFasta.reads->at(0)),end(objFasta.reads->at(0)));
  printf("%d\n",b.size() );
  objMatrix.veckm(b,5);
  for(int i = 0;i<7;i++)
    printf("%s\n", objMatrix.vec->at(i).c_str());
  std::cin.get();
  return 0;
}
