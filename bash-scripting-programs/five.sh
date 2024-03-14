#!/bin/bash

# Program to run my other four programs

./questionnaire.sh
echo "What should we count down from?"
read N
./countdown.sh $N
./bingo.sh
./fortune.sh