# The following will possibly be set (allow re-sourcing)
# (All but PATH)
unset XTELNET_GEOMETRY
unset EDITOR
unset HOSTNAME
unset BCOLOURED
unset GRCCOLOUR
unset NCPUS
unset FLASHIT_DIRS
unset USE_CCACHE
unset OUT_DIR_COMMON_BASE
unset PDFVIEWER
unset FZF_DEFAULT_OPTS
#unalias cd

set -o pipefail

export PATH=~/bin:~/.cabal/bin:$PATH

if [ -f "$HOME/.bash_paths.sh" ]; then
. "$HOME/.bash_paths.sh"
fi

# Measure this with the 'xwininfo' command-line utility
export XTELNET_GEOMETRY="-geometry 132x88--6+21"
export XTELNET_GEOMETRY=-"geometry 104x15--9+-8"

# Sshell & Util settings
export LANG='en_GB.UTF-8'
#set editing-mode vi
export EDITOR=vim
export FZF_DEFAULT_OPTS="--extended"

#if [ "X$(screen -ls | grep sshfw_nntp)" == "X" ]; then
#   echo "Starting ssh tunnel..."
#   screen -d -m -S sshfw_nntp ssh -L localhost:1234:localhost:6680 seldlx0294
#   sleep 3
#fi

#alias make src.make.sh

#Convert shell-variable to environment
export HOSTNAME

function _bash_exitstatus {
    EXITSTATUS="$?"
    BOLD="\[\033[1m\]"
    RED="\[\033[1;31m\]"
    GREEN="\[\e[32;1m\]"
    BLUE="\[\e[34;1m\]"
    OFF="\[\033[m\]"

    PROMPT="[\u@\h ${BLUE}\W${OFF}"

    if [ "${EXITSTATUS}" -eq 0 ]
    then
       PS1="${PROMPT} ${BOLD}${GREEN}:)${OFF} ]\$ "
    else
       PS1="${PROMPT} ${BOLD}${RED}:(${OFF} ]\$ "
    fi

    PS2="${BOLD}>${OFF} "
}

###############################################################################
# Synchronize histories after each command terminates
# Tips picked uf from:
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
###############################################################################
HISTSIZE=9000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignorespace:ignoredups

history() {
  _bash_history_sync
  builtin history "$@"
}

_bash_history_sync() {
  builtin history -a         #1
  HISTFILESIZE=$HISTSIZE     #2
  builtin history -c         #3
  builtin history -r         #4
}

_bash_prompt_command() {
	_bash_exitstatus
	_bash_history_sync
}

PROMPT_COMMAND=_bash_prompt_command

# Google 'repo' command helpers

# Get manifests branch for current git
_repo_mbr() {
	repo info . | grep "Current revision" | awk '{print $3}'
}
alias mbr=_repo_mbr

# Clean & restore current git to manifest
_repo_gclean() {
	local CURBR=$(git branch | grep -Ee '^\*' | cut -d" " -f2-)
	local TEST="${CURBR}"
	if [ "X${CURBR}" == "X" -o "X${CURBR}" != "X${CURBR/\(detached/}" ]; then
		echo "Git-Cleaning on a disconnected branch?" 1>&2
		git branch
		#echo "${CURBR}"
		echo "Bailing out..." 1>&2
		return 1
	fi
	git stash && git stash clear
	git clean -fxd && \
		git checkout origin/$(mbr) && \
		git reset --hard && \
		git clean -fxd
	git checkout "${CURBR}"
}
alias mclean=_repo_gclean

_prline() {
	echo -n "#########1#########2#########3#########4"
	echo    "#########5#########6#########7#########8"
}

