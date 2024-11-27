let
    v = builtins.fromJSON (builtins.readFile ./config);
in
    v
