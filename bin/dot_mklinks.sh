#!/bin/bash
#
# Creates links from $HOME to dot files

DOT_DIR="$USER@$(hostname)"
SCRIPT_DIR=$(dirname $(readlink -f $0))
ROOT_DIR=$(cd ${SCRIPT_DIR}; cd ..; pwd)
N_SAVES=0

BACKUP_DIR="$HOME/tmp/dot/$(date +%y%m%d_%H%S)"
mkdir -p "${BACKUP_DIR}"

pushd $DOT_DIR 1>/dev/null

for E in $(
	ls -d .* | \
	grep -Eve '\.$' -e '\.git$' -e '\.gitignore$' -e '\.gitmodules$'
); do
	if [ -h "$HOME/$E" ]; then
		LINK_TO_US=$(
			ls -al "$HOME/$E" 2>/dev/null | \
				grep '>' | cut -f2 -d">" | \
				awk '{print $1}' | \
				grep "${ROOT_DIR}/${DOT_DIR}"
		)
		if [ "X${LINK_TO_US}" == "X" ]; then
			#I.e. link to somewhere else
			cp -dpr  "$HOME/$E" "${BACKUP_DIR}/$E"
			(( N_SAVES++ ))
			echo " Existing link to dot-file/-directory saved: $E"
		fi
	elif [ -a "$HOME/$E" ]; then
		cp -dpr  "$HOME/$E" "${BACKUP_DIR}/$E"
		rm -rf "$HOME/$E"
		(( N_SAVES++ ))
		echo " Existing dot-file/-directory saved: $E"
	fi
	ln -sf "$(pwd)/$E" $HOME;
done

popd 1>/dev/null

if [ $N_SAVES -gt 0 ]; then
	echo
	echo "Backup directory for original dot-files or links to dot-files (${N_SAVES}): "
	echo " ${BACKUP_DIR}"
else
	rm -rf "${BACKUP_DIR}"
fi
echo
echo "Done!"
