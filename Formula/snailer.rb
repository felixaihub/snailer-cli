class Snailer < Formula
  desc "AI-powered development CLI"
  homepage "https://github.com/felixaihub/snailer-cli"
  version "0.1.12"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/felixaihub/snailer-cli/releases/download/v0.1.12/snailer-v0.1.12-aarch64-apple-darwin.tar.gz"
      sha256 "b560308b7757919c29986b831ef355036d85f705204a9c2a03a99a1aea270360"
    else
      url "https://github.com/felixaihub/snailer-cli/releases/download/v0.1.12/snailer-v0.1.12-x86_64-apple-darwin.tar.gz"
      sha256 "83c2849dc3f1b97af75e40ef47f827a67d77b601c61dfca889f6288e73615164"
    end
  end

  on_linux do
    url "https://github.com/felixaihub/snailer-cli/releases/download/v0.1.12/snailer-v0.1.12-x86_64-unknown-linux-musl.tar.gz"
    sha256 "332d1bfc25f97ec5289f7930979429b2b3d4a6987cc61e54c878c6cf793a4e61"
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
