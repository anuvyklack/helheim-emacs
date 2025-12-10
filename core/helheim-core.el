;;; helheim-core.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;;; Customizations

(defgroup helheim nil
  "Helheim specific settings."
  :prefix 'helheim-)

;; Denote format
(defcustom helheim-id-format "%Y%m%dT%H%M%S"
  "The format string of timebased ID as `format-time-string' accepts."
  :type 'string
  :group 'helheim)

(defcustom helheim-file-id-regexp "\\`\\([0-9]\\{8\\}T[0-9]\\{6\\}\\)--"
  "File name ID regexp."
  :type 'string
  :group 'helheim)

;;; Config

(require 'helheim-elpaca)

(elpaca dash (require 'dash))
(elpaca f (require 'f))
(elpaca s)

(elpaca pcre2el)
(elpaca paredit)
(elpaca blackout (require 'blackout))

(elpaca avy
  (setq avy-keys (number-sequence ?a ?z) ;; Any lower-case letter a-z.
        avy-style 'at-full
        avy-all-windows nil
        avy-all-windows-alt t
        avy-background t
        ;; the unpredictability of this (when enabled) makes it a poor default
        avy-single-candidate-jump t))

(elpaca-wait)

(use-package hel
  ;; :ensure (hel :repo "~/code/emacs/hel" :files (:defaults "**"))
  :load-path "~/code/emacs/hel"
  :config
  (hel-mode))

(use-package transient
  :ensure t
  :defer t
  :custom
  ;; Pop up transient windows at the bottom of the current window instead of
  ;; entire frame. This is more ergonomic for users with large displays or many
  ;; splits.
  (transient-display-buffer-action '(display-buffer-below-selected
                                     (dedicated . t)
                                     (inhibit-same-window . t)))
  (transient-show-during-minibuffer-read t)
  ;; (transient-default-level 5)
  :config
  ;; Close transient menus with ESC.
  (keymap-set transient-map "<escape>" #'transient-quit-one))

(use-package nerd-icons
  :ensure t
  :defer t
  :custom
  (nerd-icons-scale-factor 0.95)
  :config
  ;; Add some icons
  (cl-loop for (mode . icon-spec)
           in '((fundamental-mode nerd-icons-faicon "nf-fa-file_o" :face nerd-icons-dsilver)
                (deadgrep-mode nerd-icons-faicon "nf-fa-search"))
           do (setf (alist-get mode nerd-icons-mode-icon-alist)
                    icon-spec)))

(elpaca-wait)

;;; Core modules

;; Recursively add to `load-path' all folders in `modules/' directory
(let ((modules-dir (-> (file-name-concat helheim-root-directory "modules")
                       (file-name-as-directory))))
  (setq load-path `(,@load-path
                    ,modules-dir
                    ,@(f-directories modules-dir nil t))))

(require 'helheim-emacs)
(require 'helheim-xref) ; Go to defenition framework

(require 'helheim-info)
(require 'helheim-man)

(elpaca imenu-list)
(elpaca wgrep)

(provide 'helheim-core)
;;; helheim-core.el ends here
