# fvfmR: fvfmPy from R

<!-- badges: start -->
[![R-CMD-check](https://github.com/garenj/fvfmR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/garenj/fvfmR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

An R wrapper for [fvfmPy](https://github.com/garenj/fvfmPy), which does semi-automated analysis of leaf disc fluorescence images from a Walz ImagingPAM. It computes **Fv/Fm = (Fm − Fo) / Fm** for each leaf disc.

## Install

```r
remotes::install_github("garenj/fvfmR")

library(fvfmR)
fvfm_setup()   # once: creates the 'fvfm-env' Python environment and installs fvfmPy from PyPI
```

Run `fvfm_setup()` again at any time to update fvfmPy to the latest release.

Requires Python 3.10 or later. If you already have a Python environment with fvfmPy installed, skip `fvfm_setup()` and point to it instead:

```r
options(fvfmR.python = "/path/to/venv/bin/python")        # macOS / Linux
options(fvfmR.python = "C:/path/to/venv/Scripts/python.exe") # Windows
```

## Use

Try it on the two example images that ship with the package:

```r
results <- run_fvfm(fvfm_example())
```

| file | tray | what to do |
|---|---|---|
| `example1.pim` | 5 × 9, full | All 45 ROIs and the grid are detected with the default settings, so you can press Analyze straight away. |
| `example2.pim` | 6 × 10, with three empty cells (column 10, rows 4–6) | Fill the empty cells with dummy ROIs (double-click) so that every ROI gets the correct row and column. Rotating the image slightly helps align the grid. One leaf gets two ROIs with the default settings; raise *Watershed segmentation size* slightly (to about 36) to merge them. Remove any extra ROIs outside the leaves by double-clicking them. |

On your own data:

```r
results <- run_fvfm()                                           # choose a folder in the window
results <- run_fvfm("path/to/image/folder")                     # or open one directly (.pim, .tif or .tiff)
run_fvfm("path/to/image/folder", output = "results.csv")         # also write a CSV
```

The fvfmPy window opens and R waits. Check each image (use rotate, crop, rows/columns and the segmentation sliders as needed), then press **Analyze** or Enter to log it and move to the next image. When you close the window, all logged observations are returned to R as a data frame:

| column | description |
|---|---|
| `filename` | image file |
| `row`, `col`, `leaf_number` | position of the leaf disc in the grid |
| `centroid_x`, `centroid_y` | ROI centre (pixels) |
| `mean_Fo`, `mean_Fm` | mean fluorescence in the ROI |
| `FvFm` | (Fm − Fo) / Fm |

See the [fvfmPy User's Guide](https://github.com/garenj/fvfmPy) for the full walkthrough.
