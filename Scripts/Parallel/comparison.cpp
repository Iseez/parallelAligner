//
// Created by amber on 11/08/20.
//

#include "comparison.h"
#include <bits/stdc++.h>
using namespace std;

comparison::comparison() {
}
comparison::~comparison() {
}

bool mycomp(string a, string b){
    return a<b;
}

vector<string> alphabaticallySort(vector<string> a){
    sort(a.begin(),a.end(),mycomp);
    return a;
}

double comparison::compare(std::vector<std::string> v1 , std::vector<std::string> v2 ){
    //COnfirmación del sort
    vector<string> vec1 = move(alphabaticallySort(v1));
    vector<string> vec2 = move(alphabaticallySort(v2));
    int i = 0,j = 0;
    double k = 0;

    while(i<vec1.size() && j<vec2.size()){
        if (vec1[i] == vec2[j]){
            i++;
            j++;
            k++;

        }else{
            if(vec1[i]<vec2[j]){
                i++;
            }else{
                j++;
            }
        }
    }
    return k;

}

float comparison::kmdist(std::string A, std::string B,int k){
  matrix str1;
  matrix str2;
  float d = 1;
  str1.veckm(A,k);
  str2.veckm(B,k);
  double m = comparison::compare(*str1.vec,*str2.vec);
  double l;
  if(A.size()<B.size()){
    l = A.size();}
  else{l = B.size();}
  delete str1.vec;
  delete str2.vec;
  d -= m/(l-k+1);
  return d;
}
