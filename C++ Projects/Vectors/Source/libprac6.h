#ifndef LIBPRAC6_H_INCLUDED
#define LIBPRAC6_H_INCLUDED

#include <ctime>
#include <cstdlib>
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

namespace VectorSpace
{
    //Generate random numbers
    int GenRandom(int,int);

    //Generate a vector using GenRandom
    vector<int> GenVec(int,int,int);

    //Print the vector
    void PrintVector(vector<int>);

    //Error check
    int GetInt();

    //Calculate mean
    void GetMean(const vector<int>&);

    //Get the median
    void GetMedian(vector<int>&);

    //Get modal values
    void GetMod(const vector<int>&);
}


#endif // LIBPRAC6_H_INCLUDED
