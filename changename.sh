#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: sh changename.sh <nameold> <namenew>"
  exit 1
fi

nameold="$1"
namenew="$2"

while IFS= read -r folder || [[ -n "$folder" ]]; do
  if [ -d "$folder" ]; then
    echo "Processing folder: $folder"
    find "$folder" -type f -print0 | xargs -0 sed -i "s/$nameold/$namenew/g"
  else
    echo "Folder not found: $folder"
  fi
done < "folderlist.txt"

echo "String replacement completed."