#! /bin/zsh
# This file configures an Apple m1 machine for common software development tasks.
# Author: Chris Fichman
# Email: chris.fichman@terazo.com

function first_time_setup () {
  setup_zprofile
  softwareupdate --install-rosetta
  sudo bash -c "xcode-select --install; xcodebuild -license accept"
}

# Run MacOS software update
function software_update () {
  sudo bash -c "softwareupdate -i -a"
}

## Copies zprofile from this folder and installs in home directory
function setup_zprofile() {
  ## Install and source .zprofile
  cp .zprofile ${HOME}
  cp .zshrc ${HOME}
  cp .zuserconfig ${HOME}
  vim ${HOME}/.zuserconfig

  source ${HOME}/.zprofile
}

## Install homebrew
function install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo ">>>>>>>>>>READ OUTPUT CAREFULLY AND UPDATE ZPROFILE IF NEEDED<<<<<<<<<<"
}

## Install and configure nvm
function install_nvm() {
  brew install nvm
  nvm install node
  nvm alias default node
  nvm use default
}

## Install and configure jenv : https://github.com/jenv/jenv
function install_jenv() {
  brew install jenv
  jenv enable-plugin export
  install_java${JAVA_MAJOR_VERSION}
  jenv add "$(${PATH_TO_JVM_HOME})"
  jenv local ${JAVA_MAJOR_VERSION}.0
  exec $SHELL -l
}

function install_java11() {
  # jenv only manages environment but does not install the JDK
  brew install --cask java11
  sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
  export PATH_TO_JVM_HOME=/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home
}

# Install aws-cli and tools
function install_aws() {
  brew install awscli
  brew install amazon-ecs-cli
}

# Installs azure-cli
function install_azure() {
  brew install azure-cli
}

# Installs gcloud SDK
# NOTE: Download is for M1 chipset, NOT intel chipset!
function install_gcloud() {
  local orig_dir=$(pwd)
  mkdir -p ${HOME}/third-party && cd ${HOME}/third-party
  gcloud_download=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-392.0.0-darwin-arm.tar.gz
  wget -qO- $gcloud_download | tar xvz -C ${HOME}/third-party
  ./google-cloud-sdk/install.sh -q --path-update false --install-python false
  cd $orig_dir
}

## Install and configure python
# https://github.com/pyenv/pyenv
function install_pyenv() {
  brew install pyenv
  pyenv install ${USER_PYTHON_VERSION}
  pyenv global ${USER_PYTHON_VERSION}
  pip3 install bitstring uritools nose tornado boto3
}

function install_c_deps() {
  brew install gcc make
}

function install_twilio() {
  brew tap twilio/brew && brew install twilio
  twilio autocomplete zsh
  twilio login ${TWILIO_TERAZO_SID} --profile=${TWILIO_PROFILE} --auth-token=${TWILIO_TERAZO_KEY}
  twilio profiles:use ${TWILIO_PROFILE}
}

# Install languages and their dependencies
function install_languages() {
  install_pyenv
  install_c_deps
  brew install go
  install_jenv
}

function install_frameworks() {
  install_nvm
  brew install --cask docker
  brew install docker-squash
  brew install podman
  brew install kubernetes-cli minikube kubectx
  install_twilio
  if [ run_cloud_install == 'y' ]; then
    install_aws
    install_gcloud
    install_azure
  fi
}

# Install databases and commonly used applications 
# - doesn't run by default because containers make more sense for these things
function install_databases() {
  brew install postgresql
  brew install --cask pgadmin4
}

function install_ides() {
  brew install --cask intellij-idea visual-studio-code sublime-text
}

function install_cli_utils() {
  brew install wget curl rsync lz4
  brew install tmux watch htop netcat nmap
  brew install jq tree gawk gnu-sed
}

# Install homebrew managed packages
function install_homebrew_packages () {
  install_cli_utils
  install_languages
  install_frameworks
  # install_databases
}

## Create ssh-key and add to keychain
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
function git_gen_ssh_key() {
  if [ ! -f ${GIT_SSH} ]; then
    ssh-keygen -t ed25519 -f "${GIT_SSH}" -C "${USER_EMAIL}"
    cat << EOF > ${HOME}/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ${GIT_SSH}
EOF
  else
    echo "ssh file already exists, skipping generation."
  fi
  ## Turn on ssh agent and add key to keychain
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain ${GIT_SSH}
}

function brewup() {
  brew update;
  brew upgrade;
  brew upgrade --cask;
  brew cleanup;
  brew doctor;
}

run_first_time_setup="n"
run_system_update="n"
run_full_install="n"
run_brew_update="n"

function run_prompts(){
  echo "First time setup? (y/n):"
  read run_first_time_setup
  echo "Run software update? (y/n):"
  read run_software_update
  echo "Full install? (y/n):"
  read run_full_install
  echo "Install cloud sdks? (y/n):"
  read run_cloud_install
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
  if [ $run_update_brew = "y" ]; then
    brewup
  fi
  if [ $run_full_install = "y" ]; then
    install_homebrew_packages
    install_gcloud
    if [ $run_optional_install = "y" ]; then
      install_ides
    fi
  fi
}

main