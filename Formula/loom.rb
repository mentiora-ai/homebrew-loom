class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.15.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.1/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ccbf845c8367a4edf7693e31e7fd3d6b54742dc29cf010e623a68f1c8bac3ab4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.1/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4c761df199504001b5cc902bef693876420d729fc2e62115a92ab9afd3370767"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.1/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd6346fb051b94148d289db049e63aac6c37e52f56186161c07c9e6c21aa5ede"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.1/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02d1c84af40e0f293a94ddbc920d20c36f321391ff79f1ae3c9fcfff4aecda61"
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
