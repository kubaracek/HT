{ mkDerivation, base, conduit, mtl, random, stdenv }:
mkDerivation {
  pname = "bank";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base conduit mtl random ];
  executableHaskellDepends = [ base conduit mtl random ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
