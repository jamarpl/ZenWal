# Zen Browser Custom CSS Guide

## How Zen loads userChrome.css

Zen (like Firefox) loads `userChrome.css` from the **active profile's** `chrome/` directory.
The active profile is determined by `~/.config/zen/profiles.ini`.

### Finding the active profile

```
cat ~/.config/zen/profiles.ini
```

Look for the `[InstallXXXXXXXX]` block that matches your running instance — its `Default=` line
names the active profile directory. Example:

```ini
[Install15B76BAA26BA15E7]
Default=mfbp1jn9.Default (release)-2
```

So the file to edit is:
```
~/.config/zen/mfbp1jn9.Default (release)-2/chrome/userChrome.css
```

### Enabling userChrome.css

The pref must be set. Add this to the profile's `user.js` (create it if it doesn't exist):

```js
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
```

This gets written into `prefs.js` on next startup. You can confirm it took effect by checking:
```
grep legacyUserProfile ~/.config/zen/<profile>/prefs.js
```

---

## How Zen's theme system works

Zen derives almost all colors from a small set of root variables. Setting these cascades through
the entire UI automatically — you don't need to target every component individually.

### The variables that actually matter

| Variable | What it controls | Default (dark) |
|---|---|---|
| `--zen-primary-color` | Accent color — tab highlights, buttons, focus rings | `AccentColor` (system) |
| `--zen-branding-dark` | Base dark background color | `#101010` |
| `--zen-branding-paper` | Base light background color | `#e2e2e2` |
| `--zen-main-browser-background` | Main sidebar/background fill | `#1b1b1b` |
| `--zen-main-browser-background-toolbar` | Toolbar area fill | same as above |
| `--zen-navigator-toolbox-background` | Sidebar shell background | `transparent` |
| `--zen-themed-toolbar-bg-transparent` | Top app wrapper background | `#171717` |

**Important:** Some of these variables get overridden by Zen's JS theme engine via inline styles,
or by platform-specific media queries (e.g. Linux transparency). In those cases, setting the
variable on `:root` is not enough — you must also target the element directly. See the element
selectors section below.

### Variables derived automatically

These are computed — shown here so you know what exists, not what to set:

| Variable | How it's computed |
|---|---|
| `--zen-colors-primary` | `--zen-primary-color` mixed 20% into branding bg |
| `--zen-colors-secondary` | `--zen-colors-primary` mixed 30% into branding bg |
| `--zen-colors-tertiary` | `--zen-primary-color` mixed 1% into branding bg (near-bg) |
| `--zen-colors-border` | `--zen-colors-secondary` mixed 20% into grey |
| `--zen-colors-hover-bg` | `--zen-primary-color` mixed 90% into branding bg |
| `--zen-urlbar-background` | `--zen-primary-color` mixed 4% into dark grey |
| `--zen-dialog-background` | `#1c1c1c` (dark) |

### Other overrideable variables

These are not derived — you can set them directly if needed:

| Variable | What it controls |
|---|---|
| `--arrowpanel-background` | Dropdown/popup menus background |
| `--arrowpanel-color` | Dropdown/popup menus text color |
| `--arrowpanel-border-color` | Dropdown/popup menus border |
| `--tab-selected-bgcolor` | Selected tab background |
| `--tab-hover-background-color` | Hovered tab background |
| `--toolbar-bgcolor` | Toolbar background (semi-transparent by default) |
| `--zen-dialog-background` | Dialog/modal backgrounds |
| `--zen-urlbar-background` | URL bar background |
| `--zen-border-radius` | Global border radius (default 7px) |

---

## Key element selectors

These are the actual elements in Zen's chrome, sourced from `omni.ja`.
Where noted, the background must be set directly on the element rather than via a variable.

