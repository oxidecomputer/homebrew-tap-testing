class DistTest < Formula
  desc "Test program for oxidecomputer/cargo-dist releases"
  homepage "https://github.com/oxidecomputer/dist-test"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/dist-test/releases/download/v0.1.2/dist-test-aarch64-apple-darwin.tar.xz"
      sha256 "cb49b1e25641c3b974ef0371a36fa460bbaa0c3b3313975e579063fe07bb4931"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/dist-test/releases/download/v0.1.2/dist-test-x86_64-apple-darwin.tar.xz"
      sha256 "70337d941c2b0b6754b86e5a6b6c7d89960fd0a1a42ab01e5a864e4806d94340"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oxidecomputer/dist-test/releases/download/v0.1.2/dist-test-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3f2dcb8ecc4d5f453626b27e7ae54ee52195c5742890061412b3bddf0f9def0d"
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
      bin.install "dist-test"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dist-test"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dist-test"
    end

    install_binary_aliases!
    generate_completions_from_executable(
      bin/"dist-test",
      "completion",
      shell_parameter_format: :arg,
    )

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_predicate bin/"dist-test", :executable?
  end
end
