/* Joseph Noyes
CS 317 Assignment 1
Problem 15 Brute Force Password Generation
Program contains an array of capital letters, the user is asked to enter the
password length and the program outputs all the possible combinations.*/

#include <iostream>
#include <ctime>
#include <math.h>
#include<conio.h>
#include<string>

using namespace std;

void main()
{
	//Delcare some neccessary variables
	int passwordLength = 0;
	char Letters[] = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', \
		'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
	double Possiblities = 0;
	int LettersLength = sizeof(Letters);
	int value = 0;
	string word;
	char choice;
	bool run = true;

	//While loop to keep allowing user to enter different lengths until user wants
	//to exit.
	while (run)
	{
		cout << "Please enter the password length:" << endl;
		cin >> passwordLength;

		//Calculate the possiblities
		Possiblities = pow(LettersLength, passwordLength);
		cout << "There are " << Possiblities << " Possible combinations." << endl;
		cout << "Press enter to continue..." << endl;
		_getch();  //Used for the user to press enter to continue

		//Start of brute force password generating and timer.
		clock_t start; //Clock start time
		double timeTaken;

		start = clock();
		//for loop
		for (int i = 0; i < Possiblities; i++)
		{
			word = "";
			value = i;
			//for loop from 0 to whatever the user entered for password length
			for (int j = 0; j < passwordLength; j++)
			{
				//divide value by LettersLength, take the remainder.  The remainder will
				//be used to represent the first letter of the password that is generated.
				int Character = value % LettersLength;
				word = Letters[(int)Character] + word;

				//Change the value of int value to obtain the second letter. Dividing
				//value by the size of the characters array should make the remainder
				//increment by 1 the next time the loop is executed.
				value = value / LettersLength;
			}

			//output the generated combinations
			cout << word << endl;
		}
		//obtain the time it took
		timeTaken = (clock() - start) / (double)CLOCKS_PER_SEC;
		cout << "Password generation completed." << endl;
		cout << "It took " << timeTaken << " seconds." << endl << endl;
		cout << "Press Q to exit, press any other key to rerun the program" << endl;
		choice = _getch();
		if (choice == 'Q' || choice == 'q')
		{
			run = false;
		}
	}
};