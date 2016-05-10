#!/bin/bash
#
# Cleanup script for 'bins' storage
#
###

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
source $SCRIPT_DIR/bins-core.sh

##
# Functions
##

function log {
  echo "[`date +'%F %T'`] $*"
}


function deleteBins() {
  local directory=$1
  declare -a subdirectories=("${!2}")
  local versions_to_keep=$3

  local number_of_versions=${#subdirectories[@]}
  local number_of_versions_to_delete=$((number_of_versions - versions_to_keep))
 
  if [ "$number_of_versions_to_delete" -le 0 ]; then
    log "Found $number_of_versions versions in $directory. Keeping all"
  else
    log "Found $number_of_versions versions in $directory. Deleting $number_of_versions_to_delete versions"
    for (( i=0; i<${number_of_versions_to_delete}; i++ ));
    do
      rm -r ${subdirectories[$i]}
    done
  fi
}


function deleteBinsInDirectory() {
  local directory=$1
  local versions_to_keep=$2
  local root_directory=$(pwd)
  cd $directory

  local versions=($(ls -1vd "[[:digit:]]*" 2> /dev/null))
  local labels=($(ls -1vd "[[:alpha:]]*" 2> /dev/null))

  deleteBins $directory versions[@] $versions_to_keep

  for label in ${labels[@]}; do
    deleteBinsInDirectory $label $versions_to_keep
  done

  cd $root_directory
}

##
# Main
##

if [ "$1" == "" ]; then
  echo "Please provide binary root directory"
  echo "  Usage: $0 <dir>"
  exit 123
fi

if [ "$2" == "" ]; then
  echo "Please provide number of versions to keep"
  echo "  Usage: $0 <dir> <versions to keep>"
  exit 124
fi

ROOT=$1
VERSIONS_TO_KEEP=$2

log "----------- Start  -----------" 
log "Executing cleanup of $ROOT with $VERSIONS_TO_KEEP versions to keep"

cd $1
ROOT=$(pwd)

PATHS=$(find . -mindepth 4 -maxdepth 4 -type d)

for DIR in ${PATHS[@]}; do

  deleteBinsInDirectory $DIR $VERSIONS_TO_KEEP

done

log "----------- Done -----------" 
