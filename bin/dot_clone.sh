#!/bin/bash
#
# Clones a gold-machine into a sub-module in this directory
# with the name user@host

THIS_HOST_TYPE=$(uname -a | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
CLONE_AS="$USER@$(hostname)"
CURR_BRANCH=$(git branch | grep -Ee '^\*' | awk '{print $2}')

echo
if [ "${CURR_BRANCH}" == "master" ]; then
	echo "Branch-off from [${CURR_BRANCH}] to [${USER}]"
	git checkout -B "${USER}"
fi

set -u
set -e

if [ -d ".git/modules/${CLONE_AS}" ]; then
	echo
	echo "[.git/modules/${CLONE_AS}] exists. Removing..."
	rm -rf ".git/modules/${CLONE_AS}"
fi

echo
echo "Cloning from gold-standard [${THIS_HOST_TYPE}] to [${CLONE_AS}]"
git submodule add -b "${THIS_HOST_TYPE}" -- ssh://dot_siterepo/DOT "${CLONE_AS}"

pushd "${CLONE_AS}"
	echo
	echo "Branch-off machine-module from "[${THIS_HOST_TYPE}]" to [${CLONE_AS}]"
	git checkout -B "${CLONE_AS}"
	echo "Make personal changes in [${CLONE_AS}] and feel free to commit"
popd

