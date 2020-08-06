//
// Created by amber on 05/08/20.
//
#include "matrix.h"

matrix::matrix(){
}
matrix::~matrix(){
}

std::vector<std::string>*vec;

void veckm(std::string A,int k){

        std::vector<std::string>* vec2;
        int sais = A.size();
        std::string kmero;

        for (int i=0; sais-k; i++){
            kmero = A.substr(i,k);
            vec2 -> push_back(kmero);
        }
        vec = vec2;
}

