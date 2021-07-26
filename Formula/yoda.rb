class Yoda < Formula
  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://yoda.hepforge.org/downloads/?f=YODA-1.7.5.tar.bz2"
  sha256 "7b1dc7bb380d0fbadce12072f5cc21912c115e826182a3922d864e7edea131db"

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
