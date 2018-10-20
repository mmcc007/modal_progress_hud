#!/usr/bin/env bash
set -e
runTests () {
  cd $1;
  if [ -f "pubspec.yaml" ]
  then
  echo "Running tests in $1..."
    flutter test --coverage
    sed "s/^SF:lib/SF:${1:2}\/lib/g" coverage/lcov.info >> $2/lcov.info
  fi
}
export -f runTests
# if running locally
if [ -f "lcov.info" ]; then
  rm lcov.info
fi
find . -maxdepth 1 -type d -exec bash -c 'runTests "$0" `pwd`' {} \;
