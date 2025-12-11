;;; helheim-git.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'hel-core)

;; Entry points
(hel-keymap-set mode-specific-map
  ;; "v" (cons "version control" vc-prefix-map)
  "v" (cons "version control"
            (define-keymap
              "SPC" 'magit-dispatch
              "RET" 'magit-dispatch
              "?"   'magit-dispatch
              "v"   'magit-status
              "f"   'magit-file-dispatch)))

;;; Keybindings

(with-eval-after-load 'with-editor
  (hel-keymap-set with-editor-mode-map :state '(normal motion)
    "Z Z" 'with-editor-finish
    "Z Q" 'with-editor-cancel))

(with-eval-after-load 'magit
  (hel-keymap-set magit-mode-map
    "i"   nil ;; `magit-gitignore'
    "g"   nil ;; `magit-refresh'
    "G"   nil ;; `magit-refresh-all'
    ":"   nil ;; `magit-git-command'
    "z"   nil ;; `magit-stash'
    "C-w" nil
    "<remap> <next-line>" nil      ;; `magit-next-line'
    "<remap> <previous-line>" nil) ;; `magit-previous-line'

  (hel-keymap-set magit-mode-map
    "C-w p" 'magit-toggle-buffer-lock
    "SPC" 'magit-dispatch ;; SPC SPC
    ;; Use the default Hel motion commands instead of `magit-next-line'
    ;; and `magit-previous-line', because they are surprisingly slow and
    ;; make little sense, since we have selection on "v".
    "j"   'next-line
    "k"   'previous-line
    ;;                              ;; original key
    "x"   'magit-delete-thing       ;; "k"
    "X"   'magit-file-untrack       ;; "K"
    "-"   'magit-revert-no-commit   ;; "v"
    "_"   'magit-revert             ;; "V"
    "p"   'magit-push               ;; "P"
    "o"   'magit-reset-quickly      ;; "x"
    "O"   'magit-reset              ;; "X"
    "I"   'magit-gitignore          ;; "i"
    "y"   'magit-copy-section-value ;; "C-w"
    "|"   'magit-git-command        ;; ":"
    "'"   'magit-submodule          ;; "o"
    "\""  'magit-subtree            ;; "O"
    "="   'magit-diff-less-context  ;; "-"
    "g r" 'magit-refresh            ;; "g"
    "g R" 'magit-refresh-all        ;; "G"
    "Z"   'magit-stash              ;; "z"
    ;; "i"   'helheim-magit-text-mode
    "v"   (lambda (arg)
            (interactive "P")
            (if (use-region-p)
                (deactivate-mark arg)
              (set-mark-command arg)))
    "<escape>" (lambda ()
                 (interactive)
                 (deactivate-mark)))

  (hel-keymap-set magit-status-mode-map
    "g z" 'magit-jump-to-stashes
    "g t" 'magit-jump-to-tracked
    "g n" 'magit-jump-to-untracked
    "g u" 'magit-jump-to-unstaged
    "g s" 'magit-jump-to-staged
    "g f" 'magit-jump-to-unpulled-from-upstream
    "g F" 'magit-jump-to-unpulled-from-pushremote
    "g p" 'magit-jump-to-unpushed-to-upstream
    "g P" 'magit-jump-to-unpushed-to-pushremote
    "j" nil) ;; `magit-status-jump'

  (hel-keymap-set magit-diff-mode-map
    "y"   'magit-copy-section-value
    "g d" 'magit-jump-to-diffstat-or-diff
    "j"    nil)

  (hel-keymap-set magit-diff-section-map
    "C-j" nil) ;; `magit-diff-visit-worktree-file'

  (hel-keymap-set magit-log-mode-map
    "z j" 'magit-go-backward
    "z k" 'magit-go-forward
    "/"   'magit-log-move-to-revision
    "j"    nil) ;; `magit-log-move-to-revision'

  (hel-keymap-set magit-blob-mode-map
    "z j" 'magit-blob-next      ;; "n"
    "z k" 'magit-blob-previous) ;; "p"

  (hel-keymap-set git-commit-mode-map :state 'normal
    "g k" 'git-commit-prev-message ;; "M-p"
    "g j" 'git-commit-next-message ;; "M-n"
    "z k" 'git-commit-prev-message
    "z j" 'git-commit-next-message)

  (hel-keymap-set magit-revision-mode-map
    "j" nil ;; `magit-revision-jump'
    "/" 'magit-revision-jump))


;;;; Transient dispatches

(with-eval-after-load 'magit
  (transient-suffix-put 'magit-dispatch "Z" :key "%") ;; `magit-worktree'
  (transient-suffix-put 'magit-dispatch "z" :key "Z") ;; `magit-stash'
  (transient-suffix-put 'magit-dispatch "o" :key "'") ;; `magit-submodule'
  (transient-suffix-put 'magit-dispatch "O" :key "\"") ;; `magit-subtree'
  (transient-suffix-put 'magit-dispatch "V" :key "_") ;; `magit-revert'
  (transient-suffix-put 'magit-dispatch "X" :key "O") ;; `magit-reset'
  (transient-suffix-put 'magit-dispatch "v" :key "-") ;; `magit-reverse'
  (transient-suffix-put 'magit-dispatch "k" :key "x") ;; `magit-discard'

  (transient-suffix-put 'magit-branch "x" :key "X") ;; `magit-branch-reset'
  (transient-suffix-put 'magit-branch "k" :key "x") ;; `magit-branch-delete'

  (transient-suffix-put 'magit-remote "k" :key "x") ;; `magit-remote-remove'
  (transient-suffix-put 'magit-tag    "k" :key "x") ;; `magit-tag-delete'

  ;; NOTE: "V" keys in `magit-revert' popup presents twice.
  (transient-suffix-put 'magit-revert "V" :key "_") ;; `magit-revert-and-commit'
  (transient-suffix-put 'magit-revert "V" :key "_")) ;; `magit-sequencer-continue'

;;;; Blame

(with-eval-after-load 'magit
  (hel-keymap-set magit-blame-read-only-mode-map
    "y"   'magit-blame-copy-hash
    "j"   'magit-blame-next-chunk
    "k"   'magit-blame-previous-chunk
    "C-j" 'magit-blame-next-chunk-same-commit
    "C-k" 'magit-blame-previous-chunk-same-commit
    "RET" 'magit-diff-show-or-scroll-up)

  (add-hook 'magit-blame-mode-hook
            (defun helheim-git-magit-blame-h ()
              (if magit-blame-mode
                  (hel-motion-state)
                (hel-normal-state)))))

;;;; Git rebase

(with-eval-after-load 'git-rebase
  (setq git-rebase-mode-map
        (define-keymap
          :parent special-mode-map
          "RET" 'git-rebase-show-commit
          "j"   'forward-line
          "k"   'git-rebase-backward-line
          "M-j" 'git-rebase-move-line-down
          "M-k" 'git-rebase-move-line-up
          "p"   'git-rebase-pick
          "d"   'git-rebase-kill-line ;; or `git-rebase-drop'
          "b"   'git-rebase-break
          "e"   'git-rebase-edit
          "l"   'git-rebase-label
          "m"   'git-rebase-merge
          "M"   'git-rebase-merge-toggle-editmsg
          "s"   'git-rebase-squash
          "S"   'git-rebase-squish
          "f"   'git-rebase-fixup
          "F"   'git-rebase-alter
          "A"   'git-rebase-alter
          "q"   'undefined
          "r"   'git-rebase-reword
          "w"   'git-rebase-reword
          "t"   'git-rebase-reset
          "u"   'git-rebase-undo
          "U"   'git-rebase-update-ref
          "x"   'git-rebase-exec
          "y"   'git-rebase-insert
          "n"   'git-rebase-noop
          ;;
          "}"   'forward-paragraph
          "{"   'backward-paragraph
          "] p" 'forward-paragraph
          "[ p" 'backward-paragraph))
  (remove-hook 'git-rebase-mode-hook #'git-rebase-mode-show-keybindings)
  (add-hook 'git-rebase-mode-hook 'helheim-git-rebase-mode-show-keybindings 90))

(defun helheim-git-rebase-mode-show-keybindings ()
  "Modify the \"Commands:\" section of the comment Git generates.
Modify that section to replace Git's one-letter command abbreviation,
with the key bindings used in Magit."
  (let ((inhibit-read-only t))
    ;; (save-excursion
    ;;   (save-match-data))
    (goto-char (point-min))
    (re-search-forward (concat git-rebase-comment-re "\\s-+Commands:")
                       nil t)
    (delete-region (point) (point-max))
    (cl-labels ((key (str)
                  (propertize str 'font-lock-face 'help-key-binding))
                (comment (str)
                  (propertize str 'font-lock-face 'font-lock-comment-face)))
      (-> (list ""
                (concat (key "M-j") (comment " / ") (key "M-k") (comment " rearrange commits"))
                (concat (key "p") (comment "  pick <commit> = use commit"))
                (concat (key "r") (comment "  reword <commit> = use commit, but edit the commit message"))
                (concat (key "e") (comment "  edit <commit> = use commit, but stop for amending"))
                (concat (key "s") (comment "  squash <commit> = use commit, but meld into previous commit"))
                (concat (key "f") (comment "  fixup <commit> = use commit, but meld into previous commit,"))
                (comment "                    dropping <commit>'s message")
                (concat (key "F") (comment "  fixup -C <commit> = use commit, but meld into previous commit,"))
                (comment "                       dropping previous commit's message")
                (concat (key "S") (comment "  fixup -c <commit> = use commit, but meld into previous commit"))
                (comment "            dropping previous commit's message, and open the editor")
                (concat (key "x") (comment "  exec <command> = run command (the rest of the line using shell"))
                (concat (key "b") (comment "  break = stop here (continue rebase later with 'git rebase --continue'"))
                (concat (key "d") (comment "  drop <commit> = remove commit"))
                (concat (key "l") (comment "  label <label> = label current HEAD with a name"))
                (concat (key "t") (comment "  reset <label> = reset HEAD to a label"))
                (concat (key "m") (comment "  merge [-C <commit> | -c <commit>] <label> [# <oneline>]"))
                (comment "        create a merge commit using the original merge commit's")
                (comment "        message (or the oneline, if no original merge commit was")
                (comment "        specified); use -c <commit> to reword the commit message")
                (concat (key "U") (comment "  update-ref <ref> = track a placeholder for the <ref> to be updated"))
                (comment "                      to this position in the new commits. The <ref> is")
                (comment "                      updated at the end of the rebase")
                (concat (key "RET") (comment " show commit in another window"))
                (concat (key "u") (comment "   undo last change"))
                (concat (key "i") (comment "   switch to normal state"))
                (concat (key "ZZ") (comment "  proceed rebase"))
                (concat (key "ZQ") (comment "  abort rebase"))
                ""
                (comment "these lines can be re-ordered; they are executed from top to bottom.")
                ""
                (comment "if you remove a line here that commit will be lost.")
                ""
                (comment "however, if you remove everything, the rebase will be aborted.")
                "")
          (string-join (comment (concat "\n" comment-start " ")))
          (insert)))
    (goto-char (point-min))))

;;; Config

;; `diff-hl-command-map'
;; `diff-hl-mode-map'
(use-package diff-hl
  :ensure t
  :commands (diff-hl-stage-current-hunk
             diff-hl-revert-hunk
             diff-hl-next-hunk
             diff-hl-previous-hunk)
  :hook
  (elpaca-after-init-hook . global-diff-hl-mode)
  (dired-mode-hook . diff-hl-dired-mode)
  ;; (dired-mode-hook . diff-hl-dired-mode-unless-remote)
  ;; (vc-dir-mode-hook . turn-on-diff-hl-mode)
  ;; (diff-hl-mode-hook . diff-hl-flydiff-mode)
  )

(use-package magit
  :ensure t
  :defer t
  :custom
  (magit-refresh-verbose debug-on-error)
  (magit-diff-refine-hunk t) ;; show granular diffs in selected hunk
  ;; (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-bury-buffer-function #'magit-restore-window-configuration)

  ;; ;; Don't autosave repo buffers. This is too magical, and saving can
  ;; ;; trigger a bunch of unwanted side-effects, like save hooks and
  ;; ;; formatters. Trust the user to know what they're doing.
  ;; (magit-save-repository-buffers nil)

  ;; ;; Don't display parent/related refs in commit buffers; they are rarely
  ;; ;; helpful and only add to runtime costs.
  ;; (magit-revision-insert-related-refs nil)

  ;; ;; If two projects have the same project name (e.g. A/src and B/src will
  ;; ;; both resolve to the name "src"), Magit will treat them as the same
  ;; ;; project and destructively hijack each other's magit buffers. This is
  ;; ;; especially problematic if you use workspaces and have magit open in
  ;; ;; each, and the two projects happen to have the same name! By unsetting
  ;; ;; `magit-uniquify-buffer-names', magit uses the project's full path as
  ;; ;; its name, preventing such naming collisions.
  ;; (magit-uniquify-buffer-names nil)

  :config
  (magit-auto-revert-mode)

  ;; Turn ref links into clickable buttons.
  (add-hook 'magit-process-mode-hook #'goto-address-mode)

  ;; The mode-line isn't useful in these popups and take up valuable screen
  ;; estate, so free it up.
  (add-hook 'magit-popup-mode-hook #'hide-mode-line-mode)

  ;; ;; Prevent sudden window position resets when staging/unstaging/discarding/etc
  ;; ;; hunks in `magit-status-mode' buffers. It's disorienting, especially on
  ;; ;; larger projects.
  ;; (defvar +magit--refreshed-buffer nil)
  ;; (add-hook! 'magit-pre-refresh-hook
  ;;   (defun +magit--set-window-state-h ()
  ;;     (when (doom-region-active-p)
  ;;       (setq-local +magit--refreshed-buffer
  ;;                   (list (current-buffer) (doom-region-beginning) (window-start))))))
  ;; (add-hook! 'magit-post-refresh-hook
  ;;   (defun +magit--restore-window-state-h ()
  ;;     (cl-destructuring-bind (&optional buf pt beg) +magit--refreshed-buffer
  ;;       (when (and buf (eq (current-buffer) buf))
  ;;         (goto-char pt)
  ;;         (set-window-start nil beg t)
  ;;         (kill-local-variable '+magit--refreshed-buffer)))))

  ;; ;; Add additional switches that seem common enough
  ;; (transient-append-suffix 'magit-fetch "-p"
  ;;   '("-t" "Fetch all tags" ("-t" "--tags")))
  ;; (transient-append-suffix 'magit-pull "-r"
  ;;   '("-a" "Autostash" "--autostash"))

  ;; ;; Clean up after magit by killing leftover magit buffers and reverting
  ;; ;; affected buffers (or at least marking them as need-to-be-reverted).
  ;; (define-key magit-mode-map "q" #'+magit/quit)
  ;; (define-key magit-mode-map "Q" #'+magit/quit-all)
)

;; project.el integration: Replace VC-dir with Magit
(with-eval-after-load 'project
  (hel-keymap-set project-prefix-map
    "v" 'helheim-project-magit)
  ;; In `project-switch-project' dispatch replace VC-Dir with Magit.
  (when-let* ((i (-elem-index '(project-vc-dir "VC-Dir")
                              project-switch-commands)))
    (setcar (nthcdr i project-switch-commands)
            '(helheim-project-magit "Magit"))))

;;;; Commands

;;;###autoload
(defun helheim-project-magit ()
  "Open Magit status buffer in the current project's root."
  (interactive)
  (magit-status-setup-buffer (project-root (project-current t))))

;; TODO: currently doesn't work
(define-minor-mode helheim-magit-text-mode
  "Switch to `text-mode' in current magit buffer."
  :init-value nil
  (if helheim-magit-text-mode
      (progn
        (setq-local helheim-git--previous-magit-mode major-mode)
        (text-mode))
    ;; else
    (funcall helheim-git--previous-magit-mode)
    (setq-local helheim-git--previous-magit-mode nil)
    (magit-refresh))
  (hel-switch-to-initial-state))

;;; .
(provide 'helheim-git)
;;; helheim-git.el ends here
