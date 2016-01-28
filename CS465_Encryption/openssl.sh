###############################################################################
# Paul Eccleston, Joseph Noyes, Jeffery Webb                                  #
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

#arrays to hold the 10 times, used to calculate the standard deviation
declare -a desArray
declare -a des3Array
declare -a aesArray

echo ""
echo "Using openssl to encrypt files"
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
  desArray[$i]=$duration #store in array to calculate SD later

  #write to file
  echo "des encryption time for loop $i is: $duration" >> EncryptionTimes.txt

  #add up total, increment i
  desTotalTime=$(echo "$desTotalTime+$duration" | bc)
  i=$((i+1))

done

#write total to file, reset i variable
echo ""
echo "Total time for des encryption for 10 loops: $desTotalTime" >> EncryptionTimes.txt
i=0

#get ready for 3des encryption
echo "" >> EncryptionTimes.txt
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
  des3Array[$i]=$duration #store in array to calculate SD later

  #write to final
  echo "3des encryption time for loop $i is: $duration" >> EncryptionTimes.txt

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
  aesArray[$i]=$duration #store in array to calculate SD later

  #write to final
  echo "aes-128 encryption time for loop $i is: $duration" >> EncryptionTimes.txt

  #add up total, increment i
  totalAes=$(echo "$totalAes+$duration" | bc)
  i=$((i+1))
done

#write total to file, reset i variable
echo ""
echo "Total time for aes-128 encryption for 10 loops: $totalAes" >> EncryptionTimes.txt

echo "Calculating information for about encryptions performed..."
echo ""
###############################################################################
#Calculate the averages
desAvg=$(echo "$desTotalTime/10" | bc -l)
des3Avg=$(echo "$total3Des/10" | bc -l)
aesAvg=$(echo "$totalAes/10" | bc -l)

##############################################################################
#Calculate the standard deviations
desSD=0
des3SD=0
aesSD=0
tempTotal=0

#for loop for des SD calculation
for i in "${desArray[@]}"
do
	sdTemp=$(echo "$i-$desAvg" | bc -l)
	sdTemp=$(echo "$sdTemp^2" | bc -l)
	tempTotal=$(echo "$tempTotal + $sdTemp" | bc -l)
done

desSD=$(echo "$tempTotal/10" | bc -l)
desSD=$(echo "sqrt ( $desSD )" | bc -l)
tempTotal=0

for i in "${des3Array[@]}"
do
	sdTemp=$(echo "$i-$des3Avg" | bc -l)
	sdTemp=$(echo "$sdTemp^2" | bc -l)
	tempTotal=$(echo "$tempTotal + $sdTemp" | bc -l)
done

des3SD=$(echo "$tempTotal/10" | bc -l)
des3SD=$(echo "sqrt ( $des3SD )" | bc -l)
tempTotal=0

#for loop for des SD calculation
for i in "${aesArray[@]}"
do
        sdTemp=$(echo "$i-$aesAvg" | bc -l)
        sdTemp=$(echo "$sdTemp^2" | bc -l)
        tempTotal=$(echo "$tempTotal + $sdTemp" | bc -l)
done

aesSD=$(echo "$tempTotal/10" | bc -l)
aes3SD=$(echo "sqrt ( $aesSD )" | bc -l)
tempTotal=0


#print averages and standard deviations to file
echo "" >> EncryptionTimes.txt
echo "************************************************************" >> EncryptionTimes.txt
echo "des average time: $desAvg" >> EncryptionTimes.txt
echo "des standard deviation: $desSD" >> EncryptionTimes.txt
echo "des3 average time: $des3Avg" >> EncryptionTimes.txt
echo "des3 standard deviation: $des3SD" >> EncryptionTimes.txt
echo "aes-128 average time: $aesAvg" >> EncryptionTimes.txt
echo "aes-128 standard deviation: $aesSD" >> EncryptionTimes.txt
echo "Encryptions finished, information stored in EncryptionTimes.txt"
echo ""

#reset variables
desTotalTime=0
total3Des=0
totalAes=0

unset desArray
unset des3Array
unset aesArray

#begin decryption of files
echo "Using openssl to decrypt files"
echo ""
echo "Decrypting des encrypted file..."
i=0

echo "Des decryption times:" > DecryptionTimes.txt
#while loop for des decryption
while [ $i -lt 10 ]; do

  #start time
  startTime=$(date +%s.%N)

  #des decryption with openssl
  openssl des-cbc -d -in desEncryptOut.txt -out des-Decrypted.txt -pass pass:3ncrypt1onP@ssw0rd

  #calculate the time it took to decrypt
  endTime=$(date +%s.%N)
  duration=$(echo "$endTime-$startTime" | bc)
  desArray[$i]=$duration #store in array to calculate SD later
 
  #write to file
  echo "des decryption time for loop $i is: $duration" >> DecryptionTimes.txt

  #add up total, increment i
  desTotalTime=$(echo "$desTotalTime+$duration" | bc)
  i=$((i+1))

