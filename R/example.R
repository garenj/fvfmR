#' Path to the example images
#'
#' fvfmR ships with two example \code{.pim} images from a Walz ImagingPAM.
#' Use them to try out \code{\link{run_fvfm}} or to check your installation.
#'
#' \describe{
#'   \item{\code{example1.pim}}{A full 5 x 9 tray. The default settings detect
#'     all 45 ROIs and the correct grid, so it can be analysed straight away.}
#'   \item{\code{example2.pim}}{A 6 x 10 tray with three empty cells (column
#'     10, rows 4 to 6), which needs some adjustment before analysis:
#'     \itemize{
#'       \item Fill the three empty cells with dummy ROIs (double-click) so that
#'         every ROI is assigned to the correct row and column.
#'       \item Rotating the image slightly helps align the grid.
#'       \item One leaf is split into two ROIs with the default settings;
#'         increasing \emph{Watershed segmentation size} slightly (to about 36)
#'         merges them.
#'     }
#'     Remove any extra ROIs outside the leaves by double-clicking them.}
#' }
#'
#' @param file Name of an example file. \code{NULL} (default) returns the
#'   folder containing all example images.
#'
#' @return Path to the example folder, or to \code{file} within it.
#' @export
#'
#' @examples
#' fvfm_example()
#' list.files(fvfm_example())
#' fvfm_example("example1.pim")
#' \dontrun{
#' results <- run_fvfm(fvfm_example())
#' }
fvfm_example <- function(file = NULL) {
  dir <- system.file("extdata", package = "fvfmR", mustWork = TRUE)
  if (is.null(file)) {
    return(dir)
  }
  path <- file.path(dir, file)
  if (!file.exists(path)) {
    stop("'", file, "' is not an example file. Available files: ",
         paste(list.files(dir), collapse = ", "), call. = FALSE)
  }
  path
}
