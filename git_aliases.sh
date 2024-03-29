#!/usr/bin/env bash

# Add
alias ga='echo git add;git add'
alias gap='echo git add -p;git add -p'
alias gau='echo git add -u;git add -u'

# Branch
alias gb='echo git branch;git branch'

# Checkout
alias gco='echo git checkout;git checkout'
alias gcom='echo git checkout master;git checkout master'

# Cherry Pick
alias gcp='echo git cherry-pick;git cherry-pick'

# Commit
alias gca='echo git commit --amend;git commit --amend'
alias gcan='echo git commit --amend --no-edit;git commit --amend --no-edit'

# Fetch
alias gf='echo git fetch;git fetch'

# Log
alias gl='echo git log;git log'

# Pull
alias gpl='echo git pull --rebase; git pull --rebase;'
alias gplo='echo git pull origin;git pull origin'
alias gplom='echo git pull origin master;git pull origin master'
alias gploh='echo git pull origin head;git pull origin head'

# Push
alias gpso='echo git push origin;git push origin'
alias gpsof='echo git push origin -f;git push origin -f'
alias gpsoh='echo git push origin head;git push origin head'
alias gpsohf='echo git push origin head -f;git push origin head -f'

# Reset
alias grh='echo git reset --hard;git reset --hard'

# Rebase
alias gr='echo git rebase;git rebase'
alias gri='echo git rebase -i;git rebase -i'
alias grm='echo git rebase master;git rebase master'
alias grc='echo git rebase --continue;git rebase --continue'
alias gra='echo git rebase --abort;git rebase --abort'

# Stash
alias gst='echo git stash;git stash'

# Status
alias gs='echo git status;git status'

# Submodules
alias gsu='echo git submodule update;git submodule update'
alias gsui='echo git submodule update --init;git submodule update --init'
alias gsuir='echo git submodule update --init --recursive;git submodule update --init --recursive'

########################
# Misc
########################

# Add Tracked files and Commit ammend
alias gac='echo ga -u && gcan;ga -u && gcan'

# Add Tracked files, Commit ammend and force push to origin
alias gacp='echo ga -u && gcan && gpsof;ga -u && gcan && gpsof'

# Refer: https://stackoverflow.com/questions/29914052/how-to-git-rebase-a-branch-with-the-onto-command
# Rebase on origin/master
# Usage : grom <oldparent>
function grom(){
  if [ -z "$1" ]; then
    echo "Error: old parent branch/commit not provided"
    echo "Usage: grom <oldparent>"
    return 1
  fi
  git rebase --onto origin/master $1
}

# Usage : grocm <oldparent>
# Rebase on only checked out master on local machine
function grocm(){
  if [ -z "$1" ]; then
    echo "Error: old parent branch/commit not provided"
    echo "Usage: grocm <oldparent>"
    return 1
  fi
  git rebase --onto master $1
}

# Git rebase onto : gro <newparent> <oldparent>
function gro(){
  if [ -z "$1" ]; then
    echo "Error: new parent branch/commit not provided"
    echo "Usage: gro <newparent> <oldparent>"
    return 1
  fi
  if [ -z "$2" ]; then
    echo "Error: old parent branch/commit not provided"
    echo "Usage: gro <newparent> <oldparent>"
    return 1
  fi
  git rebase --onto $1 $2
}

# Append issue reference to Git commit message
gcm() {
  if [[ $# -ne 1 ]]; then
    # display usage
    echo "Usage: gcm \"Commit Msg\""
    echo "Automatically appends the issue reference (if found) to the commit message."
  else
    local branch_suffix
    branch_suffix=$(git rev-parse --abbrev-ref HEAD | cut -d/ -f2)
    local issue_reference
    if [[ $branch_suffix =~ ^([A-Z]+-[0-9]+) ]]; then
      if grep -q 'zsh' <<< "$SHELL"; then
        issue_reference="${match[1]}"
      else
        issue_reference="${BASH_REMATCH[1]}"
      fi
    fi

    if [ -z "$issue_reference" ]; then
      echo -e "\033[0;31mCould not extract issue reference from branch name! Issue reference must match [A-Z]+-[0-9]+"
    else
      echo "git commit -m \"$issue_reference $1 \""
      git commit -m "$issue_reference $1"
    fi
  fi
}

# Git commit with message
function gcmm(){
  git commit -m "$1"
}

# Git fetch and checkout a branch
function gfco(){
  gf && gco "$1"
}

# https://craftquest.io/guides/git/git-workflow-tools/git-subtrees
# Git subtree pull
function gsubp(){
  # Currently we only have interop repo added to subtree
  # Change git repo as needed
  git subtree pull --prefix third_party/interop git@gitlab.com:abc.git master --squash
}
