# Termux Ubuntu Style Setup

A Bash installer that transforms a fresh Termux installation into a customized Ubuntu-style terminal environment.

It provides an Ubuntu-inspired color scheme, Ubuntu Mono Nerd Font, `lsd` file icons, a custom ANSI-Shadow startup banner, `lolcat` colors, and a Git-aware Bash prompt.

> Designed for **Termux on Android**.

---

## Features

- Ubuntu-inspired terminal color scheme
- Ubuntu Mono Nerd Font
- Nerd Font icons for `lsd`
- Custom FIGlet `ANSI-Shadow` font
- Animated/colorful `lolcat` startup banner
- Custom two-line Bash prompt
- Current working directory in the prompt
- Automatic Git branch detection
- `ls` → `lsd`
- `ll` → detailed `lsd` listing
- `la` → hidden files
- `l` → short listing
- Removes the default Termux MOTD
- Installs required packages automatically
- Backs up the existing `.bashrc`
- Safe to run again without duplicating the configuration

---

## Preview

The startup banner uses the custom `ANSI-Shadow` FIGlet font:

```text
██╗  ██╗ █████╗ ██████╗  ██████╗
██║  ██║██╔══██╗██╔══██╗██╔════╝
███████║███████║██████╔╝██║  ███╗
██╔══██║██╔══██║██╔══██╗██║   ██║
██║  ██║██║  ██║██║  ██║╚██████╔╝
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

The banner is piped through lolcat for a colorful gradient.


---

Custom Prompt

The Bash prompt displays the configured username and current directory:

┌──[user@termux]
└──[~/projects] $

Inside a Git repository, the current branch is also displayed:

┌──[user@termux] [git:main]
└──[~/projects/myapp] $

Changing branches automatically updates the prompt:

┌──[user@termux] [git:develop]
└──[~/projects/myapp] $


---

LSD Icons

The installer installs an Ubuntu Mono Nerd Font so that lsd can display file-type icons.

The following aliases are configured:

Command	Description

ls	lsd with icons
ll	Detailed listing with icons
la	Show hidden files
l	Short listing


Example:

ls

The output will include Nerd Font icons for supported file types.


---

Requirements

You need:

Android

Termux

Internet connection


The script must be executed inside Termux.

For the official Termux project and installation information, see:

https://github.com/termux/termux-app


---

Installation

One-line installation

Run the following command inside Termux:

curl -fsSL https://raw.githubusercontent.com/Sepatu-Bot/<repo-name>/main/setup.sh | bash

Replace <repo-name> with the actual repository name.

For example, if the repository is:

https://github.com/Sepatu-Bot/termux-ubuntu

the command becomes:

curl -fsSL https://raw.githubusercontent.com/Sepatu-Bot/termux-ubuntu/main/setup.sh | bash

Recommended installation

For users who want to inspect the script before executing it:

git clone https://github.com/Sepatu-Bot/<repo-name>.git
cd <repo-name>
chmod +x setup.sh
./setup.sh


---

What the Installer Does

1. Updates Termux

pkg update -y
pkg upgrade -y

2. Installs required packages

git
lsd
figlet
toilet
curl
unzip
ruby

It also installs:

lolcat

through RubyGems.

3. Configures the Ubuntu color scheme

The configuration is written to:

~/.termux/colors.properties

4. Installs Ubuntu Mono Nerd Font

The Nerd Font version is used because lsd requires Nerd Font glyphs for its file icons.

The active Termux font is installed as:

~/.termux/font.ttf

5. Removes the default Termux MOTD

The default welcome message is removed from:

$PREFIX/etc/motd

6. Installs the custom FIGlet fonts

The installer replaces:

$PREFIX/share/figlet

with:

https://github.com/Sepatu-Bot/figlet

The custom:

ANSI-Shadow.flf

font is then verified before continuing.

7. Configures Bash

The installer modifies:

~/.bashrc

and creates a backup before making changes.

The configuration includes:

Startup banner

Username

lsd aliases

Git branch detection

Custom prompt



---

Username

During installation you will be asked for a username:

Enter your username (maximum 6 characters):

The username:

Cannot be empty

Must be 6 characters or fewer

Can contain letters

Can contain numbers

Can contain _


Example:

Abdul

or:

Sec_01


---

Configuration

The installer creates the following configuration:

export TERMUX_USERNAME="username"

LSD

alias ls='lsd --icon always --group-dirs first'
alias ll='lsd -lah --icon always --group-dirs first'
alias la='lsd -A --icon always --group-dirs first'
alias l='lsd -l --icon always --group-dirs first'

FIGlet

figlet -f ANSI-Shadow "$TERMUX_USERNAME"

Lolcat

figlet -f ANSI-Shadow "$TERMUX_USERNAME" | lolcat


---

Re-running the Installer

The installer creates a timestamped backup of your existing .bashrc:

~/.bashrc.backup.YYYYMMDD_HHMMSS

The installer also removes its previous configuration block before adding a new one.

This prevents multiple copies of the same configuration from accumulating in .bashrc.


---

Applying Changes

After installation, restart Termux.

Alternatively:

source ~/.bashrc

For font and color changes, completely close and reopen Termux if necessary.


---

Troubleshooting

Icons appear as boxes

Make sure Termux is using the installed Nerd Font.

Check:

lsd --icon always

If icons still appear incorrectly, restart Termux.


---

ANSI-Shadow cannot be loaded

Check that the font exists:

ls "$PREFIX/share/figlet/ANSI-Shadow.flf"

Test it:

figlet -f ANSI-Shadow TEST


---

Git branch does not appear

Make sure you're inside a Git repository:

git status

Then:

git branch --show-current


---

Restore the previous .bashrc

List your backups:

ls -la ~/.bashrc.backup.*

Then restore the desired backup:

cp ~/.bashrc.backup.YYYYMMDD_HHMMSS ~/.bashrc


---

Files

The main installer is:

setup.sh

The custom FIGlet font repository is:

https://github.com/Sepatu-Bot/figlet


---

Credits

Termux

https://github.com/termux/termux-app

Nerd Fonts

https://github.com/ryanoasis/nerd-fonts

LSD

https://github.com/lsd-rs/lsd

FIGlet

https://github.com/cmatsuoka/figlet

Custom FIGlet Fonts

https://github.com/Sepatu-Bot/figlet

Lolcat

https://github.com/busyloop/lolcat


---

License

Use, modify, and redistribute according to the licenses of the individual components used by this project.

The custom configuration and installer are provided as-is.

### One important recommendation for the actual repo

For the public repository, I'd structure it as:

```text
termux-ubuntu/
├── README.md
├── setup.sh
└── LICENSE

Then users only need:

curl -fsSL https://raw.githubusercontent.com/Sepatu-Bot/termux-ubuntu/main/setup.sh | bash
