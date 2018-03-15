class Nllfast < Formula
  desc "Fast SUSY cross section calculations"
  homepage "http://pauli.uni-muenster.de/~akule_01/nnllfast/doku.php?id=nllfast"
  url "http://pauli.uni-muenster.de/~cbors_01/nllfast/nllfast-3.1-13TeV.tar.bz2"
  version "3.1-2.11-1.21"
  sha256 '30415727b25c770b03661014f903c7504fb4a989707ad85fa1e47df2665aab1d'

  resource "nllfast21_grid" do
    url "http://pauli.uni-muenster.de/~akule_01/nllfast/nllfast-2.11grids.tar"
    version "2.11"
    sha256 '7070e913e0ca95b6ce787b7d186e827188cd7ee1c80927957b51706d9a5f43c3'
  end

  resource "nllfast21_f" do
    url "http://pauli.uni-muenster.de/~akule_01/nllfast/nllfast-2.1.f"
    version "2.1"
    sha256 'e9b99f74e7cd7e8b0ebc502f9cd577f5d053419f55aac166c743e9ca8ac6481c'
  end

  resource "nllfast12_grid" do
    url "http://pauli.uni-muenster.de/~akule_01/nllfast/nllfast-1.21grids.tar"
    version "1.21"
    sha256 '43f40d8d09ce29f4ed905640bc7a36759d066e2700740d74c82dcf3f85b8f7e0'
  end

  resource "nllfast12_f" do
    url "http://pauli.uni-muenster.de/~akule_01/nllfast/nllfast-1.2.f"
    version "1.2"
    sha256 '14ee14794a8fa42c6abad2a0fe2c0b9738cb065a115116ab4dff7848e0b96599'
  end

  depends_on "gcc" # for gfortran

  def install
    (buildpath/'13TeV').install Dir['*.{grid,f}']

    resource('nllfast12_grid').stage do
      (buildpath/'7TeV').install Dir['*']    
    end

    resource('nllfast21_grid').stage do
      (buildpath/'8TeV').install Dir['*']    
    end

    resource('nllfast12_f').stage do
      (buildpath/'7TeV').install Dir['*']    
    end

    resource('nllfast21_f').stage do
      (buildpath/'8TeV').install Dir['*']    
    end

    system "gfortran ./13TeV/*.f -o ./13TeV/nllfast"
    system "gfortran ./7TeV/*.f -o ./7TeV/nllfast"
    system "gfortran ./8TeV/*.f -o ./8TeV/nllfast"


    (prefix/'7TeV').install Dir[buildpath/'7TeV/*.grid'], buildpath/'7TeV/nllfast'
    (prefix/'8TeV').install Dir[buildpath/'8TeV/*.grid'], buildpath/'8TeV/nllfast'
    (prefix/'13TeV').install Dir[buildpath/'13TeV/*.grid'], buildpath/'13TeV/nllfast'

    system 'touch ./nllfast-7'
    system 'touch ./nllfast-8'
    system 'touch ./nllfast-13'

    inreplace 'nllfast-7', '', "#!/bin/bash\npushd #{prefix}/7TeV >/dev/null\n./nllfast $@\npopd >/dev/null\n"
    inreplace 'nllfast-8', '', "#!/bin/bash\npushd #{prefix}/8TeV >/dev/null\n./nllfast $@\npopd >/dev/null\n"
    inreplace 'nllfast-13', '', "#!/bin/bash\npushd #{prefix}/13TeV >/dev/null\n./nllfast $@\npopd >/dev/null\n"

    bin.install 'nllfast-7'
    bin.install 'nllfast-8'
    bin.install 'nllfast-13'

  end

end
