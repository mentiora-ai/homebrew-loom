class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.9.0/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9244d74f1e3882e2c003b7a0222fd5cfababad71aee46d7fd2cc89243efc4218"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.9.0/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "512b861c1de2c2ca19f7af1761ca87c198ad4cad7a5670947295860b8007bffc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.9.0/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "40dc0c4c92c1ebb0fe30c0c3bb3f9df0788ebda50a54286934089708fda11039"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.9.0/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "561e8fc8aeb4c9952b2ad9d5badbc5897e98dd94451511937fe5c45c2031ffe5"
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
