###############################################################################
# Joseph Noyes, Jeffery Webb, Paul Eccleston                                  #
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

key_bits_des=56
key_bits_3des=168
key_bits_aes128=128

seconds_in_a_day=$((60 * 24))
seconds_in_a_year=$(($seconds_in_a_day * 365))
seconds_in_a_decade=$((10 * $seconds_in_a_year))

printTime () {
$(which echo) -n "It would take "
if [ $(echo $1 | wc -c) -gt $(echo $seconds_in_a_decade | wc -c) ]; then
    $(which echo) -n `round $(echo $1 / $seconds_in_a_decade | bc -l) 1` decades
elif [ $1 -gt $seconds_in_a_year ]; then
    $(which echo) -n `round $(echo $1 / $seconds_in_a_year | bc -l) 1` years 
elif [ $1 -gt $seconds_in_a_day ]; then
    $(which echo) -n `round $(echo $1 / $seconds_in_a_day | bc -l) 1` day 
else
	$(which echo) -n $1 seconds
fi

}

round()
{
	echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
};
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
echo "Total time for 3des encryption for 10 loops: $total3Des" >> EncryptionTimes.txt

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
echo "**********************************************************************"
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
  openssl aes-128-cbc -d  -in aes128EncryptOut.txt -out aes128-Decrypted.txt -pass pass:3ncrypt1onP@ssw0rd

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

#*****************************************************************************
# Brute forcing
echo "**********************************************************************"
echo "Starting brute force attempts for each encrypted file..."
echo ""
echo "Brute Force Information" > BruteForce.txt
echo "" >> BruteForce.txt
i=0

#start time
startTime=$(date +%s.%N)
while [ $i -lt 1000 ]; do #$(openssl rand -base64 32)
  tempPassword=hhh123FakePassword
  #des decryption with openssl
  openssl aes-128-cbc -d -in aes128EncryptOut.txt -out decrypted.txt -pass pass:$tempPassword >/dev/null 2>&1

  if [ $? -eq 0 ]; then
	diff decrypted.txt pokelist.txt >/dev/null 2>&1
	  if [ $? -eq 0 ]; then
		echo "Successfully brute forced with password: $tempPassword"
		exit
	  fi
  fi

  #add up total, increment i
  i=$((i+1))
done

#calculate the time it took to decrypt
endTime=$(date +%s.%N)
duration=$(echo "$endTime-$startTime" | bc)
totalSeconds=$(echo "(2^$key_bits_aes128) * ($duration/1000)" | bc -l)
hashes=$(echo "60.0/($duration/1000.0)" | bc -l)
hashes=$(round $hashes 1)
totalSeconds=$(round $totalSeconds 1)
$(which echo) -n At a rate of $hashes attempts per minute, 
printTime $totalSeconds
echo " to brute force AES-128-cbc"
echo ""

#print to file
$(which echo) -n At a rate of $hashes attempts per minute, >> BruteForce.txt
printTime $totalSeconds >> BruteForce.txt
echo " to brute force AES-128-cbc" >> BruteForce.txt
echo "" >> BruteForce.txt

#*****************************************************************************
#*****************************************************************************
# Brute forcing

i=0

#start time
startTime=$(date +%s.%N)
while [ $i -lt 1000 ]; do #$(openssl rand -base64 32)
  tempPassword=hhh123FakePassword
  #des decryption with openssl
  openssl des-cbc -d -in desEncryptOut.txt -out decrypted.txt -pass pass:$tempPassword >/dev/null 2>&1

  if [ $? -eq 0 ]; then
	diff decrypted.txt pokelist.txt >/dev/null 2>&1
	  if [ $? -eq 0 ]; then
		echo "Successfully brute forced with password: $tempPassword"
		exit
	  fi
  fi

  #add up total, increment i
  i=$((i+1))
done

#calculate the time it took to decrypt
endTime=$(date +%s.%N)
duration=$(echo "$endTime-$startTime" | bc)
totalSeconds=$(echo "(2^$key_bits_des) * ($duration/1000)" | bc -l)
hashes=$(echo "60.0/($duration/1000.0)" | bc -l)
hashes=$(round $hashes 1)
totalSeconds=$(round $totalSeconds 1)
$(which echo) -n At a rate of $hashes attempts per minute, 
printTime $totalSeconds
echo " to brute force des-cbc"
echo ""

#print to file
$(which echo) -n At a rate of $hashes attempts per minute, >> BruteForce.txt
printTime $totalSeconds >> BruteForce.txt
echo " to brute force des-cbc" >> BruteForce.txt
echo "" >> BruteForce.txt


#*****************************************************************************
#*****************************************************************************
# Brute forcing
i=0

#start time
startTime=$(date +%s.%N)
while [ $i -lt 1000 ]; do
  tempPassword=hhh123FakePassword
  #des decryption with openssl
  openssl des-ebe-cbc -d -in desEncryptOut.txt -out decrypted.txt -pass pass:$tempPassword >/dev/null 2>&1

  if [ $? -eq 0 ]; then
	diff decrypted.txt pokelist.txt >/dev/null 2>&1
	  if [ $? -eq 0 ]; then
		echo "Successfully brute forced with password: $tempPassword"
		exit
	  fi
  fi

  #add up total, increment i
  i=$((i+1))
done

#calculate the time it took to decrypt
endTime=$(date +%s.%N)
duration=$(echo "$endTime-$startTime" | bc)
totalSeconds=$(echo "(2^$key_bits_3des) * ($duration/1000)" | bc -l)
hashes=$(echo "60.0/($duration/1000.0)" | bc -l)
hashes=$(round $hashes 1)
totalSeconds=$(echo $totalSeconds | tr -d '\\ ')
totalSeconds=$(round $totalSeconds 1)
$(which echo) -n At a rate of $hashes attempts per minute, 
printTime $totalSeconds
echo " to brute force des-ebe-cbc"
echo ""

#print to file
$(which echo) -n At a rate of $hashes attempts per minute, >> BruteForce.txt
printTime $totalSeconds >> BruteForce.txt
echo " to brute force des-ebe-cbc" >> BruteForce.txt
echo ""  >> BruteForce.txt


#*****************************************************************************
#remove files

echo "Cleaning up temp file..."
rm aes128EncryptOut.txt desEncryptOut.txt des3EncryptOut.txt aes128-Decrypted.txt des3-Decrypted.txt des-Decrypted.txt decrypted.txt

echo ""
echo "Information stored in EncryptionTimes.txt, DecryptionTimes.txt,"
echo "and BruteForce.txt"
echo ""
echo "Script finished running."
