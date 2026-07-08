class Dxai < Formula
  desc "Clean, optimize, and manage AI dev environments on your Mac"
  homepage "https://github.com/glen15/dxai"
  url "https://github.com/glen15/dxai/archive/refs/tags/V1.0.23.tar.gz"
  sha256 "35347dd2661952e7df3d0768bf57eb16c877f54bc8845efbf09c3bbb1b291d00"
  license "MIT"
  head "https://github.com/glen15/dxai.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  resource "binaries-arm64" do
    on_arm do
      url "https://github.com/glen15/dxai/releases/download/V1.0.23/binaries-darwin-arm64.tar.gz"
      sha256 "efcb5e29698cf4c117a3cc36d5f84b3e2116ec17c98efbdd3877515eafbc2038"
    end
  end

  resource "binaries-amd64" do
    on_intel do
      url "https://github.com/glen15/dxai/releases/download/V1.0.23/binaries-darwin-amd64.tar.gz"
      sha256 "ceb91f905a4f0015c77630e2088251361f946d059cfc7e2cafef95bd87d41df7"
    end
  end

  def install
    # Install main CLI script
    bin.install "dxai"

    # Install support files
    (var/"lib/dxai").install Dir["bin/*.sh"]
    (var/"lib/dxai/lib").install Dir["lib/*"]

    # Build Go binaries if not using pre-built
    config_bin = var/"lib/dxai/bin"
    config_bin.mkpath

    system "go", "build", *std_go_args(ldflags: "-s -w", output: config_bin/"analyze-go"), "./cmd/analyze"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: config_bin/"status-go"), "./cmd/status"
  end

  test do
    assert_match "dxai version", shell_output("#{bin}/dxai --version")
  end
end
