{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  boost,
  gettext,
  libime,
  fcitx5,
  fcitx5-qt,
  fcitx5-lua,
  qtwebengine,
  opencc,
  curl,
  fmt,
  qtbase,
  luaSupport ? true,
}:

let
  pyStrokeVer = "20121124";
  pyStroke = fetchurl {
    url = "http://download.fcitx-im.org/data/py_stroke-${pyStrokeVer}.tar.gz";
    hash = "sha256-jrEoqb+kOVLmfPL87h/RNMb0z9MXvC9sOKYV9etk4kg=";
  };
  pyTableVer = "20121124";
  pyTable = fetchurl {
    url = "http://download.fcitx-im.org/data/py_table-${pyTableVer}.tar.gz";
    hash = "sha256-QhRqyX3mwT1V+eme2HORX0xmc56cEVMqNFVrrfl5LAQ=";
  };
in

stdenv.mkDerivation rec {
  pname = "fcitx5-chinese-addons";
  version = "5.1.8";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-QO136EbUFxT7yA1Fs4DvV0CKpdCMw/s5s9sW3vRzGD8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    fcitx5-lua
  ];

  prePatch = ''
    ln -s ${pyStroke} modules/pinyinhelper/$(stripHash ${pyStroke})
    ln -s ${pyTable} modules/pinyinhelper/$(stripHash ${pyTable})
  '';

  buildInputs = [
    boost
    fcitx5
    fcitx5-qt
    libime
    curl
    opencc
    qtwebengine
    fmt
  ]
  ++ lib.optional luaSupport fcitx5-lua;

  cmakeFlags = [
    (lib.cmakeBool "USE_QT6" (lib.versions.major qtbase.version == "6"))
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Addons related to Chinese, including IME previous bundled inside fcitx4";
    mainProgram = "scel2org5";
    homepage = "https://github.com/fcitx/fcitx5-chinese-addons";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
