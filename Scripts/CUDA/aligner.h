#ifndef ALIGNER_H
#define ALIGNER_H
#include <string>
#include <vector>
#include <iostream>
#include <stdio.h>
#include <fstream>
#include <sstream>
#include "dev_array.h"
using namespace std;

class aligner{
public:
  __host__ aligner();
  __host__ aligner(string name);
  __host__ ~aligner();
  __host__ double length();
  __host__ void getReads();
  char** h_reads;
  vector<string>* reads;
  vector<string>* headers;
  __device__ static void swapp(char* a,int id1,int id2,int k);
  __device__ static double compare(char* v1,char* v2,int* k);
  __device__ static float kmdist(char* A,char* B,int* k);
  __device__ static void veckm(char *test,char *a,int k);
private:
  string fileName;
  double noReads;
};
#endif
