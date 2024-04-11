{ config, pkgs, ... }:

{
  #imports = [ <home-manager/nixos> ];

  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/persist/passwords/root";
  users.users.lia = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPasswordFile = "/persist/passwords/lia";
  };

  #home-manager.users.lia = { pkgs, ... }: {
  #  programs.bash.enable = true;
  #  home.packages = [ pkgs.python3 ];
  #};
}
