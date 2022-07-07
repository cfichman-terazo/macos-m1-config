#! /bin/zsh
# This file configures an Apple m1 machine for common software development tasks.
# Author: Chris Fichman
# Email: chris.fichman@terazo.com

run_first_time_setup="n"
run_software_update="n"
run_install_system_tools="n"
run_brew_update="n"

function run_prompts(){
  echo "First time setup? (y/n):"
  read run_first_time_setup
  echo "Run software update? (y/n):"
  read run_software_update
  echo "Install system tools? (y/n):"
  read run_install_system_tools
  echo "Create git ssh key? (y/n):"
  read run_git_ssh_keygen
  echo "Update brew and packages? (y/n):"
  read run_update_brew
}

function main(){
  run_prompts
  if [ $run_software_update = "y" ]; then
    software_update
  fi
  if [ $run_first_time_setup = "y" ]; then
    first_time_setup
  fi
  if [ $run_install_system_tools = "y" ]; then
    install_system_tools
  fi
  if [ $run_git_ssh_keygen = "y" ]; then
    git_ssh_keygen
  fi 
  if [ $run_update_brew = "y" ]; then
    brewup
  fi
}

source ./.zutils-system
source ./.zutils-tools
main