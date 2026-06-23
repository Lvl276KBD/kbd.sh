# ❤︎ dentry — .desktop file generator ❤︎

A Bash script that generates `.desktop` files using a guided interactive prompt.


## ❤︎ Overview

This script helps create `.desktop` files in:


~/.local/share/applications


It also manages optional icons stored in:


~/.local/share/applications/icons


It supports automatic execution handling for:

- **Shell (`.sh`)** → `bash script.sh`  
- **Java (`.jar`)** → `java -jar file.jar`  
- **AppImage (`.AppImage`)** → executable binary  
- **Python (`.py`)** → `python3 script.py`
- **Websites** → `xdg-open https://test.com`

## ❤︎ Features

- FZF-based file picker
- File type detection
- Error handling / validation
- Overwrite capability
- Category + Comment tags  
- Run in Terminal
- Website support

## ❤︎ Dependencies

Make sure these are installed:

- `bash`
- `fzf`
- `findutils`
- `realpath`
- `chmod`
- 'xdg-utils'

## ❤︎ Directory structure

```text
~/.local/share/applications/
├── *.desktop files
└── icons/
```


## ❤︎ Example `.desktop` file

```ini
[Desktop Entry]
Type=Application
Name=My App
Exec=python /home/user/app.py
Icon=/home/user/.local/share/applications/icons/app.png
Terminal=false
Categories=Utility;
Comment=My test application
