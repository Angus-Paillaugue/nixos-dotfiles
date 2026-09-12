{
  programs.fish = {
    enable = true;
    interactiveShellInit = /* fish */ ''
      set fish_greeting;
      starship init fish | source
      fnm env --use-on-cd --shell fish | source
      alias create-shell="~/.config/home-manager/utils/create-shell.sh $argv"
      alias nvm="fnm"
      alias c="clear"
      alias h="cd ~"
      alias ls="eza --icons --group-directories-first --color=always --classify"
      alias ll="eza -l --icons --group-directories-first --color=always --git"
      alias la="eza -la --icons --group-directories-first --color=always --git"
      alias cat="bat --color always --theme gruvbox-dark"

      # fnm
      set -U fish_user_paths $HOME/.local/share/fnm $fish_user_paths
      eval "$(fnm env --use-on-cd --shell fish)"
    '';
  };
}
