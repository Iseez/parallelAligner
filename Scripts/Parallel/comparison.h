//
// Created by amber on 11/08/20.
//

#include <vector>
#include <string>
#include <iostream>
#include <string>
#include "matrix.h"

#ifndef COMPARISION_COMPARISON_H
#define COMPARISION_COMPARISON_H


class comparison {
    //Private section
public:
    //public
    comparison();
    ~comparison();
    double compare(std::vector<std::string>,std::vector<std::string>);
    float kmdist(std::string A,std::string B,int k);
};


#endif //COMPARISION_COMPARISON_H
