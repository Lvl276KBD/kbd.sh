--❤︎ dentry — .desktop file generator ❤︎--
A #Bash script that generates .desktop files using a guided interactive prompt.

--❤︎ Overview ❤︎--

This script helps create .desktop files in:
-- ~/.local/share/applications

It also manages optional icons stored in:
-- ~/.local/share/applications/icons

It supports automatic execution handling for:
-- .sh scripts
-- .jar Java applications
-- .AppImage files
-- generic executables

--❤︎ Features ❤︎--

-- App name input
-- FZF-based file picker
-- Automatic execution type detection
-- Icon name validation
-- Overwrite capability of existing entries
-- Category + Comment support
-- Terminal support

--❤︎ Dependencies ❤︎--

Make sure these are installed:

- bash
- fzf
- findutils
- realpath
- chmod

--❤︎ Directory structure ❤︎--

~/.local/share/applications/
├── *.desktop files
└── icons/

--❤︎ Example .desktop file ❤︎--

[Desktop Entry]
Type=Application
Name=My App
Exec=python /home/user/app.py
Icon=/home/user/.local/share/applications/icons/app.png
Terminal=false
Categories=Utility;
Comment=My test application
