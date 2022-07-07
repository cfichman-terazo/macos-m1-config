#! /bin/zsh
# This file configures an Apple m1 machine for common software development tasks.
# Author: Chris Fichman
# Email: chris.fichman@terazo.com

run_primestreet_first_time_setup="n"
run_primestreet_install="n"

function run_primestreet_prompts(){
  echo "Primestreet first time setup? (y/n):"
  read run_primestreet_first_time_setup
  echo "Install Primestreet project infrastructure? (y/n):"
  read run_primestreet_install
}

function primestreet_main(){
  run_primestreet_prompts
  if [ $run_primestreet_first_time_setup = "y" ]; then
    primestreet_first_time_setup
  fi
  if [ $run_primestreet_install = "y" ]; then
    primestreet_install
  fi
}

source ${HOME}/.zprimestreet
primestreet_main