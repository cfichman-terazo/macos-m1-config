#! /bin/zsh
# This file configures an Apple m1 machine for common software development tasks.
# Author: Chris Fichman
# Email: chris.fichman@terazo.com

## Copies non-config zfiles from this repo.
function sync_non_config_zfiles() {
  find . -type f -name ".z*" -exec rsync -uab --backup-dir "${HOME}/.old-dotz-files" --suffix ".old" {} ${HOME} ';'
}

## Copies and configures user settings, then sources zprofile.
function setup_user_zprofile() {
  sync_non_config_zfiles
  vim ${HOME}/.zuserconfig
  source ${HOME}/.zprofile
}

run_software_update="n"
run_install_system_tools="n"
run_zprofile_setup="n"
run_install_develop_tools="n"
run_git_ssh_keygen="n"
run_brew_update="n"
run_project_install="n"

function run_prompts(){
  echo "Run software update? (y/n):"
  read run_software_update
  echo "Install required system tools? (y/n):"
  read run_install_system_tools
  echo "Setup shell environment? (y/n):"
  read run_zprofile_setup
  echo "Install optional development tools? (y/n):"
  read run_install_develop_tools
  echo "Create git ssh key? (y/n):"
  read run_git_ssh_keygen
  echo "Update brew and packages? (y/n):"
  read run_update_brew
  echo "Current project install? (y/n):"
  read run_project_install
}

function main(){
  run_prompts
  if [ ${run_software_update} = "y" ]; then
    software_update
  fi
  if [ ${run_install_system_tools} = "y" ]; then
    install_system_tools
  fi
  if [ ${run_zprofile_setup} = "y" ]; then
    setup_user_zprofile
  fi
  if [ ${run_install_develop_tools} = "y" ]; then
    install_develop_tools
  fi
  if [ ${run_git_ssh_keygen} = "y" ]; then
    git_ssh_keygen
  fi 
  if [ ${run_update_brew} = "y" ]; then
    brewup
  fi
  if [ ${run_project_install} = "y" ]; then
    echo "Project to be installed: ${CURRENT_PROJECT}"
    source ${CURRENT_PROJECT}/configure-project.sh
  fi
}
source ./.zutils-system
source ./.zutils-tools
main