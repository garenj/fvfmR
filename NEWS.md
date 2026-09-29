# fvfmR 1.0.0

* First CRAN release.
* fvfmR is now an R interface to the 'fvfmPy' Python package (>= 1.0.3).
  `run_fvfm()` opens the fvfmPy window on a folder of `.pim`, `.tif` or
  `.tiff` images and returns the logged observations to R as a data frame
  when the window is closed.
* `fvfm_setup()` creates the 'fvfm-env' Python environment and installs
  fvfmPy, after asking for confirmation in interactive sessions.
  Alternatively, use `options(fvfmR.python = ...)` to point to an existing
  Python environment.
* New `fvfm_example()` gives the path to two example `.pim` images.
* `convert_pim()` has been removed: fvfmPy reads `.pim` files directly.
* The package has been renamed from fvfm to fvfmR, to match fvfmPy.
