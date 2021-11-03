{ lib, pkgs, buildGoModule, cdrtools, ... }:

buildGoModule rec {
  pname = "terraform-provider-libvirt";
  version = "0.6.11";

  propagatedBuildInputs = [ cdrtools ];
  src = pkgs.fetchFromGitHub {
    owner = "knownunown";
    repo = "terraform-provider-libvirt";
    rev = "main";
    # sha256 = lib.fakeHash;
    sha256 = "sha256-44BC+Qu+rhuAk9YVCmCB8//s3nVHZHpHpmJhiVqCiag=";
  };
  vendorSha256 = "sha256-Rbnw6HyrQGtiIA4toUMoyJydpgK0T4zEXg39ReqARlg=";

  /*
  terraform-provider-libvirt> running tests
  terraform-provider-libvirt> # github.com/dmacvicar/terraform-provider-libvirt [github.com/dmacvicar/terraform-provider-libvirt.test]
  terraform-provider-libvirt> ./main_test.go:11:21: printVersion(buf) used as value
  */
  doCheck = false;

  postBuild = "mv ../go/bin/terraform-provider-libvirt{,_v${version}}";

  meta = {
    platforms = lib.platforms.unix;
  };
}
