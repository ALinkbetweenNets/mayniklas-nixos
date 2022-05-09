{ self, ... }: {

  imports = [ ./cron.nix ];

  mayniklas = {
    cloud.vmware-x86.enable = true;
    docker = { enable = true; };
    hosts = { enable = true; };
    in-stock-bot = { enable = false; };
    metrics = {
      blackbox.enable = true;
      flake.enable = true;
      node.enable = true;
    };
    pihole = {
      enable = true;
      port = "8080";
    };
    plex-version-bot = { enable = true; };
    scene-extractor = { enable = true; };
    shelly-plug-s = { enable = true; };
    librespeedtest = {
      enable = true;
      port = "8000";
    };
    server = {
      enable = true;
      home-manager = true;
    };
    youtube-dl = { enable = true; };
  };

  mayniklas.services.owncast = {
    enable = false;
    port = 8989;
    openFirewall = true;
  };

  networking = {
    hostName = "kora";
    dhcpcd.enable = false;
    interfaces.ens192.ipv4.addresses = [{
      address = "192.168.5.21";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.5.1";
    nameservers = [ "192.168.5.1" "1.1.1.1" ];
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  system.stateVersion = "20.09";

}
