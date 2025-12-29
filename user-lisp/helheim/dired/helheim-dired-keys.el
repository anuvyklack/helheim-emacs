;;; helheim-dired-keys.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Keybindings
(require 'dired)

;; "b" key is free
(hel-keymap-set dired-mode-map
  "h"   'dired-up-directory
  "j"   'dired-next-line
  "k"   'dired-previous-line
  "l"   'dired-find-file

  "i"   'dired-toggle-read-only ;; wdired

  "C-c i"   '("add ID" . helheim-dired-do-add-id)
  "C-c s /" 'dired-do-find-regexp

  "C-k" 'dired-prev-marked-file
  "C-j" 'dired-next-marked-file

  "/"   'dired-goto-file
  "I"   'dired-maybe-insert-subdir ;; was on "i"
  "K"   'dired-do-kill-lines
  "C-c u" 'dired-undo ;; recover marks, killed lines or subdirs

  ;; "o"   'dired-do-open
  "e"   'dired-do-open ;; "e" for external
  "o"   'dired-find-file-other-window
  "|"   'dired-do-shell-command

  "s"   'dired-sort-toggle-or-edit
  ;; "?"   'casual-dired-tmenu

  "d"   'dired-flag-file-deletion
  "x"   'dired-do-flagged-delete
  "X"   '+dired-do-flagged-delete-permanently

  "c"   (define-keymap
          "p" '("change permissions" . dired-do-chmod)
          "o" '("change owner"       . dired-do-chown)
          "g" '("change group"       . dired-do-chgrp)
          "t" '("update timestamp"   . dired-do-touch))

  "p"   'dired-copy-paste-do-paste
  "y"   (define-keymap
          "y" 'dired-copy-paste-do-copy
          "d" 'dired-copy-paste-do-cut
          "n" '+dired-copy-file-name
          "p" '+dired-copy-file-path
          "c" 'dired-do-copy
          "m" 'dired-do-rename        ; move files
          "l" 'dired-do-symlink
          "L" 'dired-do-relsymlink
          "h" 'dired-do-hardlink
          "x" 'dired-do-shell-command
          "X" 'dired-do-async-shell-command)
  "g"   (define-keymap
          "/" 'dired-do-find-regexp
          "d" 'dired-do-delete        ; delete marked (not flagged) files
          "o" 'dired-find-file-other-window
          "c" 'dired-do-compress-to
          "z" 'dired-do-compress
          "s" 'casual-dired-sort-by-tmenu
          "a" 'dired-show-file-type
          "r" 'dired-do-redisplay
          "u" 'dired-downcase
          "U" 'dired-upcase
          "x" 'browse-url-of-dired-file)

  ;; ;; Alternative version
  ;; "p"   'dired-copy-paste-do-paste
  ;; "y"   (define-keymap
  ;;         "y" 'dired-copy-paste-do-copy
  ;;         "d" 'dired-copy-paste-do-cut
  ;;         "n" '+dired-copy-file-name
  ;;         "p" '+dired-copy-file-path)
  ;; "g"   (define-keymap
  ;;         "c" 'dired-do-copy
  ;;         "d" 'dired-do-delete ; delete marked (not flagged) files
  ;;         "m" 'dired-do-rename ; move files
  ;;         "l" 'dired-do-symlink
  ;;         "L" 'dired-do-relsymlink
  ;;         "h" 'dired-do-hardlink
  ;;         "s" 'casual-dired-sort-by-tmenu
  ;;         "a" 'dired-show-file-type
  ;;         "r" 'dired-do-redisplay
  ;;         "u" 'dired-downcase
  ;;         "U" 'dired-upcase
  ;;         "x" 'dired-do-shell-command
  ;;         "X" 'dired-do-async-shell-command)

  ;; Upper case keys (except !) for operating on the marked files
  "B"       'dired-do-byte-compile
  "C"       'dired-do-copy
  "D"       'dired-do-delete
  "E"       'dired-do-open
  "G"       'dired-do-chgrp
  "H"       'dired-do-hardlink
  "I"       'dired-do-info
  "L"       'dired-do-load
  "M"       'dired-do-rename          ; move files
  "N"       'dired-do-man
  "O"       'dired-do-chown
  "P"       'dired-do-chmod           ; permissions
  "Q"       'dired-do-find-regexp-and-replace
  "R"       'dired-do-relsymlink
  "S"       'dired-do-symlink
  "T"       'dired-do-touch
  ;; "X"       'dired-do-shell-command
  ;; "Y"       'dired-do-relsymlink
  "Z"       'dired-do-compress

  "C-c s r" 'dired-do-find-regexp-and-replace ; bound to `query-replace' in other `search-map'

  ;; Commands to mark and unmark.
  "m"       'dired-mark
  "u"       'dired-unmark
  "U"       'dired-unmark-all-marks
  "~"       'dired-toggle-marks       ; reverse marks
  "DEL"     'dired-unmark-backward    ; <backspace>
  "* u"     'dired-unmark-all-files   ; `dired-unmark'
  "v"       '+dired-toggle-selection

  "* m"     nil ;; `dired-mark'
  "* ?"     nil ;; `dired-unmark-all-files'
  "* !"     nil ;; `dired-unmark-all-marks'

  ;; The bindings follow a convention where the filters are mapped on
  ;; lower-case letters or punctuation, operators are mapped on symbols
  ;; (such as !, |, * etc.) and group commands are mapped on upper-case
  ;; letters.  The exception to this is `p' which is bound to
  ;; `dired-filter-pop', which is a very common operation and warrants a
  ;; quick binding.
  "f"   dired-filter-map
  "F"   dired-filter-mark-map
  "C-c t f" 'dired-filter-group-mode ;; toggle filter group

  ")"   'dired-omit-mode
  "("   'dired-hide-details-mode

  "z ." 'dired-omit-mode
  "z i" 'dired-hide-details-mode

  ;; dired narrow
  "n"   'dired-narrow-fuzzy
  "N"   'dired-narrow-regexp
  "z n" 'dired-narrow-fuzzy
  "z N" 'dired-narrow-regexp

  ;; dired-subtree
  "<tab>"     'dired-subtree-toggle
  "<backtab>" 'dired-subtree-cycle
  "z j" 'dired-subtree-next-sibling
  "z k" 'dired-subtree-previous-sibling
  "z u" 'dired-subtree-up

  ;; thumbnail manipulation (image-dired)
  "t" (define-keymap
        "RET" 'image-dired-show-all-from-dir
        "t"   'image-dired-display-thumbs ;; display thumbs for marked files
        "i"   'image-dired-dired-toggle-marked-thumbs
        "e"   'image-dired-dired-display-external
        "a"   'image-dired-display-thumbs-append)

  ;; regexp commands
  "%" (define-keymap
        "/" 'dired-mark-files-containing-regexp
        "d" 'dired-flag-files-regexp
        "g" 'dired-flag-garbage-files
        "m" 'dired-do-rename-regexp   ; move files
        "c" 'dired-do-copy-regexp
        "l" 'dired-do-symlink-regexp
        "L" 'dired-do-relsymlink-regexp
        "h" 'dired-do-hardlink-regexp)

  ;; Encryption and decryption (epa-dired).
  ;; ":" is occupied by `execute-extended-command'
  ";"   (define-keymap
          "d" 'epa-dired-do-decrypt
          "v" 'epa-dired-do-verify
          "s" 'epa-dired-do-sign
          "e" 'epa-dired-do-encrypt)

  "G" nil) ; make "G" scroll to the end of buffer

;;;; image-dired

(with-eval-after-load 'image-dired
  (hel-keymap-set image-dired-thumbnail-mode-map
    "w"    nil ; unbind `image-dired-copy-filename-as-kill'
    "y"   'image-dired-copy-filename-as-kill))

(defvar image-dired-thumbnail-buffer "*image-dired*"
  "Image-Dired's thumbnail buffer.")

(add-to-list 'display-buffer-alist
             `(,(regexp-quote image-dired-thumbnail-buffer)
               (display-buffer-reuse-window display-buffer-pop-up-window)))

;; TODO: Upstream this.
;; FIX: Original `image-dired-show-all-from-dir' command is carelessly written:
;;   it calls `image-dired-display-thumbs' which creates and displays
;;   `image-dired-thumbnail-buffer' with `pop-to-buffer' and calls
;;   `image-dired--update-header-line'. And then it self does it again.
(define-advice image-dired-show-all-from-dir (:override (dir) helheim)
  "Make a thumbnail buffer for all images in DIR and display it.
Any file matching `image-dired--file-name-regexp' is considered an
image file."
  (interactive "DShow thumbnails for directory: ")
  (dired dir)
  (dired-mark-files-regexp (image-dired--file-name-regexp))
  (let ((files (dired-get-marked-files nil nil nil t)))
    (cond ((null (cdr files))
           (message "No image files in directory"))
          ((or (not image-dired-show-all-from-dir-max-files)
               (<= (length (cdr files)) image-dired-show-all-from-dir-max-files)
               (and (length> (cdr files) image-dired-show-all-from-dir-max-files)
                    (y-or-n-p
                     (format
                      "Directory contains more than %d image files.  Proceed?"
                      image-dired-show-all-from-dir-max-files))))
           (image-dired-display-thumbs)
           (let ((inhibit-message t))
             (dired-unmark-all-marks))
           (setq default-directory dir))
          (t (message "Image-Dired canceled")))))

;;; Commands

;;;###autoload
(defun +dired-toggle-selection ()
  "Toggle selection."
  (interactive)
  (if (use-region-p)
      (deactivate-mark)
    (set-mark-command nil)))

;;;###autoload
(defalias '+dired-copy-file-name #'dired-copy-filename-as-kill)

;;;###autoload
(defun +dired-copy-file-path ()
  "Copy full file name (including path) into kill ring."
  (interactive)
  (dired-copy-filename-as-kill 0))

;;;###autoload
(defun +dired-do-flagged-delete-permanently ()
  "Delete files permanently instead of trashing them."
  (declare (interactive-only t))
  (interactive nil dired-mode)
  (let ((delete-by-moving-to-trash nil))
    (dired-do-flagged-delete)))

;;;###autoload
(defalias '+dired-delete-permanently #'+dired-do-flagged-delete-permanently)

;;;; Prepend file name with ID

;;;###autoload
(defun helheim-dired-do-add-id ()
  "Prepend marked files names with timestamp based ID.
If file already has ID — do nothing."
  (declare (interactive-only t))
  (interactive nil dired-mode)
  (dolist (file (dired-get-marked-files))
    (unless (helheim-dired-file-id file)
      (let* ((filename (file-name-nondirectory file))
             (id (helheim-dired-generate-file-id file))
             (newname (format "%s--%s" id filename)))
        (rename-file file newname))))
  (dired-revert))

;;;###autoload
(defun helheim-dired-file-id (filepath)
  "Return FILE's ID if it has one."
  (let ((filename (file-name-nondirectory filepath)))
    (if (string-match helheim-file-id-regexp filename)
        (match-string-no-properties 1 filename))))

;;;###autoload
(defun helheim-dired-generate-file-id (filepath)
  "Return ID based on FILE creation time."
  (let* ((created (helheim-dired--file-creation-time filepath))
         (modified (file-attribute-modification-time (file-attributes filepath)))
         (time (if (time-less-p created modified)
                   created modified)))
    (format-time-string helheim-id-format time)))

(defun helheim-dired--file-creation-time (filepath)
  "Return the FILE creation time using the `stat' from coreutils."
  (-> (process-lines "stat" "--format=%w" filepath)
      (car)
      (parse-time-string)
      (encode-time)))

(defun helheim-dired--file-modification-time (filepath)
  (file-attribute-modification-time (file-attributes filepath)))

;;; .
(provide 'helheim-dired-keys)
;;; helheim-dired-keys.el ends here
