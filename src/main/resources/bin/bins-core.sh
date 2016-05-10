#!/bin/bash

function getScriptDir() {
  local source="${BASH_SOURCE[0]}"
  while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
    local current_dir="$( cd -P "$( dirname "$source" )" && pwd )"
    source="$(readlink "$source")"
    [[ $source != /* ]] && source="$current_dir/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  echo "$( cd -P "$( dirname "$source" )" && pwd )"
}

#
# Check if a file exists and has the provided permission
# Exit if the file does not exist or does not have the correct permission
#
# Possible permissions are 'read' and 'write'
#
# Example:
#   checkFilePermission "/tmp/my.file.txt" "read"
#   checkFilePermission "/tmp/my.file.txt" "write"
#
function checkFilePermission {
  local property_file=$1
  local permission=$2

  if [ -z "$property_file" ]; then
    echo "File name must be provided"
    exit 122
  fi

  if [ ! -e $property_file ]; then
    echo "File '$property_file' does not exist"
    exit 123
  fi

  if [[ "$permission" == "read" && ! -r $property_file ]]; then
    echo "No read permissions on file '$property_file'"
    exit 124
  elif [[ "$permission" == "write" && ! -w $property_file ]]; then
    echo "No write permissions on file '$property_file'"
    exit 125
  fi
}

#
# Read property from configuration file and place it in a variable.
# Exit if the property does not exist
#
# Example:
#   readPropery MY_PROPERTY "my.property" "/tmp/my.file.txt"
#
#   echo $MY_PROPERTY
#
function readProperty() {
  local return_property_name=$1
  local property_to_read=$2
  local property_file=$3

  checkFilePermission $property_file 'read'

  local value=$(cat $property_file | grep -m 1 "^$property_to_read=" | sed "s/^$property_to_read=\(.*\)/\1/")

  eval "$return_property_name='$value'"
}

SCRIPT_DIR="$(getScriptDir)"
BINS_HOME="$( cd $SCRIPT_DIR && cd .. && pwd )"

readProperty BINS_HOST "bins.host" "$BINS_HOME/etc/bins.properties"
readProperty BINS_PATH "bins.path" "$BINS_HOME/etc/bins.properties"

export BINS_HOST
export BINS_PATH

function getLocalPath() {
  local artifact=$1
  local version=${2//[.-]/\/}
  echo $BINS_PATH/$artifact/$version
}

function getRemotePath() {
  echo $BINS_HOST:$(getLocalPath $1 $2)
}
