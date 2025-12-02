🧰 Toolbar Toggle Manager for Directory Opus
Restore all your custom toolbars with one hotkey — finally tame the toolbar chaos!  
🔗 GitHub Repo

🚀 Overview
Directory Opus is powerful, but it has one frustrating limitation:  
When you manually close and re-enable a toolbar, it reappears in its default location — not where you last placed it. 😤

This script fixes that.  
With Toolbar Toggle Manager, you can restore your entire toolbar layout instantly using a single hotkey. Just configure it once — and it takes over from there. 🎯

🛠️ What It Does
- ✅ Restores all toolbars to their predefined positions  
- ✅ Supports tree-following toolbars (STATE=tree) with correct docking  
- ✅ Provides a command to preview all configured toolbars in a floating dialog  
- ✅ Includes debug logging to help troubleshoot command execution  
- ✅ Works with Directory Opus 13+

📦 Included Commands
| Command Name         | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| RestoreAllToolbars | Executes all toolbar commands in sequence (with a 50ms delay)               |
| ShowToolbarCommands| Displays a dialog listing all configured toolbar commands for quick review  |

📖 How To Use

---

🧭 Configuration Guide
The Toolbar Toggle Manager is a Directory Opus script that helps you manage toolbar visibility by storing predefined commands. It's particularly useful for restoring your preferred toolbar layout with a single command.

---

⚙️ Basic Configuration
Access the configuration through:  
Settings > Preferences > Toolbars > Scripts > Toolbar Toggle Manager

---

📝 Configuration Format
In the ToolbarCommands field, add one toolbar per line using this format:  
`
DisplayName|Toolbar Command
`

---

🧪 Common Toolbar Commands
Standard Toolbars:  
`
Header|Toolbar NAME=Header STATE=top LINE=0  
Menu|Toolbar NAME=Menu STATE=top LINE=1  
Operations|Toolbar NAME=Operations STATE=top LINE=2  
File Display|Toolbar NAME="File Display" STATE=bottom
`

Tree-Following Toolbar (Special Case):  
`
Pic|Toolbar NAME=Pic STATE=tree,bottom LINE=4
`

---

🌳 Understanding STATE=tree Toolbars
When you use STATE=tree, the toolbar is docked to the folder tree panel rather than the main lister window. This makes it follow the tree panel wherever it goes.

STATE Options for Tree-Docked Toolbars:  
- STATE=tree — Docks vertically to the side of the tree (default)  
- STATE=tree,bottom — Docks horizontally at the bottom of the tree panel ✅  
- STATE=tree,top — Docks horizontally at the top of the tree panel  
- STATE=tree,left — Docks vertically to the left of the tree panel  
- STATE=tree,right — Docks vertically to the right of the tree panel

---

🔢 LINE Parameter
- LINE=4 — Sets the order/position when multiple toolbars share the same docking area  
- Lower numbers appear first (closer to edge)

---

🧾 Example Configuration
`
Header|Toolbar NAME=Header STATE=top LINE=0  
Menu|Toolbar NAME=Menu STATE=top LINE=1  
Operations|Toolbar NAME=Operations STATE=top LINE=2  
Pic Toolbar|Toolbar NAME=Pic STATE=tree,bottom LINE=4  
File Display|Toolbar NAME="File Display" STATE=bottom
`

---

🧨 Using the Commands
The script provides two commands:  
- RestoreAllToolbars — Executes all configured toolbar commands at once  
- ShowToolbarCommands — Displays your current configuration in a dialog

---

💡 Tips
- Do not use TOGGLE — this ensures toolbars are always shown, even if they were accidentally closed  
- Toolbar names with spaces need quotes: NAME="File Display"  
- The LINE parameter determines stacking order for overlapping positions  
- A 50ms delay between commands (built into the script) ensures proper execution  
- Enable debug logging (DebugLevel = 1 or 2) to troubleshoot command execution

---
