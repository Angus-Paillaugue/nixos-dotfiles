{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting;
      fnm env --use-on-cd --shell fish | source
      alias create-shell="~/.config/home-manager/utils/create-shell.sh $argv"
    '';
  };
}
