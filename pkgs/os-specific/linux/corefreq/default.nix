{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  # See the official readme for a list of optional flags:
  # https://github.com/cyring/CoreFreq/blob/master/README.md
  extraFlags ? [ ],
}:

stdenv.mkDerivation rec {
  pname = "corefreq";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "cyring";
    repo = "CoreFreq";
    rev = version;
    hash = "sha256-k9tw32yG8WGGCY0/5WWvRTBzz+jka7PZ9WU05rwnunI=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  env.NIX_CFLAGS_COMPILE = "-I${src}/${stdenv.hostPlatform.qemuArch}";
  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ]
  ++ extraFlags;

  preInstall = ''
    mkdir -p $out/bin
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "CPU monitoring and tuning software designed for 64-bit processors";
    homepage = "https://github.com/cyring/CoreFreq";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mrene ];
    mainProgram = "corefreq-cli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
