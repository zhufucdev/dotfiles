{ pkgs, ... }:
with pkgs;
[
  # Client
  neovide
  maple-mono.NF-CN
  nerd-fonts.jetbrains-mono
  # Language servers & tools
  tree-sitter-latest
  ripgrep
  vue-language-server
  astro-language-server
  vtsls
  docker-language-server
  gopls
  isort
  black
  delve
  markdownlint-cli
  stylua
  tailwindcss-language-server
  pyrefly
  mdx-language-server
  harper
  prettierd
  vscode-langservers-extracted
  typescript-language-server
  lldb
  taplo
  buf
  lua
  lua-language-server
  libxml2
]