# Clean & restore git to manifest
_repo_forall_gclean() {
	repo forall -c ' \
		echo -n "#########1#########2#########3#########4"; \
		echo    "#########5#########6#########7#########8"; \
		pwd; \
		echo -n "#########1#########2#########3#########4"; \
		echo    "#########5#########6#########7#########8"; \
		echo "Manifest branch: " $(repo info . | grep "Current revision" | cut -f2 -d":" | sed -e "s/^ //"); \
		git stash && git stash clear && git clean -fxd && \
			git checkout origin/$(repo info . | grep "Current revision" | cut -f2 -d":" | sed -e "s/^ //") && \
			git reset --hard && \
			git clean -fxd
	'
}
alias rclean=_repo_forall_gclean
#		git clean -fxd && \
#			git checkout origin/$(repo info . | grep "Current revision" | '"awk '{print $3}'"') && \
#			git reset --hard && \
#			git clean -fxd


# ~.~ Build/make wrappers ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~
# Override the following envars in local terminal if needed

# Detect build colorization.
################which grc 1>/dev/null 2>/dev/null && export BCOLOURED="yes"
which grc 1>/dev/null 2>/dev/null && export BCOLOURED="yes"

# How grc/crcat should behave (if applicable).
#export GRCCOLOUR="auto"
export GRCCOLOUR="on"

# Detect number of CPUS on host
export NCPUS=$(grep processor /proc/cpuinfo | wc -l)
#export NCPUS=1

function print_mline(){
	echo -n "#########1#########2#########3#########4"
	echo    "#########5#########6#########7#########8"
}

function print_bstart() {
	print_mline
	echo "Build starts: $(date)"
	print_mline
}

function print_bstop() {
#	if [ $# -gt 1 ]; then
		if [ $1 ]; then
			local RES="OK"
		else
			local RES="FAILURE"
		fi
#	fi

	local RES=${RES-"UNKNOWN"}

	print_mline
	echo "Build stops: $(date)"
	echo "Result: $RES"
	print_mline
	return $1
}

# Logged generic make
function _lmake_generic() {
	local TLOGFILE=/tmp/make_$(basename $(pwd))_$(date +%s.%N).log
	print_bstart | tee $TLOGFILE

	if [ "X${BCOLOURED}" == "X" ]; then
		time make -j$NCPUS ${@}  |& tee -a $TLOGFILE
	else
##		time stdbuf -oL grc -es  --colour=$GRCCOLOUR  make -j$NCPUS ${@} |& tee -a $TLOGFILE
		time grc -es  --colour=$GRCCOLOUR  make -j$NCPUS ${@} |& tee -a $TLOGFILE
	fi
	RC=$?
	print_bstop $RC |& tee -a $TLOGFILE
	return $RC
}

## NOTE: that aliasing make will crap recursive builds. Therefor use another
## name just to be sure (even if BW clain not to use recusive builds).
alias bmake=_bw_make
export -f _bw_make

## cd to build-direcory for MuppFactory
function _cd_build() {
	cd $(dirname $(find . -iname build.bat))
}
## NOTE: that aliasing make will crap recursive builds. Therefor use another
## name just to be sure (even if BW clain not to use recusive builds).
alias cdb=_cd_build

# Logged make front-end
# Note: "lmake showcommands" to show verbose output for Android builds
function _lmake() {
	if [ "X$(basename $(pwd))" == "Xproprietary" ]; then
		_lmake_polaris_proprietary "${@}"
	else
		_lmake_generic "${@}"
	fi
}
alias lmake=_lmake

# List log names on host belonging to "project" (i.e. pwd)
function _llogs_raw() {
	ls /tmp/make_* | \
		grep $(basename $(pwd)) | \
		sort -r -k1 -t"_" -n | \
		cut -f3 -d"_" | \
		cut -f1 -d"."
}

function _llogs() {
	##_llogs_raw | xargs -I'{}' date --date='@{}'
	for TS in $(_llogs_raw); do
		local DATESTR=$(date --date="@${TS}")
		local FNAME=$(ls /tmp/make_* | \
			grep $(basename $(pwd)) | \
			grep $TS)
		echo "${DATESTR} # ${FNAME}"
	done
}
alias llogs=_llogs

# Less a log
function _lless() {
	local NUMBER=${1-"1"}

	local TS=$(_llogs_raw | head -n${NUMBER} | tail -n1)
	local FNAME=$(ls /tmp/make_* | \
		grep $(basename $(pwd)) | \
		grep $TS)

	less -SR "${FNAME}"
}
alias lless=_lless

