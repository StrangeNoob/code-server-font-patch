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
STYLE_HTML_PATH="./resources/style.html"

# Validate code-server path
if [ ! -d "$WORKBENCH_PATH" ]; then
  echo "Invalid code-server path: $CODE_SERVER_PATH"
  exit 1
fi

# Check if custom fonts are already included
if ! grep -q "/* ::CUSTOM VSCODE FONTS:: */" "$HTML_TEMPLATE_PATH"; then
  # Copy fonts to workbench directory
  cp --recursive --update=none ./resources/fonts "$WORKBENCH_PATH/"

  # Append style.html content to the HTML template
  sed -i '/<\/head>/i <link rel="stylesheet" type="text/css" href="./resources/style.html">' "$HTML_TEMPLATE_PATH"
fi

echo "Custom fonts have been integrated successfully."


