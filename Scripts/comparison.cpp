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
    //returns 1 if string a is alphabetically
    //less than string b
    //quite similar to strcmp operation
    return a<b;
}

vector<string> alphabaticallySort(vector<string> a){
    int n=a.size();
    //mycomp function is the defined function which
    //sorts the strings in alphabatical order
    sort(a.begin(),a.end(),mycomp);
    for(int i =0; i<a.size();i++){
        //printf("%s ",a[i].c_str());
    }
    return a;
}

double comparison::compare(std::vector<std::string> v1 , std::vector<std::string> v2 ){
    //COnfirmación del sort
    vector<string> vec1 = move(alphabaticallySort(v1));
    vector<string> vec2 = move(alphabaticallySort(v2));

    //Vector 1 con sort
    for(int i =0; i<vec1.size();i++){
        printf("%s ",vec1[i].c_str());
    }

    printf("\n");

    //Vector 2 con sort
    for(int i =0; i<vec2.size();i++){
        printf("%s ",vec2[i].c_str());
    }

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
    printf("\n");
    printf("%f", k);
    return k;

}


