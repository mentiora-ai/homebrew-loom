class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.15.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.8/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "440200a50b622675050862f7c2ed647db7f766ba6bd123616d4b6266b74d05b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.8/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b241e3430a0b9e4336f66db9a84ae5f7e9aca948e041647fbc60f83e9fde0659"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.8/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c78dae678b98f080e54b078ccca7621938d310557a6ca307e285d4a313b8c8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.8/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "49057fd065d219e4bd8318b46b9ef9d8ae6ad5c473c7759d2761a4a450c3c4b6"
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
