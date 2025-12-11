;;; helheim-embark.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(require 'hel-core)

;;; Keybindings

(hel-keymap-global-set
  "C-<return>" 'embark-act
  "C-<m>" 'embark-act
  "M-m"   'embark-dwim)

;; On QWERTY keyboard c, v, b keys are next to each other.
(hel-keymap-set minibuffer-local-map
  "C-c C-c" 'embark-export
  "C-c C-v" 'embark-collect
  "C-c C-b" 'embark-become)

;;;; Embark menus keymaps
;;
;; Original Embark keybindings are tailored for Emacs. Lets reconfigure them for
;; Hel.
;;
;; Embark Keymap Hierarchy
;; -----------------------
;; - embark-meta-map
;;   + embark-general-map
;;     + embark-region-map
;;     + embark-file-map
;;     + embark-kill-ring-map
;;     + embark-url-map
;;     + embark-email-map
;;     + embark-library-map
;;     + embark-buffer-map
;;     + embark-tab-map
;;     + embark-identifier-map
;;       + embark-symbol-map
;;         + embark-face-map
;;         + embark-variable-map
;;         + embark-function-map
;;           + embark-command-map
;;     + embark-expression-map
;;       + embark-defun-map
;;     + embark-heading-map
;;     + embark-package-map
;;     + embark-bookmark-map
;;     + embark-flymake-map
;;     + embark-unicode-name-map
;;     + embark-prose-map
;;         + embark-sentence-map
;;         + embark-paragraph-map
;;   - embark-become-help-map
;;   - embark-become-file+buffer-map
;;   - embark-become-shell-command-map
;;   - embark-become-match-map
;;
;; Embark Org extension
;; --------------------
;; - embark-meta-map
;;   - embark-general-map
;;     - embark-heading-map
;;       - embark-org-heading-map
;;     - embark-org-table-cell-map
;;     - embark-org-table-map
;;     - embark-org-link-map
;;     - embark-org-src-block-map
;;     - embark-org-inline-src-block-map
;;     - embark-org-babel-call-map
;;     - embark-org-item-map
;;     - embark-org-plain-list-map
;;     - embark-org-export-in-place-map
;; - embark-org-link-copy-map

(with-eval-after-load 'embark
  (hel-keymap-set embark-general-map
    "y"  'embark-copy-as-kill ; "w"
    "w"   nil  ; `embark-copy-as-kill'
    "C-s" nil  ; `embark-isearch-forward'
    "C-r" nil) ; `embark-isearch-backward'

  (hel-keymap-set embark-region-map
    "w" 'whitespace-cleanup-region ; "F"
    "n" 'hel-narrow-to-region-indirectly
    ;; "k" 'apply-macro-to-region-lines ; "k" for keyboard macro
    "u"  nil  ; `upcase-region'
    "l"  nil  ; `downcase-region'
    "f"  nil  ; `fill-region'
    "p"  nil  ; `fill-region-as-paragraph'
    "F"  nil  ; `whitespace-cleanup-region'
    "t"  nil  ; `transpose-regions'
    ";"  nil) ; `comment-or-uncomment-region'

  (hel-keymap-set embark-kill-ring-map
    "d" 'embark-kill-ring-remove) ; "\"

  (hel-keymap-set embark-buffer-map
    "d" 'kill-buffer ; "k"
    "D" 'embark-kill-buffer-and-window ; "K"
    "k"  nil
    "K"  nil)

  (hel-keymap-set embark-tab-map
    "d" 'tab-bar-close-tab-by-name ; "k"
    "k"  nil)

  (hel-keymap-set embark-identifier-map
    "N" 'embark-previous-symbol)

  (with-eval-after-load 'helpful
    (hel-keymap-set embark-symbol-map
      "h" 'helpful-symbol))

  ;; (hel-keymap-set embark-expression-map
  ;;   "n" 'forward-list
  ;;   "N" 'backward-list
  ;;   "d" 'kill-region ; "k"
  ;;   "k"  nil)

  (hel-keymap-set embark-expression-map
    "k" nil)

  (hel-keymap-set embark-defun-map
    "N" nil) ; `narrow-to-defun'

  (hel-keymap-set embark-heading-map
    "m"   'outline-mark-subtree
    "j"   'outline-next-visible-heading
    "k"   'outline-previous-visible-heading
    "n"   'outline-forward-same-level
    "N"   'outline-backward-same-level
    "M-j" 'outline-move-subtree-up
    "M-j" 'outline-move-subtree-down
    "f"    nil  ; `outline-forward-same-level'
    "b"    nil  ; `outline-backward-same-level'
    "^"    nil  ; `outline-move-subtree-up'
    "v"    nil) ; `outline-move-subtree-down'

  (hel-keymap-set embark-flymake-map
    "n" 'flymake-goto-next-error
    "N" 'flymake-goto-prev-error)

  (hel-keymap-set embark-unicode-name-map
    "Y" 'embark-save-unicode-character ; "W"
    "W"  nil)

  (hel-keymap-set embark-prose-map
    "w" 'whitespace-cleanup-region ; "F"
    "f"  nil  ; `fill-region'
    "u"  nil  ; `upcase-region'
    "l"  nil  ; `downcase-region'
    "F"  nil) ; `whitespace-cleanup-region'

  (hel-keymap-set embark-sentence-map
    "n" 'forward-sentence
    "N" 'backward-sentence)

  (hel-keymap-set embark-paragraph-map
    "n" 'forward-paragraph
    "N" 'backward-paragraph))

(with-eval-after-load 'embark
  ;; Keymap for *Embark Collect* buffer.
  (hel-keymap-set embark-collect-mode-map
    ;; `m' and `u' are common keys for selecting and unselecting in
    ;; Dired like buffers.
    "m" 'hel-embark-select
    "u" 'hel-embark-select
    "y" 'embark-copy-as-kill))

(with-eval-after-load 'embark-consult
  (hel-keymap-set embark-consult-rerun-map
    "g"    nil
    "g r" 'embark-rerun-collect-or-export))

;;; Config

(use-package embark
  :ensure t
  :defer t
  :custom
  (which-key-use-C-h-commands nil)
  (prefix-help-command 'embark-prefix-help-command)
  :config
  ;; Hide the modeline of the Embark live/completions buffers.
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :after consult
  :hook (embark-collect-mode-hook . consult-preview-at-point-mode))

;;; Commands

(defun hel-embark-select ()
  "Add or remove the target from the current buffer's selection.
You can act on all selected targets at once with `embark-act-all'.
When called from outside `embark-act' this command will select
the first target at point."
  (interactive)
  (embark-select)
  (next-line))

(provide 'helheim-embark)
;;; helheim-embark.el ends here
