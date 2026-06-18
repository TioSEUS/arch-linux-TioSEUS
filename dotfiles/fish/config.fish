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
# Atalhos para facilitar a vida no Arch Seu Inutio
alias fm="spf"
alias atualizar='yay -Syu'
alias limpar='yay -Sc'
alias conf-hypr='nano ~/.config/hypr/hyprland.conf'
alias conf-fish='nano ~/.config/fish/config.fish'
alias conf-kitty='nano ~/.config/kitty/kitty.conf'

# --- Otimização para Jogos (AMD) ---
set -gx AMD_DEBUG ngg
