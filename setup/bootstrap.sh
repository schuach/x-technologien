#!/bin/bash

# change to home directory first
cd ~

## git-setup
# fullname="USER INPUT"
# read -p "Bitte ihren Namen eingeben (z. B. 'Max Mustermann'): " username
# user="USER INPUT"
# read -p "Bitte E-Mail-Adresse eingeben: " email
# git config --global user.name "$username"
# git config --global user.email "$email"

# git config --global credential.helper store

## java installieren
command -v java >/dev/null || ( apt-get update -y && apt-get install default-jre -y )

## Das Repo klonen
cd ~
mkdir projects
cd ~/projects

git clone https://gitlab.obvsg.at/ss/x-technologien.git

# make symlinks for driver scripts
ln -s ~/projects/x-technologien/saxon/bin/saxon-xslt ~/bin/saxon-xslt
ln -s ~/projects/x-technologien/saxon/bin/saxon-xquery ~/bin/saxon-xquery

## XSpec
cd ~/projects
git clone https://github.com/xspec/xspec.git

# set SAXON_HOME and XSPEC_HOME environment variable
echo export SAXON_HOME=~/projects/x-technologien/saxon/share/java >> ~/.bashrc
echo export XSPEC_HOME=~/projects/xspec >> ~/.bashrc


# symlink xspec.sh to ~/bin
ln -s ~/projects/xspec/bin/xspec.sh ~/bin/xspec.sh

# source .bashrc so environment variables are set
source ~/.bashrc

## test runs
# start a transformation
cd ~/projects/x-technologien
saxon-xslt -s:setup/test.xsl setup/test.xsl

# run tests -- one should pass, one should fail
xspec.sh setup/test.xspec
