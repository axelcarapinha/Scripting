#!/bin/bash

DOWNLOADS_DIR=~/Downloads
REPO_DIR=~/Desktop/CTFs
REPO_URL=git@github.com:axelcarapinha/CTFs.git
TARGET_FILE_NAME="HTB Academy Student Transcript"

# Opens Firefox to download the file (requires the HTB Academy user to be logged in)
# It's the URL used by the GET request from HTB's website,
# can be seen by using the browser's Dev Tools pannel (Ctrl + Shift + I)
firefox -new-window "https://academy.hackthebox.com/account/transcript?nameIdentifier=name"

# Prepare the repo where the file will be stored
if [ -d "$REPO_DIR" ]; then
  echo "Repository directory already exists."
else
  git clone "$REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR"

# Wait for the file to be dwnloaded
sleep 3

# Find the most recent HTB transcript file
TARGET_FILE=$(ls -t "$DOWNLOADS_DIR" | grep "$TARGET_FILE_NAME" | head -n 1)

# Check if the file was found
if [ -n "$TARGET_FILE" ]; then # grep will leave it empty in case it does NOT exist
  mv "$DOWNLOADS_DIR/$TARGET_FILE" "$REPO_DIR/01_HTB-files/HTB-Academy_Transcript.pdf" || {
    echo "Failed to move file to repository directory."
    exit 1
  }
else
  echo "No transcript file found in the Downloads directory."
  exit 2
fi

# Add the changes to GitHub
git add .
git commit -m "[SCRIPT'S COMMIT] New certification!"
git push -u 
