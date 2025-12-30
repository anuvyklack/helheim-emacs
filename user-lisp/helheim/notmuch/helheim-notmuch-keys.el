;;; helheim-notmuch-keys.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Keybindings

(require 'notmuch)

(hel-set-initial-state 'notmuch-hello-mode  'motion)
(hel-set-initial-state 'notmuch-search-mode 'motion)
(hel-set-initial-state 'notmuch-tree-mode   'motion)
(hel-set-initial-state 'notmuch-show-mode   'motion)
(add-hook 'notmuch-hello-mode-hook #'hel-switch-to-normal-state-in-field-widget)

(setq notmuch-tagging-keys
      `(("a" notmuch-archive-tags "Archive")
        ("u" notmuch-show-mark-read-tags "Mark read")
        ("f" ("+flagged") "Flag")
        ("d" ,(notmuch-tag-change-list
               (-concat +notmuch-delete-tags notmuch-archive-tags))
         "Delete")
        ("s" ,(notmuch-tag-change-list
               (-concat +notmuch-spam-tags notmuch-archive-tags))
         "Mark as spam")))

;; For `notmuch-tag-jump'
(setq notmuch-tag-jump-reverse-key "m")

(hel-keymap-set notmuch-common-keymap
  ;; Hel keybindings
  "h"   'left-char
  "j"   'next-line
  "k"   'previous-line
  "l"   'right-char
  "%"   'hel-mark-whole-buffer
  "C-o" 'hel-backward-mark-ring
  "C-i" 'hel-forward-mark-ring
  ;;
  "?"   'notmuch-help
  "q"   'notmuch-bury-or-kill-this-buffer
  "s"   'notmuch-search
  "t"   'notmuch-search-by-tag
  "T"   'notmuch-tree
  "Z"   'notmuch-tree
  "U"   'notmuch-unthreaded
  "u"   'notmuch-tag-undo
  "x"   'notmuch-refresh-this-buffer
  "c"   '("Compose mail" . notmuch-mua-new-mail)
  "C-c RET" '("Sync email" . notmuch-poll-and-refresh-this-buffer) ;; leader
  ", RET"   '("Sync email" . notmuch-poll-and-refresh-this-buffer) ;; localleader
  ", s" 'notmuch-search
  ", t" 'notmuch-search-by-tag
  ", u" 'notmuch-unthreaded
  ", z" 'notmuch-tree
  ", c" '("Compose mail" . notmuch-mua-new-mail)
  ", v" 'notmuch-version
  "g"    nil
  "G"    nil)

(hel-keymap-set notmuch-hello-mode-map
  "m"   'notmuch-jump-search ;; "m" for jump menu
  "g g" 'beginning-of-buffer
  "G"   'end-of-buffer)

(hel-keymap-set notmuch-search-mode-map
  "RET"   'notmuch-search-show-thread
  "M-RET" 'notmuch-tree-from-search-thread
  ;;
  "h"   'left-char
  "j"   'helheim-notmuch-search-next-line
  "k"   'helheim-notmuch-search-previous-line
  "l"   'right-char
  "v"   'helheim-notmuch-toggle-selection
  ;;
  "] ]" 'notmuch-search-next-thread
  "[ [" 'notmuch-search-previous-thread
  ;;
  "s"   '("Edit search" . notmuch-search-edit-search)
  "e"   '("Edit search" . notmuch-search-edit-search)
  "f"   '("Filter results" . notmuch-search-filter)
  "t"   '("Filter by tag" . notmuch-search-filter-by-tag)
  "o"   '("Inverse order" . notmuch-search-toggle-order)
  "i"   '("Show ignored" . notmuch-search-toggle-hide-excluded) ;; "i" for ignore
  "T"   'notmuch-tree-from-search-current-query
  "U"   'notmuch-unthreaded-from-search-current-query
  ;;
  "m"   '("Mark with tag" . notmuch-tag-jump) ;; "m" for mark
  "*"   '("Tag all" . notmuch-search-tag-all)
  "-"   '("Remove tag" . notmuch-search-remove-tag)
  "+"   '("Add tag" . notmuch-search-add-tag)
  "a"   '("Archive" . notmuch-search-archive-thread)
  "d"   '("Delete" .  +notmuch-search-delete)
  "!"   '+notmuch-search-flagged
  "x"   'notmuch-refresh-this-buffer ;; apply tag changes like in Dired
  ;;
  "y"   '("yank" . notmuch-search-stash-map) ;; by "stash" Notmuch means copy
  "c"   '("Compose mail" . notmuch-mua-new-mail)
  "r"   '("Reply" . notmuch-search-reply-to-thread-sender)
  "R"   '("Reply all" . notmuch-search-reply-to-thread)
  ", r" '("Reply" . notmuch-search-reply-to-thread-sender)
  ", R" '("Reply all" . notmuch-search-reply-to-thread)
  "g g" 'notmuch-search-first-thread
  "G"   'notmuch-search-last-thread)

(hel-keymap-set notmuch-tree-mode-map
  "z"    nil
  "c"    nil
  "RET" 'notmuch-tree-show-message
  ;;
  "h"   'left-char
  ;; "j"   'next-line
  ;; "k"   'previous-line
  "l"   'right-char
  ;;
  "j"   'helheim-notmuch-tree-next-line
  "k"   'helheim-notmuch-tree-previous-line
  "C-j" 'notmuch-tree-next-matching-message
  "C-k" 'notmuch-tree-prev-matching-message
  "g j" 'notmuch-tree-next-matching-message
  "g k" 'notmuch-tree-prev-matching-message
  "z j" 'notmuch-tree-next-message
  "z k" 'notmuch-tree-prev-message
  "] ]" 'notmuch-tree-next-thread
  "[ [" 'notmuch-tree-prev-thread
  "g g" 'notmuch-search-first-thread
  "G"   'notmuch-search-last-thread
  ;;
  "o"   '("Inverse order" . notmuch-tree-toggle-order)
  "i"   '("Show ignored" . notmuch-tree-toggle-hide-excluded) ;; "i" for ignore
  "T"   'notmuch-search-from-tree-current-query
  "U"   'notmuch-unthreaded-from-tree-current-query
  "Z"   'notmuch-tree-from-unthreaded-current-query
  ;;
  ;; Access notmuch-show functions directly from notmuch-tree buffer
  "|"   'notmuch-show-pipe-message
  "w"   'notmuch-show-save-attachments
  "v"   'notmuch-show-view-all-mime-parts
  "y"   '("yank" . notmuch-show-stash-map) ;; by "stash" Notmuch means copy
  "b"   'notmuch-show-resend-message
  ;;
  "a"   '("Archive" . notmuch-tree-archive-message-then-next)
  "A"   '("Archive thread" . notmuch-tree-archive-thread-then-next)
  "d"   '("Delete" . +notmuch-tree-delete)
  "D"   '("Delete thread" . +notmuch-tree-delete-thread)
  "m"   '("Mark with tag" . notmuch-tag-jump) ;; "m" for mark
  "-"   '("Remove tag" . notmuch-tree-remove-tag)
  "+"   '("Add tag" . notmuch-tree-add-tag)
  "*"   '("Tag thread" . notmuch-tree-tag-thread)
  "x"   'notmuch-refresh-this-buffer ;; apply tag changes like in Dired
  ;;
  "r"   '("Reply" . notmuch-tree-reply-sender)
  "R"   '("Reply all" . notmuch-tree-reply)
  ", r" '("Reply" . notmuch-tree-reply-sender)
  ", R" '("Reply all" . notmuch-tree-reply)
  "s"   'notmuch-tree-to-tree
  "|"   'notmuch-show-pipe-message
  "e"   'notmuch-tree-resume-message)

(hel-keymap-set notmuch-show-mode-map :state '(motion normal)
  "C-j" 'notmuch-show-next-open-message
  "C-k" 'notmuch-show-previous-open-message
  "z j" 'notmuch-show-next-message
  "z k" 'notmuch-show-previous-message
  "] ]" '("Notmuch next thread" . notmuch-show-next-thread-show)
  "[ [" '("Notmuch prev thread" . notmuch-show-previous-thread-show))

(hel-keymap-set notmuch-show-mode-map
  ;; "M-RET" 'notmuch-show-open-or-close-all
  "g x" 'goto-address-at-point
  ;;
  "h"   'left-char
  "j"   'next-line
  "k"   'previous-line
  "l"   'right-char
  "g g" 'beginning-of-buffer
  "G"   'end-of-buffer
  ;;
  "z c" '("Fold message" . notmuch-show-toggle-part-invisibility)
  "z O" '("Unfold all messages" . +notmuch-show-show-all-messages)
  ;;
  "n"   'notmuch-show-next-open-message
  "p"   'notmuch-show-previous-open-message
  "N"   'notmuch-show-next-message
  "P"   'notmuch-show-previous-message
  "M-n" 'notmuch-show-next-thread-show
  "M-p" 'notmuch-show-previous-thread-show
  "C-c C-c" 'notmuch-show-advance-and-archive ;; <leader><leader>
  "DEL" 'notmuch-show-rewind ;; <backspace>
  ;;
  "a"   '("Archive" . notmuch-show-archive-message)
  "A"   '("Archive thread" . notmuch-show-archive-thread)
  ;; "a"   '("Archive" . notmuch-show-archive-message-then-next-or-next-thread)
  ;; "A"   '("Archive thread" . notmuch-show-archive-thread-then-next)
  "d"   '("Delete" . +notmuch-show-delete)
  "D"   '("Delete thread" . +notmuch-show-delete-thread)
  "m"   '("Mark with tag" . notmuch-tag-jump) ;; "m" for mark
  "*"   'notmuch-show-tag-all
  "-"   'notmuch-show-remove-tag
  "+"   'notmuch-show-add-tag
  "x"   'notmuch-refresh-this-buffer ;; apply tag changes like in Dired
  ;;
  "Z"   'notmuch-tree-from-show-current-query
  "U"   'notmuch-unthreaded-from-show-current-query
  ;; Use forwarding to share information with others; use resending to fix
  ;; delivery issues or resend to the original recipient.
  "f"   '("Forward message" . notmuch-show-forward-message)
  "F"   '("Forward open messages" . notmuch-show-forward-open-messages)
  "b"   'notmuch-show-resend-message
  "r"   '("Reply" . notmuch-show-reply-sender)
  "R"   '("Reply all" . notmuch-show-reply)
  "L"   'notmuch-show-filter-thread
  "|"   'notmuch-show-pipe-message
  "w"   'notmuch-show-save-attachments ;; "w" for write
  "p"   'notmuch-show-save-attachments
  "V"   'notmuch-show-view-raw-message
  "e"   'notmuch-show-resume-message
  "y"   '("copy" . notmuch-show-stash-map)
  "H"   '("Headers visibility" . notmuch-show-toggle-visibility-headers)
  "!"   'notmuch-show-toggle-elide-non-matching
  "$"   'notmuch-show-toggle-process-crypto
  "."   'notmuch-show-part-map
  "#"   'notmuch-show-print-message
  ;; ", a" '("Save attachments" . notmuch-show-save-attachments)
  ", w" '("Save attachments" . notmuch-show-save-attachments)
  ", r" '("Reply" . notmuch-show-reply-sender)
  ", R" '("Reply all" . notmuch-show-reply)
  ", p" '("Print" . notmuch-show-print-message)
  ", l" '("Links" . notmuch-show-browse-urls)
  ", V" '("View raw message" . notmuch-show-view-raw-message)
  ", %" '("Choose duplicate" . notmuch-show-choose-duplicate)
  "C-c t h" '("Notmuch headers visibility" . notmuch-show-toggle-visibility-headers)
  "C-c t i" '("Notmuch thread indentation" . notmuch-show-toggle-thread-indentation)
  "c"   nil
  "t"   nil)

(hel-keymap-set notmuch-show-stash-map
  "c" '("Copy CC field" . notmuch-show-stash-cc)
  "d" '("Copy date" . notmuch-show-stash-date)
  "F" '("Copy filename" . notmuch-show-stash-filename)
  "f" '("Copy from" . notmuch-show-stash-from)
  "i" '("Copy ID" . notmuch-show-stash-message-id)
  "I" '("Copy ID stripped" . notmuch-show-stash-message-id-stripped)
  "s" '("Copy subject" . notmuch-show-stash-subject)
  "T" '("Copy tags" . notmuch-show-stash-tags)
  "t" '("Copy to" . notmuch-show-stash-to)
  "l" 'notmuch-show-stash-mlarchive-link
  "L" 'notmuch-show-stash-mlarchive-link-and-go
  "G" 'notmuch-show-stash-git-send-email
  "?" '("Show help" . notmuch-subkeymap-help))

(hel-keymap-set notmuch-show-part-map
  "s" '("Save part" . notmuch-show-save-part)
  "v" '("View part" . notmuch-show-view-part)
  "o" '("View part interactively" . notmuch-show-interactively-view-part)
  "|" '("Pipe part" . notmuch-show-pipe-part)
  "m" '("Choose mime of part" . notmuch-show-choose-mime-of-part)
  "?" '("Help" . notmuch-subkeymap-help))

;;; Commands

;; v
(defun helheim-notmuch-toggle-selection ()
  "Toggle selection."
  (interactive nil notmuch-search-mode notmuch-tree-mode)
  (if (use-region-p)
      (deactivate-mark)
    (hel-expand-line-selection 1)))

;; j
(defun helheim-notmuch-search-next-line (count)
  (interactive "p" notmuch-search-mode)
  (if (region-active-p)
      (hel-expand-line-selection count)
    (next-line count)))

;; k
(defun helheim-notmuch-search-previous-line (count)
  (interactive "p" notmuch-search-mode)
  (if (region-active-p)
      (hel-expand-line-selection (- count))
    (previous-line count)))

;; j
(defun helheim-notmuch-tree-next-line ()
  (interactive nil notmuch-tree-mode)
  (if (region-active-p)
      (hel-expand-line-selection 1)
    (notmuch-tree-next-message)))

;; k
(defun helheim-notmuch-tree-previous-line ()
  (interactive nil notmuch-tree-mode)
  (if (region-active-p)
      (hel-expand-line-selection -1)
    (notmuch-tree-prev-message)))

(defun +notmuch-show-show-all-messages ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (progn
             (notmuch-show-message-visible (notmuch-show-get-message-properties) t)
             (notmuch-show-goto-message-next)))))

;;;; Delete

(defun +notmuch-search-delete ()
  "Mark thread as deleted."
  (interactive)
  (notmuch-search-tag (notmuch-tag-change-list
                       (-concat +notmuch-delete-tags notmuch-archive-tags)))
  (notmuch-tree-next-message))

(defun +notmuch-tree-delete ()
  (interactive)
  (notmuch-tree-tag (notmuch-tag-change-list
                     (-concat +notmuch-delete-tags notmuch-archive-tags)))
  (notmuch-tree-next-message))

(defun +notmuch-tree-delete-thread ()
  (interactive)
  (notmuch-tree-tag-thread (notmuch-tag-change-list
                            (-concat +notmuch-delete-tags notmuch-archive-tags))))

(defun +notmuch-show-delete ()
  (interactive)
  (notmuch-show-tag (notmuch-tag-change-list
                     (-concat +notmuch-delete-tags notmuch-archive-tags))))

(defun +notmuch-show-delete-thread ()
  (interactive)
  (notmuch-show-tag-all (notmuch-tag-change-list
                         (-concat +notmuch-delete-tags notmuch-archive-tags))))

;;;; Flagged

(defun +notmuch-search-flagged ()
  (interactive)
  (notmuch-search-tag '("+flagged"))
  (notmuch-tree-next-message))

(defun +notmuch-tree-flagged ()
  (interactive)
  (notmuch-tree-tag '("+flagged"))
  (notmuch-tree-next-message))

(defun +notmuch-show-flagged ()
  (interactive)
  (notmuch-show-tag '("+flagged"))
  (notmuch-show-next-thread-show))

;;; .
(provide 'helheim-notmuch-keys)
;;; helheim-notmuch-keys.el ends here
