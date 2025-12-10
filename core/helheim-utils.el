;;; helheim-utils.el -*- lexical-binding: t; -*-
;;; Code:
(eval-when-compile
  (require 'dash)
  (require 's))

(defun helheim-load-file (file)
  "Load FILE by path relative to Helheim root directory."
  (let ((file (expand-file-name file helheim-root-directory))
        (inhibit-message t))
    (when (file-exists-p file)
      (load-file file))))

(defun +original-value (symbol)
  "Return the original value for SYMBOL, if any."
  ;; This code is taken from the `helpful' package. I have no idea why it’s
  ;; written this way, but the original author seems to be a very proficient
  ;; Elisp hacker.
  (let ((orig-val-expr (get symbol 'standard-value)))
    (if (consp orig-val-expr)
        (ignore-errors
          (eval (car orig-val-expr))))))

(defun +hook-values (hook)
  "Return list with all local and global elements of the HOOK.
HOOK should be a symbol."
  (if (local-variable-p hook)
      (append (->> (buffer-local-value hook (current-buffer))
                   (delq t))
              (default-value hook))
    ;; else
    (ensure-list (symbol-value hook))))

(defun +common-indentation ()
  "Return the common indentation off all lines in the buffer."
  (save-excursion
    (goto-char (point-min))
    (let ((indentation 0))
      (while (not (eobp))
        (unless (s-blank-str? (thing-at-point 'line))
          (cl-callf min indentation (current-indentation)))
        (forward-line))
      indentation)))

(provide 'helheim-utils)
;;; helheim-utils.el ends here
