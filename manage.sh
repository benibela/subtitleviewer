#/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../../../manageUtils.sh

githubProject subtitleviewer

BASE=$HGROOT/programs/data/subtitleviewer

case "$1" in
mirror)
  syncHg  
;;

esac

