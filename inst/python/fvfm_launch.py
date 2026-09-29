"""
Launch the fvfmPy GUI on a given folder and hand the logged results back to R.

Called by fvfmR::run_fvfm() as a separate process:

    python fvfm_launch.py <image_folder> <results_csv>

When the window is closed, every observation logged during the session
(including batches saved and cleared via "Save results") is written to
<results_csv> for R to read back. Nothing is written if nothing was logged.
"""

import sys

import pandas
from PySide6.QtWidgets import QApplication

from fvfmPy.fvfmPy import ImageViewer


class RImageViewer(ImageViewer):
    """ImageViewer that returns its results to R instead of prompting on exit."""

    def __init__(self, image_folder):
        self.flushed_results = []
        super().__init__(image_folder)

    def save_results(self):
        # Keep a copy in case the user chooses "Clear logged observations"
        pending = list(self.current_results or [])
        super().save_results()
        if self.current_results is None:
            self.flushed_results.extend(pending)

    def all_results(self):
        return self.flushed_results + list(self.current_results or [])

    def closeEvent(self, event):
        # Results are returned to R on close, so no save prompt is needed
        event.accept()


def main(folder, results_csv):
    app = QApplication.instance() or QApplication(sys.argv[:1])

    window = RImageViewer(folder)
    window.show()
    window.raise_()
    window.activateWindow()
    app.exec()

    results = window.all_results()
    if results:
        pandas.DataFrame(results).to_csv(results_csv, index=False)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: fvfm_launch.py <image_folder> <results_csv>")
    main(sys.argv[1], sys.argv[2])
