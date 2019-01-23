class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.8.tar.xz"
  sha256 "e2876d987c00783ac3c1358e9da52794ac26f557e262194fcba60ac88bafa445"
  revision 1

  bottle do
    sha256 "31bc1f2cecf14e6a2d751f257a09426d5f00ef0c46910154fe2ec1180dbe059e" => :mojave
    sha256 "04afe02f130d01741467427001c3fa1f6a0dbd09767653ea5eccbd8326421471" => :high_sierra
    sha256 "0e770b424256d46f816041357aa27bef22ab5366133e6b20fe685793ca3bd49e" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libgee"
  depends_on "openssl"
  depends_on "readline"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java",
                          "--enable-introspection"
    system "make"
    system "make", "install"
  end
end
