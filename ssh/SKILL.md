# SSH Skill for Termux/Android

SSH connectivity skill for Android/Termux environments.

## Capabilities

- Connect to VPS servers via SSH using password or key authentication
- Execute remote commands on VPS
- Manage SSH keys and ssh-agent
- Auto-load credentials from environment variables (`.zshrc`, `.zhrc`)
- Fix Termux permission issues for git/SSH tools

## Credentials

Reads from environment variables:
- `AISSH_HOSTINGER_PWD` - Hostinger VPS password
- SSH keys in `~/.ssh/`

## Setup & Permissions

### Install dependencies
```bash
pkg install openssh sshpass git
```

### Fix Termux permissions (required for git/SSH)
```bash
chmod +x /data/data/com.termux/files/usr/bin/git
chmod +x /data/data/com.termux/files/usr/libexec/git-core/git
```

### Start ssh-agent
```bash
ssh-agent -s
# Then set SSH_AUTH_SOCK from output
```

### Add key to agent
```bash
ssh-add ~/.ssh/id_ed25519
```

## Usage

### Connect and run command
```
ssh root@93.127.202.196 "uptime"
```

### Interactive session
```
ssh root@93.127.202.196
```

### Using ssh-agent
```
SSH_AUTH_SOCK=~/.ssh/agent/<socket> ssh user@host
```

### With password (sshpass)
```
sshpass -p 'PASSWORD' ssh root@host
```

## Known Hosts

| Host | IP | User | Credential |
|------|-----|------|------------|
| hostinger | 93.127.202.196 | root | AISSH_HOSTINGER_PWD |

## Dependencies

- `openssh` - SSH client
- `sshpass` - Password-based SSH
- `git` - Version control (needs permission fix on Termux)

## Troubleshooting

### Permission denied (git)
```bash
chmod +x /data/data/com.termux/files/usr/libexec/git-core/git
```

### Key not accepted
```bash
ssh-add -l  # Check loaded keys
ssh-add ~/.ssh/id_ed25519  # Add key
```

### Connection refused
- Verify VPS is running
- Check SSH port (default: 22)
- Ensure credentials are correct