| Selector | What it is | Notes |
|---|---|---|
| `#navigator-toolbox` | The entire left sidebar shell | Uses `--zen-navigator-toolbox-background` |
| `#nav-bar` | The navigation toolbar (URL bar row) | |
| `#zen-main-app-wrapper` | Wrapper around the top toolbar area | Background must be set directly — overridden by platform media queries |
| `.zen-browser-generic-background` | Background layer behind sidebar and content | |
| `.zen-browser-generic-background::after` | Where `--zen-main-browser-background` is painted | Set directly to override JS inline styles |
| `.zen-browser-generic-background::before` | Previous background (used during transitions) | Set directly alongside `::after` |
| `.zen-toolbar-background` | Top toolbar background in compact mode | Hardcoded color, must be set directly |
| `#tabbrowser-tabpanels` | The tab content area | |
| `#sidebar-box` | The browser sidebar panel | |
| `.tabbrowser-tab[selected] .tab-background` | Selected tab | |
| `.tabbrowser-tab:hover .tab-background` | Hovered tab | |

---

## Working userChrome.css

```css
:root {
  --zen-primary-color:                    <color4> !important;
  --zen-branding-dark:                    <color0> !important;
  --zen-branding-paper:                   <color7> !important;
  --zen-main-browser-background:          <color0> !important;
  --zen-main-browser-background-toolbar:  <color0> !important;
  --zen-navigator-toolbox-background:     <color0> !important;
  --toolbar-bgcolor:                       <color0> !important;
  --zen-themed-toolbar-bg-transparent:     <color0> !important;
  --arrowpanel-background:                 <color0> !important;
  --arrowpanel-color:                      <color7> !important;
  --arrowpanel-border-color:               <color8> !important;
}

.zen-toolbar-background,
#zen-main-app-wrapper {
  background: <color0> !important;
}

.zen-browser-generic-background::after,
.zen-browser-generic-background::before {
  background: <color0> !important;
}
```

Pywal color mapping:

| Variable | Pywal color | Description |
|---|---|---|
| `--zen-primary-color` | `color4` (line 5) | Muted accent |
| `--zen-branding-dark` | `color0` (line 1) | Background |
| `--zen-branding-paper` | `color7` (line 8) | Foreground/text |
| `--arrowpanel-border-color` | `color8` (line 9) | Warm grey border |

---

## Automatic pywal sync

Colors are synced automatically every time you run `wal` using a postrun hook.

### The script

`~/dotfiles/zen/scripts/update-zen-colors.sh` reads `~/.cache/wal/colors` and rewrites
`userChrome.css` with the new palette:

```bash
COLORS=~/.cache/wal/colors

color0=$(sed -n '1p' "$COLORS")   # background
color4=$(sed -n '5p' "$COLORS")   # accent
color7=$(sed -n '8p' "$COLORS")   # foreground
color8=$(sed -n '9p' "$COLORS")   # border
```

Run it manually at any time:
```
~/dotfiles/zen/scripts/update-zen-colors.sh
```

### The hook

`~/.config/wal/postrun` is executed by pywal after every `wal` run:

```bash
#!/usr/bin/env bash
~/dotfiles/zen/scripts/update-zen-colors.sh
```

After `wal` runs, `userChrome.css` is updated automatically. Restart Zen to apply the new colors.

---

## Debugging tips

- **Confirm the file loads**: replace all CSS with `#navigator-toolbox { background: red !important; }` and restart.
  If you see red, the file is loading. If not, check the profile path and the pref.

- **Inspect variables**: open the Browser Toolbox (`Ctrl+Alt+Shift+I`), go to Inspector,
  find `:root`, and check the computed CSS variables to see what Zen has set and what you're overriding.

- **Why `!important` is needed**: Zen's JS theme engine sets some variables via inline styles
  at runtime, which beats normal `:root` declarations. `!important` on the variable definition
  forces the override. For some elements (notably `#zen-main-app-wrapper` and
  `.zen-browser-generic-background::after`), the variable itself gets overridden — in those cases
  you must set `background` directly on the element.

- **Extracting Zen's source CSS**: Zen's internal stylesheets are bundled in
  `/opt/zen-browser-bin/browser/omni.ja` (a zip file). Extract with:
  ```
  mkdir -p ~/.config/zen/omni-extracted
  cd ~/.config/zen/omni-extracted
  unzip /opt/zen-browser-bin/browser/omni.ja
  ```
  Theme-related CSS lives in:
  `chrome/browser/content/browser/zen-styles/`
