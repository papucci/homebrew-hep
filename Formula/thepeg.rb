class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "https://herwig.hepforge.org"
  url "https://thepeg.hepforge.org/downloads/ThePEG-2.1.4.tar.bz2"
  sha256 "400c37319aa967ed993fdbec84fc65b24f6cb3779fb1b173d7f5d7a56b772df5"

  head do
    url "http://thepeg.hepforge.org/hg/ThePEG", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "boost"
  depends_on "gsl"
  depends_on "fastjet" => :recommended
  depends_on "hepmc"   => :recommended
  depends_on "lhapdf"  => :recommended
  depends_on "rivet"   => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-stdcxx11
      --without-javagui
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/setupThePEG", "#{share}/ThePEG/MultiLEP.in"
    system "#{bin}/runThePEG", "MultiLEP.run"
  end
end
