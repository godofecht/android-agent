# Android Build Skill for Termux/Android

Build Android apps on a remote VPS and install them on your Android device.

## Capabilities

- Set up Android SDK on remote VPS
- Create simple Android apps programmatically
- Build APKs using Gradle on VPS
- Download APK to local device
- Install APK via ADB (wireless or USB)

## Prerequisites

### VPS Setup (automated)
```bash
# Java + Android SDK
apt-get update && apt-get install -y openjdk-17-jdk wget unzip
mkdir -p /opt/android-sdk/cmdline-tools
cd /opt/android-sdk/cmdline-tools
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip -q cmdline-tools.zip && mv cmdline-tools latest
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
yes | sdkmanager --licenses
sdkmanager 'platform-tools' 'platforms;android-34' 'build-tools;34.0.0'

# Gradle
cd /opt && wget -q https://services.gradle.org/distributions/gradle-8.0-bin.zip
unzip -q gradle-8.0-bin.zip && rm gradle-8.0-bin.zip
export PATH=$PATH:/opt/gradle-8.0/bin
```

### Local Setup (Termux)
```bash
pkg install android-tools openssh sshpass
```

## Credentials

Reads from environment variables:
- `AISSH_HOSTINGER_PWD` - VPS password (or use SSH keys)

## Usage

### Build and Install Flow

1. **Build APK on VPS:**
```bash
sshpass -p 'PASSWORD' ssh root@VPS_IP "
  export ANDROID_HOME=/opt/android-sdk
  export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/build-tools/34.0.0:/opt/gradle-8.0/bin
  cd /root/SquareApp && /opt/gradle-8.0/bin/gradle assembleDebug --no-daemon
"
```

2. **Download APK:**
```bash
sshpass -p 'PASSWORD' ssh root@VPS_IP "cat /root/SquareApp/app/build/outputs/apk/debug/app-debug.apk" > ~/app-debug.apk
```

3. **Install via ADB:**
```bash
# Wireless debugging
adb connect DEVICE_IP:5555
adb install ~/app-debug.apk

# Or copy to downloads for manual install
cp ~/app-debug.apk ~/storage/downloads/
```

### Enable Wireless Debugging on Android

1. Settings > About Phone > Tap "Build Number" 7 times
2. Settings > System > Developer Options
3. Enable "Wireless Debugging"
4. Note IP address and port (e.g., 192.168.1.100:37849)
5. Connect: `adb connect 192.168.1.100:37849`

## Known Hosts

| Host | IP | User | Credential |
|------|-----|------|------------|
| hostinger | 93.127.202.196 | root | AISSH_HOSTINGER_PWD |

## Example: Create Square App

Project structure:
```
/root/SquareApp/
├── settings.gradle
├── build.gradle (root)
├── gradle.properties
├── app/
│   ├── build.gradle
│   └── src/main/
│       ├── AndroidManifest.xml
│       └── java/com/example/squareapp/
│           └── MainActivity.java
└── gradle/wrapper/
    └── gradle-wrapper.properties
```

MainActivity.java draws a blue square on white background.

## Troubleshooting

### ADB: Device unauthorized
- Check phone for "Allow USB debugging?" prompt
- Enable "Always allow from this computer"

### ADB: No devices
- Enable Wireless Debugging in Developer Options
- Run `adb connect IP:PORT`

### Build fails
- Check ANDROID_HOME and PATH
- Ensure SDK licenses accepted
- Run `gradle clean assembleDebug`

### VPS permission denied
- Use SSH keys instead of password
- Ensure root access on VPS

## Files

- `SKILL.md` - This skill definition
- `builder.sh` - Automated build script
- `install.sh` - ADB install script

## License

MIT
