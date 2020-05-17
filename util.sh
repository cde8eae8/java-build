#!/bin/bash

# call add_prefix(prefix, " ", ...)
function add_prefix() {
  prefix="$1"
  shift 
  add_prefixJ "$prefix" " " $@
}

# add_prefix(prefix, delim, ...)
function add_prefixJ() {
  prefix="$1"
  delim="$2"
  shift 
  shift
  res=""
  echo -n "${prefix}$1"
  shift
  for s in $@; do
    echo -n "${delim}${prefix}${s}"
  done
}
