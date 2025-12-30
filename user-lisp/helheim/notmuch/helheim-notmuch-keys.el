;;; helheim-notmuch-keys.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Keybindings

(require 'notmuch)

(hel-set-initial-state 'notmuch-hello-mode  'normal)
(hel-set-initial-state 'notmuch-search-mode 'normal)
(hel-set-initial-state 'notmuch-tree-mode   'normal)
(hel-set-initial-state 'notmuch-show-mode   'normal)

(hel-keymap-set notmuch-common-keymap :state 'normal
  "q"   'notmuch-bury-or-kill-this-buffer
  "s"   'notmuch-search
  "S"   'notmuch-unthreaded
  "T"   'notmuch-tree
  "t"   'notmuch-search-by-tag
  "c"   'notmuch-mua-new-mail
  "?"   'notmuch-help
  "u"   'notmuch-tag-undo
  "g r" 'notmuch-poll-and-refresh-this-buffer
  "V"   'notmuch-version
  ;; "g r" 'notmuch-refresh-this-buffer
  ;; "g R" 'notmuch-refresh-all-buffers
  ;; "C-w R" 'notmuch-refresh-all-buffers
  )

(hel-keymap-set notmuch-search-mode-map :state 'normal
  ;; "<mouse-1>" 'notmuch-search-show-thread
  ;; "RET" 'notmuch-search-show-thread
  "S"   'notmuch-search-filter
  "K"   'notmuch-tag-jump
  "o"   'notmuch-search-toggle-order
  "T"   'notmuch-tree-from-search-current-query
  "*"   'notmuch-search-tag-all
  "a"   'notmuch-search-archive-thread
  "c"   'compose-mail
  ;; "c C" 'compose-mail-other-frame
  ;; "d" 'evil-collection-notmuch-search-toggle-delete
  ;; "!" 'evil-collection-notmuch-search-toggle-unread
  ;; "=" 'evil-collection-notmuch-search-toggle-flagged
  "q"   'notmuch-bury-or-kill-this-buffer
  "r"   'notmuch-search-reply-to-thread-sender
  "R"   'notmuch-search-reply-to-thread
  "t"   'notmuch-search-filter-by-tag
  "-"   'notmuch-search-remove-tag
  "+"   'notmuch-search-add-tag
  "g g" 'notmuch-search-first-thread
  "G"   'notmuch-search-last-thread)

(hel-keymap-set notmuch-tree-mode-map :state 'normal
  ;; "<mouse-1>" 'notmuch-tree-show-message
  ;; "RET" 'notmuch-tree-show-message
  "?" 'notmuch-help
  "q" 'notmuch-tree-quit
  "S" 'notmuch-tree-to-search
  "c" 'notmuch-mua-new-mail
  "T" 'notmuch-search-from-tree-current-query
  "r" 'notmuch-tree-reply-sender
  "R" 'notmuch-tree-reply
  ;; "d" 'evil-collection-notmuch-tree-toggle-delete
  ;; "!" 'evil-collection-notmuch-tree-toggle-unread
  ;; "=" 'evil-collection-notmuch-tree-toggle-flagged
  "K" 'notmuch-tag-jump
  "A" 'notmuch-tree-archive-thread-then-next
  "a" 'notmuch-tree-archive-message-then-next
  "s" 'notmuch-tree-to-tree
  "C-j" 'notmuch-tree-next-thread
  "C-k" 'notmuch-tree-prev-thread
  "] ]" 'notmuch-tree-next-message
  "[ [" 'notmuch-tree-prev-message
  "g j" 'notmuch-tree-next-matching-message
  "g k" 'notmuch-tree-prev-matching-message
  "|" 'notmuch-show-pipe-message
  "-" 'notmuch-tree-remove-tag
  "+" 'notmuch-tree-add-tag
  "*" 'notmuch-tree-tag-thread
  "e" 'notmuch-tree-resume-message)

(hel-keymap-set notmuch-show-mode-map :state 'normal
  ;; "<tab>"     'notmuch-show-next-button
  ;; "<backtab>" 'notmuch-show-previous-button
  ;; "RET"       'notmuch-show-toggle-message
  "g x" 'goto-address-at-point
  "p"   'notmuch-show-save-attachments
  "A"   'notmuch-show-archive-thread-then-next
  "S"   'notmuch-show-filter-thread
  "K"   'notmuch-tag-jump
  ;; "C"   'notmuch-mua-new-mail
  ;; "c c" 'notmuch-mua-new-mail
  "r" 'notmuch-show-reply-sender
  "R" 'notmuch-show-reply
  ;; "n" 'notmuch-show-forward-message
  "X"   'notmuch-show-archive-thread-then-exit
  "T"   'notmuch-tree-from-show-current-query
  "<"   'notmuch-show-toggle-thread-indentation
  "a"   'notmuch-show-archive-message-then-next-or-next-thread
  ;; "d"   'evil-collection-notmuch-show-toggle-delete
  ;; "="   'evil-collection-notmuch-show-toggle-flagged
  "H"   'notmuch-show-toggle-visibility-headers
  "g j" 'notmuch-show-next-open-message
  "g k" 'notmuch-show-previous-open-message
  "z j" 'notmuch-show-next-open-message
  "z k" 'notmuch-show-previous-open-message
  "] ]" 'notmuch-show-next-message
  "[ [" 'notmuch-show-previous-message
  "C-j" 'notmuch-show-next-message
  "C-k" 'notmuch-show-previous-message
  "M-j" 'notmuch-show-next-thread-show
  "M-k" 'notmuch-show-previous-thread-show
  "x"   'notmuch-show-archive-message-then-next-or-exit
  "|"   'notmuch-show-pipe-message
  "*"   'notmuch-show-tag-all
  "-"   'notmuch-show-remove-tag
  "+"   'notmuch-show-add-tag
  "."   'notmuch-show-part-map)


;;; .
(provide 'helheim-notmuch-keys)
;;; helheim-notmuch-keys.el ends here