#Re-init bash (re-read this file)
function _ibash() {
	source ~/.bash_profile
}
alias ibash=_ibash

#Shortcut to edit this. Re-source upon completion
function _vbash() {
	vim ~/.bash_profile
	_ibash
}
alias vbash=_vbash

#Shortcut to edit ~/.gitconfig
function _vgit() {
	vim ~/.gitconfig
}
alias vgit=_vgit

#Shortcut to edit ~/.i3/config
function _vi3() {
	vim ~/.i3/config
}
alias vi3=_vi3

#View PDF-file
function _pdfw() {
	#echo "screen -dmS \"pdfw_${@}\" evince ${@}"
	echo "screen -dmS \"pdfw_evince\" evince ${@}"
	screen -dmS "pdfw_evince" evince "${@}"
}
alias pdfw=_pdfw

function _fullbuild() {
	(cd ../android/; senv; lmake);
	git st 2>&1 tee /tmp/git_status0.txt;
	lmake
}
alias fullbuild=_fullbuild

#Grep in history. Essential when we have constant merging of histories
function _gh() {
	history | \
		grep "${@}" | \
		sort -k2 | \
		uniq -s5 | \
		sort -nk1 | \
		grep "${@}"
}
alias gh=_gh

### Directory profiles handling
### Inspired by the following zshell solution
### As bash can't handle named indexes (associative arrays) very well, we
### have to use normal numbered instead, and search,

declare -a CHPWD_ARR

