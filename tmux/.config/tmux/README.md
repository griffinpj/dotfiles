# tmux config

Personal tmux setup. `tmux.conf` is symlinked to `~/.config/tmux/tmux.conf`.

- tmux 3.5a, macOS
- Prefix: `C-b` (default)
- Theme: Catppuccin (mocha)
- Plugin manager: TPM at `~/.tmux/plugins/`

## Dependencies

```sh
# plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# session switcher stack
brew install sesh fzf zoxide
```

Then start tmux and run `<prefix> I` to install plugins (or
`~/.tmux/plugins/tpm/bin/install_plugins`).

## Plugins

| Plugin | Purpose |
| --- | --- |
| `catppuccin/tmux` | Status bar theme (mocha flavor) |
| `christoomey/vim-tmux-navigator` | Seamless `C-h/j/k/l` nav across nvim splits + tmux panes |
| `tmux-plugins/tmux-yank` | Clipboard yank (no `reattach-to-user-namespace` needed) |
| `MunifTanjim/tmux-mode-indicator` | Mode prompt in status-right (`TMUX`/`WAIT`/`COPY`/`SYNC`) |
| `omerxx/tmux-floax` | Floating scratch pane |
| `sainnhe/tmux-fzf` | Fuzzy find sessions/windows/panes |

## Keybindings

All prefixed with `C-b` unless marked `(no prefix)`.

### Panes
| Key | Action |
| --- | --- |
| `Left` / `Right` | Split horizontal (inherits current dir) |
| `Up` / `Down` | Split vertical (inherits current dir) |
| `h` `j` `k` `l` | Select pane (left/down/up/right) |
| `H` `J` `K` `L` | Resize pane (repeatable) |
| `<` / `>` | Swap pane up/down |
| `C-h/j/k/l` (no prefix) | Move across nvim ↔ tmux (vim-tmux-navigator) |

### Copy mode (vi)
| Key | Action |
| --- | --- |
| `v` | Enter copy mode |
| `v` (in copy mode) | Begin selection |
| `y` (in copy mode) | Yank to system clipboard (`pbcopy`) |

### Misc
| Key | Action |
| --- | --- |
| `s` | Session switcher (sesh + fzf) |
| `r` | Reload config |

## Notable settings

- `escape-time 10` — kills ESC lag in nvim
- `focus-events on` — nvim autoread / focus events
- `terminal-overrides ",*256col*:Tc"` — true color
- `mouse on`
- `base-index 1`, `pane-base-index 1`, `renumber-windows on`
- `history-limit 50000`

## Not enabled (optional)

- `tmux-resurrect` + `tmux-continuum` — save/restore sessions across reboot
- Prefix remap (kept default `C-b`)
