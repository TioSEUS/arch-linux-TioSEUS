# Iniciar o Hyprland automaticamente ao logar no TTY1
if status is-login
    if test (tty) = "/dev/tty1"
        exec Hyprland
    end
end

if status is-interactive
    # Comandos para rodar em sessões interativas
    fastfetch

    # Desativar a mensagem de Boas-Vindas do fish
    set -g fish_greeting ''

    if type -q starship
        # Inicializar o prompt do Starship
        starship init fish | source
    end
end


# --- Aliases (Atalhos de Comandos) ---
alias fm="yazi"
alias atualizar='yay -Syu'
alias limpar='yay -Sc'

# === ATALHOS DE CONFIGURAÇÃO (abrem no VS Code) ===
alias conf-hypr='code ~/.config/hypr/hyprland.conf'
alias conf-fish='code ~/.config/fish/config.fish'
alias conf-kitty='code ~/.config/kitty/kitty.conf'
alias conf-rofi='code ~/.config/rofi/config.rasi'
alias conf-waybar='code ~/.config/waybar/config.jsonc'
alias conf-waybar-style='code ~/.config/waybar/style.css'
alias conf-swaync='code ~/.config/swaync/config.json'
alias conf-cava='code ~/.config/cava/config'
alias conf-fastfetch='code ~/.config/fastfetch/config.jsonc'

# === EDITOR PADRÃO ===
set -gx EDITOR code
set -gx VISUAL code
set -gx SUDO_EDITOR 'code --wait'

# --- Otimização para Jogos (AMD) ---
set -gx AMD_DEBUG ngg
