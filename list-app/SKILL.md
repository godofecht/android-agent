# List App Skill - Simple Todo/List Maker

A clean, simple list-making app for Android.

## Features

- ✅ Add items to list
- ✅ Long-press to delete items
- ✅ Clear all button
- ✅ Auto-save (persists on close)
- ✅ Material Design UI

## Install

APK Location: `/sdcard/Download/ListApp-debug.apk`

## Usage

1. **Add item:** Type in text field, press Enter or tap +
2. **Delete item:** Long-press any item
3. **Clear all:** Tap trash icon in header

## UI

```
┌─────────────────────────────────┐
│ 📝 My Lists              [🗑️]  │  <- Header
├─────────────────────────────────┤
│ □ Buy groceries                 │
│ □ Walk the dog                  │
│ □ Finish homework               │
│ □ Call mom                      │
│                                 │
├─────────────────────────────────┤
│ [Add new item...     ]    [+]  │  <- Input
└─────────────────────────────────┘
```

## Data Storage

Lists are saved to internal storage:
- File: `list_data.txt`
- Location: `/data/data/com.example.listapp/files/`
- Format: Serialized ArrayList

## Build on VPS

```bash
export AISSH_HOSTINGER_PWD="your-password"
cd /root/ListApp
/opt/gradle-8.0/bin/gradle assembleDebug --no-daemon
```

## Customization

### Change theme color
Edit `activity_main.xml`:
- Header: `#6200ee` (purple)
- Add button: `#6200ee`

### Change app name
Edit `AndroidManifest.xml`:
```xml
android:label="Your App Name"
```

## Files

| File | Description |
|------|-------------|
| `MainActivity.java` | List logic + UI |
| `activity_main.xml` | Layout |
| `edittext_bg.xml` | Input field background |
| `add_btn_bg.xml` | Add button background |

## License

MIT
