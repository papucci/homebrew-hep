class Madgraph5Amcatnlo < Formula
  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/2.0/2.6.x/+download/MG5_aMC_v2.6.5.tar.gz"
  sha256 "f41d1afa11566d80c867e1bf3d8d135a28e73042d30bd75f28313dee965e0bdb"

  bottle :unneeded

  depends_on "fastjet"
  depends_on "gcc" # for gfortran

  def install
    # fix broken dynamic links
    MachO::Tools.change_install_name("vendor/DiscreteSampler/check",
                                     "/opt/local/lib/libgcc/libgfortran.3.dylib",
                                     "#{Formula["gcc"].lib}/gcc/#{Formula["gcc"].version_suffix}/libgfortran.dylib")
    MachO::Tools.change_install_name("vendor/DiscreteSampler/check",
                                     "/opt/local/lib/libgcc/libquadmath.0.dylib",
                                     "#{Formula["gcc"].lib}/gcc/#{Formula["gcc"].version_suffix}/libquadmath.0.dylib")

    cp_r ".", prefix

    # Homebrew deletes empty directories, but aMC@NLO needs them
    Dir["**/"].reverse_each { |d| touch prefix/d/".keepthisdir" if Dir.entries(d).sort==%w[. ..] }

    # fix python2

    inreplace prefix/"MadSpin/madspin",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/MadWeight/bin/madweight.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/MadWeight/bin/mw_options",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/NLO/bin/generate_events",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/NLO/bin/shower",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/NLO/bin/aMCatNLO",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/NLO/bin/calculate_xsect",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/NLO/Utilities/NLO_Born3.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/NLO/Utilities/VetoPrefactors/virt_reweighter.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/NLO/Utilities/VetoPrefactors/resum_reweighter.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/LO/bin/internal/Gridpack/gridrun",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/LO/bin/generate_events",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/LO/bin/madevent",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"aloha/bin/aloha",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"bin/mg5",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"bin/mg5_aMC",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"bin/.compile.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"madgraph/madweight/MW_driver.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"madgraph/interface/madgraph_interface.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"madgraph/various/histograms.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"madgraph/various/plot_djrs.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"madgraph/iolibs/gen_infohtml.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"madgraph/iolibs/template_files/loop_optimized/check_sa_all.py.inc",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"madgraph/iolibs/template_files/loop_optimized/check_sa.py.inc",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"madgraph/iolibs/template_files/loop/check_sa_all.py.inc",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"tests/parallel_tests/loop_sample_script.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"tests/parallel_tests/sample_script.py",  "/usr/bin/env python", "/usr/bin/env python2"
    inreplace prefix/"Template/MadWeight/src/makefile",  "python ../", "python2 ../"
    inreplace prefix/"Template/MadWeight/mod_file/mod_setup_model",  "python ./bin", "python2 ./bin"
    inreplace prefix/"INSTALL",  "python .", "python2 ."
    inreplace prefix/"tests/acceptance_tests/test_model_equivalence.py",  "call(['python','", "call(['python2','"
    inreplace prefix/"Template/LO/bin/internal/addmasses_optional.py",  "/usr/bin/python", "/usr/bin/env python2"
    inreplace prefix/"Template/LO/Source/.make_opts",  "python -c", "python2 -c"
    inreplace prefix/"bin/.compile.py",  "call('python ", "call('python2 "
    inreplace prefix/"madgraph/interface/common_run_interface.py",  "call(['python'", "call(['python2'"
    inreplace prefix/"madgraph/various/progressbar.py",  "/usr/bin/python", "/usr/bin/env python2"

  end

  def caveats; <<~EOS
    To shower aMC@NLO events with herwig++ or pythia8, first install
    them via homebrew and then enter in the mg5_aMC interpreter:

      set hepmc_path #{HOMEBREW_PREFIX}
      set thepeg_path #{HOMEBREW_PREFIX}
      set hwpp_path #{HOMEBREW_PREFIX}
      set pythia8_path #{HOMEBREW_PREFIX}

  EOS
  end

  test do
    system "echo \'generate p p > t t~\' >> test.mg5"
    system "echo \'quit\' >> test.mg5"
    system "#{bin}/mg5_aMC", "-f", "test.mg5"
  end
end
