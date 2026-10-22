final: prev:
let
  version = "1.4.4";
  sources = {
    "aarch64-darwin" = {
      name = "bun-darwin-aarch64.zip";
      hash = "sha256-wkDX8My5DCY6hJ/NsJt+5iYw2SE0jtaq/ahrnVd7xRA=";
    };
    "aarch64-linux" = {
      name = "bun-linux-aarch64.zip";
      hash = "sha256-uqa7NvUdblhWHgK76oJQOKnfRU9nPW13bou/hvjHhQ4=";
    };
    "x86_64-linux" = {
      name = "bun-linux-x64-baseline.zip";
      hash = "sha256-4ERutVmVdy65iUvrrppr42jZhai5Jx7hJEhvmUbu3XY=";
    };
  };

  sourceFor =
    _system: source:
    prev.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/${source.name}";
      inherit (source) hash;
    };

  platformSources = prev.lib.mapAttrs sourceFor sources;
in
{
  bun = prev.bun.overrideAttrs (old: {
    inherit version;
    src =
      platformSources.${prev.stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${prev.stdenv.hostPlatform.system}");
    passthru = old.passthru // {
      sources = platformSources;
    };
  });
}
