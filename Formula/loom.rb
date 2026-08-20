class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.0/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "47e1cdc45d4d43ef1a0978e802afae63a811c92c59b45c158db676cc8633d38c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.0/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bb7e98727ba0a0af1eaa34694fc2c1ece9c2344bc5de3c4c888d46dab89a9eac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.0/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "433023eff798d4ea63ccf0a5d2278684fb44c87e6759fbdff7a3474e559369be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.0/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b671746b20d3210e2ec02de846eedd01c792323bf6a6e24faae7c6d84731ae5"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "loom", "loom-daemon", "loom-mcp", "loom-shim-chromium"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "loom", "loom-daemon", "loom-mcp", "loom-shim-chromium"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "loom", "loom-daemon", "loom-mcp", "loom-shim-chromium"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "loom", "loom-daemon", "loom-mcp", "loom-shim-chromium"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
