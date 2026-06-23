class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.12.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.12.3/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5df5a0bbf5edcebd0410cb64ad4b5c73bf5ac7da8147348f8ef9064747449954"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.12.3/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "41bb3e5eb4cd8fa172e30c2041b6a408948096841db12b0e72d6978df7fedf00"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.12.3/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8b6e642526720aa79eb538188273e92ed1e26ffc978b8396a1b3be9a9cbeef35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.12.3/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "25308b1e87956fd3e2b90a470df88007e3722d2cf1a6f65d0271d8bbe71d9c82"
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
