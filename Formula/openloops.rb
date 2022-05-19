class Openloops < Formula
  desc "Fully automated implementation of the Open Loops algorithm"
  homepage "https://openloops.hepforge.org"
  url "https://openloops.hepforge.org/downloads?f=OpenLoops-2.1.2.tar.gz"
  sha256 "f52575cae3d70b6b51a5d423e9cd0e076ed5961afcc015eec00987e64529a6ae"

  livecheck do
    url "https://openloops.hepforge.org/downloads"
    regex(/href=.*?OpenLoops[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "981e3f2b5601f6839548abeab6a122f5dfe3c5b571659efcbcf5e9a21ee6765b"
    sha256 cellar: :any, big_sur:  "86fbc11f2e61b0a1e4b23f37952e1249b3da36f52b2fc5dd99a5ba8b30247a1a"
    sha256 cellar: :any, catalina: "79bad08133f8e46db91580c5659bbcb57b259d717d820d362244ea57fa57b2cc"
  end

  depends_on "scons" => :build
  depends_on arch: :x86_64 # https://github.com/davidchall/homebrew-hep/issues/203
  depends_on "gcc" # for gfortran

  patch :DATA

  def install
    system "scons"
    cp_r ".", prefix
    bin.install_symlink prefix/"openloops"
  end

  def caveats
    <<~EOS
      OpenLoops downloads and installs process libraries in its
      own installation path: #{prefix}

      These process libraries are lost if OpenLoops is uninstalled.

    EOS
  end

  test do
    system bin/"openloops", "help"
  end
end

__END__
diff --git a/openloops b/openloops
index 5f068c9..e3e09f7 100755
--- a/openloops
+++ b/openloops
@@ -63,6 +63,9 @@ else
     return 0
        fi

+  # Make sure we execute everything from $BASEDIR
+  cd $BASEDIR
+
 fi

 #####################

diff --git a/SConstruct b/SConstruct
index 1111ea7..d0e9a0b 100644
--- a/SConstruct
+++ b/SConstruct
@@ -387,6 +387,7 @@ env = Environment(tools = ['default', 'textfile'] + [config['fortran_tool']],
                   LINKFLAGS = config['link_flags'],
                   LIBPATH = [config['generic_lib_dir']],
                   DOLLAR = '\$$',
+                  RPATHPREFIX = "-rpath,",
                   RPATH = [HashableLiteral('\$$ORIGIN')],
                   F90 = config['fortran_compiler'],
                   FORTRAN = config['fortran_compiler'],
