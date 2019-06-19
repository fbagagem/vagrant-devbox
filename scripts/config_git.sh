#!/usr/bin/env bash

echo "######################################################################"
echo "Configuring GIT... ###################################################"
echo "######################################################################"

USER_NAME="$1"
USER_EMAIL="$2"

git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

echo "Done."