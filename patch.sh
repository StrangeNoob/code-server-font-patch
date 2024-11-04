#!/bin/bash

# Determine code-server path
if [ -z "$1" ]; then
  CODE_SERVER_PATH="/app/code-server"
else
  CODE_SERVER_PATH="$1"
fi

# Define paths
WORKBENCH_PATH="$CODE_SERVER_PATH/lib/vscode/out/vs/workbench"
HTML_TEMPLATE_PATH="$CODE_SERVER_PATH/lib/vscode/out/vs/code/browser/workbench/workbench.html"

CUSTOM_FONTS_CSS="./resources/custom-font.css"

# Validate code-server path
if [ ! -d "$WORKBENCH_PATH" ]; then
  echo "Invalid code-server path: $CODE_SERVER_PATH"
  exit 1
fi

# Check if custom fonts are already included
if ! grep -q "/* ::CUSTOM VSCODE FONTS:: */" "$HTML_TEMPLATE_PATH"; then
  # Copy fonts to workbench directory
  cp --recursive --update=none ./resources/fonts "$WORKBENCH_PATH/"

  awk -v css="$(cat "$CUSTOM_FONTS_CSS")" '
    /<\/head>/ {
      print "<style>"
      print "/* ::CUSTOM VSCODE FONTS:: */"
      print css
      print "</style>"
    }
    { print }
  ' "$HTML_TEMPLATE_PATH" > "${HTML_TEMPLATE_PATH}.tmp" && mv "${HTML_TEMPLATE_PATH}.tmp" "$HTML_TEMPLATE_PATH"
fi

echo "Custom fonts have been integrated successfully."


