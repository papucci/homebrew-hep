class Lhapdf < Formula
  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://www.hepforge.org/archive/lhapdf/LHAPDF-6.3.0.tar.gz"
  sha256 "ed4d8772b7e6be26d1a7682a13c87338d67821847aa1640d78d67d2cef8b9b5d"

  # bottle do
  #   root_url "https://dl.bintray.com/davidchall/bottles-hep"
  #   sha256 high_sierra: "c42504e9609b05383b06249023a0d3d1a55e80d8b3a7ab716e993142d78382c7"
  #   sha256 sierra:      "550b93a493c3b30fcdb5f2b2326d53758fb8f5d0d76a645eecda6fb239170c05"
  #   sha256 el_capitan:  "c61871005b6f6207946de9ae3f5f710a9ec5e695f324b03ac26dc554a547d432"
  # end

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.cxx11
    inreplace "wrappers/python/setup.py.in", "stdc++", "c++" if ENV.compiler == :clang

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    inreplace prefix/"bin/lhapdf",  "/usr/bin/env python", "/usr/bin/env python2"
  end

  def caveats
    <<~EOS
      PDFs may be downloaded and installed with

        lhapdf install CT10nlo

      At runtime, LHAPDF searches #{share}/LHAPDF
      and paths in LHAPDF_DATA_PATH for PDF sets.

    EOS
  end

  test do
    system "#{bin}/lhapdf", "help"
    system "python", "-c", "import lhapdf; lhapdf.version()"
  end
end
