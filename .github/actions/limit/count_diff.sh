#!/bin/bash
echo "::group::Count changed lines"
set -eux

changed=$(git diff $BASE --numstat \
  | if [ "$EXCLUDE" != "" ]; then grep -vP "^(\d+\s+)+\/?($EXCLUDE)\/"; else cat; fi \
  | grep -P ".*\.($EXT)$" \
  | awk '{ additions+=$1 } END { printf "%d", additions }')

echo "CHANGED=$changed" >> $GITHUB_ENV

set +eux
echo "::endgroup::"

if [ $changed -gt $LIMIT ]; then
  echo "::warning::Exceeds limit. (Limit: $LIMIT, Changed: $changed)"
  exit 1
fi