;;; helheim-keybindings.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;
;; If you want to see all key bindings in keymap place point (cursor) on it
;; and press "M", or press "<F1> M" and type the name of the keymap.
;;
;;; Code:
(require 'hel-core)

(hel-keymap-global-set :state 'insert
  "C-/"   'hippie-expand)

(hel-keymap-global-set :state 'normal
  "z SPC" 'cycle-spacing
  "z ."   'set-fill-prefix)

(hel-keymap-global-set
  "C-x C-b" 'ibuffer-jump ; override `list-buffers'
  "C-x C-r" 'recentf-open ; override `find-file-read-only'
  "C-x C-d" 'dired-jump)  ; override `list-directory'

;; <leader>
(hel-keymap-set mode-specific-map
  "RET" 'dired-jump
  "," 'switch-to-buffer
  "/" 'consult-ripgrep ; "/" is bound to search in Hel
  "d" 'dired-jump
  "b" (cons "buffer"
            (define-keymap
              "b" 'ibuffer-jump        ; "<leader> bb"
              "n" 'switch-to-buffer    ; next key after "b"
              "s" 'save-buffer
              "w" 'write-file
              "d" 'kill-current-buffer ; also "C-w d"
              "z" 'bury-buffer         ; also "C-w z"
              "g" 'revert-buffer       ; also "C-w r"
              "r" 'rename-buffer
              "x" 'scratch-buffer
              ;; Bookmarks
              "RET" 'bookmark-jump
              "m" 'bookmark-set
              "M" 'bookmark-delete))
  "f" (cons "file"
            (define-keymap
              "b" 'switch-to-buffer
              "f" 'find-file  ; select file in current dir or create new one
              "/" 'consult-fd ; or `consult-find'
              "d" 'dired
              "l" 'locate
              "r" '("Recent files" . recentf-open)
              "w" 'write-file))
  "o" (cons "open"
            (define-keymap
              "t" 'treemacs ; from future
              "i" 'imenu-list-smart-toggle))
  "p" (cons "project"
            (hel-keymap-set project-prefix-map
              "RET" 'project-dired
              ","   'project-switch-to-buffer
              "/"   'project-find-regexp
              "B"   'project-list-buffers))
  "s" (cons "search"
            (hel-keymap-set search-map
              "a" 'xref-find-apropos
              "r" 'query-replace
              "R" 'query-replace-regexp)))

;;;; Customize

(hel-set-initial-state 'Custom-mode 'normal)

(with-eval-after-load 'cus-edit
  (hel-keymap-set custom-mode-map :state 'normal
    "z j" 'widget-forward
    "z k" 'widget-backward
    "z u" 'Custom-goto-parent
    "q"   'Custom-buffer-done))

;;;; Elpaca

(hel-set-initial-state 'elpaca-info-mode 'normal)

;;;; Help

;; <F1>
(hel-keymap-set help-map
  "F" 'describe-face
  "M" 'describe-keymap
  "s" 'helpful-symbol
  ;; Rebind `b' key from `describe-bindings' to prefix with more binding
  ;; related commands.
  "b" (cons "bindings"
            (define-keymap
              "b" 'describe-bindings
              "B" 'embark-bindings ; alternative for `describe-bindings'
              "i" 'which-key-show-minor-mode-keymap
              "m" 'which-key-show-major-mode
              "t" 'which-key-show-top-level
              "f" 'which-key-show-full-keymap
              "k" 'which-key-show-keymap)))

;;;; Magit-Section

(add-hook 'magit-section-mode-hook 'helheim-disable-hl-line-mode)

(with-eval-after-load 'magit-section
  (hel-keymap-set magit-section-mode-map
    "<tab>"     'magit-section-cycle
    "<backtab>" 'magit-section-cycle-global ; S-<tab>
    "C-j"       'magit-section-forward-sibling
    "C-k"       'magit-section-backward-sibling
    "n"         'magit-section-forward
    "N"         'magit-section-backward
    "C-<tab>"   nil
    "M-<tab>"   nil
    "C-c TAB"   nil)
  (hel-keymap-set magit-section-mode-map :state 'motion
    "z j" 'magit-section-forward
    "z k" 'magit-section-backward
    "z u" 'magit-section-up
    "z a" 'magit-section-toggle
    "z c" 'magit-section-hide
    "z o" 'magit-section-show
    "z O" 'magit-section-show-children
    "z m" 'magit-section-show-level-1-all
    "z r" 'magit-section-show-level-4-all
    "z 1" 'magit-section-show-level-1-all
    "z 2" 'magit-section-show-level-2-all
    "z 3" 'magit-section-show-level-3-all
    "z 4" 'magit-section-show-level-4-all))

;;;; Repeat mode

(put 'other-window 'repeat-map nil) ;; Use "." key instead.

;;;; Disable Isearch keys
;; Isearch doesn't play well with multiple cursors and `consult-ripgrep' is
;; better anyway.

(hel-keymap-global-set
  "C-s"   nil  ; `isearch-forward'
  "C-M-s" nil  ; `isearch-forward-regexp'
  "C-r"   nil  ; `isearch-backward'
  "C-M-r" nil) ; `isearch-backward-regexp'
(hel-keymap-set search-map
  "w"     nil  ; `isearch-forward-word'
  "_"     nil  ; `isearch-forward-symbol'
  "."     nil  ; `isearch-forward-symbol-at-point'
  "M-."   nil) ; `isearch-forward-thing-at-point'

;; After deleting "M-." from `search-map' there remain an empty (27 keymap)
;; which blocks access to "g" and "m" keys from `hel-leader'. 27 is ASCII
;; code for ESC. This is about how Emacs works: key sequences starts with ESC
;; are accessible via Meta key.
(cl-callf2 assq-delete-all 27 search-map)

(with-eval-after-load 'embark
  (hel-keymap-set embark-general-map
    "C-s" nil   ; `embark-isearch-forward'
    "C-r" nil)) ; `embark-isearch-backward'

(provide 'helheim-keybindings)
;;; helheim-keybindings.el ends here
