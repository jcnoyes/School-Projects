/*
Joseph Noyes
CS 317 
Problem 17 Quick Sort
Program asks the user for 10 elements, which gets put into an array
and then the program uses quick sort to sort the elements in order.
Screen shots of this program will be taken to help come up with the
correct logic.
*/

#include<iostream>
using namespace std;

//Function Protocols
void QuickSort(int Array[], int first, int last);
int Part(int A[], int start, int end);

void main(void)
{
	//varables needed
	int elements[10];
	int input;

	//Obtain 10 elements from the user, assumes the user enters
	//everything correctly.
	cout << "Please enter ten elements to sort: \n";
	for (int i = 0; i < 10; i++)
	{
		cin >> input;
		elements[i] = input;
	}
	//print out all the elements
	cout << "\nWill sort the following array:\n";
	for (int i = 0; i < 10; i++)
	{
		cout << elements[i];
		cout << " ";
	}

	QuickSort(elements, 0, 9);

	//elements should be sorted
	cout << "\nSorted Array: \n";
	for (int i = 0; i < 10; i++)
	{
		cout << elements[i] << " ";
	}
	cout << endl;
	system("PAUSE");
}

void QuickSort(int Array[], int first, int last)
{
	if (first < last)
	{
		//Obtain the pivot
		int pivot = Part(Array, first, last);
		//cout << "Pivot: " << pivot << endl;
		//Divide the Array into 2
		QuickSort(Array, first, (pivot-1));
		QuickSort(Array, (pivot+1), last);
	}
}

int Part(int A[], int start, int end)
{
	//Pivot for this section of the array
	int pivot = A[start];
	int leftSide = start + 1; //The start of the array, without pivot
	int rightSide = end;
	bool finished = false;
	int t;

	while (finished != true)
	{
		//Move left
		while (leftSide <= rightSide && A[leftSide] <= pivot)
		{
			leftSide++;
		}

		//Move right
		while (rightSide >= leftSide && A[rightSide] >= pivot)
		{
			rightSide--;
		}

		//If the leftSide pointer crosses the rightSide pointer
		if (rightSide < leftSide)
		{
			finished = true;
		}
		else
		{
			//If the pivot never crossed, swap right and left elements
			t = A[rightSide];
			A[rightSide] = A[leftSide];
			A[leftSide] = t;
		}
	}

	//Swap the start and rightSide
	//set rightSide element to pivot
	A[start] = A[rightSide];
	A[rightSide] = pivot;

	return rightSide; //rightSide becomes new pivot
}
