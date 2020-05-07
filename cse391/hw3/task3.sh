#!/bin/bash

####################################
# Name: <Your name here>
# CSE 391 - Spring 2020 
# Homework 3 - Task 3
####################################

function problem6 {
  # Type your answer to problem #6 below this line
  find . -mindepth 2 -name '*.html' -delete ; rm -d dir*/
}

function problem7 {
  # Type your answer to problem #7 below this line
  seq 1 9 | xargs mkdir
}

function problem8 {
  # Type your answer to problem #8 below this line
  javac CheckTransactions.java ; java CheckTransactions 2> err.log
}
