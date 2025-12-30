;;; helheim-notmuch.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Config

(use-package notmuch
  :ensure t
  :defer t
  :custom
  ;; notmuch-hello-sections
  ;; notmuch-hello-thousands-separator
  ;; (notmuch-column-control 80)
  (notmuch-show-logo nil)
  (message-kill-buffer-on-exit t)
  ;; (message-send-mail-function 'message-send-mail-with-sendmail)
  ;; (send-mail-function 'sendmail-send-it)
  ;; (sendmail-program "/usr/local/bin/msmtp")
  (notmuch-search-result-format '(("date" . "%12s ")
                                  ("count" . "%-7s ")
                                  ("authors" . "%-30s ")
                                  ("subject" . "%-72s ")
                                  ("tags" . "(%s)")))
  ;; (notmuch-saved-searches
  ;;  '((:name "inbox"   :query "tag:inbox not tag:trash" :key "i")
  ;;    (:name "flagged" :query "tag:flagged"             :key "f")
  ;;    (:name "sent"    :query "tag:sent"                :key "s")
  ;;    (:name "drafts"  :query "tag:draft"               :key "d")))
  (notmuch-archive-tags '("-inbox" "-unread"))
  (notmuch-tree-thread-symbols '((prefix . "╾")
                                 (top . "─")
                                 (top-tee . "┬")
                                 (vertical . "│")
                                 (vertical-tee . "├")
                                 (bottom . "╰")
                                 (arrow . "╴")))
  :hook
  ((notmuch-hello-mode-hook
    notmuch-search-mode-hook
    notmuch-tree-mode-hook
    notmuch-show-mode-hook) . helheim-notmuch-set-revert-function-h)
  :config
  (setq-default notmuch-search-oldest-first nil)
  (add-hook 'notmuch-show-mode-hook
            (defun helheim-notmuch-set-default-directory-h ()
              (setq default-directory "~/Downloads/")))
  (require 'helheim-notmuch-keys))

(defun helheim-notmuch-set-revert-function-h ()
  (setq revert-buffer-function (lambda (&rest _)
                                 (notmuch-refresh-all-buffers))))

;;;; Restore window config on exit

;; (add-hook 'notmuch-hello-mode-hook #'+notmuch-init-h)
;;
;; (defun +notmuch-init-h ()
;;   (add-hook 'kill-buffer-hook #'+notmuch-kill-notmuch-h nil t))
;;
;; (defvar +notmuch--old-wconf nil)
;;
;; (defun +notmuch-kill-notmuch-h ()
;;   ;; (prolusion-mail-hide)
;;   (cond ((and (modulep! :ui workspaces)
;;               (+workspace-exists-p +notmuch-workspace-name))
;;          (+workspace/delete +notmuch-workspace-name))
;;         (+notmuch--old-wconf
;;          (set-window-configuration +notmuch--old-wconf)
;;          (setq +notmuch--old-wconf nil))))

;;; .
(provide 'helheim-notmuch)
;;; helheim-notmuch.el ends here
