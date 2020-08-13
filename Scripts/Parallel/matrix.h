//
// Created by amber on 05/08/20.
//
#include <string>
#include <stdio.h>
#include <iostream>
#include <vector>

#ifndef DEPENDENCIA_MATRIX_H
#define DEPENDENCIA_MATRIX_H


class matrix {
    //Private section
public:
    //
        matrix();
        ~matrix();
        void veckm(std::string,int k);
        std::vector<std::string>* vec;
};




#endif //DEPENDENCIA_MATRIX_H
