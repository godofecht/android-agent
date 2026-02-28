# Android Agent

Qwen Code skills for Android/Termux environments.

## Skills

### SSH
VPS connectivity and remote command execution via SSH.

- Connect to servers using password or key authentication
- Execute remote commands
- Manage SSH keys and ssh-agent
- Auto-load credentials from environment variables

## Setup

```bash
# Install dependencies
pkg install openssh sshpass

# Clone skills to Qwen directory
cp -r ssh ~/.qwen/skills/
```

## Configuration

Add credentials to `~/.zshrc` or `~/.zhrc`:

```bash
export AISSH_HOSTINGER_PWD="your-password"
```

## Usage

Once the skill is loaded, you can:
- SSH into your VPS: `ssh root@93.127.202.196`
- Run remote commands: `ssh root@93.127.202.196 "uptime"`
- Manage SSH keys via ssh-agent

## License

MIT
