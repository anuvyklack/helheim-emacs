;;; helheim-vertico.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(require 'hel-core)

;;; Keybindings

;; "z" layer available both form Normal and Motion states.
(hel-keymap-global-set :state '(normal motion)
  "z '"  '("vertico repeat" . vertico-repeat)
  "z \"" '("select vertico session" . vertico-repeat-select))

(hel-keymap-set minibuffer-local-map
  "M-a"  'marginalia-cycle)

(with-eval-after-load 'vertico
  (hel-keymap-set vertico-map :state 'normal
    "y"     'vertico-save ; Copy current candidate to kill ring.
    "j"     'vertico-next
    "k"     'vertico-previous
    "g g"   'vertico-first
    "G"     'vertico-last)

  (hel-keymap-set vertico-map
    "M-j"   'next-history-element
    "M-k"   'previous-history-element

    "C-j"   'vertico-next
    "C-k"   'vertico-previous
    "C-S-j" 'vertico-next-group
    "C-S-k" 'vertico-previous-group

    "C-l"   'vertico-insert
    "C-h"   'vertico-directory-up

    ;; Scrolling in Insert state.
    "C-f"   'vertico-scroll-up
    "C-b"   'vertico-scroll-down

    ;; Rebind "}" / "{" and "]p" / "[p" keys
    "<remap> <hel-forward-paragraph>"      'vertico-next-group
    "<remap> <hel-backward-paragraph>"     'vertico-previous-group
    "<remap> <hel-forward-paragraph-end>"  'vertico-next-group
    "<remap> <hel-backward-paragraph-end>" 'vertico-previous-group

    ;; Rebind "C-f" / "C-b" and "C-d" / "C-u" scrolling keys
    "<remap> <hel-smooth-scroll-down>"      'vertico-scroll-up
    "<remap> <hel-smooth-scroll-up>"        'vertico-scroll-down
    "<remap> <hel-smooth-scroll-page-down>" 'vertico-scroll-up
    "<remap> <hel-smooth-scroll-page-up>"   'vertico-scroll-down))

;;; Config

(use-package vertico
  :ensure t
  :custom
  (vertico-resize 'grow-only) ; Grow and shrink the Vertico minibuffer
  (vertico-count 15) ; How many candidates to show
  (vertico-scroll-margin 2)
  (vertico-cycle nil)
  :config
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  (vertico-mode))

(use-package vertico-directory
  :after vertico
  :hook
  ;; Cleans up path when moving directories with shadowed paths syntax, e.g.
  ;; cleans ~/foo/bar/// to /, and ~/foo/bar/~/ to ~/.
  (rfn-eshadow-update-overlay-hook . vertico-directory-tidy)
  :config
  (keymap-set vertico-directory-map "C-h" 'vertico-directory-up))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :custom
  ;; Icons make no sense when they are all the same and only add distraction.”
  (nerd-icons-completion-category-icons nil)
  (nerd-icons-completion-icon-size 0.95)
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
  (nerd-icons-completion-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  ;; Despite override in the name orderless can still be used in `find-file' etc.
  (completion-category-overrides '((file (styles orderless partial-completion))))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  :config
  ;; This is the default values.
  (setq orderless-affix-dispatch-alist '((?% . char-fold-to-regexp)
                                         (?! . orderless-not)
                                         (?& . orderless-annotation)
                                         (?, . orderless-initialism) ; ?`
                                         (?= . orderless-literal)
                                         (?^ . orderless-literal-prefix)
                                         (?~ . orderless-flex))
        orderless-style-dispatchers '(orderless-affix-dispatch)))

(provide 'helheim-vertico)
;;; helheim-vertico.el ends here
