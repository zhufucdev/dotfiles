{ config, ... }:
{
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  initContent = ''
    export MCFLY_FUZZY=2
    eval "$(pyenv init -)"
    eval "$(mcfly init zsh)"
    bindkey ';3C' forward-word
    bindkey ';3D' backward-word

    autoload -U select-word-style
    select-word-style bash
    export WORDCHARS='.-'
  '';

  zplug = {
    enable = true;
    plugins = [
      { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
      {
        name = "0i0/0i0.zsh-theme";
        tags = [
          "as:theme"
          "depth:1"
        ];
      } # Installations with additional options. For the list of options, please refer to Zplug README.
      {
        name = "zsh-users/zsh-history-substring-search";
        tags = [ "as:plugin" ];
      }
    ];
  };
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };
}
