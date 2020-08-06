#include "reader.h"
fasta::fasta(){
}
fasta::fasta(string name){
  fileName = name;
}
fasta::~fasta(){
}
void fasta::length(){
    int counter = 0;
    ifstream file(fileName.c_str());
    string data;
    while(getline(file,data,'>')){
        counter++;
    }
    noSequences =  counter;
}
void fasta::getSequence(){
  ifstream file(fileName.c_str());
  stringstream buffer;
  buffer << file.rdbuf();
  string data,id,seq;
  while (getline(buffer, data)) {
    if(data.empty())
        continue;
    if (data[0] == '>') {
      if(!id.empty())
        sequence->push_back(seq);
        id = data.substr(1);
        seq.clear();
    }
    else {
      seq += data;
    }
  }
  if(!id.empty())
    sequence->push_back(seq);
}
