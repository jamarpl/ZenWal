# Zen Browser CSS Reference

## CSS variables — set these

These are the root variables you configure in `:root`. Setting these cascades through the entire UI.

| Variable | What it controls | Default (dark) |
|---|---|---|
| `--zen-primary-color` | Accent color — tab highlights, buttons, focus rings | `AccentColor` (system) |
| `--zen-branding-dark` | Base dark background color | `#101010` |
| `--zen-branding-paper` | Base light background color | `#e2e2e2` |
| `--zen-main-browser-background` | Main sidebar/background fill | `#1b1b1b` |
| `--zen-main-browser-background-toolbar` | Toolbar area fill | same as above |
| `--zen-navigator-toolbox-background` | Sidebar shell background | `transparent` |
| `--zen-themed-toolbar-bg-transparent` | Top app wrapper background | `#171717` |
| `--arrowpanel-background` | Dropdown/popup menus background | — |
| `--arrowpanel-color` | Dropdown/popup menus text color | — |
| `--arrowpanel-border-color` | Dropdown/popup menus border | — |
| `--tab-selected-bgcolor` | Selected tab background | — |
| `--tab-hover-background-color` | Hovered tab background | — |
| `--toolbar-bgcolor` | Toolbar background | semi-transparent |
| `--zen-dialog-background` | Dialog/modal backgrounds | `#1c1c1c` |
| `--zen-urlbar-background` | URL bar background | — |
| `--zen-border-radius` | Global border radius | `7px` |

---

## CSS variables — computed (read-only)

These are derived automatically. Don't set them — they'll be overwritten.

| Variable | How it's computed |
|---|---|
| `--zen-colors-primary` | `--zen-primary-color` mixed 20% into branding bg |
| `--zen-colors-secondary` | `--zen-colors-primary` mixed 30% into branding bg |
| `--zen-colors-tertiary` | `--zen-primary-color` mixed 1% into branding bg (near-bg) |
| `--zen-colors-border` | `--zen-colors-secondary` mixed 20% into grey |
| `--zen-colors-hover-bg` | `--zen-primary-color` mixed 90% into branding bg |
| `--zen-urlbar-background` | `--zen-primary-color` mixed 4% into dark grey |
| `--zen-dialog-background` | `#1c1c1c` (dark) |

---

## Element selectors

These elements require direct `background` overrides — the variable alone isn't enough because Zen's JS engine or platform media queries override the variable at runtime.

| Selector | What it is | Notes |
|---|---|---|
| `#navigator-toolbox` | Entire left sidebar shell | Uses `--zen-navigator-toolbox-background` |
| `#nav-bar` | Navigation toolbar (URL bar row) | — |
| `#zen-main-app-wrapper` | Wrapper around the top toolbar area | Set `background` directly — overridden by platform media queries |
| `.zen-browser-generic-background` | Background layer behind sidebar and content | — |
| `.zen-browser-generic-background::after` | Where `--zen-main-browser-background` is painted | Set directly to override JS inline styles |
| `.zen-browser-generic-background::before` | Previous background (used during transitions) | Set directly alongside `::after` |
| `.zen-toolbar-background` | Top toolbar background in compact mode | Hardcoded color, must be set directly |
| `#tabbrowser-tabpanels` | Tab content area | — |
| `#sidebar-box` | Browser sidebar panel | — |
| `.tabbrowser-tab[selected] .tab-background` | Selected tab | — |
| `.tabbrowser-tab:hover .tab-background` | Hovered tab | — |

---

## Working userChrome.css template

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
