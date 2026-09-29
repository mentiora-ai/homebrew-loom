class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.15.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.7/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4504bbebcfa665e9e9a33845f29930f7d9a758d7c96c403c74a24a31f6fd22eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.7/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "dffc45cfa6e2a43c4683662f496bb6289a2f69e02bedae8d7fc6ad7df7e12957"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.7/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60db7b62de9eee95be39cdc84497c40e78b0f091b5ba86bd45250f355229e7ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.15.7/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "109406603610c73b95f5fd77a2f061fef30127cf3a3d79c89618d06f1a3d5507"
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
