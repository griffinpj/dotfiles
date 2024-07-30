#!/bin/bash

# Get the contents of the clipboard
message=$(pbpaste)

# Check if the message is empty
if [ -z "$message" ]; then
  echo "No text found in clipboard"
  exit 1
fi

# Run the git commit command with the message
git commit -m "$message"
