#' Set up the Python environment for the fvfmR package
#'
#' Creates a dedicated virtual environment called \code{fvfm-env} and installs
#' the \href{https://github.com/garenj/fvfmPy}{fvfmPy} Python package and its
#' dependencies into it. Run this once after installing the package, or again
#' to update fvfmPy. The environment is created in reticulate's virtualenv
#' folder (see \code{\link[reticulate]{virtualenv_root}}) and needs about
#' 1.5 GB of disk space.
#'
#' By default the latest release of fvfmPy is installed from PyPI. Use
#' \code{source} to install from a downloaded \code{.tar.gz} or \code{.whl}
#' file instead. Running \code{fvfm_setup()} again updates fvfmPy to the
#' latest release.
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
#'   release from PyPI.
#' @param ask Logical. Ask for confirmation before creating or modifying the
#'   Python environment? Default: \code{TRUE} in interactive sessions.
#'
#' @return Invisible path to the environment's Python executable, or
#'   \code{NULL} if setup was cancelled.
#' @export
#'
#' @examples
#' \dontrun{
#' fvfm_setup()
#' fvfm_setup(source = "~/Downloads/fvfmpy-1.0.0.tar.gz")
#' }
fvfm_setup <- function(python = NULL, source = NULL, ask = interactive()) {
  env_name <- .fvfm_env_name

  if (isTRUE(ask)) {
    env_path <- file.path(reticulate::virtualenv_root(), env_name)
    action <- if (reticulate::virtualenv_exists(env_name)) {
      "install or update fvfmPy in the existing Python environment"
    } else {
      "create a Python environment"
    }
    prompt <- paste0(
      "fvfm_setup() will ", action, " at\n  ", env_path, "\n",
      "and download fvfmPy and its dependencies (about 1.5 GB of disk space ",
      "once installed). Continue?"
    )
    if (!isTRUE(utils::askYesNo(prompt))) {
      message("Setup cancelled. Nothing was changed.")
      return(invisible(NULL))
    }
  }

  if (!reticulate::virtualenv_exists(env_name)) {
    message("Creating Python virtual environment '", env_name, "' ...")
    reticulate::virtualenv_create(envname = env_name, python = python)
  } else {
    message("Python virtual environment '", env_name, "' already exists.")
  }

  message("Installing fvfmPy and its dependencies (this may take a few minutes) ...")
  package <- if (is.null(source)) "fvfmPy" else normalizePath(source, mustWork = TRUE)
  reticulate::virtualenv_install(env_name, packages = package)
  # Pre-release builds of fvfmPy on TestPyPI were numbered 1.0.3, higher than
  # the PyPI releases, so pip would keep them. Reinstall fvfmPy itself (not its
  # dependencies) so that the requested version is always the one installed.
  reticulate::virtualenv_install(
    env_name,
    packages    = package,
    pip_options = c("--force-reinstall", "--no-deps")
  )

  python <- reticulate::virtualenv_python(env_name)
  .check_fvfmpy(python)

  message(
    "\nSetup complete. fvfmPy is installed in '", env_name, "'.\n",
    "Start the fvfmPy window with:\n",
    "  library(fvfmR)\n",
    "  results <- run_fvfm()                          # choose a folder in the window\n",
    "  results <- run_fvfm('/path/to/image/folder')   # or open a folder directly"
  )
  invisible(python)
}
