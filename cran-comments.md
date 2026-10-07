## Submission

This is a new submission.

## Test environments

* local macOS (aarch64), R 4.6.0
* GitHub Actions: macOS (R-release), Windows (R-release), Ubuntu (R-devel,
  R-release, R-oldrel-1)
* win-builder: R-devel (2026-10-05 r90641 ucrt)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.
* Possibly misspelled words in DESCRIPTION (Fo, Fv, fluorometer,
  photosystem): these are correct; see below.

## Notes for CRAN reviewers

* fvfmR is an R interface to the 'fvfmPy' Python package
  (https://pypi.org/project/fvfmPy/), which provides an interactive window
  for analysing leaf disc fluorescence images. 'Python' and 'fvfmPy' are
  declared in SystemRequirements.

* The examples for `run_fvfm()` and `fvfm_setup()` are wrapped in `\dontrun{}`
  because they cannot be run on CRAN's machines: `fvfm_setup()` downloads and
  installs Python packages, and `run_fvfm()` needs 'fvfmPy' and opens an
  interactive window. `fvfm_example()` has runnable examples.

* The tests do not need Python. The one test that needs 'fvfmPy' is skipped
  on CRAN.

* `fvfm_setup()` only writes to the user's file system when the user calls it,
  and in interactive sessions it asks for confirmation first. It creates a
  Python virtual environment in reticulate's standard location
  (`reticulate::virtualenv_root()`).

* Possibly misspelled words in DESCRIPTION: "Fv", "Fm" and "Fo" are standard
  chlorophyll fluorescence parameters (variable, maximum and minimum
  fluorescence); "fluorometer" and "photosystem" are standard terms in plant
  physiology.
