#include "reader.h"
fasta::fasta(){
}
fasta::fasta(string name){
  fileName = name;
}
fasta::~fasta(){
}
double fasta::length(){
    double counter = 0;
    ifstream file(fileName.c_str());
    string data;
    while(getline(file,data,'>')){
        counter++;
    }
    counter--;
    noReads =  counter;
    return counter;
}
void fasta::getReads(){
  reads = new vector<string>(noReads);
  ifstream file(fileName.c_str());
  stringstream buffer;
  buffer << file.rdbuf();
  string data,id,seq;
  double indx = 0;
  while (getline(buffer, data)) {
    if(data.empty())
        continue;
    if(data[0] == '>') {
      if(!id.empty())
        {reads->at(indx) = seq;
        indx++;}
      id = data.substr(1);
      seq.clear();
    }
    else {
      seq += data;
    }
  }
  if(!id.empty())
    reads->at(indx) = seq;
}
