#!/usr/bin/env bash

# Color Formatting Code Constants
NC='\033[0;m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'

# Wordnik API Key for testing: a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5
# Fetches a random word using the api at "http://random-word-api.herokuapp.com/home"
word=$(curl -s -X GET "random-word-api.herokuapp.com/word?number=1&swear=0")

# Checks to make sure the API call worked
if [[ $word == "" ]]; then
	printf "${RED}There was a problem fetching the word.\n"
	printf "Check your internet connection or the API endpoint.\n${NC}"
	exit 1
fi

# Formats Word to remove JSON wrapper
word=$(echo "$word" | tr -d '[\"]')
wl=${#word}

# Show word for testing:
#echo $word

printf -- "-- Welcome to Universle! --\n\nStart guessing:\n"

# Guess Number
gn=0
guess=""
# Main Guess Loop
while [[ $guess != $word ]]; do
	read guess
	gl=${#guess}
	((gn++))

	# Erase user input
	echo -e -n "\033[1A\033[2K"

	existcheck=$word

	# First Pass for Removing Green Letters from Yellow Letter Check Variable
	for (( i=0; i<$gl; i++ )); do
		letter=${guess:$i:1}
		if [[ $letter == ${word:$i:1} ]]; then
			existcheck=${existcheck/$letter}
		fi
	done

	# Check Guess Letters
	for (( i=0; i<$gl; i++ )); do
		letter=${guess:$i:1}
		if [[ $letter == ${word:$i:1} ]]; then
			printf $GREEN
		elif [[ "$existcheck" == *"$letter"* ]]; then
			printf $YELLOW
			# Removes the letter from a temp copy of the word so the number of yellow letters is correct
			existcheck=${existcheck/$letter}
		fi
		printf "${letter}${NC}"
	done

	# Check Guess Size
	if (( $gl > $wl )); then
		printf "-"
	elif (( $gl < $wl )); then
		printf "+"
	fi

	echo
done

echo
echo "You guessed it in ${gn} tries!"
