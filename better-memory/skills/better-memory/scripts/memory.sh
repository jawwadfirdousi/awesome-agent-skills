#!/usr/bin/env bash
# better-memory CLI - manage project/tag-scoped memories stored as JSON
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_PRIMARY="${SKILL_DIR}/memories.json"
CONFIG_FALLBACK="${HOME}/.config/claude/memories.json"

require_jq() {
    if ! command -v jq >/dev/null 2>&1; then
        echo "Error: jq is required" >&2
        exit 1
    fi
}

# Active store path: first existing, else the primary (skill-local) path.
config_path() {
    if [[ -f "$CONFIG_PRIMARY" ]]; then
        echo "$CONFIG_PRIMARY"
    elif [[ -f "$CONFIG_FALLBACK" ]]; then
        echo "$CONFIG_FALLBACK"
    else
        echo "$CONFIG_PRIMARY"
    fi
}

# Emit the store JSON (empty skeleton if missing/empty); validates JSON.
read_config() {
    local p
    p="$(config_path)"
    if [[ -s "$p" ]]; then
        jq . "$p" 2>/dev/null || {
            echo "Error: $p is not valid JSON" >&2
            exit 1
        }
    else
        echo '{"memories":[]}'
    fi
}

# Atomic write + chmod 600 (memories can hold personal context).
write_config() {
    require_jq
    local p tmp
    p="$(config_path)"
    mkdir -p "$(dirname "$p")"
    tmp="$(mktemp)"
    printf '%s\n' "$1" > "$tmp"
    mv "$tmp" "$p"
    chmod 600 "$p" 2>/dev/null || true
}

now_ts() {
    date -u +%Y-%m-%dT%H:%M:%SZ
}

# Short random hex id; falls back to $RANDOM if /dev/urandom is unavailable.
gen_id() {
    if [[ -r /dev/urandom ]]; then
        od -An -N4 -tx1 /dev/urandom | tr -d ' \n'
    else
        printf '%04x%04x' "$RANDOM" "$RANDOM"
    fi
}

# Current project name: git repo basename, else current directory basename.
# This is the default scope when --project is omitted, mirroring per-repo memory.
default_project() {
    local root
    if command -v git >/dev/null 2>&1 && root="$(git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$root" ]]; then
        basename "$root"
    else
        basename "$PWD"
    fi
}

# Project to filter read commands by: "" (all) with --all, explicit --project,
# else the auto-detected current project.
resolve_scope_project() {
    if [[ "$ARG_ALL" == "true" ]]; then
        echo ""
    elif [[ -n "$ARG_PROJECT" ]]; then
        echo "$ARG_PROJECT"
    else
        default_project
    fi
}

# Human label describing the active read scope.
scope_label() {
    local scope="$1"
    if [[ "$ARG_ALL" == "true" ]]; then
        echo "all projects"
    elif [[ -n "$ARG_PROJECT" ]]; then
        echo "$ARG_PROJECT"
    else
        echo "$scope (current repo; pass --project <name> or --all)"
    fi
}

