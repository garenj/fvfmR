#' Set up the Python environment for the fvfmR package
#'
#' Creates a dedicated virtual environment called \code{fvfm-env} and installs
#' the \href{https://github.com/garenj/fvfmPy}{fvfmPy} Python package and its
#' dependencies into it. Run this once after installing the package, or again
#' to update fvfmPy.
#'
#' By default fvfmPy is installed from TestPyPI, and its dependencies from
#' PyPI. Use \code{source} to install from a downloaded \code{.tar.gz} or
#' \code{.whl} file instead.
#'
#' If you already have a Python environment with fvfmPy installed, you can skip
#' this step and point the package at it with
#' \code{options(fvfmR.python = "/path/to/venv/bin/python")}.
#'
#' @param python Path to a Python 3.10+ executable used to create the virtual
#'   environment. \code{NULL} (default) lets reticulate find Python on your
#'   system.
#' @param source Optional path to a local fvfmPy source (\code{.tar.gz}) or
#'   wheel (\code{.whl}) file. \code{NULL} (default) installs the latest
#'   version from TestPyPI.
#'
#' @return Invisible path to the environment's Python executable.
#' @export
#'
#' @examples
#' \dontrun{
#' fvfm_setup()
#' fvfm_setup(source = "~/Downloads/fvfmpy-1.0.3.tar.gz")
#' }
fvfm_setup <- function(python = NULL, source = NULL) {
  env_name <- .fvfm_env_name

  if (!reticulate::virtualenv_exists(env_name)) {
    message("Creating Python virtual environment '", env_name, "' ...")
    reticulate::virtualenv_create(envname = env_name, python = python)
  } else {
    message("Python virtual environment '", env_name, "' already exists.")
  }

  message("Installing fvfmPy and its dependencies (this may take a few minutes) ...")
  if (is.null(source)) {
    # fvfmPy is only published on TestPyPI. Install its dependencies from PyPI
    # first so that none of them are resolved from TestPyPI.
    reticulate::virtualenv_install(
      env_name,
      packages = c("numpy", "opencv-python", "scipy", "scikit-image",
                   "PySide6", "matplotlib", "pandas")
    )
    reticulate::virtualenv_install(
      env_name,
      packages    = "fvfmPy",
      pip_options = c("--index-url=https://test.pypi.org/simple/", "--no-deps")
    )
  } else {
    reticulate::virtualenv_install(
      env_name,
      packages = normalizePath(source, mustWork = TRUE)
    )
  }

  python <- reticulate::virtualenv_python(env_name)
  .check_fvfmpy(python)

  message(
    "\nSetup complete. fvfmPy is installed in '", env_name, "'.\n",
    "Analyse a folder of images with:\n",
    "  library(fvfmR)\n",
    "  results <- run_fvfm('/path/to/image/folder')"
  )
  invisible(python)
}
