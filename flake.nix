{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem(system: let
    pkgs = nixpkgs.legacyPackages.${system};
    tf = pkgs.terraform.withPlugins(p: with p; [
      p.null
      p.template
      (pkgs.callPackage ./terraform-provider-libvirt.nix {})
    ]);
  in {
    devShell = pkgs.mkShell {
      buildInputs = with pkgs; [ tf terraform-lsp ];
    };
  });
}