# JSON array of the requested --tag values ([] when none).
tags_json() {
    if (( ${#ARG_TAGS[@]} == 0 )); then
        printf '[]'
    else
        jq -nc '$ARGS.positional' --args "${ARG_TAGS[@]}"
    fi
}

# JSON array of --add-tag values ([] when none).
add_tags_json() {
    if (( ${#ARG_ADD_TAGS[@]} == 0 )); then
        printf '[]'
    else
        jq -nc '$ARGS.positional' --args "${ARG_ADD_TAGS[@]}"
    fi
}

# JSON array of --remove-tag values ([] when none).
remove_tags_json() {
    if (( ${#ARG_REMOVE_TAGS[@]} == 0 )); then
        printf '[]'
    else
        jq -nc '$ARGS.positional' --args "${ARG_REMOVE_TAGS[@]}"
    fi
}

# Count non-empty lines in a string (0 for empty).
count_lines() {
    [[ -z "$1" ]] && { echo 0; return; }
    printf '%s\n' "$1" | wc -l | tr -d ' '
}

id_exists() {
    echo "$1" | jq -e --arg id "$2" '.memories[] | select(.id == $id)' >/dev/null 2>&1
}

# Ids matching a project filter ("" = wildcard) and ALL wanted tags ([] = any).
matching_ids() {
    echo "$1" | jq -r --arg p "$2" --argjson tags "$3" '
        .memories[]
        | select( (($p == "") or (.project == $p))
                  and ((($tags - (.tags // [])) | length) == 0) )
        | .id'
}

# Render one memory object ($1) in the given format ($2): human|json.
emit_memory() {
    local obj="$1" fmt="$2"
    case "$fmt" in
        json) echo "$obj" | jq . ;;
        *)    echo "$obj" | jq -r '
                "ID:        \(.id)\n" +
                "Project:   \(.project)\n" +
                "Tags:      \((.tags // []) | join(", "))\n" +
                "Created:   \(.created_at)\n" +
                "Updated:   \(.updated_at)\n" +
                "Content:\n\(.content)"' ;;
    esac
}

# Parse all supported flags into ARG_* globals. Rejects positional args.
parse_args() {
    ARG_PROJECT=""
    ARG_TAGS=()
    ARG_ADD_TAGS=()
    ARG_REMOVE_TAGS=()
    ARG_CONTENT=""
    ARG_ID=""
    ARG_QUERY=""
    ARG_FORMAT="human"
    ARG_YES="false"
    ARG_ALL="false"
    ARG_REGEX="false"
    while (( $# > 0 )); do
        case "$1" in
            --project)
                [[ -n "${2:-}" ]] || { echo "Error: --project requires a value" >&2; exit 1; }
                ARG_PROJECT="$2"; shift 2 ;;
            --tag)
                [[ -n "${2:-}" ]] || { echo "Error: --tag requires a value" >&2; exit 1; }
                ARG_TAGS+=("$2"); shift 2 ;;
            --add-tag)
                [[ -n "${2:-}" ]] || { echo "Error: --add-tag requires a value" >&2; exit 1; }
                ARG_ADD_TAGS+=("$2"); shift 2 ;;
            --remove-tag)
                [[ -n "${2:-}" ]] || { echo "Error: --remove-tag requires a value" >&2; exit 1; }
                ARG_REMOVE_TAGS+=("$2"); shift 2 ;;
            --content)
                [[ -n "${2:-}" ]] || { echo "Error: --content requires a value" >&2; exit 1; }
                ARG_CONTENT="$2"; shift 2 ;;
            --id)
                [[ -n "${2:-}" ]] || { echo "Error: --id requires a value" >&2; exit 1; }
                ARG_ID="$2"; shift 2 ;;
            --query|-q)
                [[ -n "${2:-}" ]] || { echo "Error: --query requires a value" >&2; exit 1; }
                ARG_QUERY="$2"; shift 2 ;;
            --format)
                [[ -n "${2:-}" ]] || { echo "Error: --format requires a value" >&2; exit 1; }
                ARG_FORMAT="$2"; shift 2 ;;
            --yes|-y)
                ARG_YES="true"; shift ;;
            --all)
                ARG_ALL="true"; shift ;;
            --regex)
                ARG_REGEX="true"; shift ;;
            -*)
                echo "Error: Unknown option: $1" >&2; exit 1 ;;
            *)
                echo "Error: unexpected argument: $1 (all inputs are flags)" >&2; exit 1 ;;
        esac
    done
}

# --- commands -------------------------------------------------------------

cmd_add() {
    require_jq
    parse_args "$@"
    (( ${#ARG_TAGS[@]} > 0 )) || { echo "Error: at least one --tag is required." >&2; exit 1; }
    [[ -n "$ARG_CONTENT" ]] || { echo "Error: --content is required." >&2; exit 1; }

    local project auto="false"
    if [[ -n "$ARG_PROJECT" ]]; then
        project="$ARG_PROJECT"
    else
        project="$(default_project)"; auto="true"
    fi

    local cfg tags existing id ts new
    cfg="$(read_config)"
    tags="$(tags_json)"

    # Idempotency: identical project + content already stored.
    existing="$(echo "$cfg" | jq -r --arg p "$project" --arg t "$ARG_CONTENT" '
        [ .memories[] | select(.project == $p and .content == $t) | .id ] | (.[0] // empty)')"
    if [[ -n "$existing" ]]; then
        echo "Memory already exists [$existing] under $project (no change). Change it with: update --id $existing [--content ...] [--add-tag ...] [--remove-tag ...]."
        exit 0
    fi

    id="$(gen_id)"
    while id_exists "$cfg" "$id"; do id="$(gen_id)"; done
    ts="$(now_ts)"
    new="$(echo "$cfg" | jq \
        --arg id "$id" --arg p "$project" --argjson tags "$tags" --arg t "$ARG_CONTENT" --arg ts "$ts" '
        .memories += [{
            id: $id, project: $p, tags: ($tags | unique), content: $t,
            created_at: $ts, updated_at: $ts
        }]')"
    write_config "$new"
    local taglist
    taglist="$(printf '%s' "$tags" | jq -r 'unique | join(", ")')"
    if [[ "$auto" == "true" ]]; then
        echo "Added memory [$id] under $project [tags: $taglist] (project auto-detected; use --project to override)."
    else
        echo "Added memory [$id] under $project [tags: $taglist]."
    fi
}

# Shared filter for recall/list: memories in scope matching ALL wanted tags.
filter_scoped() {
    local cfg="$1" scope="$2" tags="$3"
    echo "$cfg" | jq --arg p "$scope" --argjson tags "$tags" '
        .memories
        | map(select( (($p == "") or (.project == $p))
                      and ((($tags - (.tags // [])) | length) == 0) ))
        | sort_by(.project, .created_at)'
}

# One-line "tag (count)" summary of a memory array, busiest first.
tags_summary() {
    echo "$1" | jq -r '
        [.[].tags[]?] | group_by(.)
        | map({t: .[0], n: length}) | sort_by(-.n)
        | map("\(.t) (\(.n))") | join(", ")'
}

cmd_recall() {
    require_jq
    parse_args "$@"
    case "$ARG_FORMAT" in human|json) ;; *)
        echo "Error: --format must be human or json" >&2; exit 1 ;;
    esac

    local cfg scope tags filtered count
    cfg="$(read_config)"
    scope="$(resolve_scope_project)"
    tags="$(tags_json)"
    filtered="$(filter_scoped "$cfg" "$scope" "$tags")"
    count="$(echo "$filtered" | jq 'length')"

    if [[ "$ARG_FORMAT" == "json" ]]; then
        echo "$filtered" | jq 'map({id, project, tags,
            summary: (.content | gsub("[\n\t ]+"; " ") | if length > 80 then .[0:79] + "…" else . end)})'
        return
    fi

    echo "Memory index - $(scope_label "$scope")"
    if [[ "$count" -eq 0 ]]; then
        echo "  (nothing stored here yet)"
        return
    fi
    local tagline
    tagline="$(tags_summary "$filtered")"
    [[ -z "$tagline" ]] && tagline="(none)"
    echo "Tags in scope: $tagline"
    echo
    echo "$filtered" | jq -r '
        def snip: gsub("[\n\t ]+"; " ") | if length > 80 then .[0:79] + "…" else . end;
        group_by(.project)[]
        | ( "\(.[0].project)  (\(length))",
            ( .[] | "  [\(.id)] \(.content | snip)"
                    + (if (.tags|length) > 0 then "  " + (.tags | map("#" + .) | join(" ")) else "" end) ),
            "" )'
}

cmd_list() {
    require_jq
    parse_args "$@"
    case "$ARG_FORMAT" in human|json) ;; *)
        echo "Error: --format must be human or json" >&2; exit 1 ;;
    esac

    local cfg scope tags filtered count
    cfg="$(read_config)"
    scope="$(resolve_scope_project)"
    tags="$(tags_json)"
    filtered="$(filter_scoped "$cfg" "$scope" "$tags")"
    count="$(echo "$filtered" | jq 'length')"

    if [[ "$ARG_FORMAT" == "json" ]]; then
        echo "$filtered"
        return
    fi

    echo "Scope: $(scope_label "$scope")"
    if [[ "$count" -eq 0 ]]; then
        echo
        echo "No memories here yet."
        echo "Add one with: memory.sh add --tag <t> --content \"...\""
        return
    fi
    echo
    echo "Memories ($count):"
    echo
    echo "$filtered" | jq -r '
        group_by(.project)[]
        | ( "\(.[0].project)  (\(length))",
            ( .[] | "  - [\(.id)] \(.content)"
                    + (if (.tags|length) > 0 then "\n      " + (.tags | map("#" + .) | join(" ")) else "" end) ),
            "" )'
}

cmd_search() {
    require_jq
    parse_args "$@"
    [[ -n "$ARG_QUERY" ]] || { echo "Error: --query is required." >&2; exit 1; }
    case "$ARG_FORMAT" in human|json) ;; *)
        echo "Error: --format must be human or json" >&2; exit 1 ;;
    esac

    local cfg scope tags results count
    cfg="$(read_config)"
    scope="$(resolve_scope_project)"
    tags="$(tags_json)"
    results="$(echo "$cfg" | jq --arg p "$scope" --argjson tags "$tags" --arg q "$ARG_QUERY" --argjson rx "$ARG_REGEX" '
        .memories
        | map(select(
            (($p == "") or (.project == $p))
            and ((($tags - (.tags // [])) | length) == 0)
            and (if $rx
                 then (.content | test($q; "i"))
                 else ((.content | ascii_downcase) | contains($q | ascii_downcase))
                 end)))
        | sort_by(.project, .created_at)')"
    count="$(echo "$results" | jq 'length')"

    if [[ "$ARG_FORMAT" == "json" ]]; then
        echo "$results"
        return
    fi

    echo "Search \"$ARG_QUERY\" - $(scope_label "$scope") - $count match(es)"
    if [[ "$count" -eq 0 ]]; then
        echo "Note: search matches memory text literally; for concept/synonym recall, use recall and tags."
        return
    fi
    echo
    echo "$results" | jq -r '
        def snip: gsub("[\n\t ]+"; " ") | if length > 100 then .[0:99] + "…" else . end;
        .[] | "  [\(.id)] \(.project): \(.content | snip)"
              + (if (.tags|length) > 0 then "  " + (.tags | map("#" + .) | join(" ")) else "" end)'
}

cmd_get() {
    require_jq
    parse_args "$@"
    case "$ARG_FORMAT" in human|json) ;; *)
        echo "Error: --format must be human or json" >&2; exit 1 ;;
    esac

    local cfg obj ids n id scope loc tags
    cfg="$(read_config)"

    if [[ -n "$ARG_ID" ]]; then
        obj="$(echo "$cfg" | jq -e --arg id "$ARG_ID" '.memories[] | select(.id == $id)')" || {
            echo "Error: no memory with id '$ARG_ID'." >&2; exit 1; }
        emit_memory "$obj" "$ARG_FORMAT"
        return
    fi

    if (( ${#ARG_TAGS[@]} > 0 )); then
        scope="$(resolve_scope_project)"
        loc="$scope"; [[ -z "$loc" ]] && loc="any project"
        tags="$(tags_json)"
        ids="$(matching_ids "$cfg" "$scope" "$tags")"
        n="$(count_lines "$ids")"
        local taglist; taglist="$(printf '%s' "$tags" | jq -r 'join(", ")')"
        if [[ "$n" -eq 0 ]]; then
            echo "Error: no memory in $loc tagged: $taglist." >&2; exit 1
        elif [[ "$n" -gt 1 ]]; then
            echo "Error: $n memories in $loc tagged: $taglist. Pick one with --id, or narrow with more --tag:" >&2
            echo "$ids" | sed 's/^/  /' >&2
            exit 1
        fi
        id="$ids"
        obj="$(echo "$cfg" | jq -e --arg id "$id" '.memories[] | select(.id == $id)')"
        emit_memory "$obj" "$ARG_FORMAT"
        return
    fi

    echo "Error: provide --id, or --tag (optionally with --project or --all)." >&2
    exit 1
}

cmd_update() {
    require_jq
    parse_args "$@"

    local has_content="false" edit_tags="false"
    [[ -n "$ARG_CONTENT" ]] && has_content="true"
    if (( ${#ARG_ADD_TAGS[@]} > 0 )) || (( ${#ARG_REMOVE_TAGS[@]} > 0 )); then edit_tags="true"; fi
    if [[ "$has_content" == "false" && "$edit_tags" == "false" ]]; then
        echo "Error: nothing to update. Pass --content and/or --add-tag/--remove-tag." >&2; exit 1
    fi

    local cfg id ids n ts new scope loc tags addj remj newtags
    cfg="$(read_config)"

    if [[ -n "$ARG_ID" ]]; then
        id_exists "$cfg" "$ARG_ID" || { echo "Error: no memory with id '$ARG_ID'." >&2; exit 1; }
        id="$ARG_ID"
    elif (( ${#ARG_TAGS[@]} > 0 )); then
        scope="$(resolve_scope_project)"
        loc="$scope"; [[ -z "$loc" ]] && loc="any project"
        tags="$(tags_json)"
        ids="$(matching_ids "$cfg" "$scope" "$tags")"
        n="$(count_lines "$ids")"
        local taglist; taglist="$(printf '%s' "$tags" | jq -r 'join(", ")')"
        if [[ "$n" -eq 0 ]]; then
            echo "Error: no memory in $loc tagged: $taglist to update." >&2; exit 1
        elif [[ "$n" -gt 1 ]]; then
            echo "Error: $n memories in $loc tagged: $taglist. Pick one with --id, or narrow with more --tag:" >&2
            echo "$ids" | sed 's/^/  /' >&2
            exit 1
        fi
        id="$ids"
    else
        echo "Error: target a memory with --id, or with --tag (optionally --project)." >&2
        exit 1
    fi

    addj="$(add_tags_json)"
    remj="$(remove_tags_json)"

    # Enforce the >=1 tag invariant when editing tags.
    if [[ "$edit_tags" == "true" ]]; then
        newtags="$(echo "$cfg" | jq -c --arg id "$id" --argjson add "$addj" --argjson rem "$remj" '
            .memories[] | select(.id == $id) | (((.tags // []) + $add - $rem) | unique)')"
        if [[ "$newtags" == "[]" ]]; then
            echo "Error: that would remove all tags; a memory must keep at least one tag." >&2; exit 1
        fi
    fi

    ts="$(now_ts)"
    new="$(echo "$cfg" | jq \
        --arg id "$id" --arg t "$ARG_CONTENT" --argjson hasContent "$has_content" \
        --argjson editTags "$edit_tags" --argjson add "$addj" --argjson rem "$remj" --arg ts "$ts" '
        .memories |= map(
            if .id == $id then
                (if $hasContent then .content = $t else . end)
                | (if $editTags then .tags = (((.tags // []) + $add - $rem) | unique) else . end)
                | .updated_at = $ts
            else . end)')"
    write_config "$new"
    echo "Updated memory [$id]."
}

cmd_delete() {
    require_jq
    parse_args "$@"

    local cfg new
    cfg="$(read_config)"

    if [[ -n "$ARG_ID" ]]; then
        id_exists "$cfg" "$ARG_ID" || { echo "Error: no memory with id '$ARG_ID'." >&2; exit 1; }
        new="$(echo "$cfg" | jq --arg id "$ARG_ID" '.memories |= map(select(.id != $id))')"
        write_config "$new"
        echo "Deleted memory [$ARG_ID]."
        return
    fi

    # Delete never auto-detects the project: a destructive scope must be explicit.
    if [[ -n "$ARG_PROJECT" ]]; then
        local tags ids n scope taglist
        tags="$(tags_json)"
        ids="$(matching_ids "$cfg" "$ARG_PROJECT" "$tags")"
        n="$(count_lines "$ids")"
        scope="$ARG_PROJECT"
        if (( ${#ARG_TAGS[@]} > 0 )); then
            taglist="$(printf '%s' "$tags" | jq -r 'join(", ")')"
            scope="$ARG_PROJECT tagged: $taglist"
        fi
        if [[ "$n" -eq 0 ]]; then
            echo "Error: no memory in $scope." >&2; exit 1
        fi
        if [[ "$n" -gt 1 && "$ARG_YES" != "true" ]]; then
            echo "This would delete $n memories in $scope:"
            echo "$ids" | sed 's/^/  /'
            echo
            echo "Re-run with --yes to confirm, or target one with --id."
            return
        fi
        new="$(echo "$cfg" | jq --arg p "$ARG_PROJECT" --argjson tags "$tags" '
            .memories |= map(select(
                ( (.project == $p) and ((($tags - (.tags // [])) | length) == 0) ) | not ))')"
        write_config "$new"
        echo "Deleted $n memory(ies) in $scope."
        return
    fi

    echo "Error: target a memory with --id, or a scope with --project [--tag ...]." >&2
    echo "Note: delete does not auto-detect the project; pass --project explicitly." >&2
    exit 1
}

usage() {
    cat << 'USAGE'
Usage: memory.sh <command> [options]

Commands:
  recall  [--project <p> | --all] [--tag <t> ...] [--format human|json]
            Compact index (snippet + tags per memory). Run at the start of work.
  add     [--project <p>] --tag <t> [--tag <t2> ...] --content "<text>"
            Store a memory. At least one tag required; project defaults to the repo.
  list    [--project <p> | --all] [--tag <t> ...] [--format human|json]
            List memories in full, grouped by project.
  search  --query "<text>" [--regex] [--project <p> | --all] [--tag <t> ...] [--format human|json]
            Find memories whose content matches literally (case-insensitive).
  get     (--id <id> | --tag <t> ... [--project <p> | --all]) [--format human|json]
            Show one memory in full.
  update  (--id <id> | --tag <t> ... [--project <p> | --all]) [--content "<text>"] [--add-tag <t>] [--remove-tag <t>]
            Change a memory's content and/or tags (a memory must keep >=1 tag).
  delete  --id <id>
            Delete one memory.
  delete  --project <p> [--tag <t> ...] [--yes]
            Delete a project, or memories in it matching all given tags (--yes when >1).
  help    Show this help.

Tags:
  A memory carries one or more tags (free-form labels). Filtering by multiple
  --tag matches memories that have ALL of them. 'recall' lists the tags in scope
  so you know what to fetch by. Tags are how you save and fetch precisely, and
  they bridge wording gaps that literal 'search' misses.

Scope:
  Read commands (recall/list/search) and 'add' default the project to the current
  repo (git basename, else cwd). --project targets another; --all spans every
  project. 'delete' never auto-detects: pass --project or --id explicitly.

Storage:
  JSON in memories.json at the skill root (gitignored, chmod 600). Each memory has
  project, tags[], content, timestamps, and a short id shown by recall/list.

Examples:
  memory.sh recall
  memory.sh add --tag decision --tag database --content "Chose Postgres over Mongo."
  memory.sh recall --tag letter --all
  memory.sh search --query postgres
  memory.sh get --id 1a2b3c4d
  memory.sh update --id 1a2b3c4d --content "Revised note."
  memory.sh update --id 1a2b3c4d --add-tag urgent --remove-tag draft
  memory.sh delete --project acme-api --tag scratch --yes
USAGE
}

case "${1:-help}" in
    recall)           shift; cmd_recall "$@" ;;
    add)              shift; cmd_add "$@" ;;
    list|ls)          shift; cmd_list "$@" ;;
    search|find)      shift; cmd_search "$@" ;;
    get)              shift; cmd_get "$@" ;;
    update)           shift; cmd_update "$@" ;;
    delete|remove|rm) shift; cmd_delete "$@" ;;
    help|--help|-h)   usage ;;
    *)
        echo "Unknown command: $1" >&2
        usage
        exit 1 ;;
esac
