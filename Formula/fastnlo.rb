class Fastnlo < Formula
  desc "Fast pQCD calculations for PDF fits"
  homepage "https://fastnlo.hepforge.org"
  url "https://fastnlo.hepforge.org/code/v23/fastnlo_toolkit-2.3.1pre-2411.tar.gz"
  version "2.3.1.2411"
  sha256 "cbe2cbf5785690e23e964fb9922895acda1210565e481657be23d62bc699a93a"

  depends_on "lhapdf"
  depends_on "gcc" # for gfortran
  depends_on "fastjet" => :optional
  depends_on "hoppet"  => :optional
  depends_on "python"  => :optional
  depends_on "qcdnum"  => :optional
  depends_on "root"    => :optional
  depends_on "yoda"    => :optional

  if build.with? "python"
    depends_on "swig"    => :build
  end

  def am_opt(pkg)
    (build.with? pkg) ? "--with-#{pkg}=#{Formula[pkg].opt_prefix}" : "--without-#{pkg}"
  end

  def install
    ENV.cxx11

    gfortlibpath = File.dirname(`gfortran --print-file-name libgfortran.dylib`)
    inreplace "fastnlotoolkit/Makefile.in", "-fext-numeric-literals", ""
    inreplace "fastnlotoolkit/Makefile.in", "-lgfortran", "-lgfortran -L#{gfortlibpath}"

    if build.with? "python"
      ENV.append "PYTHON_VERSION", "3"
    end
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-lhapdf=#{Formula["lhapdf"].opt_prefix}
    ]

    args << am_opt("fastjet")
    args << am_opt("qcdnum")
    args << am_opt("hoppet")
    args << am_opt("yoda")
    args << am_opt("root")
    args << "--enable-pyext" if build.with? "python"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/fnlo-tk-cppread", "-h"
  end
end
