class Loom < Formula
  desc "Agent-first browser automation runtime — deterministic Chromium sessions with replay-equal hash chains, MCP-native tools, and a content-addressed action store."
  homepage "https://github.com/mentiora-ai/loom"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.12.0/loom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1db81c712405e9fd0ad66422c09e133ea0a55bec825bd801773c1ac4aa29c70c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.12.0/loom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6ca397387c76b036797173b2805892b17914c54f39f428ab2d5ec5049a0865de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.12.0/loom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ede35d862c8baa85067c153ad50aa557aef6d1329c418706505e64656b0f343e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mentiora-ai/loom/releases/download/v0.12.0/loom-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f99fb34afcd8013f9ee575114a2e8d26f876ab92bd8667ed2f3b5ddf2225cb3"
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
