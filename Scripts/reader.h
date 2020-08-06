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
  double length();
  void getSequence();
  vector<string>* sequence;
private:
  string fileName;
  double noSequences = 0;
};
#endif
