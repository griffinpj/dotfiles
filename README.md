# Dotfiles

## Introduction

These dotfiles are managed with `stow`. More information about stow can be found [here](https://www.gnu.org/software/stow/).

The structure is as follows,

```
.
├── README.md
├── fish
│   └── .config
│       └── fish
│           ├──  config.fish
│           └── ... 
├── gh
│   └── .config
│       └── gh
│           └── ... 
├── kitty
│   └── .config
│       └── kitty
│           ├── kitty.conf
│           └── ...
├── lazygit
│   └── .config
│       └── lazygit
│           └── ... 
├── nvim
│   └── .config
│       └── nvim
│           ├── init.lua
│           ├── ... 
│           └── lua
│               ├── config
│               │   └── ...
│               ├── core
│               │   └── ...
│               ├── helpers
│               │   └── ...
│               └── plugins
│                   └── ...
├── scripts
│   └── .local
│       └── scripts
│           └── ... 
├── skhd
│   └── .config
│       └── skhd
│           └── skhdrc
├── tmux
│   └── .config
│       └── tmux
│           └── tmux.conf
└── yabai
    └── .config
        └── yabai
            └── yabairc
```

First clone the dotfiles repo into your `~/` directory and `cd` into the new direcotry.


You can then run `stow` on a top level folder within the dotfiles repository e.g `stow nvim`. This will create a link to `~/.config/nvim` for us. 
You may repeat this step on other folders that you wish to include in your local configuration.


