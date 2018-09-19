# DOT

This is the root repository for DOT.

Start by initializing including git modules

## What is this

DOT is a repository to help manage all your dot-files across machines but
still easily manage & keep them in sync with each other.

To help you start, the repository contains `gold-standard` configurations.

* Linux
* Cygwin (Windows)

..and helper scripts.

## Background (why's)

I created this "system" mainly to keep my (Vim-)plugins,
(terminal/screen)shout-cuts & settings manageable across the various
machines I worked with on a daily basis as I've come to care less about
which host OS I work with, as long as it's "*NIXy" enough.

Even though radically different, I still wanted **not** to have to think
about all the quirks and different short-cuts across various window-systems
and OS:es.

------------------------------------------------

### Cloning and installing the project

Cloning is instaling. The project is using gitmodues of itself but of other
branches. The *gold standard* branches (`Linux`and `Cygwin`) and possibly
your own which are  derived from either of the above and named according to
your username (this will be  changed into `user@host` in future).

All this may sound very complicated, but there's a script helping you.
All you have to do is to *not clone the normal way* suggested by github, but
follow the subsections below. 

### Prerequisite:

To avoid "hard-coding" remote-names of submodules in the helper-scripts, a 
*symbolic name* is used instead: `ssh://dot_siterepo/`.
(see `.gitmodules` in this directory).

*The symbolic remote concept is also very useful when you want to store your own
dot-files, which for natural reasons should never be pushed to a public repository
like gitgub. I.e. when you're done cloning and running the helper-scripts once,
remap the remote to somewhere else and push changes there instead.*

Remap the *symbolic name* in your `~/.gitconfig` to fit the server hosting for
the submodules.

* For public Github repository:

```
[url "https://github.com/helsinova/"]
    insteadOf = ssh://dot_siterepo/
```

* If you're an official member of the project:

```
[url "ssh://git@github.com/helsinova/"]
    insteadOf = ssh://dot_siterepo/
```

#### Example remaps whence initial insall is done

* Typical Gerrit hosting:

```
[url "ssh://account@server:29418/pathname/"]
    insteadOf = ssh://dot_siterepo/

[url "ssh://account@review_server:29418/pathname/"]
    pushInsteadOf = ssh://dot_siterepo/
    pushInsteadOf = ssh://account@server:29418/pathname/
```

### Clone all in one go

Now youre ready to clone the project. Below you will clone with submodules but
from *root-branch* which doesn't have any submodules of actual dot-configs yet,
but it has the wiki which is another submodule.

* `git clone --recursive ssh://dot_siterepo/DOT.git`

### Installing (using scripts)

The procetude below will:

* Checkout a dot-file branch of a *golds-standard based* on your hos
* Branch it, using the *naming convention* mentioned
* Install all the dot-files in this branch oont your system 
  * **but** save your current one in a backup directory in case you need some things back

* **Note** that all installed dot-files are in the form of **links**. This is a nifty feature which
enables having your *clone* in a synchonizable directory (i.e. *Dropbox* e.t.c.) which in turns makes
it easier to prune & branch several mashines dot-configs from one installation into another.

```bash
cd DOT
bin/dot_clone.sh 
bin/dot_mklinks.sh
```

Verify installation:

* `git branch`

This should be your `$HOSTNAME`

* `ls -al`

You should see a new directory named `user@host`. This is a submodule which you can also now verify
in the .gitmodues file.

* `ls -al ~`

Youo should see links of dot-files pointing int into youor DOT directory.

## Finalization

* Remember to change the symbolic remote as mentioned above
* Exit your current session and log in again and you should be good to go

### Tweaks

The installation process (scripts) has a bug as of writing. It doesn't sync the submodules for `Vim` 
Look in the .gitmodules and verify. If the error persists do as follows:

```bash
git submodule init
git submodule sync
git submodule update
```



