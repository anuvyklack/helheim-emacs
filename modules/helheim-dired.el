;;; helheim-dired.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(require 'dash)

;;; Keybindings

;; After `dired-x' because it unconditionally binds "F" and "V" keys.
(with-eval-after-load 'dired-x
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
          "." 'image-dired-display-thumb
          "d" 'image-dired-display-thumbs
          "t" 'image-dired-dired-toggle-marked-thumbs
          "j" 'image-dired-jump-thumbnail-buffer
          "i" 'image-dired-dired-display-image
          "o" 'image-dired-dired-display-external ; "t x"
          "a" 'image-dired-display-thumbs-append
          "c" 'image-dired-dired-comment-files
          "f" 'image-dired-mark-tagged-files
          "e" 'image-dired-dired-edit-comment-and-tags
          "T" 'image-dired-tag-files
          "r" 'image-dired-delete-tag)

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

    "G" nil)) ; make "G" scroll to the end of buffer

;;;; TODO image-dired

(with-eval-after-load 'image-dired
  (hel-keymap-set image-dired-thumbnail-mode-map
    "n"   'image-dired-display-next
    "N"   'image-dired-display-previous

    "y"   'image-dired-copy-filename-as-kill
    "w"    nil ; unbind `image-dired-copy-filename-as-kill'
    ))

;;; Config

(elpaca casual)

;; (use-package async
;;   :ensure t
;;   :after dired
;;   :blackout dired-async-mode
;;   (dired-async-mode)) ; Do dired actions asynchronously.

