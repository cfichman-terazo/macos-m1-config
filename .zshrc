#! /bin/zsh
# Adds colors and nice display features to shell 
# Author: Chris Fichman
# Email: chris.fichman@terazo.com

export NOGIT=''  ### non-empty means dont use it

# Not sure what this doees in zsh - in bash it would ensure UTF-8 is being used.
export LC_COLLATE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# HISTORY CONFIGURATION
# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups ingorespace
# Filter out certain commands from history output
export HISTIGNORE='ls:cd:cd -:mkdir:pwd:exit:date:git status*:git log*:rm *'

TMPDIR="$HOME/tmp"
if [[ ! -d $TMPDIR ]] ; then
    mkdir -p $TMPDIR
else
    export TMPDIR
fi

# Configures git display in user prompt of shell
_git_prompt() {
    local branch
    local git_state
    local git_head
    local git_dir
    local tag
    local commit

    if branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" ; then
        if [ "$branch" != HEAD ] ; then
            git_head=$branch; commit="$(git rev-parse --short $branch)"
        elif tag="$(git describe --tags --exact-match HEAD 2>/dev/null)"; then
            git_head=$tag; commit="$(git rev-parse --short $tag)"
        else
            git_head="detatched"; commit="$(git rev-parse --short HEAD)"
        fi

        git_dir=$(git rev-parse --git-dir);

        if [ -d "$git_dir/rebase-apply" ]; then
            git_state=rebase
        elif [ -d "$git_dir/rebase-merge" ]; then
            git_state=rebase
        elif [ -f "$git_dir/MERGE_HEAD" ]; then
            git_state=merge
        elif [ -f "$git_dir/CHERRY_PICK_HEAD" ]; then
            git_state=cherry-pick
        elif [ -f "$git_dir/REVERT_HEAD" ]; then
            git_state=revert
        elif [ -f "$git_dir/BISECT_LOG" ]; then
            git_state=bisect
        fi
    fi

    if [[ -n "$git_head" ]] ; then
        echo "(${git_head}:${commit})"
    fi
    if [[ -n "$git_state" ]] ; then
        echo "${git_state}"
    fi
}

function exitcode_color_vcs() {
    RET=$?
    ###^^^ this one _MUST_ be first, other commands muck with it

    if [[ $RET -eq 0 ]]; then
        ERRMSG="%F{green}$RET%f"
    else
        ERRMSG="%F{red}$RET%f"
    fi

    VCSSTUFF=""
    [[ -z $GITSTUFF && -z $NOGIT ]] && VCSSTUFF=${VCSSTUFF}$(_git_prompt)
    unset PS1
    unset GITSTUFF
    # Configure user prompt prefix in terminal. Adds exit code of previous command, git branch(if git repo is present), host and pwd (respectively).
    PS1="${ERRMSG} %F{magenta}${VCSSTUFF}%f%F{yellow}%n%f:%F{cyan}%1~%f ›" 
    unset ERRMSG
    unset VCSSTUFF
    #set -o nounset
}

# Linux sh uses PROMPT_COMMAND but zsh doesn't have it
export PROMPT_COMMAND=exitcode_color_vcs
# zsh uses precmd to run bash functions before shell prompt is created.
precmd() {eval "$PROMPT_COMMAND"}

# ------------------------------------------------------------------------------------------------------------------------------------------------
# Docker Settings
# ------------------------------------------------------------------------------------------------------------------------------------------------
# export DOCKER_BUILDKIT=1

# ------------------------------------------------------------------------------------------------------------------------------------------------
# NVM Settings
# ------------------------------------------------------------------------------------------------------------------------------------------------
# export NODE_VERSION=node
# nvm use ${NODE_VERSION}

# ------------------------------------------------------------------------------------------------------------------------------------------------
# Library Paths and autocomplete. Enable as needed. 
# WARNING:Enabling too many autocomplete rules below this point may negatively impact shell performance!
# ------------------------------------------------------------------------------------------------------------------------------------------------
# Add Homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Setup NVM Path
export NVM_DIR="${HOME}/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Setup jenv path
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
switch_jenv

# Setup pyenv path
export PYENV_ROOT="${HOME}/.pyenv"
command -v pyenv >/dev/null || export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init -)"

# Setup twilio autocomplete
#eval $(twilio autocomplete:script zsh)

# Setup Gcloud path and autocomplete
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cfichman/third-party/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/cfichman/third-party/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/cfichman/third-party/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/cfichman/third-party/google-cloud-sdk/completion.zsh.inc'; fi