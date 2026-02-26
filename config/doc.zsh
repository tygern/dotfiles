doc() {
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: doc [-f format] <output-name>"
    echo "Converts clipboard markdown to <output-name>.<format> using pandoc."
    echo "Default format: pdf. Other options: docx, epub, html, etc."
    return 0
  fi

  local fmt="pdf"
  if [[ "$1" == "-f" ]]; then
    if [[ -z "$2" ]]; then
      echo "doc: -f requires a format argument" >&2
      return 1
    fi
    fmt="$2"
    shift 2
  fi

  if [[ $# -ne 1 ]]; then
    echo "Usage: doc [-f format] <output-name>" >&2
    return 1
  fi

  local extra_args=()
  [[ "$fmt" == "epub" ]] && extra_args+=("--epub-title-page=false")

  pbpaste | pandoc -f markdown "${extra_args[@]}" -o "$1.$fmt"
}
