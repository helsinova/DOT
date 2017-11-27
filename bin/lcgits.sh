#!/bin/bash
#
# Find, relative to the git your standing in, and open all local git-configs
# for editing in vim 

relative to the git
your standing in.

pushd $(git rev-parse --show-toplevel) >/dev/null
	# Find all local git config-files. Exclude .vim sub-bodules.
	FILES=$(
		for R in $(
			find . -name .git -type d); do
				find $R -name config;
			done | grep -v "\.vim"
	)
	vim $FILES
popd >/dev/null
