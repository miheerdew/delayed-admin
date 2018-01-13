function create_group {
    local grp="$1"
    if dseditgroup -o read "$grp" &> /dev/null; then
	log "Group $grp already exists"
    else
        dseditgroup -o create "$grp"
	log "Created group $grp"
    fi
}

function delete_group {
    local grp="$1"
    if dseditgroup -o read "$grp" &> /dev/null; then
        dseditgroup -o delete "$grp"
	log "Deleted group $grp"
    else
	log "Group $grp does not exist. Doing nothing."
    fi
}
