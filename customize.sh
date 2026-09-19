#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#                 TERMUX UBUNTU SETUP
# ============================================================
#
# Features:
#   - Ubuntu terminal colors
#   - Ubuntu Mono Nerd Font
#   - lsd with icons
#   - Git
#   - Figlet + ANSI-Shadow
#   - Toilet
#   - Lolcat
#   - Custom startup banner
#   - Custom Git-aware prompt
#   - Custom ls aliases
#   - Removes default Termux MOTD
#
# ============================================================

set -e

# ============================================================
# COLORS
# ============================================================

GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
RESET='\033[0m'

info() {
    echo -e "${CYAN}[+]${RESET} $1"
}

success() {
    echo -e "${GREEN}[✓]${RESET} $1"
}

warning() {
    echo -e "${YELLOW}[!]${RESET} $1"
}

error() {
    echo -e "${RED}[✗]${RESET} $1"
}

section() {
    echo
    echo -e "${BLUE}================================================${RESET}"
    echo -e "${WHITE}$1${RESET}"
    echo -e "${BLUE}================================================${RESET}"
    echo
}


# ============================================================
# TERMUX CHECK
# ============================================================

section "TERMUX UBUNTU SETUP"

if [ -z "$PREFIX" ] || [ ! -d "$PREFIX" ]; then
    error "This script must be executed inside Termux."
    exit 1
fi

success "Termux environment detected."


# ============================================================
# 1. UPDATE AND UPGRADE
# ============================================================

section "UPDATING TERMUX"

info "Updating package repositories..."

pkg update -y

info "Upgrading installed packages..."

pkg upgrade -y

success "Termux packages updated."


# ============================================================
# 2. INSTALL REQUIRED PACKAGES
# ============================================================

section "INSTALLING REQUIRED PACKAGES"

info "Installing Git, lsd, Figlet, Toilet, Curl and Unzip..."

pkg install -y \
    git \
    lsd \
    figlet \
    toilet \
    curl \
    unzip

success "Required packages installed."


# ============================================================
# 3. INSTALL RUBY
# ============================================================

section "INSTALLING RUBY"

info "Installing Ruby..."

pkg install -y ruby

success "Ruby installed."


# ============================================================
# 4. INSTALL LOLCAT
# ============================================================

section "INSTALLING LOLCAT"

info "Installing lolcat through RubyGems..."

gem install lolcat --no-document

success "lolcat installed."


# ============================================================
# 5. CONFIGURE UBUNTU COLORS
# ============================================================

section "CONFIGURING UBUNTU COLORS"

mkdir -p "$HOME/.termux"

cat > "$HOME/.termux/colors.properties" <<'EOF'
background=#300A24
foreground=#FFFFFF

color0=#2E3436
color1=#CC0000
color2=#4E9A06
color3=#C4A000
color4=#3465A4
color5=#75507B
color6=#06989A
color7=#D3D7CF
color8=#555753
color9=#EF2929
color10=#8AE234
color11=#FCE94F
color12=#729FCF
color13=#AD7FA8
color14=#34E2E2
color15=#EEEEEC
EOF

success "Ubuntu color scheme configured."


# ============================================================
# 6. INSTALL UBUNTU MONO NERD FONT
# ============================================================

section "INSTALLING UBUNTU MONO NERD FONT"

FONT_DIR="$HOME/.termux/fonts"
FONT_ZIP="$HOME/UbuntuMono.zip"
FONT_FILE="$HOME/.termux/font.ttf"

mkdir -p "$FONT_DIR"

info "Downloading Ubuntu Mono Nerd Font..."

curl -L --fail \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip" \
    -o "$FONT_ZIP"

success "Ubuntu Mono Nerd Font downloaded."

info "Extracting font..."

