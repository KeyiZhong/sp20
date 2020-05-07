#!/bin/bash

####################################
# Name: <Your name here>
# CSE 391 - Spring 2020 
# Homework 3 - Task 2
####################################

function problem1 {
  # Type your answer to problem #1 below this line
  cut -d, -f1 intro_survey_20sp.csv
}

function problem2 {
  # Type your answer to problem #2 below this line
  cat intro_survey_20wi.csv > combined_results.csv ; tail -n+2 intro_survey_20sp.csv >> combined_results.csv
}

function problem3 {
  # Type your answer to problem #3 below this line
  cut -d, -f2 intro_survey_20sp.csv | grep -i "noodles" | wc -l
}

function problem4 {
  # Type your answer to problem #4 below this line
  cut -d, -f1 intro_survey_20sp.csv | tail -n+2 | sort -f | uniq -c | sort -bgr | head -n3
}

function problem5 {
  # Type your answer to problem #5 below this line
  # How many people are enrolling in 351 and like dogs
  grep "Yes" intro_survey_20sp.csv | cut -d, -f3 | grep "Dogs" | wc -l
}
