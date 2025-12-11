;;; helheim-emacs-lisp.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(require 'hel-core)
(require 'hel-paredit)

;;; Keybindings

(dolist (keymap (list emacs-lisp-mode-map lisp-interaction-mode-map))
  (hel-keymap-set keymap :state 'normal
    ;; Vim uses `K' but it is occupied in Hel. `M' is near `K' and free.
    "M"       'helpful-at-point
    "g d"     '("Find definition" . helheim-elisp-find-definitions)
    "C-w g d" '("Find definition other window" . helheim-elisp-find-definitions-other-window))
  (hel-keymap-set keymap
    "C-c e" (cons "eval"
                  (define-keymap
                    "e"   'pp-eval-last-sexp
                    "f"   'eval-defun
                    "r"   'elisp-eval-region-or-buffer ; "C-c C-e"
                    "b"   'eval-buffer
                    "B"   'elisp-byte-compile-buffer
                    ;; "m"   'macrostep-expand
                    "m"   'emacs-lisp-macroexpand
                    "p"   'pp-macroexpand-last-sexp
                    "RET" 'eval-print-last-sexp))))

(hel-keymap-set lisp-data-mode-map :state 'normal
  "M" 'helpful-at-point)

(hel-keymap-set lisp-mode-shared-map :state 'insert
  "C-h" 'backward-delete-char-untabify)

;;; Config

;; ;; Treat `-' char as part of the word on `w', `e', `b', motions.
;; (modify-syntax-entry ?- "w" emacs-lisp-mode-syntax-table)
;; (modify-syntax-entry ?_ "w" emacs-lisp-mode-syntax-table)

(add-hook 'emacs-lisp-mode-hook (lambda () (setq-local tab-width 8)))
(add-hook 'emacs-lisp-mode-hook #'hel-paredit-mode)
(add-hook 'lisp-data-mode-hook  #'hel-paredit-mode)

(add-to-list 'display-buffer-alist
             `(,(rx string-start
                    (or "*Pp Eval Output*" "*Pp Macroexpand Output*")
                    string-end)
               (display-buffer-use-some-window display-buffer-pop-up-window)
               (inhibit-same-window . t)
               (body-function . select-window)))

(use-package elisp-demos
  :ensure t
  :after helpful
  :config
  (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1)
  (advice-add 'helpful-update      :after #'elisp-demos-advice-helpful-update))

;; Extra highlighting
(use-package highlight-defined
  :ensure t
  ;; :custom (highlight-defined-face-use-itself . t)
  :hook
  (emacs-lisp-mode-hook . highlight-defined-mode)
  (help-mode-hook . highlight-defined-mode))

;; `elisp-refs-function'
;; `elisp-refs-macro'
;; `elisp-refs-symbol'
;; `elisp-refs-special'
;; `elisp-refs-variable'
(use-package elisp-refs
  :ensure t
  :config
  (hel-keymap-set elisp-refs-mode-map
    "C-j" 'elisp-refs-next-match
    "C-k" 'elisp-refs-prev-match
    "n"   'elisp-refs-next-match
    "N"   'elisp-refs-prev-match)
  ;;
  (dolist (cmd '(elisp-refs-visit-match
                 elisp-refs-next-match
                 elisp-refs-prev-match))
    (hel-advice-add cmd :around #'hel-jump-command-a)))

;;;; Go to definition

(elpaca elisp-def)

(defun helheim-elisp-find-definitions ()
  "Try `elisp-def', on fail try other xref backends."
  (interactive)
  (deactivate-mark)
  (or (ignore-errors (call-interactively 'elisp-def))
      (call-interactively 'helheim-xref-find-definitions)))

(defun helheim-elisp-find-definitions-other-window ()
  (interactive)
  (other-window-prefix)
  (helheim-elisp-find-definitions))

(dolist (cmd '(helheim-elisp-find-definitions
               helheim-elisp-find-definitions-other-window))
  (hel-advice-add cmd :around #'hel-jump-command-a))

(provide 'helheim-emacs-lisp)
;;; helheim-emacs-lisp.el ends here
