{ config, lib, ... }:
with lib;
{
  networking.firewall.extraCommands =
    flip concatMapStrings config.myNatIfs (n: ''
      ip46tables -A INPUT -i ${n} -p udp --dport ntp -j ACCEPT
      ip46tables -A INPUT -i ${n} -p tcp --dport ntp -j ACCEPT
    '');

  services.openntpd.extraConfig = ''
    listen on 0.0.0.0
    listen on ::
  '';
}
