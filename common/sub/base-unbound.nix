{ config, lib, ... }:
with lib;
{
  # Make sure we always use unbound
  networking.hasLocalResolver = true;

  networking.firewall.extraCommands = ''
    # Allow unbound to access dns servers
    ip46tables -A OUTPUT -m owner --uid-owner unbound -p udp --dport domain -j ACCEPT
    ip46tables -A OUTPUT -m owner --uid-owner unbound -p tcp --dport domain -j ACCEPT

    # Allow all users to access dns
    ip46tables -A OUTPUT -o lo -p udp --dport domain -j ACCEPT
    ip46tables -A OUTPUT -o lo -p tcp --dport domain -j ACCEPT
  '';

  services.unbound = {
    enable = true;
    extraConfig = concatStrings (flip mapAttrsToList config.myDns.forwardZones (name: servers:
      "forward-zone:\n  name: ${name}\n" + flip concatMapStrings servers ({ server, port }:
        "  forward-addr: \"${server}@${toString port}\"\n"
      )
    )) + ''
      server:
        interface: 0.0.0.0
        interface: ::0
        access-control: 0.0.0.0/0 allow
      remote-control:
        control-enable: yes
        control-use-cert: no
    '';
  };

  myDns.forwardZones' = attrNames config.myDns.forwardZones;
}
