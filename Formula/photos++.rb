class Photosxx < Formula
  desc "Photon emissions corrections"
  version "3.64"
  homepage "https://photospp.web.cern.ch/photospp/"
  url "http://photospp.web.cern.ch/photospp/resources/PHOTOS.3.64/PHOTOS.3.64.tar.gz"
  sha256 "92c545d83c0f654ca40949c7e36e79a96230421659a4621cd9ae9c82dd5a30ee"

  depends_on "hepmc3" => :recommended
  depends_on "hepmc2" => :optional
  depends_on "automake" => :build


  patch :DATA

  def install

    args = %W[
      --prefix=#{prefix}
    ]

    args << "--with-hepmc=#{Formula["hepmc2"].opt_prefix}"   if build.with? "hepmc2"
    args << "--with-hepmc3=#{Formula["hepmc3"].opt_prefix}"   if build.with? "hepmc3"
#    args << "--with-pythia8=#{Formula["pythia8"].opt_prefix}"   if build.with? "pythia8"
#    args << "--with-tauola=#{Formula["tauola++"].opt_prefix}"   if build.with? "tauola++"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

end

__END__
diff --git a/Makefile b/Makefile
index 1605ce5..263f5cf 100755
--- a/Makefile
+++ b/Makefile
@@ -28,19 +28,19 @@ LIB_PHOTOSPP_HEPMC3_OBJECTS  = src/$(EVENT_RECORD_INTERFACE_DIR)/PhotosHepMC3Par
 ##### Link objects to make library ######
 all: include_dir lib_dir $(EVENT_RECORD_INTERFACE_DIR) $(FORTRAN_PHOTOS_INTERFACE_DIR) $(PHOTOS_C_INTERFACE_DIR) $(PHOTOS_C_DIR) $(UTILITIES_DIR)
 	ar cr lib/$(LIB_PHOTOSPP_A) $(LIB_PHOTOSPP_OBJECTS)
-	$(LD) $(LDFLAGS) $(SOFLAGS) -o lib/$(LIB_PHOTOSPP_SO).$(LIB_VER) -Wl,-soname,$(LIB_PHOTOSPP_SO) $(LIB_PHOTOSPP_OBJECTS)
+	$(LD) $(LDFLAGS) $(SOFLAGS) -o lib/$(LIB_PHOTOSPP_SO).$(LIB_VER) -Wl,-install_name,$(LIB_PHOTOSPP_SO) $(LIB_PHOTOSPP_OBJECTS)
 	ar cr lib/$(LIB_PHOTOSPP_HEPEVT_A) $(LIB_PHOTOSPP_HEPEVT_OBJECTS)
-	$(LD) $(LDFLAGS) $(SOFLAGS) -o lib/$(LIB_PHOTOSPP_HEPEVT_SO).$(LIB_VER) -Wl,-soname,$(LIB_PHOTOSPP_HEPEVT_SO) $(LIB_PHOTOSPP_HEPEVT_OBJECTS)
+	$(LD) $(LDFLAGS) $(SOFLAGS) -o lib/$(LIB_PHOTOSPP_HEPEVT_SO).$(LIB_VER) -Wl,-install_name,$(LIB_PHOTOSPP_HEPEVT_SO) $(LIB_PHOTOSPP_HEPEVT_OBJECTS)
 	ln -sf $(LIB_PHOTOSPP_SO).$(LIB_VER) lib/$(LIB_PHOTOSPP_SO)
 	ln -sf $(LIB_PHOTOSPP_HEPEVT_SO).$(LIB_VER) lib/$(LIB_PHOTOSPP_HEPEVT_SO)
 ifneq ($(HEPMCLOCATION), )
 	ar cr lib/$(LIB_PHOTOSPP_HEPMC_A) $(LIB_PHOTOSPP_HEPMC_OBJECTS)
-	$(LD) $(LDFLAGS) $(SOFLAGS) -o lib/$(LIB_PHOTOSPP_HEPMC_SO).$(LIB_VER) -Wl,-soname,$(LIB_PHOTOSPP_HEPMC_SO) $(LIB_PHOTOSPP_HEPMC_OBJECTS)
+	$(LD) $(LDFLAGS) $(SOFLAGS) -o lib/$(LIB_PHOTOSPP_HEPMC_SO).$(LIB_VER) -Wl,-install_name,$(LIB_PHOTOSPP_HEPMC_SO) $(LIB_PHOTOSPP_HEPMC_OBJECTS)
 	ln -sf $(LIB_PHOTOSPP_HEPMC_SO).$(LIB_VER) lib/$(LIB_PHOTOSPP_HEPMC_SO)
 endif
 ifneq ($(HEPMC3LOCATION), )
 	ar cr lib/$(LIB_PHOTOSPP_HEPMC3_A) $(LIB_PHOTOSPP_HEPMC3_OBJECTS)
-	$(LD) $(LDFLAGS) $(SOFLAGS) -o lib/$(LIB_PHOTOSPP_HEPMC3_SO).$(LIB_VER) -Wl,-soname,$(LIB_PHOTOSPP_HEPMC3_SO) $(LIB_PHOTOSPP_HEPMC3_OBJECTS)
+	$(LD) $(LDFLAGS) $(SOFLAGS) -o lib/$(LIB_PHOTOSPP_HEPMC3_SO).$(LIB_VER) -Wl,-install_name,$(LIB_PHOTOSPP_HEPMC3_SO) $(LIB_PHOTOSPP_HEPMC3_OBJECTS)
 	ln -sf $(LIB_PHOTOSPP_HEPMC3_SO).$(LIB_VER) lib/$(LIB_PHOTOSPP_HEPMC3_SO)
 endif
 
diff --git a/platform/make.inc.in b/platform/make.inc.in
index a9a8ca0..7f83409 100755
--- a/platform/make.inc.in
+++ b/platform/make.inc.in
@@ -12,9 +12,9 @@ F77      = @F77@
 F77FLAGS = @FFLAGS@ -fPIC -fno-automatic -fno-backslash -ffixed-line-length-132
 FFLAGS   = $(F77FLAGS)
 
-LD       = @F77@
-LDFLAGS  = -g -lstdc++
-SOFLAGS  = -shared
+LD       = @CC@
+LDFLAGS  = -g -lc++
+SOFLAGS  = -shared -undefined dynamic_lookup
 
 RANLIB   = @RANLIB@
 AR       = ar
