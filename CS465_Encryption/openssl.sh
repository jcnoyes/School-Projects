###############################################################################
# Joseph Noyes, Jeffery Webb                                                  #
# CS 465 Homework 1 - Openssl                                                 #
# Script encrypts a file (pokelist.txt) 10 times to obtain a statistical avg  #
# time it takes to encrypt the file.  It then decrypts the file 10 times to   #
# get the statistical average time it takes to decrypt the file.              #
###############################################################################


#!/bin/bash

#variables
desTotalTime=0
total3Des=0
totalAes=0

echo ""
echo "Using openssl to encrypt files..."
echo ""

#while loop for des
echo "Starting loop for des encryption..."
i=0

#Start writing the times to a file
echo "Des Encryption Times:" > EncryptionTimes.txt

#while loop for des encryption
while [ $i -lt 10 ]; do

  #start time
  startTime=$(date +%s.%N)

  #des encryption with openssl
  openssl des-cbc -in pokelist.txt -out desEncryptOut.txt -pass pass:3ncrypt1onP@ssw0rd

  #calculate the time it took to encrypt
  endTime=$(date +%s.%N)
  duration=$(echo "$endTime-$startTime" | bc)

  #write to file
  echo "des encryption time for loop $i is $duration: " >> EncryptionTimes.txt

  #add up total, increment i
  desTotalTime=$(echo "$desTotalTime+$duration" | bc)
  i=$((i+1))

done

#write total to file, reset i variable
echo ""
echo "Total time for des encryption for 10 loops: $desTotalTime" >> EncryptionTimes.txt
i=0

#get ready for 3des encryption
echo "3des Encryption Times:" >> EncryptionTimes.txt

echo "Starting loop for 3des encryption..."

#while loop for 3des encryption
while [ $i -lt 10 ]; do
  
  #start the timer
  startTime=$(date +%s.%N)

  #encrypt 3des with openssl
  openssl des-ede-cbc -in pokelist.txt -out des3EncryptOut.txt -pass pass:3ncrypt1onP@ssw0rd

  #calculate the time it took
  endTime=$(date +%s.%N)
  duration=$(echo "$endTime-$startTime" | bc)

  #write to final
  echo "3des encryption time for loop $i is $duration: " >> EncryptionTimes.txt

  #add up total, increment i
  total3Des=$(echo "$total3Des+$duration" | bc)
  i=$((i+1))

done

#write total to file, reset i variable
echo ""
echo "Total time for 3des encryption for 10 loops: $Total3Des" >> EncryptionTimes.txt

i=0

echo "" >> EncryptionTimes.txt
echo "aes-128 Encryption Times:" >> EncryptionTimes.txt

echo "Starting loop for aes-128 encryption..."

#While loop for aes encryption
while [ $i -lt 10 ]; do

  #start the timer
  startTime=$(date +%s.%N)

  #encrypt aes-128 with openssl
  openssl aes-128-cbc -in pokelist.txt -out aes128EncryptOut.txt -pass pass:3ncrypt1onP@ssw0rd

  #calculate the time it took
  endTime=$(date +%s.%N)
  duration=$(echo "$endTime-$startTime" | bc)

  #write to final
  echo "aes-128 encryption time for loop $i is $duration: " >> EncryptionTimes.txt

  #add up total, increment i
  totalAes=$(echo "$totalAes+$duration" | bc)
  i=$((i+1))
done

#write total to file, reset i variable
echo ""
echo "Total time for aes-128 encryption for 10 loops: $totalAes" >> EncryptionTimes.txt

###############################################################################
#Calculate the averages
desAvg=$(echo "$desTotalTime/10" | bc -l)
des3Avg=$(echo "$total3Des/10" | bc -l)
aesAvg=$(echo "$totalAes/10" | bc -l)

#print averages to file
echo "" >> EncryptionTimes.txt
echo "************************************************************" >> EncryptionTimes.txt
echo "des average time: $desAvg" >> EncryptionTimes.txt
echo "des3 average time: $des3Avg" >> EncryptionTimes.txt
echo "aes-128 average time: $aesAvg" >> EncryptionTimes.txt
echo "Encryptions finished, information stored in EncryptionTimes.txt"
echo ""

#reset variables
desTotalTime=0
total3Des=0
totalAes=0

#begin decryption of files
echo "Using openssl to decrypt files"
