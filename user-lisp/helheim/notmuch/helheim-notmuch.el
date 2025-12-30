;;; helheim-notmuch.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Customizing

(defcustom +notmuch-delete-tags '("+trash")
  "Tags applied to mark email for deletion."
  :type '(repeat string)
  :group 'notmuch)

(defcustom +notmuch-spam-tags '("+spam")
  "Tags applied to mark email as spam."
  :type '(repeat string)
  :group 'notmuch)

;;; Config

(use-package mm-decode
  :defer t
  :config
  (when (executable-find "w3m")
    (setopt mm-text-html-renderer 'gnus-w3m)
    ;; (setopt mm-text-html-renderer 'w3m) ;; requires external `w3m' package
    ;; (setopt mm-text-html-renderer 'w3m-standalone)
    )
  ;; Clean up file names, removing spaces, so that the operating system
  ;; does not get confused.
  (add-to-list 'mm-file-name-rewrite-functions #'mm-file-name-replace-whitespace)
  :custom
  (mm-html-inhibit-images nil)
  (mm-inline-text-html-with-w3m-keymap t)
  (mm-html-inhibit-images nil)
  (gnus-inhibit-images nil))

(use-package notmuch
  :ensure t
  :defer t
  :custom
  (mail-user-agent 'notmuch-user-agent)
  (notmuch-show-logo nil)
  (message-kill-buffer-on-exit t)
  (notmuch-search-result-format '(("date" . "%12s ")
                                  ("count" . "%-7s ")
                                  ("authors" . "%-30s ")
                                  ("subject" . "%-72s ")
                                  ("tags" . "(%s)")))
  (notmuch-tree-thread-symbols '((prefix . "╾")
                                 (top . "─")
                                 (top-tee . "┬")
                                 (vertical . "│")
                                 (vertical-tee . "├")
                                 (bottom . "╰")
                                 (arrow . "╴")))
  (notmuch-hl-line nil) ;; Disable Notmuchs' own `hl-line-mode' implementation.
  (notmuch-wash-wrap-lines-length 86) ;; message text width
  (notmuch-show-indent-messages-width 4)
  (notmuch-saved-searches
   '(( :name "inbox"    :query "tag:inbox"   :key "i")
     ( :name "unread"   :query "tag:inbox and tag:unread"  :key "u")
     ( :name "flagged"  :query "tag:flagged" :key "f")
     ( :name "sent"     :query "tag:sent"    :key "s")
     ( :name "trash"    :query "tag:trash"   :key "t")
     ( :name "spam"     :query "tag:spam"    :key "S")
     ( :name "drafts"   :query "tag:draft"   :key "d")
     ( :name "archive"  :query "not tag:inbox and not tag:trash" :key "a")
     ( :name "all mail" :query "*"           :key "A")))
  :hook
  ((notmuch-hello-mode-hook
    notmuch-search-mode-hook
    notmuch-tree-mode-hook
    notmuch-show-mode-hook) . helheim-notmuch-setup-revert-function-h)
  (notmuch-show-mode-hook . helheim-notmuch-show-setup-default-directory-h)
  (notmuch-show-mode . (lambda ()
                         (setq-local fill-column notmuch-wash-wrap-lines-length)))
  :config
  (setq-default notmuch-search-oldest-first nil)
  (advice-add 'notmuch-tree-quit :after #'helheim-notmuch-kill-buffer-a)
  (advice-add 'notmuch-bury-or-kill-this-buffer :after #'helheim-notmuch-kill-buffer-a)
  (require 'helheim-notmuch-keys))

(defun helheim-notmuch-setup-revert-function-h ()
  (setq-local revert-buffer-function (lambda (&rest _)
                                       (notmuch-refresh-this-buffer))))

(defun helheim-notmuch-show-setup-default-directory-h ()
  "Set the `defult-directory' for notmuch show buffer.
It is used as the default directory when you save email attachments."
  (setq default-directory "~/Downloads/"))

(defun helheim-notmuch-kill-buffer-a (&rest _)
  "Update previous buffer when quit from current to reflect changes."
  (when (notmuch-interesting-buffer (current-buffer))
    ;; (notmuch-refresh-this-buffer)
    (notmuch-refresh-all-buffers)))

;;; .
(provide 'helheim-notmuch)
;;; helheim-notmuch.el ends here
