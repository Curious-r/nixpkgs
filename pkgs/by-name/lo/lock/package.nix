{
  lib,
  stdenv,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gpgme,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lock";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "konstantintutsch";
    repo = "Lock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JAtQxmcLFNj6epk3ipVaa/u7fQ4E2maHZN+7jk+ktmE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    glib # For `glib-compile-schemas`
    gtk4 # For `gtk-update-icon-cache`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gpgme
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Process data with GnuPG";
    homepage = "https://konstantintutsch.com/Lock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "com.konstantintutsch.Lock";
    inherit (gpgme.meta) platforms;
  };
})
