class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "http://home.thep.lu.se/~torbjorn/Pythia.html"
  url "https://pythia.org/download/pythia83/pythia8306.tgz"
  version "8.306"
  sha256 "734803b722b1c1b53c8cf2f0d3c30747c80fc2dde5e0ba141bc9397dad37a8f6"

  depends_on "boost"
  depends_on "hepmc"
  depends_on "lhapdf"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-hepmc2=#{Formula["hepmc"].opt_prefix}
      --with-lhapdf6=#{Formula["lhapdf"].opt_prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    ENV["PYTHIA8DATA"] = share/"Pythia8/xmldoc"

    cp_r share/"Pythia8/examples/.", testpath
    system "make", "main01"
    system "./main01"
    system "make", "main41"
    system "./main41"
  end
end
