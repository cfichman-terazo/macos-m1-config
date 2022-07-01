#! /bin/zsh
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
  cp .zprofile ~
  cp .zshrc ~
  cp .zuserconfig ~
  vim ~/.zuserconfig

  source ~/.zprofile
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

# Install aws-cli and tools
function install_aws() {
  brew install aws-shell
  brew install awscli
  brew install amazon-ecs-cli
}

function install_gcloud() {
  gcloud_download=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-392.0.0-darwin-arm.tar.gz
  wget -q0- $gcloud_download | tar xvz
}

## Install and configure python
# https://github.com/pyenv/pyenv
function install_python() {
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
  install_python
  install_c_deps
  brew install go
}

function install_frameworks() {
  install_nvm
  brew install --cask docker
  brew install docker-squash
  brew install podman
  brew install kubernetes-cli minikube
  install_aws
}

# Install databases and commonly used applications 
# - doesn't run by default because containers make more sense for these things
function install_databases() {
  brew install postgresql
  brew install --cask pgadmin4
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
    cat << EOF > ~/.ssh/config
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
  if [ $run_full_install = "y" ]; then
    install_homebrew_packages
    install_gcloud
  fi
  if [ $run_update_brew = "y" ]; then
    brewup
  fi
}

main