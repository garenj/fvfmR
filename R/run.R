#' Run the fvfmPy leaf disc analysis GUI
#'
#' Opens the fvfmPy window on a folder of \code{.pim}, \code{.tif} or
#' \code{.tiff} images from a Walz ImagingPAM. Use the window to check the
#' detected leaf discs, adjust rotation, cropping, rows/columns and
#' segmentation settings, and press \emph{Analyze} (or Enter) to log each image.
#' See the \href{https://github.com/garenj/fvfmPy}{fvfmPy User's Guide} for
#' details.
#'
#' R waits while the window is open. When you close it, every observation
#' logged during the session is returned as a data frame, so there is no need
#' to use the \emph{Save results} button (it still works if you want an extra
#' copy).
#'
#' The GUI runs as a separate Python process, so a problem in the GUI cannot
#' crash your R session.
#'
#' @param directory Path to the folder containing the images.
#' @param output Optional path to a CSV file to write the results to.
#' @param overwrite Logical. Overwrite \code{output} if it already exists?
#'   Default: \code{FALSE}.
#' @param python Optional path to a Python executable with fvfmPy installed.
#'   See \code{\link{fvfm_setup}} for how the default is chosen.
#'
#' @return Invisibly, a data frame with one row per leaf disc and columns
#'   \code{filename}, \code{row}, \code{col}, \code{leaf_number},
#'   \code{centroid_x}, \code{centroid_y}, \code{mean_Fo}, \code{mean_Fm} and
#'   \code{FvFm}; or \code{NULL} if no images were analysed.
#' @export
#'
#' @examples
#' \dontrun{
#' results <- run_fvfm("~/Dropbox/Experiment1/images")
#' run_fvfm("~/Dropbox/Experiment1/images", output = "results.csv")
#' }
run_fvfm <- function(directory, output = NULL, overwrite = FALSE,
                     python = NULL) {
  dir <- normalizePath(directory, mustWork = TRUE)
  if (!dir.exists(dir)) {
    stop("'directory' must be a folder: ", dir, call. = FALSE)
  }
  if (!is.null(output) && file.exists(output) && !isTRUE(overwrite)) {
    stop("Output file already exists: ", output,
         "\nUse overwrite = TRUE to replace it.", call. = FALSE)
  }

  python <- .fvfm_python(python)
  .check_fvfmpy(python)

  launcher <- system.file("python", "fvfm_launch.py", package = "fvfmR")
  if (!nzchar(launcher)) {
    stop("Cannot find the fvfmR launcher script. Try reinstalling the package.",
         call. = FALSE)
  }

  results_csv <- tempfile("fvfm_results_", fileext = ".csv")
  on.exit(unlink(results_csv), add = TRUE)

  message("Opening fvfmPy. Close the window when you are finished to return to R.")
  status <- system2(python, shQuote(c(launcher, dir, results_csv)))
  if (status != 0) {
    stop("fvfmPy exited with an error (status ", status, "). ",
         "See the messages above for details.", call. = FALSE)
  }

  if (!file.exists(results_csv)) {
    message("No images were analysed.")
    return(invisible(NULL))
  }

  results <- utils::read.csv(results_csv, stringsAsFactors = FALSE)
  message(nrow(results), " observations logged from ",
          length(unique(results$filename)), " images.")

  if (!is.null(output)) {
    utils::write.csv(results, output, row.names = FALSE)
    message("Results written to ", normalizePath(output))
  }

  invisible(results)
}
