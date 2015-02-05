{ lib, ... }:
with lib;
rec {
  gateway = {
    dhcpRange = {
      lower = 100;
      upper = 254;
    };
    natIfs = (attrNames internalVlanMap) ++ [ "tinc.vpn" ];
  };

  internalVlanMap = {
    mlan = 1; # Must Exist
    slan = 2; # Must Exist
    dlan = 3;
    ulan = 4;
  };

  vpn = {
    # Assumes a prefix of /24
    subnet = "192.168.17.";
    idMap = {
      jester = 1;
      prodigy = 2;
      atomic = 3;
      alamo = 4;
      ferrari = 5;
      delta = 6;
      legend = 7;
    };
  };

  domain = "wak.io";

  consulAclDc = "mtv-w";

  # netMaps currently assumes /16 ipv4 and /60 ipv6 allocations
  # ip processing in nix is hard :/
  netMaps = {
    "abe-p" = {
      priv4 = "10.0.";
      pub6 = "2001:470:88fa:000";
      priv6 = "fda4:941a:81b5:000";

      # Must start at 2 for multiple
      # Can be one for a single gateway
      gatewayMap = {
        atomic = 2;
      };

      internalMachineMap = {
        atomic = 2;
      };
    };
    "mtv-w" = {
      priv4 = "10.1.";
      pub6 = "2001:470:810a:000";
      priv6 = "fda4:941a:81b5:100";

      consul = {
        servers = [ "alamo" "ferrari" "legend" ];
      };
      ceph = {
        fsId = "40d2204b-4833-4249-ae3e-308c0c8171cb";
        mons = [ "alamo" "ferrari" "legend" ];
      };
      zookeeper = {
        # Numbering is important and should be consistent in
        # the cluster. Therefore it is recommended never to reuse
        # or reorganize the numeric values for nodes.
        servers = {
          alamo = 0;
          ferrari = 1;
          legend = 2;
        };
      };

      gateways = [
        "alamo"
        #"ferrari"
      ];

      # Cannot use 1 as this is reserved for the default gateway
      internalMachineMap = {
        alamo = 2;
        ferrari = 3;
        legend = 4;
        kvm = 9;
        sw1g1 = 11;
        sw1g2 = 12;
        sw10g1 = 21;
        delta = 31;
        fuel = 32;
        #lithium = ;
        #marble = ;
        #hunter = ;
      };

    };
  };
}