#!/bin/bash

# Function to get IP address of an LXC container
get_lxc_ip() {
    local vmid=$1
    pct exec $vmid -- ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n1
}

# Function to get current tags of an LXC container
get_current_tags() {
    local vmid=$1
    pvesh get /nodes/localhost/lxc/$vmid/config | grep -oP '(?<=tags: ).*' || echo ""
}

# Function to add or update tag for an LXC container
update_tag() {
    local vmid=$1
    local ip=$2
    local dry_run=$3
    local current_tags=$(get_current_tags $vmid)
    
    # Remove any existing IP tag
    current_tags=$(echo "$current_tags" | sed -E 's/(^|,)ip:[^,]*(,|$)/\1\2/g' | sed 's/^,//;s/,$//')
    
    # Add new IP tag
    if [ -z "$current_tags" ]; then
        new_tags="ip:$ip"
    else
        new_tags="${current_tags},ip:$ip"
    fi
    
    # Remove any double commas that might have been introduced
    new_tags=$(echo "$new_tags" | sed 's/,,/,/g' | sed 's/^,//;s/,$//')
    
    if [ "$dry_run" = true ]; then
        echo "  Would update tags to: $new_tags"
    else
        pvesh set /nodes/localhost/lxc/$vmid/config --tags "$new_tags"
        echo "  Tags updated to: $new_tags"
    fi
}

# Main script
echo "Starting LXC IP tagging process..."

# Check for dry run flag
dry_run=false
if [ "$1" = "--dry-run" ]; then
    dry_run=true
    echo "Running in dry run mode. No changes will be made."
fi

# Get list of LXC containers
lxc_list=$(pct list | tail -n +2)

while IFS= read -r line; do
    vmid=$(echo "$line" | awk '{print $1}')
    status=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | awk '{$1=$2=""; print $0}' | sed 's/^ *//')
    
    echo "Processing LXC $vmid ($name) - Status: $status"
    
    if [ "$status" = "running" ]; then
        ip=$(get_lxc_ip $vmid)
        if [ -n "$ip" ]; then
            echo "  IP address: $ip"
            update_tag $vmid $ip $dry_run
        else
            echo "  Unable to retrieve IP address."
        fi
    else
        echo "  Container not running. Skipping IP retrieval and tag update."
    fi
done <<< "$lxc_list"

echo "LXC IP tagging process completed."
