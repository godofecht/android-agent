#!/data/data/com.termux/files/usr/bin/bash
#
# Android Build Script - Build APK on VPS and install on device
#
# Usage: ./builder.sh [app_name] [vps_ip] [vps_password]
#

set -e

# Configuration
APP_NAME="${1:-SquareApp}"
VPS_IP="${2:-93.127.202.196}"
VPS_USER="${3:-root}"
VPS_PASSWORD="${AISSH_HOSTINGER_PWD:-}"
LOCAL_OUTPUT="$HOME/${APP_NAME}-debug.apk"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check dependencies
check_deps() {
    command -v sshpass >/dev/null 2>&1 || { log_error "sshpass not found. Install: pkg install sshpass"; exit 1; }
    command -v adb >/dev/null 2>&1 || { log_error "adb not found. Install: pkg install android-tools"; exit 1; }
    [ -n "$VPS_PASSWORD" ] || { log_error "VPS_PASSWORD or AISSH_HOSTINGER_PWD not set"; exit 1; }
}

# Create Android project on VPS
create_project() {
    log_info "Creating Android project on VPS..."
    
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" << 'VPS_SCRIPT'
set -e
APP_DIR="/root/SquareApp"

# Create directory structure
mkdir -p $APP_DIR/app/src/main/java/com/example/squareapp
mkdir -p $APP_DIR/app/src/main/res/layout
mkdir -p $APP_DIR/app/src/main/res/values
mkdir -p $APP_DIR/gradle/wrapper

# settings.gradle
cat > $APP_DIR/settings.gradle << 'EOF'
rootProject.name = "SquareApp"
include 'app'
EOF

# Root build.gradle
cat > $APP_DIR/build.gradle << 'EOF'
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath "com.android.tools.build:gradle:8.1.0"
    }
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF

# gradle.properties
cat > $APP_DIR/gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.suppressUnsupportedCompileSdk=34
EOF

# App build.gradle
cat > $APP_DIR/app/build.gradle << 'EOF'
plugins { id 'com.android.application' }
android {
    namespace 'com.example.squareapp'
    compileSdk 34
    defaultConfig {
        applicationId "com.example.squareapp"
        minSdk 24
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release { minifyEnabled false }
    }
}
dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
}
EOF

# AndroidManifest.xml
cat > $APP_DIR/app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:allowBackup="true"
        android:label="SquareApp"
        android:theme="@style/Theme.AppCompat.Light">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

# MainActivity.java - draws a blue square
cat > $APP_DIR/app/src/main/java/com/example/squareapp/MainActivity.java << 'EOF'
package com.example.squareapp;
import android.app.Activity;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(new SquareView(this));
    }

    static class SquareView extends View {
        private Paint paint;
        public SquareView(Context context) {
            super(context);
            paint = new Paint();
            paint.setColor(Color.BLUE);
            paint.setStyle(Paint.Style.FILL);
        }
        @Override
        protected void onDraw(Canvas canvas) {
            super.onDraw(canvas);
            canvas.drawColor(Color.WHITE);
            int size = Math.min(getWidth(), getHeight()) / 2;
            int left = (getWidth() - size) / 2;
            int top = (getHeight() - size) / 2;
            canvas.drawRect(left, top, left + size, top + size, paint);
        }
    }
}
EOF

# gradle-wrapper.properties
cat > $APP_DIR/gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

log_info "Project created at $APP_DIR"
VPS_SCRIPT
}

# Build APK on VPS
build_apk() {
    log_info "Building APK on VPS..."
    
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" << 'VPS_SCRIPT'
set -e
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/34.0.0:/opt/gradle-8.0/bin

cd /root/SquareApp
/opt/gradle-8.0/bin/gradle assembleDebug --no-daemon

echo "Build complete!"
ls -la /root/SquareApp/app/build/outputs/apk/debug/
VPS_SCRIPT
}

# Download APK
download_apk() {
    log_info "Downloading APK..."
    
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" \
        "cat /root/SquareApp/app/build/outputs/apk/debug/app-debug.apk" > "$LOCAL_OUTPUT"
    
    log_info "APK downloaded to: $LOCAL_OUTPUT"
    ls -la "$LOCAL_OUTPUT"
}

# Install via ADB
install_apk() {
    log_info "Installing APK via ADB..."
    
    # Try to connect to wireless debugging
    adb devices >/dev/null 2>&1
    
    # Check for connected devices
    DEVICE_COUNT=$(adb devices | grep -v "List of devices" | grep -v "^$" | wc -l)
    
    if [ "$DEVICE_COUNT" -eq 0 ]; then
        log_warn "No ADB devices connected."
        log_info "To enable wireless debugging:"
        log_info "  1. Settings > About Phone > Tap 'Build Number' 7x"
        log_info "  2. Settings > Developer Options > Enable 'Wireless Debugging'"
        log_info "  3. Run: adb connect DEVICE_IP:PORT"
        log_info ""
        log_info "Or manually install: cp $LOCAL_OUTPUT ~/storage/downloads/"
        
        # Copy to downloads as fallback
        if [ -d ~/storage/downloads ]; then
            cp "$LOCAL_OUTPUT" ~/storage/downloads/
            log_info "APK copied to Downloads folder for manual install"
        fi
    else
        log_info "Found device(s):"
        adb devices
        
        # Install
        adb install -r "$LOCAL_OUTPUT" && log_info "Installation complete!" || log_error "Installation failed"
    fi
}

# Main
main() {
    log_info "=== Android Build Script ==="
    log_info "App: $APP_NAME"
    log_info "VPS: $VPS_USER@$VPS_IP"
    
    check_deps
    create_project
    build_apk
    download_apk
    install_apk
    
    log_info "=== Done ==="
}

main "$@"
