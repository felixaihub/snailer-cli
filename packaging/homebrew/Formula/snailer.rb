class Snailer < Formula
  desc "AI-powered development CLI"
  homepage "https://github.com/felixaihub/snailer-cli"
  version "0.1.0"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/felixaihub/snailer-cli/releases/download/v0.1.0/snailer-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "REPLACE_WITH_SHA256_MAC_ARM64"
    else
      url "https://github.com/felixaihub/snailer-cli/releases/download/v0.1.0/snailer-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "REPLACE_WITH_SHA256_MAC_X64"
    end
  end

  on_linux do
    url "https://github.com/felixaihub/snailer-cli/releases/download/v0.1.0/snailer-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
    sha256 "REPLACE_WITH_SHA256_LINUX_X64"
  end

  def install
    bin.install "snailer"
  end

  def caveats
    <<~EOS
    By installing, you agree to the Snailer EULA:
    https://github.com/felixaihub/snailer-cli/blob/main/EULA.md
    EOS
  end

  test do
    assert_match "snailer", shell_output("#{bin}/snailer --help")
  end
end
