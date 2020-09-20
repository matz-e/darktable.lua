# Personal Darktable scripts

Some stuff that made managing my pictures easier.

## Installation

It is easiest to symlink the tags into the Darktable lua library directory,
.e.g:

    $ mkdir -p ~/.config/darktable/lua
    $ ln -s $PWD/pseudo-geotags.lua ~/.config/darktable/lua

Following this, add `require "pseudo-geotags"` in
`~/.config/darktable/luarc`, change as appropriate per script.
