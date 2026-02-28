# Android Build Skill

Build Android apps on a remote VPS and install them on your device automatically.

## Quick Start

```bash
# Run the full build + install flow
./builder.sh SquareApp 93.127.202.196

# Or with explicit password
./builder.sh SquareApp 93.127.202.196 root

# Just install an APK
./install.sh ~/SquareApp-debug.apk

# Install via wireless ADB
./install.sh ~/SquareApp-debug.apk 192.168.1.100 37849
```

## What It Does

1. **Creates** a simple Android app on your VPS (draws a blue square)
2. **Builds** the APK using Gradle on the VPS
3. **Downloads** the APK to your phone
4. **Installs** via ADB (or copies to Downloads for manual install)

## Requirements

### On VPS (Ubuntu/Debian)
- Java 17+
- Android SDK (command-line tools)
- Gradle 8.0+

### On Termux/Android
- `pkg install openssh sshpass android-tools`
- AISSH_HOSTINGER_PWD environment variable set

## Enable Wireless Debugging

1. **Enable Developer Options:**
   - Settings > About Phone
   - Tap "Build Number" 7 times

2. **Enable Wireless Debugging:**
   - Settings > System > Developer Options
   - Enable "Wireless Debugging"
   - Note the IP:PORT (e.g., 192.168.1.100:37849)

3. **Connect:**
   ```bash
   adb connect 192.168.1.100:37849
   ```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `AISSH_HOSTINGER_PWD` | VPS password for SSH |

## Files

| File | Description |
|------|-------------|
| `builder.sh` | Main build script (create + build + download + install) |
| `install.sh` | ADB install script only |
| `SKILL.md` | Full documentation |

## Customize the App

Edit `builder.sh` to change:
- App name and package
- MainActivity code (what the app does)
- Build configuration

## Troubleshooting

| Issue | Solution |
|-------|----------|
| ADB: no devices | Enable wireless debugging, run `adb connect IP:PORT` |
| Build fails | Check VPS has Android SDK installed |
| SSH failed | Verify password in AISSH_HOSTINGER_PWD |
| Install failed | Enable "Install via USB" in Developer Options |
