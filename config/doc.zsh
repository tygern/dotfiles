doc() {
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: doc <output-name>"
    echo "Converts clipboard markdown to <output-name>.pdf using pandoc."
    return 0
  fi

  if [[ $# -ne 1 ]]; then
    echo "Usage: doc <output-name>" >&2
    return 1
  fi

  pbpaste | pandoc -f markdown -o "$1.pdf"
}
