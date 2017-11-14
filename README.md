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

### Cloning with sub-modules (git modules) in one go:

### Prerequisite:

To avoid "hard-coding" remote-names of submodules, a *symbolic name* is
used instead: `ssh://dot_siterepo/`. (see `.gitmodules` in this directory)

Remap this *symbolic name* in `~/.gitconfig` to fit the server hosting for
the submodules.

For official Github repository:

```
[url "https://github.com/helsinova/"]
    insteadOf = ssh://dot_siterepo/

```


Typical Gerrit hosting:

```
[url "ssh://account@server:29418/pathname/"]
    insteadOf = ssh://dot_siterepo/

[url "ssh://account@review_server:29418/pathname/"]
    pushInsteadOf = ssh://dot_siterepo/
    pushInsteadOf = ssh://account@server:29418/pathname/

```

