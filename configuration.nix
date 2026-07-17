# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.enableAllHardware = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
  boot.loader.grub.useOSProber = true;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://aseipp-nix-cache.freetls.fastly.net"];
  };

  networking.hostName = "t605"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.interfaces.ens18.ipv4.addresses = [
    {
      address = "192.168.50.67";
      prefixLength = 24;
    }
  ]; 
  
  networking.defaultGateway = "192.168.50.1";
  networking.nameservers = [ "192.168.50.1" ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.administrator = {
    isNormalUser = true;
    description = "Administrator";
    extraGroups = [ "networkmanager" "wheel" "users" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    homeMode = "755";
  };

  users.users.candy = {
    isNormalUser = true;
    description = "Candy";
    extraGroups = [ "networkmanager" "wheel" "users" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
    homeMode = "755";
  };
  
  users.users.stonkola = {
    isNormalUser = true;
    description = "Stonks";
    extraGroups = [ "networkmanager" "wheel" "users" "docker" ];
    packages = with pkgs; [];
    homeMode = "755";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btrfs-progs
    caesura
    gh
    git
    podman-compose
    vim 
  ];
  
  virtualisation.containers.enable = true;
  virtualisation = {
    # podman = {
    #   enable = true;

    #   # Create a `docker` alias for podman, to use it as a drop-in replacement
    #   dockerCompat = true;

    #   # Required for containers under podman-compose to be able to talk to each other.
    #   defaultNetwork.settings.dns_enabled = true;
    # };

    docker = {
      enable = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    vips
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.qemuGuest.enable = true;

  services.transmission = {
    enable = false;
    package = pkgs.transmission_4;
    openPeerPorts = true;
    openRPCPort = true;
    settings = {
      download-dir = "/home/administrator/Downloads/red";
      rpc-authentication-required = true;
      rpc-bind-address = "0.0.0.0";
      rpc-username = "yoyoyonono";
      rpc-password = "{d67675aade8cebd6f173473fcbb0609c86f1e3acsGlwCd4h";
      rpc-whitelist-enabled = false;
      watch-dir-enabled = true;
      watch-dir = "/home/administrator/Downloads/watch";
    };
  };

  services.qbittorrent = {
    enable = true;
    webuiPort = 22459;
    openFirewall= true;
    extraArgs = ["--confirm-legal-notice"];
  };

  services.qui = {
    enable = true;
    openFirewall = true;
    secretFile = "/var/lib/qui/session-secret";
    settings = {
      host = "0.0.0.0";
    };
  };
  systemd.services.qbittorrent.serviceConfig.ProtectHome = lib.mkForce false;

  services.nginx = {
    enable = true;
    user = "administrator";
    virtualHosts."ggrks.moe" = {
      root = "/home/administrator/webyeah";
    };
  };
  systemd.services.nginx.serviceConfig.ProtectHome = false;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "192.168.50.67:8384";
    guiPasswordFile = "/home/administrator/nixost605/secret/syncthing";
    settings.gui.user = "yoyoyonono";
  }; 

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global.security = "user";
      share = {
        path = "/home/administrator";
        "read only" = "yes";
        "guest ok" = "no";
      };
    };
  };

  services.dashy = {
    enable = true;
    virtualHost = {
      domain = "dashy.ggrks.moe";
      enableNginx = true;
    };
    settings = {
      appConfig = {
        statusCheck = false;
      };
      pageInfo = {
        title = "Dashy";
      };
      sections = [
        {
          name = "usa";
          items = [
            {
              title = "jellyfin";
              icon = "https://github.com/jellyfin.png";
              url = "https://jelly.ggrks.moe/";
            }
            {
              title = "kavita";
              icon = "https://github.com/Kareadita.png";
              url = "https://kavita.ggrks.moe";
            }
            {
              title = "gitea";
              icon = "https://github.com/go-gitea.png";
              url = "https://git.ggrks.moe";
            }
            {
              title = "qbittorrent";
              icon = "https://github.com/qbittorrent.png";
              url = "https://qbittorrent.ggrks.moe/";
            }
            {
              title = "qui";
              icon = "https://github.com/autobrr.png";
              url = "https://qui.ggrks.moe/";
            }
            {
              title = "syncthing";
              icon = "https://github.com/syncthing.png";
              url = "https://syncthing.ggrks.moe/";
            }
            {
              title = "proxmox";
              icon = "https://github.com/proxmox.png";
              url = "https://pve.ggrks.moe/";
            }
          ];
        }
        {
          name = "nepal";
          items = [
            {
              title = "home assistant";
              icon = "https://github.com/home-assistant.png";
              url = "https://home.thapa.net/";
            }
            {
              title = "frigate";
              icon = "https://raw.githubusercontent.com/blakeblackshear/frigate/refs/heads/dev/web/images/branding/apple-touch-icon.png";
              url = "https://frigate.home.thapa.net/";
            }
            {
              title = "immich";
              icon = "https://github.com/immich-app.png";
              url = "https://immich.home.thapa.net/";
            }
            {
              title = "proxmox";
              icon = "https://github.com/proxmox.png";
              url = "https://pve.home.thapa.net/";
            }
          ]; 
        }
      ];
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    25580 
    8096 
    5000 
    80 
    8384
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
