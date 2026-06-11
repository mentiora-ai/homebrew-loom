class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.11.0/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a502cf402c2835a56e675df5d7e62c2e8d6f1d5f977f6a952fd59b8d183bd746"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.11.0/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4c1910df9a22b1960bb712159b0a947b05adfa575e5451ab562ab6bfb3414cbe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.11.0/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e4b32742b6f8c68403b59906692242075683bdde990395292aef90cad79e9b39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.11.0/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ebd906363363dec68374e9ffe6a276786fa75af19258e1c78444b809fd9623df"
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
