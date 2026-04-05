;;; file-clipboard-copy.el --- Helper to copy file to clipboard -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025-2026 Andrew Peck

;; Author: Andrew Peck <peckandrew@gmail.com>
;; URL: https://github.com/andrewpeck/file-clipboard-copy.el
;; Version: 0.0.1
;; Package-Requires: ((emacs "29.1"))
;; Keywords: tools

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>

;;; Commentary:
;;
;; Uses xclip to copy file to the clipboard, such that a file (not its contents)
;; can be pasted into other programs.
;;
;; Works either with the open buffer, or in dired.
;;
;;; Code:

;;;###autoload
(defun file-clipboard-copy ()
  "Copy currently opened file to clipboard."
  (interactive)

  (unless (executable-find "xclip")
    (error "Cannot copy.  xclip not found in path"))

  (pcase major-mode
    ;; in dired mode take all marked files
    ('dired-mode
     (if-let* ((files (thread-last
                        (dired-get-marked-files)
                        (mapcar (lambda (x) (when x (string-replace " "  "\\ " x)))))))
         (let ((async-shell-command-display-buffer nil))
           (async-shell-command (concat "copy-file " (string-join files " "))))
       (message "No files marked.")))

    ;; else take the current buffer
    (_ (if-let* ((file (string-replace " "  "\\ " buffer-file-name)))
           (let ((async-shell-command-display-buffer nil))
             (async-shell-command (format "copy-file %s" file)))
         (message "Buffer does not have a corresponding buffer-file-name.")))))

(provide 'file-clipboard-copy)
;;; file-clipboard-copy.el ends here
;; LocalWords:  matcher fontification verilog treesitter
