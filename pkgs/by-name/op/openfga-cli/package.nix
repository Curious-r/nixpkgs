{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  pname = "openfga-cli";
  version = "0.7.2";
in

buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-k/YDomfOn658j4XZKPV9BZZSQBnJdNJOUF6SONmESqY=";
  };

  vendorHash = "sha256-v9zzPl80TsOfYfc764aVpuflj7I4eZOa9PTCjX7dL/4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags =
    let
      buildInfoPkg = "github.com/openfga/cli/internal/build";
    in
    [
      "-s"
      "-w"
      "-X ${buildInfoPkg}.Version=${version}"
      "-X ${buildInfoPkg}.Commit=${version}"
      "-X ${buildInfoPkg}.Date=19700101"
    ];

  postInstall = ''
    completions_dir=$TMPDIR/fga_completions
    mkdir $completions_dir
    $out/bin/fga completion bash > $completions_dir/fga.bash
    $out/bin/fga completion zsh > $completions_dir/_fga.zsh
    $out/bin/fga completion fish > $completions_dir/fga.fish
    installShellCompletion $completions_dir/*
  '';

  meta = {
    description = "Cross-platform CLI to interact with an OpenFGA server";
    homepage = "https://github.com/openfga/cli";
    license = lib.licenses.asl20;
    mainProgram = "fga";
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
}
