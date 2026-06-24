# Iniciar o Hyprland automaticamente ao logar no TTY1
if status is-login
    if test (tty) = "/dev/tty1"
        exec Hyprland
    end
end

if status is-interactive
    fastfetch
    set -g fish_greeting ''
    if type -q starship
        starship init fish | source
    end
end

# --- Aliases ---
alias fm="yazi"
alias atualizar='yay -Syu'
alias limpar='yay -Sc'

# === EDITOR INTELIGENTE (code → nano → vim) ===
# Detecta qual editor está instalado e usa o primeiro disponível
# Resolve erro 127 no notebook (onde VS Code não está instalado)
if type -q code
    set -g TIOSEUS_EDITOR "code"
else if type -q nano
    set -g TIOSEUS_EDITOR "nano"
else if type -q vim
    set -g TIOSEUS_EDITOR "vim"
else
    set -g TIOSEUS_EDITOR "vi"
end

# === ATALHOS DE CONFIGURAÇÃO (usam o editor detectado) ===
alias conf-hypr="$TIOSEUS_EDITOR ~/.config/hypr/hyprland.conf"
alias conf-fish="$TIOSEUS_EDITOR ~/.config/fish/config.fish"
alias conf-kitty="$TIOSEUS_EDITOR ~/.config/kitty/kitty.conf"
alias conf-rofi="$TIOSEUS_EDITOR ~/.config/rofi/config.rasi"
alias conf-waybar="$TIOSEUS_EDITOR ~/.config/waybar/config.jsonc"
alias conf-waybar-style="$TIOSEUS_EDITOR ~/.config/waybar/style.css"
alias conf-swaync="$TIOSEUS_EDITOR ~/.config/swaync/config.json"
alias conf-cava="$TIOSEUS_EDITOR ~/.config/cava/config"
alias conf-fastfetch="$TIOSEUS_EDITOR ~/.config/fastfetch/config.jsonc"

# === EDITOR PADRÃO (pra git commit, sudoedit, etc) ===
set -gx EDITOR $TIOSEUS_EDITOR
set -gx VISUAL $TIOSEUS_EDITOR

# --- Otimização para Jogos (AMD) ---
set -gx AMD_DEBUG ngg
