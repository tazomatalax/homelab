# Proxmox LXC IP Tagger

This bash script automatically tags Proxmox LXC containers with their current IP addresses. It's designed to work directly on a Proxmox host, making it easy to identify and manage your containers.

## Features

- Retrieves IP addresses for all running LXC containers
- Adds or updates an 'ip' tag for each container with its current IP address
- Preserves existing tags, only modifying the 'ip' tag
- Includes a dry run mode for safely previewing changes

## Prerequisites

- Access to a Proxmox host with sudo privileges
- Bash shell
- Standard Proxmox utilities (`pct`, `pvesh`)

## Usage

1. Clone this repository or download the script to your Proxmox host.

2. Make the script executable:
   ```
   chmod +x lxc_ip_tagger.sh
   ```

3. Run the script in dry run mode to preview changes:
   ```
   sudo ./lxc_ip_tagger.sh --dry-run
   ```

4. If the dry run output looks correct, run the script to apply changes:
   ```
   sudo ./lxc_ip_tagger.sh
   ```

## Important Notes

- This script only updates tags for running containers.
- Existing tags are preserved; only the 'ip' tag is added or updated.
- Always run in dry run mode first to verify the expected changes.
- Ensure you have a recent backup of your Proxmox configuration before making changes.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](link-to-your-issues-page).

## License

This project is licensed under the MIT License - see the [LICENSE](link-to-your-license-file) file for details.

## Disclaimer

This script is provided as-is, without any warranties. Always test in a non-production environment first and ensure you have backups before running on a production system.
