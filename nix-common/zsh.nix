{ config, ... }:
{
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  initContent = ''
    export MCFLY_FUZZY=2

    # Lazy-load pyenv to avoid slow startup
    pyenv() {
      unfunction pyenv
      eval "$(command pyenv init -)"
      pyenv "$@"
    }

    # Lazy-load mcfly to avoid slow startup
    _mcfly_init() {
      unset -f _mcfly_init
      eval "$(command mcfly init zsh)"
    }
    add-zsh-hook precmd _mcfly_init

    bindkey ';3C' forward-word
    bindkey ';3D' backward-word
    # Vim mode
    bindkey -v

    autoload -U select-word-style
    select-word-style bash
    export WORDCHARS='.-'
  '';

  zplug = {
    enable = true;
    plugins = [
      { name = "zsh-users/zsh-autosuggestions"; }
      {
        name = "0i0/0i0.zsh-theme";
        tags = [
          "as:theme"
          "depth:1"
        ];
      }
      {
        name = "zsh-users/zsh-history-substring-search";
        tags = [ "as:plugin" ];
      }
    ];
  };
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
    extended = true;
    ignoreDups = true;
    share = true;
  };
}
