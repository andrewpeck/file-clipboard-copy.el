;;; test-file-clipboard-copy.el --- ERT tests for file-clipboard-copy -*- lexical-binding: t; -*-

;;; Code:

(require 'ert)
(require 'file-clipboard-copy)

(ert-deftest file-clipboard-copy--uri-format ()
  "URI list passed to xclip uses file:// scheme with absolute paths."
  (let* ((captured nil)
         (test-file (make-temp-file "file-clipboard-copy-test")))
    (unwind-protect
        (cl-letf (((symbol-function 'call-process-region)
                   (lambda (start end &rest _)
                     (setq captured (buffer-substring start end)))))
          (file-clipboard-copy--copy-files (list test-file))
          (should (string-prefix-p "file://" captured))
          (should (string-suffix-p (file-truename test-file) captured)))
      (delete-file test-file))))

(ert-deftest file-clipboard-copy--multiple-files ()
  "Multiple files produce one URI per line."
  (let* ((captured nil)
         (file1 (make-temp-file "file-clipboard-copy-test-1"))
         (file2 (make-temp-file "file-clipboard-copy-test-2")))
    (unwind-protect
        (cl-letf (((symbol-function 'call-process-region)
                   (lambda (start end &rest _)
                     (setq captured (buffer-substring start end)))))
          (file-clipboard-copy--copy-files (list file1 file2))
          (let ((lines (split-string captured "\n")))
            (should (= (length lines) 2))
            (should (string-prefix-p "file://" (nth 0 lines)))
            (should (string-prefix-p "file://" (nth 1 lines)))))
      (delete-file file1)
      (delete-file file2))))

;;; test-file-clipboard-copy.el ends here
