#ifndef READER_H
#define READER_H
#include <string>
#include <vector>
#include <iostream>
#include <stdio.h>
#include <fstream>
#include <sstream>
using namespace std;

class fasta{
public:
  fasta();
  fasta(string name);
  ~fasta();
  void length();
  void getSequence();
private:
  string fileName;
  int noSequences = 0;
  vector<string>* sequence;
};
#endif //EIGENFACES_EIGENV_H
