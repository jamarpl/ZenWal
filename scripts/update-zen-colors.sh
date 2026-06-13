#!/usr/bin/env bash
# Reads pywal colors and updates Zen's userChrome.css

COLORS=~/.cache/wal/colors
CHROME="/home/jamar/.config/zen/mfbp1jn9.Default (release)-2/chrome/userChrome.css"

# Read colors by line
color0=$(sed -n '1p' "$COLORS")
color4=$(sed -n '5p' "$COLORS")
color7=$(sed -n '8p' "$COLORS")
color8=$(sed -n '9p' "$COLORS")

cat > "$CHROME" <<EOF
:root {
  --zen-primary-color:                    $color4 !important;
  --zen-branding-dark:                    $color0 !important;
  --zen-branding-paper:                   $color7 !important;
  --zen-main-browser-background:          $color0 !important;
  --zen-main-browser-background-toolbar:  $color0 !important;
  --zen-navigator-toolbox-background:     $color0 !important;
  --toolbar-bgcolor:                       $color0 !important;
  --zen-themed-toolbar-bg-transparent:     $color0 !important;
  --arrowpanel-background:                 $color0 !important;
  --arrowpanel-color:                      $color7 !important;
  --arrowpanel-border-color:               $color8 !important;
}

.zen-toolbar-background,
#zen-main-app-wrapper {
  background: $color0 !important;
}

.zen-browser-generic-background::after,
.zen-browser-generic-background::before {
  background: $color0 !important;
}
EOF

echo "Zen colors updated."
