# nvim

Lua setup for nvim built on lazy.nvim


## What the heck is this ?!?! How do I use ?!?

Some people may not know where to start when diving into this majestic configuration. 
This readme shall be your lighthouse. A beacon of hope in the dark stormy waters that is the developer experience. 

## The CONFIG

Now let's start at,

### The Basics

Many key combos use the `<leader>` key. For our config, the `<leader>` key is defined
as the `<space>` key.

The clipboard within each instance of vim is contained. Meaning if you yank `y`
something in nvim, you will not be able to paste it with `CTL + v` in other 
running programs. You will only be able to paste it into your existing vim 
instance with `p`.

#### Requirements

- lazygit
- ripgrep
- npm

#### Core Remaps

`jk` -> Alias to exit insert mode (Think ESC)

`<leader>y` -> Yank to system clipboard (Allows to paste elsewhere w/ `CTL + v`)

`<leader>Y` -> Yank until end of line to system clipboard (Allows to paste elsewhere w/ `CTL + v`)

`<leader>p` -> Paste with buffer preservation. Normally pasting over highlight 
results in highlighted portion overriding current paste buffer. 

#### Navigation
> telescope.nvim offers a modal with fuzzy match for files and file contents

`<leader>pf` -> Fuzzy find project files (files in CWD)

`CTL + p` -> Fuzzy find all git files

`<leader>pv` -> Navigate to netrw page for active file's directory

`<leader>ps` -> Live grep to search within files (don't forget to escape necessary characters)

##### Navigating search results
> Within a telescope search, you can use nvim shortcuts to navigate the modal.

`CTL + u` -> Scroll up in preview window

`CTL + d` -> Scroll down in preview window

`CTL + n` -> Next search result (any mode)

`CTL + p` -> Previous search result (any mode)

`CTL + c` -> Close telescope (insert mode)

`ESC` -> Close telescope (normal mode)

`jk` -> Enter normal mode within the modal

> While in normal mode in the telescope modal,

- `h` and `l` will allow for navigation on the search line
- `j` and `k` will allow for navigation within search results
- Other vim commands will work on the search line while in this mode within
telescope

##### Opening search results
> While selecting a telescope search result, you have various options on how to open the result.

`CTL + v` -> Opens the selection in a veritcal pane in the current buffer

`CTL + x` -> Opens the selection in a horizontal pane in the current buffer

`CTL + t` -> Opens the selection in a new tab

##### Harpoon

> Harpoon is used for fast context switching between files. These mappings can be changed easily in `./after/plugin/harpoon.lua`.

`CTL + e` -> Open harpoon window
    - Can edit like any nvim buffer

`<leader>a` -> Add current file to harpoon list

`CTL + h|t|n|s` -> Will jump to the first 1st, 2nd, 3rd and 4th files in your harpoon list

#### LSP

> Most important shortcuts to know for using the LSP. More details in `./after/plugin/lsp.lua`

`:Mason` -> Command to open Mason language server modal
    - You can browse other language servers, and install with `i`

`gd` -> While your cursour is over any text object will attempt to go to the definition
    - Could be a variable definition, source file, etc...

`K` -> While your cursour is over any text object will show symbol information

`<leader>vrn` -> While your cursor is over any symbol, rename that symbol

`<leader>vrr` -> While your cursor is over any symbol, show symbol references

`<leader>f` -> LSP Format file

##### Autocompletion

`CTL + y` -> Select autocomplete suggestions

`CTL + <space>` -> Complete autocomplete suggestion

`CTL + n` -> Next autocomplete suggestion

`CTL + p` -> Previous autocomplete suggestion


