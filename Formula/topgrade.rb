class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.5.0.tar.gz"
  sha256 "413a25707600b7fd1dd9153850da2184c3a8e40841bdcb91533fe012313dbc99"

  bottle do
    cellar :any_skip_relocation
    sha256 "08374985c3f7a27882bc393d23f2332a5e10a3df63879c7dea7433993244de27" => :mojave
    sha256 "8517ac3584efd73e178cf9cc5eb51b84c5d483ba8289b6f5ff5b1b399c1f4319" => :high_sierra
    sha256 "5910f307bf9d1d1d19871e6226757f4a7483f73f48e95b4591a0015d0ec5218a" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
