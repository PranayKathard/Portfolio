#include "libUtopia.h"

namespace CrimeSpace
{
     //Generate a random number
    int GenRand(int intLower, int intUpper)
    {
        int intRange = intUpper - intLower +1;
        return rand()%intRange + intLower;
    }

    //Convert a string to an integer
    int ConvertString(string strWord)
    {
        stringstream ss(strWord);
        int intNum = 0;
        ss >> intNum;
        if(ss.fail())
        {
            cerr << "Could not convert parameter to integer" << endl;
            exit(ERR_CONVERT);
        }
        return intNum;
    }

    //Allocate and initialise the game world.
    t_2DArray MakeWorld(int intTRows, int intTCols, int intClues)
    {
        t_2DArray arrNums;

        arrNums = new t_1DArray[intTRows];

        for(int r=0;r<intTRows;r++)
        {
            arrNums[r] = new int[intTCols];
            for(int c=0;c<intTCols;c++)
            {
                arrNums[r][c] = SPACE;
            }
        }

        //Place the player
        int intRow = GenRand(0,intTRows-1);
        int intCol = GenRand(0,intTCols-1);
        arrNums[intRow][intCol] = PLAYER;

        //Place the clues
        if ((intClues*3)<(intTRows*intTCols))
        {
            intRow = GenRand(0,intTRows-1);
            intCol = GenRand(0,intTCols-1);
            for (int i = 0;i<=intClues;++i)
            {
                while(arrNums[intRow][intCol]!=SPACE)
                {
                    intRow = GenRand(0,intTRows-1);
                    intCol = GenRand(0,intTCols-1);
                }
                arrNums[intRow][intCol] = CLUE;
            }

            //Place potential clues
            for (int i = 0;i<=(intClues*2);++i)
            {
                while(arrNums[intRow][intCol]!=SPACE)
                {
                    intRow = GenRand(0,intTRows-1);
                    intCol = GenRand(0,intTCols-1);
                }
                arrNums[intRow][intCol] = POTENTIAL_CLUE;
            }
        }
        else
        {
            cerr << "Too many clues!" << endl;
            exit(ERR_SPACE);
        }
        return arrNums;
    }

    void DestroyWorld(t_2DArray& arrNums, int intTRows)
    {
        for(int i=0;i<intTRows;i++)
        {
            delete[] arrNums[i];
        }
        delete[] arrNums;
        arrNums = nullptr;
    }

    void DisplayWorld(t_2DArray arrWorld, int intTRows, int intTCols, int intTurns)
    {
        system("cls");

        //Output the feagure character given the value in the character array.
        for(int r=0;r<intTRows;r++)
        {
            for(int c=0;c<intTCols;c++)
            {
                cout << setw(2);
                cout << CH_FEATURES[arrWorld[r][c]];
            }
            cout << endl;
        }

        //Display the menu item
        cout << "Moves left:" << intTurns << endl;
        cout << "Clues left:" << CountClues(arrWorld,intTRows,intTCols) << endl;
        cout << "Move up:w" << endl;
        cout << "Move down:s" << endl;
        cout << "Move left:a" << endl;
        cout << "Move right:d" << endl;
        cout << "Investigate:i" << endl;
        cout << "Quit:x" << endl;
    }

    //Make sure the location intRow and intCol is inside the boundaries of the world
    bool IsInWorld(int intTRows, int intTCols, int intRow, int intCol)
    {
        return (intRow>=0 && intRow<intTRows && intCol>=0 && intCol<intTCols);
    }

    //Make sure the player can not move over a clue
    bool NotClue(t_2DArray arrWorld,int intRow, int intCol)
    {
        return (!(arrWorld[intRow][intCol] == CLUE) || !(arrWorld[intRow][intCol] == POTENTIAL_CLUE) || !(arrWorld[intRow][intCol] == UNCOVERED_CLUE) || !(arrWorld[intRow][intCol] == UNCOVERED_POTENTIAL));
    }

    //Locate a specific feature
    void FindFeature(t_2DArray arrWorld, int intTRows, int intTCols,int& row, int& col, FEATURES feature)
    {
        for(int r=0;r<intTRows;r++)
        {
            for(int c=0;c<intTCols;c++)
            {
                if(arrWorld[r][c] == feature)
                {
                    row = r;
                    col = c;
                }
            }
        }
    }

    void MovePlayer(t_2DArray arrWorld, int intTRows, int intTCols,enumDIRECTION direction)
    {
        int intRow = -1;
        int intCol = -1;

        //Find the player
        FindFeature(arrWorld,intTRows,intTCols,intRow,intCol,PLAYER);
        int intDRow = intRow;
        int intDCol = intCol;

        //Modify the destination location given the direction the player moves into
        switch(direction)
        {
        case enumDIRECTION::TOP:
            intDRow--;
            break;
        case enumDIRECTION::RIGHT:
            intDCol++;
            break;
        case enumDIRECTION::BOTTOM:
            intDRow++;
            break;
        case enumDIRECTION::LEFT:
            intDCol--;
            break;
        default:
            break;
        }


        //Ensure the destimation is inside the game world
        if(IsInWorld(intTRows,intTCols,intDRow,intDCol) && NotClue(arrWorld,intDRow,intDCol))
        {
            arrWorld[intDRow][intDCol] += PLAYER;
            arrWorld[intRow][intCol]-=PLAYER;
        }
    }

    void Investigate(t_2DArray& arrWorld, int intTRows, int intTCols)
    {
        int intPRow = -1;
        int intPCol = -1;
        FindFeature(arrWorld,intTRows,intTCols,intPRow,intPCol,PLAYER);
        for(int r=0;r<intTRows;r++)
        {
            for(int c=0;c<intTCols;c++)
            {
                //If a clue was found uncover
                if(arrWorld[r][c] == CLUE)
                {
                    if(abs(intPRow-r)<=RADIUS && abs(intPCol-c)<=RADIUS)
                    {
                        arrWorld[r][c] = UNCOVERED_CLUE;
                    }
                }
                //If a false clue was found uncover
                else if (arrWorld[r][c] == POTENTIAL_CLUE)
                {
                    if(abs(intPRow-r)<=RADIUS && abs(intPCol-c)<=RADIUS)
                    {
                        arrWorld[r][c] = UNCOVERED_POTENTIAL;
                    }
                }
            }
        }
    }

    int CountClues(t_2DArray arrWorld, int intTRows, int intTCols)
    {
        int intCount = 0;

        for(int r=0;r<intTRows;r++)
        {
            for(int c=0;c<intTCols;c++)
            {
                if(arrWorld[r][c]==CLUE)
                    intCount++;
            }
        }
        return intCount;
    }

}
