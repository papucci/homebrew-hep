class Nnllfast < Formula
  desc "Fast SUSY cross section calculations"
  homepage "http://pauli.uni-muenster.de/~akule_01/nnllfast/doku.php?id=start"
  url "http://pauli.uni-muenster.de/~akule_01/nnllfast/dl/nnllfast-1.0.tar.bz2"
  version "1.0"
  sha256 '5def31d667b3c19d90492e20e88b2dd68770c983c975d18db794317492c49720'

  depends_on "gcc" # for gfortran

  def install
    system "gfortran ./*.f -o ./nnllfast"

    (prefix).install Dir[buildpath/'*.grid'], buildpath/'nnllfast'

    system 'touch ./nnllfast-13'

    inreplace 'nnllfast-13', '', "#!/bin/bash\npushd #{prefix} >/dev/null\n./nnllfast $@\npopd >/dev/null\n"

    bin.install 'nnllfast-13'

  end

end
