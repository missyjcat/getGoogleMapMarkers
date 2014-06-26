#!/bin/sh

usage="$(basename "$0") [-h] [path] -- downloads 9 colors of Google Map markers from A-Z and no-letter (dot) to the desired [path]. Defaults to pwd if no path given, and creates directory if given path does not exist.

where:
  -h show this help text
  [path] where to download the markers"

while getopts 'h' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
  esac
done

currentpath=$(pwd)

# If no arguments then set path to pwd
if [ $# -lt 1 ]; then
  path=$(pwd)
  echo 'No arguments given. Path set to' $path
else
  path=$1
  
  # If directory doesn't exist, make one
  if [ ! -d "$path" ]; then
    mkdir "$path"
  fi

  cd "$path"
fi

# These are the colors we want ("" is red)
declare -a colors=("_black" "_brown" "_grey" "_white" "_orange" "_yellow" "_green" "_purple" "")

# Do the downloading
for letter in {A..Z}; do
  for color in "${colors[@]}"; do
    url="http://maps.google.com/mapfiles/marker"$color$letter".png"
    echo 'Downloading...' $url 'to' $path
    curl -O $url
  done
done

# Download the markers that don't have letters
for color in "${colors[@]}"; do
  url="http://maps.google.com/mapfiles/marker"$color".png"
  echo 'Downloading...' $url 'to' $path
  curl -O $url
done

# Remove underscores in the files
for file in *.png
do
  mv "$file" "`echo $file | sed 's/_//'`"
done

cd $currentpath

exit 0
