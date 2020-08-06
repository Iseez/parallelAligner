#include "reader.h"
int main(int argc, char const *argv[]) {
  string file = "/home/iseez/Documents/Paralelo/alignment/example.fasta";
  fasta objFasta(file);
  objFasta.length();
  objFasta.getSequence();
  return 0;
}
