class Yoda < Formula
  include Language::Python::Shebang

  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://yoda.hepforge.org/downloads/?f=YODA-1.9.10.tar.gz"
  sha256 "b9b978bdf34d688485c26b66c749c7584ee78e825961707367da54d5b95640fb"
  license "GPL-3.0-only"

  livecheck do
    url "https://yoda.hepforge.org/downloads/"
    regex(/href=.*?YODA[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 arm64_sonoma: "a3cd8db06e14abadffd88de927066c1fd4f7aba155598c6465dc23cdc71c2eed"
    sha256 ventura:      "aa12d416660611aea38f15a6ca03bfd0c34df141662c98994c22e41213986cd4"
  end

  head do
    url "http://yoda.hepforge.org/hg/yoda", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "python@3.10"
  depends_on "root" => :optional
  depends_on "python"

  if build.with? "test"
    depends_on "numpy"
  else
    depends_on "numpy" => :optional
  end

  patch :DATA

  def python
    "python3.10"
  end

  def install
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
    system "make", "install"
    system "make", "check" if build.with? "test"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    system Formula["python@3.10"].opt_bin/python, "-c", "import yoda"
    system bin/"yoda-config", "--version"
    system bin/"yodastack", "--help"
  end
end

__END__
diff --git a/pyext/build.py.in b/pyext/build.py.in
index cdebf43..6694941 100755
--- a/pyext/build.py.in
+++ b/pyext/build.py.in
@@ -35,19 +35,6 @@ libargs = " ".join("-l{}".format(l) for l in libraries)

 ## Python compile/link args
 pyargs = "-I" + sysconfig.get_config_var("INCLUDEPY")
-libpys = [os.path.join(sysconfig.get_config_var(ld), sysconfig.get_config_var("LDLIBRARY")) for ld in ["LIBPL", "LIBDIR"]]
-libpys.extend( glob(os.path.join(sysconfig.get_config_var("LIBPL"), "libpython*.*")) )
-libpys.extend( glob(os.path.join(sysconfig.get_config_var("LIBDIR"), "libpython*.*")) )
-libpy = None
-for lp in libpys:
-    if os.path.exists(lp):
-        libpy = lp
-        break
-if libpy is None:
-    print("No libpython found in expected location exiting")
-    print("Considered locations were:", libpys)
-    sys.exit(1)
-pyargs += " " + libpy
 pyargs += " " + sysconfig.get_config_var("LIBS")
 pyargs += " " + sysconfig.get_config_var("LIBM")
 #pyargs += " " + sysconfig.get_config_var("LINKFORSHARED")
@@ -92,7 +79,8 @@ for srcname in srcnames:
         xlinkargs += " " + "@ROOT_LDFLAGS@ @ROOT_LIBS@"

     ## Assemble the compile & link command
-    compile_cmd = "  ".join([os.environ.get("CXX", "g++"), "-shared -fPIC", "-o {}.so".format(srcname),
+    compile_cmd = "  ".join([sysconfig.get_config_var("LDCXXSHARED"), "-std=c++11",
+                             "-o {}.so".format(srcname),
                              srcpath, incargs, xcmpargs, xlinkargs, libargs, pyargs])
     print("Build command =", compile_cmd)
