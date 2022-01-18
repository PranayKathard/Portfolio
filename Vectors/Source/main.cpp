#include "libprac6.h"

using namespace std;
using namespace VectorSpace;

int main()
{
    //seed for random numbers
    srand(time(0));
    bool blnContinue = true;
    vector<int> vecNums;

    //do-while loop for menu
    do
    {
        system("cls");
        char chChoice = '\0';
        cout << "A: Generate a vector of random numbers." << endl
            << "B: Print the vector." << endl
            << "C: Empty content of vector." << endl
            << "D: Calculate and display mean value." << endl
            << "E: Calculate and display median value." << endl
            << "F: Calculate and display the modal values." << endl
            << "X: Exit the program." << endl;

        cin >> chChoice;
        switch(chChoice)
        {
        case 'a':
        case 'A':
            {
                cout << "How many numbers do you want to generate:";
                int intCount = GetInt();

                cout << "What is the lower bound for the random numbers:";
                int intLower = GetInt();

                cout << "What is the upper bound for the random numbers:";
                int intUpper = GetInt();

                //call function to generate vector
                vecNums = GenVec(intCount,intLower,intUpper);
                break;
            }
        case 'b':
        case 'B':
            {
                //call function to display vector
                PrintVector(vecNums);
                break;
            }
        case 'c':
        case 'C':
            {
                //clears values in vector
                vecNums.clear();
                break;
            }
        case 'd':
        case 'D':
            {
                //calll function to get the mean value
                GetMean(vecNums);
                break;
            }
        case 'e':
        case 'E':
            {
                //call function to get median
                GetMedian(vecNums);
                break;
            }
        case 'f':
        case 'F':
            {
                //call function to get mode
                GetMod(vecNums);
                break;
            }
        case 'x':
        case 'X':
            {
                //exit program
                blnContinue = false;
                break;
            }
        default:
            cerr << "Please select the correct option." << endl;

        }

        system("pause");
    }while(blnContinue);

    return 0;
}