rm -rf "$FONT_DIR"/*
unzip -o "$FONT_ZIP" -d "$FONT_DIR" >/dev/null

# Find the regular Nerd Font
NERD_FONT=$(find "$FONT_DIR" -type f \
    \( -iname "UbuntuMonoNerdFont-Regular.ttf" \
    -o -iname "UbuntuMonoNerdFontMono-Regular.ttf" \
    -o -iname "*UbuntuMono*NerdFont*Regular.ttf" \) \
    | head -n 1)

if [ -z "$NERD_FONT" ]; then
    error "Ubuntu Mono Nerd Font could not be found after extraction."
    echo
    echo "Available fonts:"
    find "$FONT_DIR" -type f -name "*.ttf"
    exit 1
fi

cp "$NERD_FONT" "$FONT_FILE"

chmod 644 "$FONT_FILE"

success "Ubuntu Mono Nerd Font configured."

# Remove downloaded archive
rm -f "$FONT_ZIP"


# ============================================================
# 7. REMOVE DEFAULT TERMUX MOTD
# ============================================================

section "REMOVING DEFAULT MOTD"

info "Removing Termux default welcome message..."

rm -f "$PREFIX/etc/motd"

success "Default Termux MOTD removed."


# ============================================================
# 8. ASK FOR USERNAME
# ============================================================

section "USERNAME SETUP"

while true; do

    #read -rp "Enter your username (maximum 6 characters): " USERNAME
    read -rp "Enter your username (maximum 6 characters): " USERNAME </dev/tty

    # Empty
    if [ -z "$USERNAME" ]; then
        error "Username cannot be empty."
        continue
    fi

    # Maximum 6 characters
    if [ "${#USERNAME}" -gt 6 ]; then
        error "Username must not exceed 6 characters."
        continue
    fi

    # Allowed characters
    if [[ ! "$USERNAME" =~ ^[a-zA-Z0-9_]+$ ]]; then
        error "Use only letters, numbers and underscore."
        continue
    fi

    break

done

success "Username set to: $USERNAME"


# ============================================================
# 9. REPLACE FIGLET DIRECTORY
# ============================================================

section "INSTALLING CUSTOM FIGLET FONTS"

FIGLET_DIR="$PREFIX/share/figlet"

info "FIGlet directory:"
echo "    $FIGLET_DIR"

if [ -d "$FIGLET_DIR" ]; then
    warning "Removing existing FIGlet directory..."
    rm -rf "$FIGLET_DIR"
fi

info "Cloning custom FIGlet repository..."

git clone \
    "https://github.com/Sepatu-Bot/figlet.git" \
    "$FIGLET_DIR"

success "Custom FIGlet repository installed."


# ============================================================
# 10. VERIFY ANSI-SHADOW
# ============================================================

section "VERIFYING ANSI-SHADOW"

ANSI_SHADOW="$FIGLET_DIR/ANSI-Shadow.flf"

if [ ! -f "$ANSI_SHADOW" ]; then
    error "ANSI-Shadow.flf was not found."
    echo
    echo "Expected:"
    echo "$ANSI_SHADOW"
    exit 1
fi

chmod 644 "$ANSI_SHADOW"

success "ANSI-Shadow.flf found."

info "Testing ANSI-Shadow..."

if ! figlet -f ANSI-Shadow "TEST" >/dev/null 2>&1; then
    error "FIGlet failed to load ANSI-Shadow."
    exit 1
fi

success "ANSI-Shadow works correctly."


# ============================================================
# 11. BACKUP BASHRC
# ============================================================

section "CONFIGURING BASH"

BASHRC="$HOME/.bashrc"

touch "$BASHRC"

BACKUP="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"

cp "$BASHRC" "$BACKUP"

success "Backup created:"
echo "    $BACKUP"


# ============================================================
# 12. REMOVE PREVIOUS INSTALLER CONFIGURATION
# ============================================================

info "Removing previous Termux Ubuntu configuration..."

sed -i \
'/# === TERMUX UBUNTU SETUP START ===/,/# === TERMUX UBUNTU SETUP END ===/d' \
"$BASHRC"


# ============================================================
# 13. WRITE NEW BASH CONFIGURATION
# ============================================================

info "Writing new Bash configuration..."

cat >> "$BASHRC" <<EOF

# ============================================================
# === TERMUX UBUNTU SETUP START ===
# ============================================================

# ------------------------------------------------------------
# Username
# ------------------------------------------------------------

export TERMUX_USERNAME="$USERNAME"


# ------------------------------------------------------------
# Startup Banner
# ------------------------------------------------------------

if command -v figlet >/dev/null 2>&1 && \
   command -v lolcat >/dev/null 2>&1; then

    clear

    figlet -f ANSI-Shadow "\$TERMUX_USERNAME" | lolcat

fi


# ------------------------------------------------------------
# LSD
# ------------------------------------------------------------

# Use lsd instead of traditional ls
alias ls='lsd --icon always --group-dirs first'

# Long listing
alias ll='lsd -lah --icon always --group-dirs first'

# Show hidden files
alias la='lsd -A --icon always --group-dirs first'

# Short listing
alias l='lsd -l --icon always --group-dirs first'


# ------------------------------------------------------------
# Git branch detection
# ------------------------------------------------------------

parse_git_branch() {
    git branch --show-current 2>/dev/null
}


# ------------------------------------------------------------
# Custom Prompt
# ------------------------------------------------------------

update_prompt() {

    local git_branch
    git_branch=\$(parse_git_branch)

    if [ -n "\$git_branch" ]; then

        PS1='\\[\\e[1;32m\\]┌──[\\[\\e[1;36m\\]\${TERMUX_USERNAME}\\[\\e[1;32m\\]@termux] [\\[\\e[1;31m\\]git:\\[\\e[1;33m\\]\${git_branch}\\[\\e[1;32m\\]]
\\[\\e[1;32m\\]└──[\\[\\e[1;33m\\]\\w\\[\\e[1;32m\\]] \\[\\e[1;37m\\]\\$ \\[\\e[0m\\]'

    else

        PS1='\\[\\e[1;32m\\]┌──[\\[\\e[1;36m\\]\${TERMUX_USERNAME}\\[\\e[1;32m\\]@termux]
\\[\\e[1;32m\\]└──[\\[\\e[1;33m\\]\\w\\[\\e[1;32m\\]] \\[\\e[1;37m\\]\\$ \\[\\e[0m\\]'

    fi
}


# ------------------------------------------------------------
# Update prompt before every command
# ------------------------------------------------------------

PROMPT_COMMAND=update_prompt


# ============================================================
# === TERMUX UBUNTU SETUP END ===
# ============================================================

EOF

success ".bashrc configured."


# ============================================================
# 14. TEST LSD ICON SUPPORT
# ============================================================

section "TESTING LSD ICONS"

info "Testing lsd..."

if lsd --icon always >/dev/null 2>&1; then
    success "lsd icon support is available."
else
    warning "lsd test returned an error."
fi


# ============================================================
# 15. RELOAD TERMUX SETTINGS
# ============================================================

section "RELOADING TERMUX"

if command -v termux-reload-settings >/dev/null 2>&1; then
    termux-reload-settings
    success "Termux settings reloaded."
else
    warning "termux-reload-settings is unavailable."
fi


# ============================================================
# 16. CLEANUP
# ============================================================

info "Cleaning temporary files..."

rm -rf "$FONT_DIR"

success "Cleanup complete."


# ============================================================
# FINAL
# ============================================================

section "SETUP COMPLETE"

echo -e "${GREEN}Username :${RESET} $USERNAME"
echo -e "${GREEN}Theme    :${RESET} Ubuntu"
echo -e "${GREEN}Font     :${RESET} Ubuntu Mono Nerd Font"
echo -e "${GREEN}FIGlet   :${RESET} ANSI-Shadow"
echo -e "${GREEN}Banner   :${RESET} FIGlet + lolcat"
echo -e "${GREEN}ls       :${RESET} lsd + icons"
echo -e "${GREEN}Git      :${RESET} Git-aware prompt"
echo

echo "Available commands:"
echo
echo "  ls     → lsd with icons"
echo "  ll     → detailed listing"
echo "  la     → hidden files"
echo "  l      → short listing"
echo

echo "Your new prompt will look like:"
echo
echo "┌──[${USERNAME}@termux]"
echo "└──[~/directory] \$"
echo

echo "Inside Git:"
echo
echo "┌──[${USERNAME}@termux] [git:main]"
echo "└──[~/project] \$"
echo

echo "Restart Termux to apply everything."
echo

echo "================================================"
