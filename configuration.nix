# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.enableAllHardware = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
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
    homeMode = "775";
  };

  users.users.candy = {
    isNormalUser = true;
    description = "Candy";
    extraGroups = [ "networkmanager" "wheel" "users" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
    homeMode = "775";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    gh
    btrfs-progs
  #  wget
    podman-compose
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
    enable = true;
    package = pkgs.transmission_4;
    openPeerPorts = true;
    openRPCPort = true;
    settings = {
      download-dir = "/home/administrator/Downloads";
      rpc-authentication-required = true;
      rpc-bind-address = "0.0.0.0";
      rpc-username = "yoyoyonono";
      rpc-password = "{d67675aade8cebd6f173473fcbb0609c86f1e3acsGlwCd4h";
      rpc-whitelist-enabled = false;
    };
  };

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
              title = "transmission";
              icon = "https://github.com/transmission.png";
              url = "https://transmission.ggrks.moe/";
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
              url = "https://home.thapa.net:8123/";
            }
            {
              title = "frigate";
              icon = "https://raw.githubusercontent.com/blakeblackshear/frigate/refs/heads/dev/web/images/branding/apple-touch-icon.png";
              url = "http://home.thapa.net:8971/";
              statusCheckAllowInsecure = true; 
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
