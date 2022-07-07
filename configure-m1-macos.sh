#! /bin/zsh
# This file configures an Apple m1 machine for common software development tasks.
# Author: Chris Fichman
# Email: chris.fichman@terazo.com

## Copies zfiles from this directory
function copy_zfiles() {
  cp .zprofile ${HOME}
  cp .zshrc ${HOME}
  cp .zutils* ${HOME}
}

## Copies and configures user settings, then sources zprofile.
function setup_zprofile() {
  copy_zfiles
  cp .zuserconfig ${HOME}
  vim ${HOME}/.zuserconfig
  source ${HOME}/.zprofile
}

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
  echo "Project install? (y/n):"
  read run_project_install
}

function main(){
  run_prompts
  if [ ${run_software_update} = "y" ]; then
    software_update
  fi
  if [ ${run_first_time_setup} = "y" ]; then
    setup_zprofile
    first_time_setup
  else
    copy_zfiles
    source ~/.zprofile
  fi
  if [ ${run_install_system_tools} = "y" ]; then
    install_system_tools
  fi
  if [ ${run_git_ssh_keygen} = "y" ]; then
    git_ssh_keygen
  fi 
  if [ ${run_update_brew} = "y" ]; then
    brewup
  fi
  if [ ${run_project_install} = "y" ]; then
    cp ${CURRENT_PROJECT}/.z* ~
    source ~/.zprofile
    source ${CURRENT_PROJECT}/configure-project.sh
  fi
}

source ./.zutils-system
main