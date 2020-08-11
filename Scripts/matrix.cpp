//
// Created by amber on 05/08/20.
//
#include "matrix.h"

matrix::matrix(){
}
matrix::~matrix(){
}

void matrix:: veckm(std::string A,int k){

        int sais = A.size();
        std::vector<std::string>* vec2 = new std::vector<std::string>(sais-k+1);
        std::string kmero;

        for (int i=0; i <= sais-k; i++){
            kmero = A.substr(i,k);
            vec2->at(i) = kmero;
        }
        vec = vec2;
}
