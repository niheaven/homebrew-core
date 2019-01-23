class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3.tar.gz"
  sha256 "665f905036b1f731a2a16f83fb298b1fb9d0f98c382625d023097151ad016b25"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2194f73ef3d18110ff4c390824691f73a3a0a38adb7e67d52fdb39b4fc39deac" => :mojave
    sha256 "adfbfd9b99c5f622aa396d8a6cea28560bdf3db1cd38ae0b51de7cc967752e1e" => :high_sierra
    sha256 "11604e3c526a5525e167f27a1088cfc7145b22cabe2ad95d18c04d749052f5d7" => :sierra
  end

  depends_on "sphinx-doc" => :build

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    # Avoid the following compiler error:
    # SecKeychain.h:102:46: error: shift expression '(1853123693 << 8)' overflows
    ENV.append_to_cflags "-fpermissive" if MacOS.version <= :lion

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    # There is an existing issue around macOS & Python locale setting
    # See https://bugs.python.org/issue18378#msg215215 for explanation
    ENV["LC_ALL"] = "en_US.UTF-8"

    system "./bootstrap", *args, "--", "-DCMAKE_BUILD_TYPE=Release"
    system "make"
    system "make", "install"

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
