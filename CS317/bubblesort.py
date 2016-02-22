#Joseph Noyes
#CS 317
#Homework 1
#Problem 14
#Script takes input from a file called "input.txt".  This file contains numbers
#that will be sorted using bubble sort.  The sorted numbers will be placed in a
#new file known as "output.txt".
#Uses Python2.7, does not work with Python3+

#Initialize needed variables
ListOfNumbers = []
inputFile="input.txt" #Assumes input.txt is in same directory as script
outPutFile="output.txt"
num=""

#Open file and began seperating the numbers and commas.
print "Opening file input.txt\n"
ReadFile= open(inputFile)
while True:
  c=ReadFile.read(1)
  if c.isdigit():  #Check to see if c is a digit, if it is put it in num
    num+=c
  elif c == " ":
    print "Ignoring whitespaces" #Just in case of whitespaces
  else:
    ListOfNumbers.append(int(num))  #append list and set num to blank
    num=""
  if not c:
    ReadFile.close()
    break

print "Created array from input.txt.  Will sort the following list:"
print ListOfNumbers

#Bubble sort begins here
ListLength=len(ListOfNumbers)
for i in range(ListLength-1, 0, -1): #Counts from last index to 0
  for j in range (i):
    if ListOfNumbers[j] > ListOfNumbers[j+1]:
	  #If element J is bigger than element j+1, swap them
	  temp=ListOfNumbers[j]
	  ListOfNumbers[j]=ListOfNumbers[j+1]
	  ListOfNumbers[j+1]=temp
print "Sorted Array:"
print ListOfNumbers

#Place in output file
print "\nNow placing the sorted array in output.txt\n"
outPut=open(outPutFile, "w")
for o in range(0, ListLength, 1):
  outPut.write(str(ListOfNumbers[o]))
  if o != ListLength-1:
     outPut.write(",")
outPut.close()
