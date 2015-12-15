/*
Program asks user to enter the number of items in a list, then the user enters
each number.  The program stores the numbers in a vector, and then the program
adds all the numbers in the list using a for loop, while loop, and recursion.
*/

#include <iostream>
#include <vector>
#include <string>
#include <limits>
using namespace std;

int Sum(int element, int count, int total, vector<int> numbs);

void main()
{
	//Introduction to the program, declares variables and greets the user
	int elementsNum;
	vector<int> elements;
	string stars = "************************************************************";
	cout << stars << endl;
	cout << "Hello, welcome to the summation program." << endl;
	cout << "Please enter the number of elements you would like to add: ";

	//for loop to ensure the user enters an integer for the number of elements to add.
	for (; ;)
	{
		try
		{
			cin >> elementsNum;
			if (!std::cin) { throw elementsNum; }
			else{ break; }
		}
		catch (int param) { 
			cout << "Please enter an integer: ";
			cin.clear();
			cin.ignore(std::numeric_limits<streamsize>::max(), '\n');
			continue;
		}
	}

	//Asks the user to populate the vector containing the elements to add
	cout << "Will sum up " << elementsNum << " elements\n";
	for (int i = 1; i <= elementsNum; i++)
	{
		cout << "Please enter the " << i << " element: ";
		int addElement;

		//ensure the user enters integers
		for (;;)
		{
			try
			{
				cin >> addElement;
				if (!std::cin){ throw addElement; }
				else{ break; }
			}
			catch (int param){
				cout << "Error, please enter an integer: ";
				cin.clear();
				cin.ignore(std::numeric_limits<streamsize>::max(), '\n');
				continue;
			}
		}
		//adds element to the vector
		elements.push_back(addElement);
	}

	//Prints summary of elements that the program will add.
	int Size = elements.size();
	cout << stars << endl;
	cout << "Will sum the following elements:\n";
	for (int i = 0; i < Size; i++)
	{
		cout << elements[i] << endl;
	}
	system("pause");
	system("cls");

	//While loop summation
	cout << "Now summing the elements with a while loop..." << endl;
	bool done = false;
	int nextElement = 0;
	int whileTotal = 0;
	while (done == false)
	{
		whileTotal += elements[nextElement];
		nextElement++;
		if (nextElement == Size)
		{
			done = true;
		}
	}
	//Prints the while loop summation total
	cout << "The total obtained from the while loop summation is: " << whileTotal << endl;
	
	//for loop summation
	int forTotal = 0;
	for (int i = 0; i < Size; i++)
	{
		forTotal += elements[i];
	}
	cout << "The total obtained from the for loop summation is: " << forTotal << endl;

	//Recursion summation, see function Sum
	int RTotal = Sum(elements[0], 0, 0, elements);
	cout << "The total obtained from the recursion summation is: " << RTotal << endl;

	//Compare each total, if match the program works
	cout << "Testing program..." << endl;
	if (forTotal == whileTotal && whileTotal == RTotal)
	{
		cout << "All totals are equal, test passed." << endl;
	}
	else
	{
		cout << "The program has different results for each total, error.";
	}
	system("pause");
}

int Sum(int element, int count, int total, vector<int> numbs)
{
	int size = numbs.size();
	total += numbs[count];
	if (count+1 < size)
	{
		total = Sum(numbs[count + 1], count + 1, total, numbs);
	}
	return total;
}
