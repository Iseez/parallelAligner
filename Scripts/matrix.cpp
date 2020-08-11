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
        printf("size %d\n",sais);
        printf("1\n");
        std::vector<std::string>* vec2 = new std::vector<std::string>(sais-k+1);
        printf("2\n");
        std::string kmero;
        printf("3\n");
        for (int i=0; i <= sais-k; i++){
            kmero = A.substr(i,k);
            vec2->at(i) = kmero;
        }
        printf("4\n");
        vec = vec2;
}
