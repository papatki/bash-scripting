#!/bin/bash

# Script generates a list of random passwords

# A rundom number as a password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# 3 random nums together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# use current date as the basis for the password
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# use nanoseconds 
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# a better password
PASSWORD=$(date +%s%N | sha256sum | head -c16)
echo "${PASSWORD}"

# add random special character to the password
RANDOM_SPECIAL=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${RANDOM_SPECIAL}"
