#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
source $SCRIPT_DIR/bins-core.sh

ID=$1
VERSION=$2
DIR=$3

if [[ "$ID" == "" || "$VERSION" == "" || "$DIR" == "" ]]; then
  echo "Arguments missing."
  echo ""
  echo "  id      : the id of the binary to upload"
  echo "  version : the version of the upload"
  echo "  dir     : the directory with binaries to upload"
  echo ""
  echo "Usage: "
  echo "  $0 <id> <version> <dir>"
  echo ""
  echo "Example:"
  echo "  $0 my-artifact 1.2.3.25 tmp"
  echo ""
  exit 123
fi


ARTIFACT_PATH="$(getLocalPath $ID $VERSION)"
REMOTE_PATH="$(getRemotePath $ID $VERSION)"

rsync --rsync-path="mkdir -p $ARTIFACT_PATH && rsync" --progress $DIR/* $REMOTE_PATH
