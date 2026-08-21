class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.15.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.2/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1a346edf91dd51674a753dbed6aaf47e06a075ddb6de7fe3f87c0143ef18c5c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.2/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9870e0a744eeeefe80fd76b3fd8d4ec8ecda7e2d18504693b2aac47d90517e04"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.2/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9c4d2e8eb3390ba07fb04be156c2cd7d22891b5b1b5c8805a5922ec4989999a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.2/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b883605465b0607bc4abbbffacc7e8baf1aa46431db4d9bf73bc31ea2c0fa2e7"
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
