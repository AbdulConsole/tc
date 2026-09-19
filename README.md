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
```

The banner is piped through lolcat for a colorful gradient.


---

## Custom Prompt

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

## LSD Icons

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

## Requirements

You need:

Android

Termux

Internet connection


The script must be executed inside Termux.

For the official Termux project and installation information, see:

https://github.com/termux/termux-app