# Returns true if ARRAY given in $1 contains $2
# Note: Array must be passed entirely (i.e. using format: array[@])
function _acontains() {
	local -a ARR=("${!1}")
	Q=$2

	for (( i=0; i < ${#ARR[@]}; i++ )); do
		if [ "X${ARR[i]}" == "X${Q}" ]; then
			return 0
		fi
	done

	return 1
}

# Source .env-file in current directory, 
# * If it exists
# * if it hasn't been sourced already
function chpwd_profiles() {
	local profile context
	local -i idx=${#CHPWD_ARR[@]}

	context="$PWD"

	if ! [ -f "${context}/.env" ]; then
		#return 1
		return
	fi

	if ! _acontains "CHPWD_ARR[@]" "${context}"; then
		CHPWD_ARR[${idx}]="${context}"
		(( idx++ ))
		source "${context}/.env"
		echo "Read new environment #${idx} (${$}:${context})"
		CHPWD_PROFILE="${profile}"
	fi

	#return 0
}

# List all environment directories read in shell
function _lenv() {
	echo ${CHPWD_ARR[*]} | sed -Ee 's/ /\n/g' | tac
}
alias lenv=_lenv

function _cd_command() {
	cd "${@}" && \
		chpwd_profiles
	pwd > ~/.bash_lastdir
}
alias cd=_cd_command

_bash_prompt_command() {
	_bash_exitstatus
	_bash_history_sync
	#echo ${0} ${1} ${2}
	#echo ${BASH_ARGC[0]}
### chpwd_profiles
}

# Open in vim arg #1 in path
function _vwhich() {
	vim $(which $1)
}
alias vwhich=_vwhich

#simple aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ec=concalc
alias senv='source $(pwd)/.env'
alias groot='cd $(git root)'

# Start instant-markdown in screen (hack) as start from within Vim under
# Cygwin for some reason does not work
alias im='screen -dmS instant-markdown-d instant-markdown-d'

# https://stackoverflow.com/questions/9625316/what-color-options-exist-for-ack-grep-for-colorization-of-output-logs-etc
export MY_ACK_COLORS="--color-filename=blue --color-lineno=red --color-match=on_bright_yellow"
alias sgrep='ack ${MY_ACK_COLORS} --cc --cpp --make --ld'
alias ack='ack ${MY_ACK_COLORS}'

# ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~ ~ ~.~ ~.~ ~.~ ~.~ ~.~ ~.~

export FLASHIT_DIRS="${HOME}/sandbox/Polaris/proprietary/out_bin,${HOME}/sandbox/Polaris/android/out/target/product/polaris"
export USE_CCACHE=1
##export OUT_DIR_COMMON_BASE=/tmp/out

#=========================================================================
# Host-OS specific aliases
#=========================================================================
if	[ "X$(uname -a | grep -i CYGWIN)" != "X" ]; then

	# Give cygpath a default behaviour
	function _cygpath_wrapper() {
		if [[ -z "${@// }" ]]; then
			cygpath -w $(pwd)
		else
			cygpath ${@}
		fi
	}
	alias cygpath=_cygpath_wrapper

elif	[ "X$(uname -a | grep -i Linux)" != "X" ]; then

	if [ which lsb_release ] && [ "X$(lsb_release -a | grep -i Ubuntu)" != "X" ]; then

		#Have this run somewhere and send the windows somewhere in the back
		#screen -dmS xdg-open__home -- xdg-open ~
		alias fm='xdg-open .'

	fi
fi


#=========================================================================
# Special tweaks
#=========================================================================
# Winowse workarounds
# --------------------

if	[ "X$(uname -a | grep -i CYGWIN)" != "X" ]; then

	# GIT_SSH is set in Windowze overall environment registry but putty agent
	# doesn't work well with bash. For (each new interactive) shell use, disable
	# it and fall back to UNIX-way of key exchanging (~/.ssh/*)
	# Workaround for variant of bug (2017-03-11)
	# https://bugs.launchpad.net/ubuntu/+source/gnome-keyring/+bug/1586835
	# Where ssh-agent has not been started or has died but the environment
	# variable SSH_AUTH_SOCK is still set
	#if [ "X$(ps -Al -u $USER | grep ssh-agent)" == "X" ]; then
	#	unset SSH_AUTH_SOCK
	#fi
	# More hints:
	# http://unix.stackexchange.com/questions/132065/how-do-i-get-ssh-agent-to-work-in-all-terminals

	# This workaround has been moved to /etc/bash.bashrc

	# GIT_SSH is set in Windowze overall environment registry but putty agent
	# doesn't work well with bash. For (each new interactive) shell use, disable
	# it and fall back to UNIX-way of key exchanging (~/.ssh/*)

	unset GIT_SSH

	# Screens underlaying terminal detection does not work under Cygwin. Work
	# around it (WORKAROUND)
	if [ "X$(grep screen <<< ${TERM})" != "X" ]; then
		alias vim='vim -T screen'
	fi

fi


# Add cygwin to PATH: IMPORTANT NOTE: FIRST
##export PATH="/c/cygwin64/bin":$PATH

#Note that Mingw and Cygwin notation for "C." is different (/cygdrive/c or
# c:/ vs. /c/)

#Alternatively, add all directories having a dll-file
#  for F in $(find c:/cygwin64/ -iname "*.dll"); do dirname $F; done | uniq

#=========================================================================
# last but least - MAGIC!: 
#=========================================================================
#If interactive shell is starting, try to cd to the same
# directory that the last bash cd:d into
if [ -t0 ]; then
	if [ -f ~/.bash_lastdir ]; then
		pushd $(cat ~/.bash_lastdir)
	fi

	#If no X-server is running, start one in a screen (Cygwin only)
	if	[ "X$(uname -a | grep -i CYGWIN)" != "X" ] && \
		[ "X$(ps -l | grep XWin)" == "X" ]
	then
		echo "Starting XWin"
		if	[ "X$(screen -ls | grep XWin)" != "X" ]; then
			echo "Stale XWin screen-session detected. Wiping this first..."
			screen -wipe XWin
		fi
		screen -dmS XWin XWin :0 -clipboard -multiwindow
	else if [ "X${DISPLAY}" == "X" ]; then
		export DISPLAY=:0.0
	fi fi


	#If not already in a screen-session, start one
	if [ "X$(grep screen <<< ${TERM})" == "X" ]; then
		screen
	fi

#	#If not already in a TMUX-session, start one
#	if [ "X$(grep screen <<< ${TERM})" == "X" ] && \
#		[ "X$TMUX" == "X" ]; then
#		tmux
#	fi
fi

