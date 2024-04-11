{ config, pkgs, lib, ... }:

let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in

{
  imports = [ "${impermanence}/nixos.nix" ];

  environment.persistence."/persist" = { 
    directories = [
      # "/etc/nixos"
      "/etc/NetworkManager"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"   
    ];
  };

  # COMMENTED BECAUSE USING TMPFS ROOT

  # Rolling back root snapshot
  # boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
  #   mkdir -p /mnt

  #   # We first mount the btrfs root to /mnt
  #   # so we can manipulate btrfs subvolumes.
  #   mount -o subvol=/ /dev/mapper/enc /mnt

  #   # While we're tempted to just delete /root and create
  #   # a new snapshot from /root-blank, /root is already
  #   # populated at this point with a number of subvolumes,
  #   # which makes `btrfs subvolume delete` fail.
  #   # So, we remove them first.
  #   #
  #   # /root contains subvolumes:
  #   # - /root/var/lib/portables
  #   # - /root/var/lib/machines
  #   #
  #   # I suspect these are related to systemd-nspawn, but
  #   # since I don't use it I'm not 100% sure.
  #   # Anyhow, deleting these subvolumes hasn't resulted
  #   # in any issues so far, except for fairly
  #   # benign-looking errors from systemd-tmpfiles.
  #   btrfs subvolume list -o /mnt/root |
  #   cut -f9 -d' ' |
  #   while read subvolume; do
  #     echo "deleting /$subvolume subvolume..."
  #     btrfs subvolume delete "/mnt/$subvolume"
  #   done &&
  #   echo "deleting /root subvolume..." &&
  #   btrfs subvolume delete /mnt/root

  #   echo "restoring blank /root subvolume..."
  #   btrfs subvolume snapshot /mnt/root-blank /mnt/root

  #   # Once we're done rolling back to a blank snapshot,
  #   # we can unmount /mnt and continue on the boot process.
  #   umount /mnt
  # '';

  #boot.initrd = {
  #  enable = true;
  #  supportedFilesystems = [ "btrfs" ];

  #  systemd.services.restore-root = {
  #    description = "Rollback btrfs rootfs";
  #    wantedBy = [ "initrd.target" ];
  #    requires = [
  #      "dev-nvme0n1p5"
  #    ];
  #    after = [
  #      "dev-nvme0n1p5"
  #      # for luks
  #      "systemd-cryptsetup@${config.networking.hostName}.service"
  #    ];
  #    before = [ "sysroot.mount" ];
  #    unitConfig.DefaultDependencies = "no";
  #    serviceConfig.Type = "oneshot";
  #    script = ''
  #      mkdir -p /mnt

  #      # We first mount the btrfs root to /mnt
  #      # so we can manipulate btrfs subvolumes.
  #      mount -o subvol=/ /dev/mapper/enc /mnt

  #      # While we're tempted to just delete /root and create
  #      # a new snapshot from /root-blank, /root is already
  #      # populated at this point with a number of subvolumes,
  #      # which makes `btrfs subvolume delete` fail.
  #      # So, we remove them first.
  #      #
  #      # /root contains subvolumes:
  #      # - /root/var/lib/portables
  #      # - /root/var/lib/machines
  #      #
  #      # I suspect these are related to systemd-nspawn, but
  #      # since I don't use it I'm not 100% sure.
  #      # Anyhow, deleting these subvolumes hasn't resulted
  #      # in any issues so far, except for fairly
  #      # benign-looking errors from systemd-tmpfiles.
  #      btrfs subvolume list -o /mnt/root |
  #      cut -f9 -d' ' |
  #      while read subvolume; do
  #        echo "deleting /$subvolume subvolume..."
  #        btrfs subvolume delete "/mnt/$subvolume"
  #      done &&
  #      echo "deleting /root subvolume..." &&
  #      btrfs subvolume delete /mnt/root

  #      echo "restoring blank /root subvolume..."
  #      btrfs subvolume snapshot /mnt/root-blank /mnt/root

  #      # Once we're done rolling back to a blank snapshot,
  #      # we can unmount /mnt and continue on the boot process.
  #      umount /mnt
  #    '';
  #  };
  #};


  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
