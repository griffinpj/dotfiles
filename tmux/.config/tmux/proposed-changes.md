# Proposed changes — tmux config

Backlog from an audit on 2026-07-27. **Nothing here is applied yet.**
`tmux.conf` is untouched; this file is notes only.

Audit was verified empirically against a live tmux server (spun up a throwaway
session, queried `list-keys` / `show -g`, killed it) — not read off the config by eye.

Environment at audit time: tmux 3.5a, macOS (Darwin 25.5), Ghostty
(`TERM=xterm-ghostty`, `COLORTERM=truecolor`), catppuccin mocha, TPM.

---

## Bugs

### 1. `terminal-overrides ",*256col*:Tc"` is dead code
`tmux.conf:12`. The pattern in `terminal-overrides` is matched against the
**outer** terminal's `TERM`, which here is `xterm-ghostty` — it never matches
`*256col*`. Truecolor currently works anyway, but only because tmux 3.2+
auto-detects `COLORTERM=truecolor`. The line contributes nothing and misleads
anyone reading the config.

### 2. `last-window` is unbound
`bind l select-pane -R` (`tmux.conf:61`) clobbered tmux's default `l` =
`last-window`. Verified: `list-keys -T prefix` shows no `last-window` at all.
Only `;` (`last-pane`) survives. There is currently no way to toggle between
two windows.

### 3. `previous-window` is unbound
tmux-floax claims `p` at load time (`@floax-bind` default is `p`), overriding
default `p` = `previous-window`. Only `M-p` (`previous-window -a`, which skips
to the previous *alert*, not the previous window) remains.

### 4. `allow-passthrough off`
Default is off. Blocks the kitty graphics protocol, so `image.nvim` and any
other in-terminal image rendering silently fails inside tmux. Ghostty supports
the protocol natively.

### 5. `-r` (repeat) flag on the four split bindings
`tmux.conf:52-55`. `-r` lets the key repeat without re-pressing the prefix.
Splitting is not a repeatable operation — holding an arrow after the prefix
produces a cascade of splits.

### 6. `detach-on-destroy on`
Default is on. Killing a session detaches the client from tmux entirely instead
of falling through to another live session. Actively bad with a sesh-driven
workflow, where hopping between many sessions is the point.

---

## Gaps

- **No undercurl support.** Missing the `usstyle` terminal feature, so nvim
  diagnostic undercurls render as flat underlines and lose their color.
- **Manual `y` bind shadows tmux-yank.** `tmux.conf:24` pipes to `pbcopy`
  directly. Fine locally; over SSH it breaks, because there is no OSC 52
  fallback. tmux-yank handles both cases and is already installed — the manual
  bind makes half the plugin redundant.
- **`status-interval 60`.** Harmless with the current status bar (session name +
  mode indicator), but it blocks ever adding a clock, battery, or CPU widget —
  those would sit up to 60s stale.
- **catppuccin is unpinned.** `set -g @plugin 'catppuccin/tmux'` tracks the
  default branch. The v1→v2 bump was a breaking change to status config, and
  this config already uses v2 syntax (`#{E:@catppuccin_status_session}`). One
  `<prefix> U` away from a broken status bar.
- **No `aggressive-resize`.** Pane sizing goes wrong when a second client
  attaches to the same session at a different terminal size.

---

## Proposed edits

### A. Terminal correctness
Replaces `tmux.conf:12`.

```tmux
set -sa terminal-features ",*:RGB"       # truecolor, matches any outer TERM
set -sa terminal-features ",*:usstyle"   # undercurl + colored underlines (nvim)
set -g  allow-passthrough on             # kitty graphics protocol / image.nvim
setw -g aggressive-resize on             # correct sizing with multiple clients
```

`terminal-features` (tmux 3.2+) is the modern replacement for
`terminal-overrides` and the `*` pattern sidesteps the outer-`TERM` matching
problem in bug #1 entirely.

### B. Recover the lost bindings
Fixes bugs #2 and #3.

```tmux
bind Tab last-window            # recovers what `bind l select-pane -R` ate
set -g @floax-bind 'C-f'        # move floax off `p`, restoring previous-window
```

Setting `@floax-bind` is the better fix for #3 than re-binding `previous-window`
onto some third key — it gives the default back rather than papering over it.
Must appear **before** the `run '~/.tmux/plugins/tpm/tpm'` line to take effect.

### C. Behavior fixes
Fixes bugs #5, #6 and two gaps.

```tmux
set -g detach-on-destroy off    # fall through to another session, don't exit
set -g status-interval 5        # unblocks dynamic status widgets
set -g display-time 2000        # 750ms default is too fast to read
```

Plus two deletions:
- Drop the `-r` from the four split bindings (`tmux.conf:52-55`).
- Delete the manual `copy-mode-vi` `y` binding (`tmux.conf:24`) and let
  tmux-yank own the clipboard, so OSC 52 works over SSH.

### D. Pin catppuccin

```tmux
set -g @plugin 'catppuccin/tmux#v2.1.3'
```

Confirm `v2.1.3` is still the current tag before applying.

---

## Plugins worth adding

| Plugin | Why | Verdict |
| --- | --- | --- |
| `fcsonline/tmux-thumbs` | Vimium-style hint labels over every path, hash, URL, and IP on screen; one keypress copies it. Rust, instant. Biggest daily-driver win available. | **strongest rec** |
| `tmux-plugins/tmux-resurrect` + `tmux-continuum` | Survive reboots. Already flagged optional in the README. With the nvim strategy enabled it restores buffers too. | **yes** |
| `tmux-plugins/tmux-open` | In copy mode, `o` opens the URL/file under the cursor, `C-o` opens it in `$EDITOR`. Tiny; pairs well with thumbs. | cheap yes |
| lazygit popup (no plugin) | One line, zero dependencies beyond lazygit itself. | **yes, free** |
| `laktak/extrakto` | fzf over scrollback tokens. Overlaps thumbs — thumbs is faster, extrakto is fuzzier. | pick one, not both |
| `alexwforsythe/tmux-which-key` | Popup menu of all bindings. Discoverability for a config this heavily customized. | maybe |
| `wfxr/tmux-fzf-url` | fzf over every URL in scrollback. Strict subset of thumbs. | skip if thumbs |

The lazygit popup, in full:

```tmux
bind g display-popup -E -w 90% -h 90% -d "#{pane_current_path}" lazygit
```

Note `bind g` is currently free, but check `list-keys -T prefix | awk '$4=="g"'`
before committing to it — plugin bindings shift as plugins are added.

---

## Open questions

- Which of thumbs vs extrakto to adopt (they overlap).
- Whether to lower `status-interval` to 5 at all, or leave it at 60 until there
  is actually a dynamic widget in the status bar to justify it.
- `tmux-resurrect` needs its nvim strategy opted into explicitly
  (`set -g @resurrect-strategy-nvim 'session'`) and depends on nvim session
  files existing — verify that before assuming buffers come back.

## When applying

1. Back up `tmux.conf` first.
2. Apply A–D, then `<prefix> r` to reload and re-check with
   `tmux list-keys -T prefix` that nothing else got clobbered.
3. Add plugins, then `<prefix> I` to install.
4. Update `README.md` — its keybinding tables and "Not enabled (optional)"
   section will both be stale.
