;;; helheim-xref.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(require 'helheim-utils)

(use-package xref
  :ensure t
  :defer t
  :custom
  (xref-search-program 'ripgrep) ; or 'ugrep
  (xref-auto-jump-to-first-definition 'show)
  (xref-prompt-for-identifier nil)
  (xref-history-storage #'xref-window-local-history)
  ;; ;; Enable completion in the minibuffer instead of the definitions buffer.
  ;; ;; You can use `embark-export' to export minibuffer content to xref buffer.
  ;; (xref-show-xrefs-function #'xref-show-definitions-completing-read)
  ;; (xref-show-definitions-function #'xref-show-definitions-completing-read)
  ;; ;; (xref-show-definitions-function #'xref-show-definitions-buffer-at-bottom)
  :config
  ;; Open xref buffer in another window
  (add-to-list 'display-buffer-alist
               '((major-mode . xref--xref-buffer-mode)
                 (display-buffer-use-some-window display-buffer-pop-up-window)
                 (inhibit-same-window . t)
                 (body-function . select-window))))

(use-package dumb-jump
  :ensure t
  :after xref
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (remove-hook 'xref-backend-functions #'etags--xref-backend))

(use-package nerd-icons-xref
  :ensure t
  :after xref
  :config (nerd-icons-xref-mode))

;;; Make Xref try all backends untill first one succeed

(defun helheim-xref--create-fetcher (kind)
  "Create a fetcher function for xref KIND.
Iterates through all backends in `xref-backend-functions' and returns
a lambda that captures the xrefs from the first backend that successfully
finds an identifier at point. Signals a user-error if no backend succeeds.

KIND should be a symbol like 'definitions or 'references, which will be
used to construct the backend method name."
  (or (cl-dolist (func (+hook-values 'xref-backend-functions))
        (if-let* ((backend (funcall func))
                  (identifier (xref-backend-identifier-at-point backend))
                  (method (intern (format "xref-backend-%s" kind)))
                  (xrefs (funcall method backend identifier)))
            (cl-return (lambda () xrefs))))
      (user-error "Nothing found")))

(defun helheim-xref-find-definitions ()
  "Find the definition of the identifier at point.

The original `xref-find-definitions' command tries all backends in
`xref-backend-functions` in order to \"find suitable for current context\".
The intended design seems to be that all possible backends for all
major modes are stored in a single global variable, and then `xref-find-backend'
selects an appropriate one.

In practice, however, `xref-find-backend' simply calls each function in
`xref-backend-functions' in order until it finds one that returns a symbol
(`cl-defgeneric' will dispatch on). In practice typical get backend function
looks like this:

  (defun eglot-xref-backend () \"Eglot xref backend.\" 'eglot)

Such functions contain no logic of their own, so Xref always picks the
first backend in the list, and the rest are never tried.  Whoever puts
on the lab coat first becomes the doctor.

This command, in contrast, tries all registered backends in sequence until
the first one succeeds in finding definitions."
  (interactive)
  (require 'xref)
  (xref--show-defs (helheim-xref--create-fetcher 'definitions) nil))

(defun helheim-xref-find-references ()
  "Find the references of the identifier at point.
Reed help for `helheim-xref-find-definitions' for the differences from
`xref-find-references'."
  (interactive)
  (require 'xref)
  (xref--show-xrefs (helheim-xref--create-fetcher 'references) nil))

(defun helheim-xref-find-definitions-other-window ()
  "Like `helheim-xref-find-definitions' but switch to the other window."
  (interactive)
  (require 'xref)
  (xref--show-defs (helheim-xref--create-fetcher 'definitions)
                   'window))

(defun helheim-xref-find-definitions-other-frame (identifier)
  "Like `helheim-xref-find-definitions' but switch to the other frame."
  (interactive)
  (require 'xref)
  (xref--show-defs (helheim-xref--create-fetcher 'definitions)
                   'frame))

(hel-keymap-global-set
  "<remap> <xref-find-references>"  #'helheim-xref-find-references
  "<remap> <xref-find-definitions>" #'helheim-xref-find-definitions
  "<remap> <xref-find-definitions-other-window>" #'helheim-xref-find-definitions-other-window
  "<remap> <xref-find-definitions-other-frame>" #'helheim-xref-find-definitions-other-frame)

(provide 'helheim-xref)
;;; helheim-xref.el ends here
