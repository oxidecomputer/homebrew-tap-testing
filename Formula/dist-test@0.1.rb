class DistTestAT01 < Formula
  desc "Test program for oxidecomputer/cargo-dist releases"
  homepage "https://github.com/oxidecomputer/dist-test"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/oxidecomputer/dist-test/releases/download/v0.1.1/dist-test-aarch64-apple-darwin.tar.xz"
      sha256 "93991263211b81c7e79044952d0d63683f2bc9ee208dcd3bd2af93a3a70157d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/oxidecomputer/dist-test/releases/download/v0.1.1/dist-test-x86_64-apple-darwin.tar.xz"
      sha256 "b242b7427f800dc7f476e827a86c3be082e5f8b4fd1394ae9f6ddf62a446fd80"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/oxidecomputer/dist-test/releases/download/v0.1.1/dist-test-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8d764933ea45f70350625f76e540a0f9f788dcd95b5c6ab6c9702eacb326ee64"
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
      bin.install "dist-test" => "dist-test-0.1"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dist-test" => "dist-test-0.1"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dist-test" => "dist-test-0.1"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  def caveats
    <<~EOS
      This formula installs its commands with a version suffix:
        dist-test-0.1
    EOS
  end

  test do
    assert_predicate bin/"dist-test-0.1", :executable?
  end
end
