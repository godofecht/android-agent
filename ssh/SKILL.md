# SSH Skill for Termux/Android

SSH connectivity skill for Android/Termux environments.

## Capabilities

- Connect to VPS servers via SSH using password or key authentication
- Execute remote commands on VPS
- Manage SSH keys and ssh-agent
- Auto-load credentials from environment variables (`.zshrc`, `.zhrc`)

## Credentials

Reads from environment variables:
- `AISSH_HOSTINGER_PWD` - Hostinger VPS password
- SSH keys in `~/.ssh/`

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
ssh-agent -s
ssh-add ~/.ssh/id_ed25519
ssh user@host
```

## Known Hosts

| Host | IP | User | Credential |
|------|-----|------|------------|
| hostinger | 93.127.202.196 | root | AISSH_HOSTINGER_PWD |

## Dependencies

- `openssh` - SSH client
- `sshpass` - Password-based SSH (install: `pkg install sshpass`)
