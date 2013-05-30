#!/bin/sh
#
# Based on p4merge compare script
#
# Before you can use this:
# * Install Beyond Compare using WineBottler
# * Edit "Beyond Compare 3.app\Contents\Info.plist" and remove the key/value pair:
#    <key>WineProgramArguments</key>
#    <string></string>

LOCAL="$1"
REMOTE="$2"
MERGING="$4"
BACKUP="/tmp/$(date +"%Y%d%m%H%M%S")"

APPLICATION_PATH="/Applications/Beyond Compare.app"
CMD="$APPLICATION_PATH"

if [ ! -x "$CMD" ]; then
  echo "Beyond Compare could not be found!" >&2
  exit 128
fi

if [ -n "$MERGING" ]; then
  BASE="$3"
  MERGE="$4"

  # Sanitize BASE path
  if [[ ! "$BASE" =~ ^/ ]]; then
    BASE=$(echo "$BASE" | sed -e 's/^.\///')
    BASE="$PWD/$BASE"

    if [ ! -f "$BASE" ]; then
      BASE=/dev/null
    fi
  fi

  # Sanitize MERGE path
  if [[ ! "$MERGE" =~ ^/ ]]; then
    MERGE=$(echo "$MERGE" | sed -e 's/^.\///')
    MERGE="$PWD/$MERGE"

    if [ ! -f "$MERGE" ]; then
      # For conflict "Both Added", Git does not pass the merge param correctly in current versions
      MERGE=$(echo "$LOCAL" | sed -e 's/\.LOCAL\.[0-9]*//')
    fi
  fi

  sleep 1 # required to create different modification timestamp
  touch "$BACKUP"

  open -n -a "$CMD" "$LOCAL" "$REMOTE" "$BASE" "$MERGE"
else
  open -n -a "$CMD" "$LOCAL" "$REMOTE"
fi

if [ -n "$MERGING" ]; then
  # Check if the merged file has changed
  if [ "$MERGE" -ot "$BACKUP" ]; then
    exit 1
  fi
fi

exit 0

