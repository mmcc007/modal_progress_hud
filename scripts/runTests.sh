#!/usr/bin/env bash
set -e

runTests () {
  cd $1;
  echo "Running tests in $1 ..."
  flutter test --coverage
  # combine line coverage info from package tests to a common file
  sed "s/^SF:lib/SF:$1\/lib/g" coverage/lcov.info >> $2/lcov.info
  cd - > /dev/null
}

# if running locally
if [ -f "lcov.info" ]; then
  rm lcov.info
fi

runTests . `pwd`
runTests example `pwd`