done

#write total to file, reset i variable
echo ""
echo "Total time for des decryption for 10 loops: $desTotalTime" >> DecryptionTimes.txt
echo "" >> DecryptionTimes.txt
i=0

#get ready for 3des Decryption
echo "3des Decryption Times:" >> DecryptionTimes.txt

echo "Starting loop for 3des Decryption..."

#while loop for des3 decryption
while [ $i -lt 10 ]; do

  #start time
  startTime=$(date +%s.%N)

  #des decryption with openssl
  openssl des-ede-cbc -d -in des3EncryptOut.txt -out des3-Decrypted.txt -pass pass:3ncrypt1onP@ssw0rd

  #calculate the time it took to decrypt
  endTime=$(date +%s.%N)
  duration=$(echo "$endTime-$startTime" | bc)
  des3Array[$i]=$duration #store in array to calculate SD later

  #write to file
  echo "des3 decryption time for loop $i is: $duration" >> DecryptionTimes.txt

  #add up total, increment i
  total3Des=$(echo "$total3Des+$duration" | bc)
  i=$((i+1))

done

#write total to file, reset i variable
echo ""
echo "Total time for des3 decryption for 10 loops: $desTotalTime" >> DecryptionTimes.txt
echo "" >> DecryptionTimes.txt
i=0

#get ready for aes-128 Decryption
echo "aes-128 Decryption Times:" >> DecryptionTimes.txt

echo "Starting loop for aes-128 Decryption..."

#while loop for aes-128 decryption
while [ $i -lt 10 ]; do

  #start time
  startTime=$(date +%s.%N)

  #des decryption with openssl
  openssl aes-128-cbc -d -in aes128EncryptOut.txt -out aes128-Decrypted.txt -pass pass:3ncrypt1onP@ssw0rd

  #calculate the time it took to decrypt
  endTime=$(date +%s.%N)
  duration=$(echo "$endTime-$startTime" | bc)
  aesArray[$i]=$duration #store in array to calculate SD later

  #write to file
  echo "aes-128 decryption time for loop $i is: $duration" >> DecryptionTimes.txt

  #add up total, increment i
  totalAes=$(echo "$total3Des+$duration" | bc)
  i=$((i+1))

done

echo ""
echo "Calculating information for about decryptions performed..."

###############################################################################
#Calculate the averages
desAvg=$(echo "$desTotalTime/10" | bc -l)
des3Avg=$(echo "$total3Des/10" | bc -l)
aesAvg=$(echo "$totalAes/10" | bc -l)

##############################################################################
#Calculate the standard deviations
desSD=0
des3SD=0
aesSD=0
tempTotal=0

#for loop for des SD calculation
for i in "${desArray[@]}"
do
	sdTemp=$(echo "$i-$desAvg" | bc -l)
	sdTemp=$(echo "$sdTemp^2" | bc -l)
	tempTotal=$(echo "$tempTotal + $sdTemp" | bc -l)
done

desSD=$(echo "$tempTotal/10" | bc -l)
desSD=$(echo "sqrt ( $desSD )" | bc -l)
tempTotal=0

for i in "${des3Array[@]}"
do
	sdTemp=$(echo "$i-$des3Avg" | bc -l)
	sdTemp=$(echo "$sdTemp^2" | bc -l)
	tempTotal=$(echo "$tempTotal + $sdTemp" | bc -l)
done

des3SD=$(echo "$tempTotal/10" | bc -l)
des3SD=$(echo "sqrt ( $des3SD )" | bc -l)
tempTotal=0

#for loop for des SD calculation
for i in "${aesArray[@]}"
do
        sdTemp=$(echo "$i-$aesAvg" | bc -l)
        sdTemp=$(echo "$sdTemp^2" | bc -l)
        tempTotal=$(echo "$tempTotal + $sdTemp" | bc -l)
done

aesSD=$(echo "$tempTotal/10" | bc -l)
aes3SD=$(echo "sqrt ( $aesSD )" | bc -l)
tempTotal=0


#print averages and standard deviations to file

#print averages to file
echo ""
echo "" >> DecryptionTimes.txt
echo "************************************************************" >> DecryptionTimes.txt
echo "des average time: $desAvg" >> DecryptionTimes.txt
echo "des standard deviation: $desSD" >> DecryptionTimes.txt
echo "des3 average time: $des3Avg" >> DecryptionTimes.txt
echo "des3 standard deviation: $des3SD" >> DecryptionTimes.txt
echo "aes-128 average time: $aesAvg" >> DecryptionTimes.txt
echo "aes-128 standard deviation: $aesSD" >> DecryptionTimes.txt
echo "Decryptions finished, information stored in DecryptionTimes.txt"
echo ""

#remove files
#echo "Cleaning up..."
#rm aes128EncryptOut.txt desEncryptOut.txt des3EncryptOut.txt aes128-Decrypted.txt des3-Decrypted.txt des-Decrypted.txt
