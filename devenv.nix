{ pkgs, lib, config, inputs, ... }:

{

  # Packages to include in the environment
  packages = with pkgs; [
    typst # Typst binary
    ltex-ls-plus # LTeX language server
    tinymist
    typstyle
  ];

  languages.typst.enable = true;

}

