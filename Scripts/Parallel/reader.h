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
  void getReads();
  vector<string>* reads;
  vector<const char*> h_reads;
  vector<string>* headers;
private:
  string fileName;
  double noReads = 0;
};
#endif
