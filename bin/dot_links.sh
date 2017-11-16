
#!/bin/bash
#
# Creates links from $HOME to dot files

DOT_DIR="$USER@$(hostname)"

set -u
set -e

pushd $DOT_DIR

for E in $(
	ls -d .* | \
	grep -Eve '\.$' -e '\.git$' -e '\.gitignore$' -e '\.gitmodules$'
); do
	ln -sf "$(pwd)/$E" ~;
done

popd
