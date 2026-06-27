class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "http://geant4.cern.ch"
  url "https://gitlab.cern.ch/geant4/geant4/-/archive/v11.4.2/geant4-v11.4.2.tar.gz"
  version "11.4.2"
  sha256 "f9d5c7d108ae6be644d12997e0289e23e5d2da18df1cab9aaacd9b76412dfec6"

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-usolids", "Use USolids (experimental)"
  option "without-multithreaded", "Build without multithreading support"

  depends_on "cmake"
  depends_on "libx11"
  depends_on "xerces-c" if build.with? "gdml"
  depends_on "qt" => :optional
  depends_on "linuxbrew/xorg/glu" unless OS.mac?

  resource "G4NDL" do
    url "http://cern.ch/geant4-data/datasets/G4NDL.4.7.1.tar.gz"
    sha256 "d3acae48622118d2579de24a54d533fb2416bf0da9dd288f1724df1485a46c7c"
  end

  resource "G4EMLOW" do
    url "http://cern.ch/geant4-data/datasets/G4EMLOW.8.8.tar.gz"
    sha256 "b60cfd63176f5d16107e2a25b35b235155032d1735d749670ca50fede12624cf"
  end

  resource "G4PhotonEvaporation" do
    url "http://cern.ch/geant4-data/datasets/G4PhotonEvaporation.6.1.2.tar.gz"
    sha256 "02149c0ab91d88ee24e78532558777e39a068b9fcdd199136101ff58e635e742"
  end

  resource "G4RadioactiveDecay" do
    url "http://cern.ch/geant4-data/datasets/G4RadioactiveDecay.6.1.2.tar.gz"
    sha256 "a40d7e3ebc64d35555c4a49d0ff1e0945cd605d84354d053121293914caea13a"
  end

  resource "G4SAIDDATA" do
    url "http://cern.ch/geant4-data/datasets/G4SAIDDATA.2.0.tar.gz"
    sha256 "1d26a8e79baa71e44d5759b9f55a67e8b7ede31751316a9e9037d80090c72e91"
  end

  resource "G4PARTICLEXS" do
    url "http://cern.ch/geant4-data/datasets/G4PARTICLEXS.4.2.tar.gz"
    sha256 "c52bbf86aaa589b78aba80b16ab0adf1041ea300de5395865b97fcee6eb55851"
  end

  resource "G4ABLA" do
    url "http://cern.ch/geant4-data/datasets/G4ABLA.3.3.tar.gz"
    sha256 "1e041b3252ee9cef886d624f753e693303aa32d7e5ef3bba87b34f36d92ea2b1"
  end

  resource "G4INCL" do
    url "http://cern.ch/geant4-data/datasets/G4INCL.1.3.tar.gz"
    sha256 "e4b3dbe52acef53536454e22443091212843821bd23628eed846d299599f3bf9"
  end

  resource "G4PII" do
    url "http://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4ENSDFSTATE" do
    url "http://cern.ch/geant4-data/datasets/G4ENSDFSTATE.3.0.tar.gz"
    sha256 "4bdc3bd40b31d43485bf4f87f055705e540a6557d64ed85c689c59c9a4eba7d6"
  end

  resource "G4RealSurface" do
    url "http://cern.ch/geant4-data/datasets/G4RealSurface.2.2.tar.gz"
    sha256 "9954dee0012f5331267f783690e912e72db5bf52ea9babecd12ea22282176820"
  end

  resource "G4TENDL" do
    url "http://cern.ch/geant4-data/datasets/G4TENDL.1.4.tar.gz"
    sha256 "4b7274020cc8b4ed569b892ef18c2e088edcdb6b66f39d25585ccee25d9721e0"
  end

  resource "G4CHANNELING" do
    url "http://cern.ch/geant4-data/datasets/G4CHANNELING.2.0.tar.gz"
    sha256 "662159288644e07b79d7fe091efbebba52b59546b3dc6f5d285b976ad12f2d06"
  end

  resource "G4NUDEXLIB" do
    url "http://cern.ch/geant4-data/datasets/G4NUDEXLIB.1.0.tar.gz"
    sha256 "cac7d65e9c5af8edba2b2667d5822e16aaf99065c95f805e76de4cc86395f415"
  end

  resource "G4URRPT" do
    url "http://cern.ch/geant4-data/datasets/G4URRPT.1.1.tar.gz"
    sha256 "6a3432db80bc088aee19c504b9c0124913005d6357ea14870451400ab20d9c11"
  end

  def install
    mkdir "geant-build" do
      args = %w[
        ../
        -DGEANT4_USE_OPENGL_X11=ON
        -DGEANT4_USE_RAYTRACER_X11=ON
        -DGEANT4_BUILD_EXAMPLE=ON
      ]

      args << "-DGEANT4_USE_QT=ON" if build.with? "qt"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
      args << "-DGEANT4_USE_USOLIDS=ON" if build.with? "usolids"
      args << "-DGEANT4_BUILD_MULTITHREADED=ON" if build.with? "multithreaded"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end

  def post_install
    resources.each do |r|
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
    end
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    system "/bin/bash", "test.sh"
  end
end
