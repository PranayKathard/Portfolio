#include "libprac6.h"

namespace VectorSpace
{
    int GenRandom(int intLower,int intUpper)
    {
        int intNum = 0;
        int intRange = intUpper - intLower + 1;
        intNum = rand()%intRange + intLower;
        return intNum;
    }

    vector<int> GenVec(int intCount,int intLower,int intUpper)
    {
        vector<int> vecNums;
        for(int i=0;i<intCount;++i)
        {
            vecNums.push_back(GenRandom(intLower,intUpper));
        }
        return vecNums;
    }

    void PrintVector(vector<int> vecNums)
    {
        for(int n:vecNums)
        {
            cout << n << " ";
        }
        cout << endl;
    }

    int GetInt()
    {
        int intNum = 0;

        cin >>intNum;
        while(cin.fail())
        {
            cin.clear();
            string strJunk;
            cin >> strJunk;
            cerr << "Conversion error" << endl;
            cout << "Please try again:" << endl;
            cin >> intNum;
        }

        return intNum;
    }

    void GetMean(const vector<int> &vecNums)
    {
        double dblMean = 0.0;
        int intTotal = 0;
        int intLength = 0;
        for(int n: vecNums)
        {
            intTotal += n;
            intLength += 1;
        }
        dblMean = double(intTotal)/double(intLength);
        cout << dblMean << endl;
    }

    void GetMedian(vector<int> &vecNums)
    {
        sort(vecNums.begin(),vecNums.end());
        if (vecNums.size() % 2 == 0)
            cout << "Median = " << (vecNums[vecNums.size()/2 - 1] + vecNums[vecNums.size()/2]) / 2.0 << endl;
        else
            cout << "Median = " << vecNums[vecNums.size()/2.0] << endl;
    }

    void GetMod(const vector<int> &vecNums)
    {
       int intCount = 0;
       int intCount2 = 0;
       int intMode = 0;

       for(int n: vecNums)
       {
           for(int i: vecNums)
           {
               if(i==n)
               {
                   ++intCount;
               }
           }
           if (intCount > intCount2)
           {
               intCount2 = intCount;
               intMode = n;
           }
       }
       cout << intMode << endl;
    }
}
