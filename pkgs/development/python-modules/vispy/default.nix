{ lib
, stdenv
, buildPythonPackage
, substituteAll
, fetchPypi
, cython
, fontconfig
, freetype-py
, hsluv
, kiwisolver
, libGL
, numpy
, setuptools-scm
, setuptools-scm-git-archive
}:

buildPythonPackage rec {
  pname = "vispy";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41a6836aa78462370fe15efaade94cbe3344586412f8d7f12689c49c299ff41b";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      gl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    cython
    setuptools-scm
    setuptools-scm-git-archive
  ];

  buildInputs = [
    libGL
  ];

  propagatedBuildInputs = [
    fontconfig
    freetype-py
    hsluv
    kiwisolver
    numpy
  ];

  doCheck = false;  # otherwise runs OSX code on linux.

  pythonImportsCheck = [
    "vispy"
    "vispy.color"
    "vispy.geometry"
    "vispy.gloo"
    "vispy.glsl"
    "vispy.io"
    "vispy.plot"
    "vispy.scene"
    "vispy.util"
    "vispy.visuals"
  ];

  meta = with lib; {
    homepage = "https://vispy.org/index.html";
    description = "Interactive scientific visualization in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
