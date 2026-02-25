# macOS-only GitHub Actions watcher
# Default: watch latest run on current branch
#
# Usage:
#   ghw                    # watch latest run on current branch
#   ghw --pick             # interactively select a run
#   ghw <run-id>           # watch specific run
#   ghw --say              # speak result out loud
#   ghw --say --pick
#   ghw --say <run-id>

__ghw_notify() {
  local title="$1"
  local body="$2"
  local do_say="${3:-0}"

  # Loud terminal output
  printf "\a\n"
  printf "============================================================\n"
  printf "%s\n%s\n" "$title" "$body"
  printf "============================================================\n"

  # macOS notification banner
  if command -v osascript >/dev/null 2>&1; then
    local esc_title esc_body
    esc_title="${title//\"/\\\"}"
    esc_body="${body//\"/\\\"}"
    osascript -e "display notification \"${esc_body}\" with title \"${esc_title}\"" >/dev/null 2>&1 || true
  fi

  # Optional speech
  if [[ "$do_say" -eq 1 ]] && command -v say >/dev/null 2>&1; then
    say "$title. $body" >/dev/null 2>&1 || true
  fi
}

ghw() {
  local do_say=0
  local pick_mode=0
  local run_id=""

  # Parse args
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --say) do_say=1; shift ;;
      --pick) pick_mode=1; shift ;;
      -h|--help)
        cat <<'EOF'
ghw: Watch a GitHub Actions run and notify when it completes (macOS).

Default:
  Watches the latest run on the current branch.

Usage:
  ghw                    Watch latest run on current branch
  ghw --pick             Interactively select a run
  ghw <run-id>           Watch a specific run
  ghw --say              Speak result out loud
  ghw --say --pick
  ghw --say <run-id>
EOF
        return 0
        ;;
      -*)
        echo "ghw: unknown flag: $1" >&2
        return 2
        ;;
      *)
        if [[ -n "$run_id" ]]; then
          echo "ghw: unexpected extra argument: $1" >&2
          return 2
        fi
        run_id="$1"
        shift
        ;;
    esac
  done

  local repo branch id
  repo="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)"
  [[ -z "$repo" ]] && repo="GitHub repo"

  # Determine run ID
  if [[ -n "$run_id" ]]; then
    id="$run_id"

  elif [[ "$pick_mode" -eq 1 ]]; then
    gh run watch --exit-status --compact
    local rc=$?
    local status_word=$([[ $rc -eq 0 ]] && echo "SUCCESS" || echo "FAILED")
    local emoji=$([[ $rc -eq 0 ]] && echo "✅" || echo "❌")
    __ghw_notify "Actions finished ${emoji}" "${repo}: ${status_word}" "$do_say"
    return $rc

  else
    branch="$(git branch --show-current 2>/dev/null)"
    if [[ -z "$branch" ]]; then
      echo "ghw: not in a git repo or no branch detected" >&2
      return 2
    fi

    id="$(gh run list \
      --branch "$branch" \
      --limit 1 \
      --json databaseId \
      -q '.[0].databaseId' 2>/dev/null)"

    if [[ -z "$id" || "$id" == "null" ]]; then
      echo "ghw: no runs found for branch '$branch'" >&2
      return 1
    fi

    echo "Watching latest run on branch '$branch' (run $id)"
  fi

  # Watch selected run
  gh run watch "$id" --exit-status --compact
  local rc=$?

  local status_word=$([[ $rc -eq 0 ]] && echo "SUCCESS" || echo "FAILED")
  local emoji=$([[ $rc -eq 0 ]] && echo "✅" || echo "❌")

  __ghw_notify "Actions finished ${emoji}" "${repo}: ${status_word} (run ${id})" "$do_say"
  return $rc
}
