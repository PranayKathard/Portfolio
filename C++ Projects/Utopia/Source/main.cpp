#include "libUtopia.h"
#include <iostream>

using namespace std;
using namespace CrimeSpace;

int main(int argc, char** argv)
{
    srand(time(nullptr));
    int intTRows = 0;
    int intTCols = 0;
    int intTurns = 0;
    int intClues= 0;

    if(argc!=5)
    {
        cerr << "Please run the program using Utopia <NumOfRows> <NumOfCols> <Turns> <Clues>" << endl;
        exit(ERR_NUM_PARAM);
    }

    //Conversion check for parametres
    intTRows = ConvertString(argv[1]);
    intTCols = ConvertString(argv[2]);
    intTurns = ConvertString(argv[3]);
    intClues = ConvertString(argv[4]);

    t_2DArray arrWorld = MakeWorld(intTRows,intTCols,intClues);


    bool blnWon = false;
    bool blnContinue = true;
    char chInput = '/0';

    do
    {
        system("cls");
        DisplayWorld(arrWorld,intTRows,intTCols, intTurns);

        //Get input from the player and move or investigate
        cin >> chInput;
        switch(chInput)
        {
        case 'w':
            MovePlayer(arrWorld,intTRows,intTCols,TOP);
            break;
        case 's':
            MovePlayer(arrWorld,intTRows,intTCols,BOTTOM);
            break;
        case 'a':
            MovePlayer(arrWorld,intTRows,intTCols,LEFT);
            break;
        case 'd':
            MovePlayer(arrWorld,intTRows,intTCols,RIGHT);
            break;
        case 'i':
            Investigate(arrWorld,intTRows,intTCols);
            break;
        case 'x':
            blnContinue = false;
            break;
        }

        //Reduces turns every round
        --intTurns;

        if(intTurns == 0)
            blnContinue = false;

        if(CountClues(arrWorld,intTRows,intTCols)<=0)
        {
            blnContinue = false;
            blnWon = true;
        }

    }while(blnContinue);

    DisplayWorld(arrWorld,intTRows,intTCols,intTurns);
    if((intTurns == 0) && (CountClues(arrWorld,intTRows,intTCols)>0))
    {
        cout << "*******************************************************************" << endl;
        cout << "*                    Out of turns!!!!!!!!!!!!                     *" << endl;
        cout << "*******************************************************************" << endl;
    }

    if(blnWon)
    {
        cout << "*******************************************************************" << endl;
        cout << "*     You found all the clues before running out of turns!!!      *" << endl;
        cout << "*******************************************************************" << endl;
    }

    //Deallocate the memory associated with the game
    DestroyWorld(arrWorld,intTRows);

   return SUCCESS;
}
