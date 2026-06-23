class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.13.0/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0f34322ec127c5a807f5407586baf7cc47cb2cef2700b7299920bb9f74ab29fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.13.0/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8968e5799edeb4c42614623791c7a13a3fb538c8db0277fb07a0672483657fe6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.13.0/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "21c2e75feb87fd6591c1a58c641200f2b74f8fca67727f88a1cf7fff665a3b5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.13.0/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aca082de6faa20cdd3ac7b1d917ab5c4a0b2364cd915f568bbb1d112b6c20fa9"
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
    bin.install "loom", "loom-daemon", "loom-mcp", "loom-shim-chromium" if OS.mac? && Hardware::CPU.arm?
    bin.install "loom", "loom-daemon", "loom-mcp", "loom-shim-chromium" if OS.mac? && Hardware::CPU.intel?
    bin.install "loom", "loom-daemon", "loom-mcp", "loom-shim-chromium" if OS.linux? && Hardware::CPU.arm?
    bin.install "loom", "loom-daemon", "loom-mcp", "loom-shim-chromium" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