(use-package dired
  :defer t
  :custom
  ;; -l                   :: use a long listing format
  ;; -a, --all            :: do not ignore entries starting with "."
  ;; -A, --almost-all     :: do not list implied "." and ".."
  ;; -h, --human-readable :: print sizes like 1K 234M 2G
  ;; -F, --classify       :: append indicator (one of /=>@|) to entries
  ;; -v                   :: natural sort of (version) numbers within text
  (dired-listing-switches "-lAhF -v --group-directories-first")
  ;; (dired-free-space nil)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)  ; Propose a target for intelligent moving/copying
  (dired-mouse-drag-files t) ;; 'move
  (delete-by-moving-to-trash t)
  (dired-deletion-confirmer 'y-or-n-p)
  (dired-recursive-deletes 'always)
  (dired-recursive-copies 'always)
  (dired-vc-rename-file t)
  (dired-create-destination-dirs 'ask)
  (dired-do-revert-buffer t)
  (auto-revert-remote-files nil)
  (dired-auto-revert-buffer #'dired-directory-changed-p) ; #'dired-buffer-stale-p
  (dired-no-confirm t)
  (dired-clean-confirm-killing-deleted-buffers nil)
  (dired-maybe-use-globstar t)
  (dired-omit-verbose t)
  (dired-omit-files "\\`[.]?#\\|\\`[.].+")
  (dired-hide-details-hide-symlink-targets nil)
  ;; (dired-hide-details-hide-absolute-location t) ;; from Emacs 31
  :config
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  (add-hook 'dired-mode-hook #'dired-omit-mode)
  ;;
  (put 'dired-jump 'repeat-map nil))

(use-package wdired
  :defer t
  :custom
  (wdired-use-dired-vertical-movement 'sometimes)
  ;; (wdired-allow-to-change-permissions t) ; 'advanced
  ;; :config
  ;; ;; Disable current line highlighting on switching to wdired and re-enable it
  ;; ;; on switching back to `dired-mode'.
  ;; (advice-add 'wdired-change-to-wdired-mode :after #'helheim-disable-hl-line-mode)
  ;; (advice-add 'wdired-change-to-dired-mode  :after #'helheim-enable-hl-line-mode)
  )

(use-package diredfl
  :ensure t
  :after dired
  :config (diredfl-global-mode))

(use-package nerd-icons-dired
  :ensure t
  :blackout t
  :hook
  (dired-mode-hook . nerd-icons-dired-mode)
  :config
  (advice-add 'wdired-change-to-wdired-mode :before (lambda () (nerd-icons-dired-mode -1)))
  (advice-add 'wdired-change-to-dired-mode  :after  (lambda () (nerd-icons-dired-mode +1))))

(elpaca dired-narrow)
(elpaca dired-subtree)

(use-package dired-copy-paste
  :ensure (dired-copy-paste :host github :repo "jsilve24/dired-copy-paste")
  :commands (dired-copy-paste-do-copy
             dired-copy-paste-do-cut
             dired-copy-paste-do-paste))

(use-package dired-filter
  :ensure t
  :after dired
  :custom
  (dired-filter-verbose nil)
  (dired-filter-prefix nil)
  (dired-filter-mark-prefix nil)
  :config
  (setq dired-filter-group-saved-groups
        '(("default"
           ("Directories"
            (directory))
           ("Archives"
            (extension "zip" "rar" "gz" "bz2" "tar"))
           ("Pictures"
            (or (extension "jfif" "JPG")
                (mode . 'image-mode)))
           ("Videos"
            (extension "mp4" "mkv" "flv" "mpg" "avi" "webm"))
           ;; ("LaTeX"
           ;;  (extension "tex" "bib"))
           ;; ("Org"
           ;;  (extension . "org"))
           ("PDF"
            (extension . "pdf"))))))

;; `ls-lisp' package
(setq ls-lisp-verbosity nil
      ls-lisp-dirs-first t)

;;;; image-dired

;; ;; TODO: xdg-open doesn't work
;; (image-dired-external-viewer "qimgv")

;; Use Thumbnail Managing Standard
;;
;; Thumbnails size:
;; - standard           128 pixels
;; - standard-large     256 pixels
;; - standard-x-large   512 pixels
;; - standard-xx-large
(setopt image-dired-thumbnail-storage 'standard
        image-dired-marking-shows-next nil)

;;; Commands

(defun +dired-toggle-selection ()
  "Toggle selection."
  (interactive)
  (if (use-region-p)
      (deactivate-mark)
    (set-mark-command nil)))

(defalias '+dired-copy-file-name #'dired-copy-filename-as-kill)

(defun +dired-copy-file-path ()
  "Copy full file name (including path) into kill ring."
  (interactive)
  (dired-copy-filename-as-kill 0))

(defun +dired-do-flagged-delete-permanently ()
  "Delete files permanently instead of trashing them."
  (declare (interactive-only t))
  (interactive nil dired-mode)
  (let ((delete-by-moving-to-trash nil))
    (dired-do-flagged-delete)))

(defalias '+dired-delete-permanently #'+dired-do-flagged-delete-permanently)

(defmacro helheim-dired-convert-to-global-minor-mode (mode)
  (declare (debug t))
  `(define-advice ,mode (:after (&rest _) helheim)
     (if ,mode
         (add-hook 'dired-mode-hook #',mode)
       (remove-hook 'dired-mode-hook #',mode))))

(helheim-dired-convert-to-global-minor-mode dired-hide-details-mode)
(helheim-dired-convert-to-global-minor-mode dired-omit-mode)
(helheim-dired-convert-to-global-minor-mode dired-filter-group-mode)

;;;; Prepend file name with ID
;; Adopted from the Denote package by Protesilaos Stavrou also known as Prot.

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

(defun helheim-dired-file-id (filepath)
  "Return FILE's ID if it has one."
  (let ((filename (file-name-nondirectory filepath)))
    (if (string-match helheim-file-id-regexp filename)
        (match-string-no-properties 1 filename))))

(defun helheim-dired-generate-file-id (filepath)
  "Return ID based on FILE creation time."
  (let* ((created (helheim-dired--file-creation-time filepath))
         (modified (file-attribute-modification-time (file-attributes filepath)))
         (time (if (time-less-p created modified)
                   created modified)))
    (format-time-string helheim-id-format time)))

(defun helheim-dired--file-creation-time (filepath)
  "Return the FILE creation time using the `stat' from coreutils."
  (-> (format "stat --format=%%w %s" (shell-quote-argument filepath))
      (shell-command-to-string)
      (string-trim)
      (parse-time-string)
      (encode-time)))

(defun helheim-dired--file-modification-time (filepath)
  (file-attribute-modification-time (file-attributes filepath)))

(provide 'helheim-dired)
;;; helheim-dired.el ends here
