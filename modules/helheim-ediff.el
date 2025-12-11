;;; helheim-ediff.el -*- lexical-binding: t -*-
;;; Commentary:
;;
;; All regarads a goes to evil-collection package.
;;
;; Here's a table describing the bindings
;;
;; | Command                     | Original Binding |   Helheim   |
;; |-----------------------------+------------------+-------------|
;; | ediff-next-difference       | n, SPC           | j, n, SPC   |
;; | ediff-previous-difference   | p, DEL           | k, N, DEL   |
;; | ediff-jump-to-difference    | j                | d           |
;; | jump to first difference    | 1j               | gg          |
;; | jump to last difference     | N/A              | G           |
;; | copy region A to region B   | a                | a, l        |
;; | copy region B to region A   | b                | b, h        |
;; | scroll down 1 line          | C-u 1 v          | C-e         |
;; | scroll up 1 line            | C-u 1 V          | C-y         |
;; | scroll down half page       | v, C-v           | C-d, v, C-v |
;; | scroll up half page         | V, M-v           | C-u, V, M-v |
;; | scroll left                 | >                | zh          |
;; | scroll right                | <                | zl          |
;; | toggle highlighting         | h                | H           |
;; | ediff-suspend               | z                | C-z         |
;; | restore old diff            | ra, rb, rc       | ua, ub, uc  |
;;
;;; Code:

(setopt ediff-diff-options "-w" ; turn off whitespace checking
        ediff-split-window-function #'split-window-horizontally
        ediff-window-setup-function #'ediff-setup-windows-plain
        ;; ediff-keep-variants nil
        )

(hel-set-initial-state 'ediff-mode 'motion)

(add-hook 'ediff-keymap-setup-hook 'helheim-ediff-setup-keys)

(defun helheim-ediff-setup-keys ()
  "Modify `ediff-mode-map'."
  (hel-keymap-set ediff-mode-map :state 'motion
    "d"   'ediff-jump-to-difference
    "H"   'ediff-toggle-hilit
    "j"   'ediff-next-difference
    "k"   'ediff-previous-difference
    "N"   'ediff-previous-difference
    "C-d" 'helheim-ediff-scroll-down
    "C-u" 'helheim-ediff-scroll-up
    "C-e" 'helheim-ediff-scroll-down-1
    "C-y" 'helheim-ediff-scroll-up-1
    "g g" 'helheim-ediff-first-difference
    "G"   'helheim-ediff-last-difference
    "C-z" 'ediff-suspend
    "z l" 'helheim-ediff-scroll-right
    "z h" 'helheim-ediff-scroll-left
    "u a" 'ediff-restore-diff
    "u b" 'ediff-restore-diff
    "u c" 'ediff-restore-diff)
  (unless (or ediff-3way-comparison-job
              (eq ediff-split-window-function 'split-window-vertically))
    (hel-keymap-set ediff-mode-map :state 'motion
      "l" 'ediff-copy-A-to-B
      "h" 'ediff-copy-B-to-A))
  ;; (hel-update-active-keymaps)
  (hel-motion-state))

;;;; Restore window config after quitting ediff

(add-hook 'ediff-before-setup-hook 'helheim--ediff-save-window-configuration)
(add-hook 'ediff-quit-hook    'helheim--ediff-restore-window-configuration 90)
(add-hook 'ediff-suspend-hook 'helheim--ediff-restore-window-configuration 90)

(let (wconf) ; Private variable shared by two functions.
  ;;
  (defun helheim--ediff-save-window-configuration ()
    (setq wconf (current-window-configuration)))
  ;;
  (defun helheim--ediff-restore-window-configuration ()
    (when (window-configuration-p wconf)
      (set-window-configuration wconf))))

;;;; Help message

(with-eval-after-load 'ediff
  (dolist (msg '(ediff-long-help-message-compare2
                 ediff-long-help-message-compare3
                 ediff-long-help-message-narrow2
                 ediff-long-help-message-word-mode
                 ediff-long-help-message-merge
                 ediff-long-help-message-head
                 ediff-long-help-message-tail))
    (dolist (change '(;;("^" . "  ")
                      ("p,DEL -previous diff " . "  k,N -previous diff ")
                      ("n,SPC -next diff     " . "  j,n -next diff     ")
                      ("    j -jump to diff  " . "    d -jump to diff  ")
                      ("    h -highlighting  " . "    H -highlighting  ")
                      ("  v/V -scroll up/dn  " . "C-u/d -scroll up/dn  ")
                      ("  </> -scroll lt/rt  " . "zh/zl -scroll lt/rt  ")
                      ("  z/q -suspend/quit"   . "C-z/q -suspend/quit")))
      (setf (symbol-value msg)
            (replace-regexp-in-string (car change) (cdr change)
                                      (symbol-value msg))))))

;;; Commands

(defun helheim-ediff-scroll-left (&optional arg)
  "Scroll left."
  (interactive "P")
  (let ((last-command-event ?>))
    (ediff-scroll-horizontally arg)))

(defun helheim-ediff-scroll-right (&optional arg)
  "Scroll right."
  (interactive "P")
  (let ((last-command-event ?<))
    (ediff-scroll-horizontally arg)))

(defun helheim-ediff-scroll-up (&optional arg)
  "Scroll up by half of a page."
  (interactive "P")
  (let ((last-command-event ?V))
    (ediff-scroll-vertically arg)))

(defun helheim-ediff-scroll-down (&optional arg)
  "Scroll down by half of a page."
  (interactive "P")
  (let ((last-command-event ?v))
    (ediff-scroll-vertically arg)))

(defun helheim-ediff-scroll-down-1 ()
  "Scroll down by a line."
  (interactive)
  (let ((last-command-event ?v))
    (ediff-scroll-vertically 1)))

(defun helheim-ediff-scroll-up-1 ()
  "Scroll down by a line."
  (interactive)
  (let ((last-command-event ?V))
    (ediff-scroll-vertically 1)))

(defun helheim-ediff-first-difference ()
  "Jump to first difference."
  (interactive)
  (ediff-jump-to-difference 1))

(defun helheim-ediff-last-difference ()
  "Jump to last difference."
  (interactive)
  (ediff-jump-to-difference ediff-number-of-differences))

(provide 'helheim-ediff)
;;; helheim-ediff.el ends here
