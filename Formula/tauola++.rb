class Tauolaxx < Formula
  desc "Tau decays"
  version "1.1.9"
  homepage "http://tauolapp.web.cern.ch/tauolapp"
  url "https://gitlab.cern.ch:8443/tauolapp/tauolapp/-/archive/master/tauolapp-master.tar.gz"
  sha256 "ad55d9fc8d0283741cfba492a8431c92ae6c2cfe5a3bd6c3f15eee8e318a2125"

  option "with-test", "Test during installation"

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" => :build # for gfortran
  depends_on "hepmc3" => :recommended
  depends_on "hepmc2" => :optional
  #depends_on "automake" => :build


  patch :DATA

  def install

    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DTauolapp_ENABLE_TAUSPINNER=ON
      ]

      args << "-DTauolapp_ENABLE_EXAMPLES=OFF" if not build.with? "test"
      args << "-DTauolapp_ENABLE_HEPMC3=ON" if build.with? "hepmc3"
      args << "-DTauolapp_ENABLE_HEPMC2=ON" if build.with? "hepmc2"

      system "cmake", buildpath, *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index df0a54c..b8f4c3c 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,6 +1,7 @@
 cmake_minimum_required(VERSION 3.6.0 FATAL_ERROR)
 #----------------------------------------------------------------------------
 project(Tauolapp LANGUAGES CXX C Fortran)
+
 set(Tauolapp_VERSION 1.1.9)
 set(Tauolapp_VERSION_MAJOR 1)
 set(Tauolapp_VERSION_MINOR 1)
@@ -170,6 +171,18 @@ foreach (c ${components})
   install(FILES ${Tauola${c}_includes} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/Tauola COMPONENT devel)
 endforeach()
 
+target_link_libraries(TauolaFortran_static PUBLIC TauolaCxxInterface_static)
+target_link_libraries(TauolaFortran PUBLIC TauolaCxxInterface)
+target_link_libraries(TauolaCxxInterface_static PUBLIC TauolaFortran_static)
+target_link_libraries(TauolaCxxInterface PUBLIC TauolaFortran_static)
+target_link_libraries(TauolaTauSpinner_static PUBLIC TauolaCxxInterface_static)
+target_link_libraries(TauolaTauSpinner PUBLIC TauolaCxxInterface)
+target_link_libraries(TauolaHEPEVT_static PUBLIC TauolaCxxInterface_static)
+target_link_libraries(TauolaHEPEVT PUBLIC TauolaCxxInterface)
+target_link_libraries(TauolaHepMC_static PUBLIC TauolaCxxInterface_static)
+target_link_libraries(TauolaHepMC PUBLIC TauolaCxxInterface)
+target_link_libraries(TauolaHepMC3_static PUBLIC TauolaCxxInterface_static)
+target_link_libraries(TauolaHepMC3 PUBLIC TauolaCxxInterface)
 
 if (TARGET TauolaHepMC)
   target_link_libraries(TauolaHepMC PRIVATE HepMC::HepMC)
