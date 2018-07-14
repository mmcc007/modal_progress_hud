#!/usr/bin/env bash
runTests () {
  cd $1;
  if [ -f "pubspec.yaml" ]
  then
    flutter test --coverage
    if [ $1 == "." ]
    then
      cat coverage/lcov.info > lcov.info
    else
      sed -i "s/lib/${1:2}\/lib/g" coverage/lcov.info
      cat coverage/lcov.info >> ../lcov.info
    fi
  fi
}
export -f runTests
find . -maxdepth 1 -type d -exec bash -c 'runTests "$0"' {} \;
