# Terminal App Skill - Android Terminal with SSH/Mosh

Build a terminal emulator app for Android with SSH and Mosh support.

## Features

- **Terminal UI** - Dark theme with green monospace text
- **Local Commands** - Execute shell commands on device
- **SSH Connect** - One-tap SSH to VPS
- **Quick Commands** - Preset buttons (uptime, df, free, whoami)
- **Mosh Support** - Mobile shell for roaming connections (via VPS)

## Quick Start

### Build on VPS
```bash
export AISSH_HOSTINGER_PWD="your-password"
~/.qwen/skills/android-build/builder.sh TerminalApp
```

### Install
APK downloaded to: `/sdcard/Download/TerminalApp-debug.apk`

## VPS Mosh Setup

Install mosh on VPS:
```bash
ssh root@93.127.202.196 "apt-get update && apt-get install -y mosh"
```

Connect from terminal app:
```bash
mosh root@93.127.202.196
```

## App Architecture

```
TerminalApp/
├── app/src/main/
│   ├── java/com/example/terminal/
│   │   └── MainActivity.java    # Terminal emulator + SSH
│   ├── res/layout/
│   │   └── activity_main.xml    # Terminal UI layout
│   └── AndroidManifest.xml
├── app/build.gradle
└── build.gradle
```

## UI Components

| Component | Description |
|-----------|-------------|
| Terminal Output | Scrollable TextView with monospace font |
| Command Input | EditText for entering commands |
| Connect Button | SSH to pre-configured VPS |
| Clear Button | Clear terminal output |
| Quick Cmd Buttons | One-tap common commands |

## Customization

### Change VPS Connection
Edit `MainActivity.java`:
```java
private static final String VPS_HOST = "your.vps.ip";
private static final String VPS_USER = "root";
private static final String VPS_PASS = "your-password";
```

### Add Quick Commands
Edit `activity_main.xml` and `MainActivity.java`:
```java
quickCmd5.setOnClickListener(v -> runQuickCommand("top -n 5"));
```

### Enable Mosh
Add mosh button in `MainActivity.java`:
```java
private void connectMosh() {
    appendOutput("\nStarting mosh session...\n");
    // Execute: mosh root@VPS_HOST
}
```

## Known Hosts

| Host | IP | User | Credential |
|------|-----|------|------------|
| hostinger | 93.127.202.196 | root | AISSH_HOSTINGER_PWD |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| SSH not found | Install sshpass: `pkg install sshpass` |
| Connection refused | Check VPS is running, SSH port 22 |
| Permission denied | Verify password in AISSH_HOSTINGER_PWD |
| Mosh not working | Install mosh on VPS: `apt install mosh` |

## Files

- `SKILL.md` - This documentation
- `builder.sh` - Build script (in android-build skill)
- `MainActivity.java` - Terminal app source

## License

MIT
