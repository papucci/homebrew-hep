class Evtgen < Formula
  desc "Hadron decays"
  version "2.02.03"
  homepage "https://evtgen.hepforge.org"
  url "https://evtgen.hepforge.org/downloads?f=EvtGen-02.02.03.tar.gz"
  sha256 "b642700b703190e3304edb98ff464622db5d03c1cfc5d275ba4a628227d7d6d0"

  option "with-test", "Test during installation"

  depends_on "cmake" => [:build, :test]
  depends_on "hepmc3" => :recommended
#  depends_on "hepmc2" => :optional
  depends_on "tauola++" => :recommended
  depends_on "photos++" => :recommended
  depends_on "pythia8" => :recommended


  def install

      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
      ]

#      args << "-DTauolapp_ENABLE_EXAMPLES=OFF" if not build.with? "test"
      args << "-DEVTGEN_HEPMC3=ON" if build.with? "hepmc3"
      args << "-DEVTGEN_PHOTOS=ON" if build.with? "photos++"
      args << "-DEVTGEN_TAUOLA=ON" if build.with? "tauola++"
      args << "-DEVTGEN_PYTHIA=ON" if build.with? "pythia8"

      system "cmake", "-S", "./R02-02-03", "-B", "build", *args
      system "cmake", "--build", "build"
#      system "make", "test" if build.with? "test"
      system "cmake", "--install", "build"
  end

end

