{ lib, pkgs, buildGoModule, cdrtools, ... }:

buildGoModule rec {
  pname = "terraform-provider-libvirt";
  version = "0.6.11";

  propagatedBuildInputs = [ cdrtools ];
  src = pkgs.fetchFromGitHub {
    owner = "knownunown";
    repo = "terraform-provider-libvirt";
    rev = "snapshot_copy_and_network_v2";
    # sha256 = lib.fakeHash;
    sha256 = "sha256-Tvv8FpS1vqIrDIw8vJuCxBII4kpGAAAPHgFOI94Iddc=";
  };
  vendorSha256 = "sha256-GejAQB67sBssrWgQ5FaVN53Ibbb0CXkJxn/OTzUhpwE=";

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
