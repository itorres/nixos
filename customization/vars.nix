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

  userInfo = {
    william = {
      uid = 1000;
      description = "William A. Kennington III";
      canRoot = true;
      loginMachines = [ "exodus" "prodigy" ];
      canShareData = true;
    };
    bill = {
      uid = 1001;
      description = "William A. Kennington Jr";
      canRoot = false;
      loginMachines = [ ];
      canShareData = true;
    };
    linda = {
      uid = 1002;
      description = "Linda D. Kennington";
      canRoot = false;
      loginMachines = [ ];
      canShareData = true;
    };
    ryan = {
      uid = 1003;
      description = "Ryan C. Kennington";
      canRoot = false;
      loginMachines = [ ];
      canShareData = true;
    };
    sumit = {
      uid = 1004;
      description = "Sumit R. Punjabi";
      canRoot = false;
      loginMachines = [ ];
      canShareData = true;
    };
  };

  remotes = [ "nixos" "prodigy" ];

  # netMaps currently assumes /16 ipv4 and /60 ipv6 allocations
  # ip processing in nix is hard :/
  netMaps = {
    "abe-p" = {
      priv4 = "10.0.";
      pub6 = "2001:470:88fa:000";
      priv6 = "fda4:941a:81b5:000";

      timeZone = "America/New_York";

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

      timeZone = "America/Los_Angeles";

      consul = {
        servers = [ "alamo" "ferrari" "legend" ];
      };
      ceph = {
        fsId = "40d2204b-4833-4249-ae3e-308c0c8171cb";
        mons = [ "alamo" "ferrari" "legend" ];
        osds = {
          "delta" = [ 4 5 6 7 8 9 10 11 12 13 ];
        };
      };
      mongodb = {
        servers = [ "alamo" "ferrari" "legend" ];
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

      gatewayIds = [ 1 ];

      gateways = [
        "alamo"
        #"ferrari"
      ];

      nasIds = [ 8 9 ];

      nases = [
        "alamo"
        "ferrari"
      ];

      # Cannot use 1 as this is reserved for the default gateway
      internalMachineMap = {
        alamo = { id = 2; vlans = [ "slan" "mlan" "dlan" "ulan" ]; };
        ferrari = { id = 3; vlans = [ "slan" "mlan" "dlan" "ulan" ]; };
        legend = { id = 4; vlans = [ "slan" "mlan" "dlan" "ulan" ]; };
        kvm = { id = 9; vlans = [ "mlan" ]; };
        sw1g1 = { id = 11; vlans = [ "mlan" ]; };
        sw1g2 = { id = 12; vlans = [ "mlan" ]; };
        sw10g1 = { id = 21; vlans = [ "mlan" ]; };
        delta = { id = 31; vlans = [ "slan" ]; };
        fuel = { id = 32; vlans = [ "slan" ]; };
        eagle = { id = 33; vlans = [ "slan" ]; };
        lithium = { id = 34; vlans = [ "slan" ]; };
        marble = { id = 35; vlans = [ "slan" ]; };
        hunter = { id = 36; vlans = [ "slan" ]; };
        exodus = { id = 90; vlans = [ "slan" ]; };
      };

    };
  };
}
