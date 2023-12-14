# This package references all the outputs we want to keep around in the nix-store.
# It builds all our NixOS systems and packages, since it depends on them.
# -> might be useful for different use cases:
#   - keep all the build outputs around for a while
#   - build all systems and packages at once
#   - compare systems with nix-tree
#   - make sure everything is present in the local nix-store for deploying to a remote machine
#
# nix run .#build_outputs
# nix-tree $(nix build --print-out-paths .#build_outputs)
{ pkgs
, lib
, self
, output_path ? "~/.keep-nix-outputs-MayNiklas"
, ...
}:
let
  all_outputs = (pkgs.writeShellScriptBin "all_outputs" (lib.strings.concatMapStrings
    (host:
      ''
        echo ${host}:
        ${pkgs.nix}/bin/nix path-info --closure-size -h ${self.nixosConfigurations.${host}.config.system.build.toplevel}
      ''
    )
    (builtins.attrNames self.nixosConfigurations)));
in
pkgs.writeShellScriptBin "build_outputs" ''
  # makes sure we don't garbage collect the build outputs
  ln -sfn ${all_outputs} ${output_path}

  # print the size of the build outputs
  ${pkgs.nix}/bin/nix path-info --closure-size -h ${all_outputs}

  # execute script that prints the size of all individual build outputs and pushes them to attic
  ${all_outputs}/bin/all_outputs

  # push outputs to attic when attic is available
  if command -v attic &> /dev/null
  then
    attic push lounge-rocks:nix-cache ${all_outputs}
  else
    echo "attic not available"
  fi
''
