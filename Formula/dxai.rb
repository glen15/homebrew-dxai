class Dxai < Formula
  desc "Clean, optimize, and manage AI dev environments on your Mac"
  homepage "https://github.com/glen15/dxai"
  url "https://github.com/glen15/dxai/archive/refs/tags/V1.0.24.tar.gz"
  sha256 "82cbe385d1d6eb540c75718f6c52842b59597c530eaa7026b69c962fa817485c"
  license "MIT"
  head "https://github.com/glen15/dxai.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  resource "binaries-arm64" do
    on_arm do
      url "https://github.com/glen15/dxai/releases/download/V1.0.24/binaries-darwin-arm64.tar.gz"
      sha256 "b8d6be8e760ff0f526f4d399377c7b985f783cc4fedc1bd8cef0b98de7c32fea"
    end
  end

  resource "binaries-amd64" do
    on_intel do
      url "https://github.com/glen15/dxai/releases/download/V1.0.24/binaries-darwin-amd64.tar.gz"
      sha256 "cc0993936ab706885427aa36589698fe99394e3c8186fbe4d14589cdc7e7f941"
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
