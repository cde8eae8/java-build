
Colors__Red="1"
Colors__Black="0"

color_start () {
  if [[ $# -ne 1 ]]; then
    echo "expected color"
  fi
  printf '\033[0;3%dm' $1 
}

color_end() {
  NOCOLOR='\033[0m'
  printf "${NOCOLOR}"
}


_color() {
    local color=$1
    local format=$2
    shift
    shift
    NOCOLOR='\033[0m'
    printf "${color}${format}${NOCOLOR}\n" "$@"
}

error() {
    _color '\033[0;31m' "$@"
}

success() {
    _color '\033[0;32m' "$@"
}

msg() {
  echo "$@"
}

