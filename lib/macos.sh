function create_group {
    local grp="$1"
    if !dseditgroup -o read "$grp" &> /dev/null; then
        dseditgroup -o create "$grp"
    fi
}

function delete_group {
    local grp="$1"
    if dseditgroup -o read "$grp" &> /dev/null; then
        dseditgroup -o delete "$grp"
    fi
}
