#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
source $SCRIPT_DIR/bins-core.sh

ID=$1
VERSION=$2
DEST=$3

if [[ "$ID" == "" || "$VERSION" == "" || "$DEST" == "" ]]; then
  echo "Arguments missing."
  echo ""
  echo "  id          : the id of the binary to download"
  echo "  version     : the version to download"
  echo "  destination : the destination to store the binaries"
  echo ""
  echo "Usage: "
  echo "  $0 <artifactId> <version> <destination>"
  echo ""
  echo "Example:"
  echo "  $0 my-artifact 1.2.3.25 tmp"
  echo ""
  exit 123
fi

REMOTE_PATH="$(getRemotePath $ID $VERSION)"

rsync --progress $REMOTE_PATH/* $DEST/
