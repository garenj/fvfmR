.fvfm_env_name <- "fvfm-env"

# Locate the Python executable that has fvfmPy installed. In order of priority:
#   1. the `python` argument
#   2. options(fvfmR.python = "...")
#   3. the FVFMR_PYTHON environment variable
#   4. the 'fvfm-env' virtualenv created by fvfm_setup()
.fvfm_python <- function(python = NULL) {
  if (is.null(python)) python <- getOption("fvfmR.python")
  if (is.null(python) && nzchar(Sys.getenv("FVFMR_PYTHON"))) {
    python <- Sys.getenv("FVFMR_PYTHON")
  }
  if (is.null(python)) {
    if (!reticulate::virtualenv_exists(.fvfm_env_name)) {
      stop(
        "No Python environment with fvfmPy was found.\n",
        "Run fvfm_setup() once to create one, or point to an existing ",
        "Python with options(fvfmR.python = '/path/to/venv/bin/python').",
        call. = FALSE
      )
    }
    python <- reticulate::virtualenv_python(.fvfm_env_name)
  }

  # Make the path absolute without normalizePath(), which would resolve a
  # virtualenv's python symlink to the base interpreter and bypass the venv
  python <- path.expand(python)
  if (!grepl("^(/|[A-Za-z]:)", python)) python <- file.path(getwd(), python)
  if (!file.exists(python)) {
    stop("Python executable not found: ", python, call. = FALSE)
  }
  python
}

# Stop with a helpful message if fvfmPy cannot be imported by `python`.
.check_fvfmpy <- function(python) {
  status <- system2(python, c("-c", shQuote("import fvfmPy")),
                    stdout = FALSE, stderr = FALSE)
  if (status != 0) {
    stop(
      "fvfmPy could not be imported by ", python, "\n",
      "Run fvfm_setup() to install it, or pip install fvfmPy into that ",
      "environment.",
      call. = FALSE
    )
  }
  invisible(TRUE)
}
