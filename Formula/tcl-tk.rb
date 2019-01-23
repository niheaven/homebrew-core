class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.8/tcl8.6.8-src.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.8-src.tar.gz"
  version "8.6.8"
  sha256 "c43cb0c1518ce42b00e7c8f6eaddd5195c53a98f94adc717234a65cbcfd3f96a"
  revision 1

  bottle do
    sha256 "9b698ba74f8d97ea25123df88775fa486a05bbe18b1744ff7a6bf7f1cd30aaa3" => :mojave
    sha256 "c591a13ec04ad772639d28f3090aa76b9f410c67189c31abcbdbe9ae29472d65" => :high_sierra
    sha256 "166f4816291851777a321e27b5d8f19322e218f682ca0881dbdfec15e7af7980" => :sierra
  end

  keg_only :provided_by_macos,
    "tk installs some X11 headers and macOS provides an (older) Tcl/Tk"

  depends_on "openssl"

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.18/tcllib-1.18.tar.gz"
    sha256 "72667ecbbd41af740157ee346db77734d1245b41dffc13ac80ca678dd3ccb515"
  end

  resource "tcltls" do
    url "https://core.tcl.tk/tcltls/uv/tcltls-1.7.16.tar.gz"
    sha256 "6845000732bedf764e78c234cee646f95bb68df34e590c39434ab8edd6f5b9af"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.8/tk8.6.8-src.tar.gz"
    mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tk/tk8.6.8-src.tar.gz"
    version "8.6.8"
    sha256 "49e7bca08dde95195a27f594f7c850b088be357a7c7096e44e1158c7a5fd7b33"

    # Upstream issue 7 Jan 2018 "Build failure with Aqua support on OS X 10.8 and 10.9"
    # See https://core.tcl.tk/tcl/tktview/95a8293a2936e34cc8d0658c21e5214f1ca9b435
    if MacOS.version == :mavericks || MacOS.version == :mountain_lion
      patch :p0 do
        url "https://raw.githubusercontent.com/macports/macports-ports/0a883ad388b/x11/tk/files/patch-macosx-tkMacOSXXStubs.c.diff"
        sha256 "2cdba6bbf2503307fe4f4d7200ad57c9926ebf0ff6ed3e65bf551067a30a04a9"
      end
    end
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end

    # Let tk finds our new tclsh
    ENV.prepend_path "PATH", bin

    resource("tk").stage do
      cd "unix" do
        system "./configure", *args, "--enable-aqua=yes",
                              "--without-x", "--with-tcl=#{lib}"
        system "make"
        system "make", "install"
        system "make", "install-private-headers"
        ln_s bin/"wish#{version.to_f}", bin/"wish"
      end
    end

    resource("tcllib").stage do
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
    end

    resource("tcltls").stage do
      system "./configure", "--with-ssl=openssl", "--with-openssl-dir=#{Formula["openssl"].opt_prefix}", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
    end
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end
