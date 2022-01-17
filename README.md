# My Dotfiles

## dotfiles
Making it easier to setup new machine!

## install

### Step 1: Pre requisities
Open Terminal, pre-install things:

1. Make sure `brew` is installed (`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"` or check [Brew website](https://brew.sh/) for the command)
1. Make sure `git` is installed (should be, but might need to update `brew install git`

### Step 2: SSH setup
If availabe, copy existing SSH keys from old machine. You will need to update the permissions once copied. (If setting up computer for same enterprise)
`sudo chmod 400 ~/.ssh/id_rsa`
`sudo chmod 600 ~/.ssh/id_rsa`
`sudo chmod 644 ~/.ssh/known_hosts`

Else, generate new keys and add them to GitHub

### Step 3: Clone this repo and run
Run this:

```sh
git clone git@github.com:karunabaral/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

Then:

1. Restart computer.
1. Open iTerm2. On Preferences > Profiles > Default (already selected) > General > Command, enter `/bin/zsh`

Now whenever you open iTerm2, it will run `zsh`.

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## what's inside

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you.
[Fork it](https://github.com/karunabaral/dotfiles/fork), remove what you don't
use, and build on what you do use.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **Brewfile**: This is a list of applications for [Homebrew Cask](http://caskroom.io) to install: things like Chrome and 1Password and stuff. Might want to edit this file before running any initial setup.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/install.sh**: Any file named `install.sh` is executed when you run `script/install`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.