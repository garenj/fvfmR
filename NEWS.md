# fvfmR 1.0.0

* First CRAN release.
* fvfmR is now an R interface to the 'fvfmPy' Python package (>= 1.0.0).
  `run_fvfm()` opens the fvfmPy window, with or without a folder of `.pim`,
  `.tif` or `.tiff` images, and returns the logged observations to R as a
  data frame when the window is closed.
* `fvfm_setup()` creates the 'fvfm-env' Python environment and installs
  fvfmPy from PyPI, after asking for confirmation in interactive sessions.
  Running it again updates fvfmPy, including replacing pre-release builds
  from TestPyPI.
  Alternatively, use `options(fvfmR.python = ...)` to point to an existing
  Python environment.
* New `fvfm_example()` gives the path to two example `.pim` images.
* `convert_pim()` has been removed: fvfmPy reads `.pim` files directly.
* The package has been renamed from fvfm to fvfmR, to match fvfmPy.
