{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder

# build
, autoPatchelfHook

# runtime
, glib
, libnl
, openssl_1_1

# propagates
, aenum
, coloredlogs
, construct
, cryptography
, dacite
, ecdsa
, rich
, pyyaml
, ipdb
, deprecation
, mobly
, pygobject3
}:

buildPythonPackage rec {
  pname = "home-assistant-chip-core";
  version = "2024.1.0";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = let
    system = {
      "aarch64-linux" = {
        name = "aarch64";
        hash = "sha256-UiikZ2DVhTqX6WYfiE8sp2e52BMlyoQnDjLap/efmNc=";
      };
      "x86_64-linux" = {
        name = "x86_64";
        hash = "sha256-/+gegUMd2n7MpJvdilS5VWefXc0tuRcLrXBBXSH35b0=";
      };
    }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  in fetchPypi {
    pname = "home_assistant_chip_core";
    inherit version format;
    dist = "cp37";
    python = "cp37";
    abi = "abi3";
    platform = "manylinux_2_31_${system.name}";
    hash = system.hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    libnl
    openssl_1_1
  ];

  propagatedBuildInputs = [
    aenum
    coloredlogs
    construct
    cryptography
    dacite
    ecdsa
    rich
    pyyaml
    ipdb
    deprecation
    mobly
    pygobject3
  ];

  pythonNamespaces = [
    "chip"
    "chip.clusters"
  ];

  pythonImportsCheck = [
    "chip"
    "chip.ble"
    "chip.configuration"
    "chip.discovery"
    "chip.exceptions"
    "chip.native"
    "chip.storage"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Python-base APIs and tools for CHIP";
    homepage = "https://github.com/home-assistant-libs/chip-wheels";
    changelog = "https://github.com/home-assistant-libs/chip-wheels/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
