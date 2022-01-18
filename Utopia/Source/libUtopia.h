#ifndef LIBUTOPIA_H_INCLUDED
#define LIBUTOPIA_H_INCLUDED

#include<cstdlib>
#include<iostream>
#include<ctime>
#include<sstream>
#include<cmath>
#include<iomanip>

using namespace std;

namespace CrimeSpace
{
    enum RETURN_CODES
    {
        SUCCESS,
        ERR_CONVERT,
        ERR_NUM_PARAM,
        ERR_SPACE
    };

    enum FEATURES
    {
        SPACE,
        PLAYER,
        CLUE,
        POTENTIAL_CLUE,
        UNCOVERED_CLUE,
        UNCOVERED_POTENTIAL
    };

    enum enumDIRECTION
    {
        TOP,
        TOP_RIGHT,
        RIGHT,
        BOTTOM_RIGHT,
        BOTTOM,
        BOTTOM_LEFT,
        LEFT,
        TOP_LEFT
    };

    const int RADIUS = 1;
    const char CH_FEATURES[] = {'.','P','C','C','$','X'};

    typedef int** t_2DArray;
    typedef int* t_1DArray;

    t_2DArray MakeWorld(int intTRows, int intTCols, int intClues);
    void DestroyWorld(t_2DArray& arrNums, int intTRows);
    void DisplayWorld(t_2DArray arrWorld, int intTRows, int intTCols, int intTurns);
    void MovePlayer(t_2DArray arrWorld, int intTRows, int intTCols,enumDIRECTION direction);
    void Investigate(t_2DArray& arrWorld, int intTRows, int intTCols);
    int CountClues(t_2DArray arrWorld, int intTRows, int intTCols);

    int ConvertString(string strWord);

}

#endif // LIBUTOPIA_H_INCLUDED
