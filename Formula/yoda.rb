class Yoda < Formula
  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://yoda.hepforge.org/downloads/?f=YODA-1.7.5.tar.bz2"
  sha256 "7b1dc7bb380d0fbadce12072f5cc21912c115e826182a3922d864e7edea131db"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    sha256 cellar: :any, high_sierra: "943992b7196311683bef4f3e9f9c96490de5da4a1ad98b9618e98c0c34b7adf1"
    sha256 cellar: :any, sierra:      "b533ca5a8dec8eb39414c1a4d657a99a23679e236c8d4ac3735e56b39cec4aca"
    sha256 cellar: :any, el_capitan:  "d283f08feb0bec71556900a3de13dc4b7abca06c6a7c3bc9053830d266de3d62"
    sha256 cellar: :any, yosemite:    "fb8667b0ceac647cfc51d65d3933efec98bff385214b4139237fbefa0fecc95e"
  end

  depends_on "cython" => :build
  head do
    url "http://yoda.hepforge.org/hg/yoda", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "numpy" => :optional
  depends_on "root" => :optional
  depends_on "python"

  def install
    # ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    ENV.append "PYTHON_VERSION", "3"

    system "rm", "pyext/yoda/core.cpp"
    system "rm", "pyext/yoda/core.h"
    system "rm", "pyext/yoda/util.cpp"
    system "rm", "pyext/yoda/rootcompat.cpp"

    if build.with? "root"
      args << "--enable-root"
      ENV.append "PYTHONPATH", Formula["root"].opt_prefix/"lib/root" if build.with? "test"
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    bash_completion.install share/"YODA/yoda-completion"
  end

  test do
    system bin/"yoda-config", "--version"
    system "python", "-c", "import yoda; yoda.version()"
  end
end
