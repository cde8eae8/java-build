#!/bin/bash

. ~/bin/sh/out-format.sh

rebuild() {
  if [[ $# -ne 2 ]]; then
    error "expected 2 arguments - task name and buildfile name"
    return 1
  fi
  ant -buildfile "$1/$2"
}

prepare_test() {
  TEST_DIR="$PWD/java-advanced-2020"
  SRC_DIR="$PWD/java-advanced-2020-solutions"
  msg "src updating..."
  git -C $SRC_DIR pull
  msg "tests updating..."
  if timeout 10 git -C $TEST_DIR pull ; then
    success "Successfully updated"
    error "last commit       $(git -C $TEST_DIR log -1 --format=%cr) at $(git -C $TEST_DIR log -1 --format=%cD):"
  else
    time="$(find $TEST_DIR/artifacts -printf "%T@ %Tc %f\n" | sort -n)"
    error "Test updating failed"
    error "*********************"
    error "YOU CAN USE OLD TESTS"
    error "*********************"
    error "now               $(date)"
    error "last commit       $(git -C $TEST_DIR log -1 --format=%cr) at $(git -C $TEST_DIR log -1 --format=%cD):"
    error "last update:"
    error "$time"
    error "continue? [Y/n]"
    read answer
    if [[ "$answer" = "n" ]]; then
      error "exit"
      exit 1
    fi
  fi
}

find_task() {
  echo $(find task"${1}"* -maxdepth 0)
}


check_variable() {
  if [[ $# -ne 1 ]]; then
    error "check variable: no arguments, expected variable name"
    exit 1
  fi

  if [[ "${!1}" = "" ]]; then
    error "variable ${1} not found"
    exit 1
  fi
}

load_config() {
  if [[ $# -ne 2 ]]; then
    error "expected name & config id"
    return 1
  fi
  name="$1"
  id="$2"

  if ! . "configs/$id.config" 2> /dev/null ; then
    error "can't find config file $task_config"
    return 1
  fi

  config_var_names="TASKDIR CLASS PACKAGE NAME TEST_NAME TEST_TYPE JAVAFILES"
  nonobligatory="ADDITIONAL_MODULES"
  ___base_package_name___="ru.ifmo.rain.$name"
  SHORT_PACKAGE=$PACKAGE
  PACKAGE="$___base_package_name___.$PACKAGE"

  for var in $config_var_names; do
    check_variable "$var"
    success "%-10s = ${!var}" "$var"  #$var = ${!var}"
  done
  for var in $nonobligatory; do
    success "%-10s = ${!var}" "$var"  #$var = ${!var}"
  done
  return 0
}

