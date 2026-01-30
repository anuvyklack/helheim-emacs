;;; helheim-magit.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Keybindings
(require 'hel-core)

;; Entry points
(hel-keymap-set mode-specific-map
  "v RET" 'magit-status
  "v SPC" 'magit-dispatch
  "v /"   'magit-dispatch
  "v ?"   'magit-dispatch
  "v g"   'magit-status ;; "C-x g"
  "v h"   'magit-dispatch ;; "h" in magit-status buffer
  "v f"   'magit-file-dispatch)

(with-eval-after-load 'with-editor
  (hel-keymap-set with-editor-mode-map :state '(normal motion)
    "Z Z" 'with-editor-finish
    "Z Q" 'with-editor-cancel))

;;;; `magit-mode-map' -- common keymap

;; `magit-mode-map' is a common keymap all other magit keymaps are inherited
;; from.
(with-eval-after-load 'magit
  (setq magit-mode-map
        (define-keymap
          :parent magit-section-mode-map
          "<escape>"   (lambda () (interactive) (deactivate-mark))
          "C-<return>" 'magit-visit-thing
          "RET"        'magit-visit-thing
          "M-TAB"      'magit-dired-jump
          "M-<tab>"    'magit-section-cycle-diffs
          "SPC"        'magit-diff-show-or-scroll-up
          "S-SPC"      'magit-diff-show-or-scroll-down
          "DEL"        'magit-diff-show-or-scroll-down
          "+"          'magit-diff-more-context
          "-"          'magit-diff-less-context
          "0"          'magit-diff-default-context
          ;; Use the default Hel motion commands instead of `magit-next-line'
          ;; and `magit-previous-line', because they are surprisingly slow and
          ;; make little sense, since we have toggle selection on "v".
          "j"   'next-line
          "k"   'previous-line
          "g g" 'beginning-of-buffer
          "G"   'end-of-buffer
          ;;
          "a"   'magit-cherry-apply
          "A"   'magit-cherry-pick
          "b"   'magit-branch
          "B"   'magit-bisect
          "c"   'magit-commit
          "C"   'magit-clone
          "d"   'magit-delete-thing
          "D"   'magit-file-untrack
          "e"   'magit-ediff-dwim
          "E"   'magit-ediff
          "f"   'magit-fetch
          "F"   'magit-pull
          "g r" 'magit-refresh-all
          "h"   'magit-dispatch
          "H"   'magit-describe-section
          ;; "i"   'helheim-magit-text-mode
          "i"   'magit-gitignore
          "I"   'magit-init
          "l"   'magit-log
          "L"   'magit-log-refresh
          "m"   'magit-merge
          "M"   'magit-remote
          "n"   'magit-show-refs
          "N"   'magit-cherry
          "o"   'magit-submodule
          "O"   'magit-subtree
          "p"   'magit-push
          "q"   'magit-mode-bury-buffer
          "Q"   'magit-git-command
          "r"   'magit-rebase
          "R"   'magit-file-rename
          "s"   'magit-stage-files
          "S"   'magit-stage-modified
          "t"   'magit-tag
          "T"   'magit-notes
          "u"   'magit-unstage-files
          "U"   'magit-unstage-all
          "v"   'helheim-magit-toggle-selection
          "w"   'magit-am
          "W"   'magit-patch
          "x"   'magit-reset-quickly
          "X"   'magit-reset
          "y"   'magit-copy-section-value
          "Y"   'magit-copy-buffer-revision
          "Z"   'magit-stash
          "!"   'magit-run
          ">"   'magit-sparse-checkout
          "|"   'magit-git-command
          "?"   'magit-dispatch
          "$"   'magit-process-buffer
          "%"   'magit-worktree
          "/"   'magit-status-quick
          "C-c C-c" 'magit-dispatch
          "C-c SPC" 'magit-dispatch ;; <leader><leader>
          "C-c C-r" 'magit-next-reference
          "C-c C-e" 'magit-edit-thing
          "C-c C-o" 'magit-browse-thing
          "C-c C-w" 'magit-copy-thing
          ", ," 'magit-display-repository-buffer ;; counterpart to "SPC ,"
          ", ?" 'magit-describe-section
          ", d" 'magit-diff
          ", D" 'magit-diff-refresh
          ", e" 'magit-edit-thing
          ", o" 'magit-browse-thing
          ", x" 'magit-revert-no-commit
          ", X" 'magit-revert
          ", y" 'magit-copy-thing ;; it seams it does nothing currently
          ", z" 'magit-worktree
          ", n" 'magit-next-reference
          ", p" 'magit-previous-reference
          ", N" 'magit-previous-reference
          "<remap> <mouse-set-point>"     'magit-mouse-set-point
          "<remap> <back-to-indentation>" 'magit-back-to-indentation)))

;; Repeat keymap
(with-eval-after-load 'magit-log
  (setq magit-reference-navigation-repeat-map
        (define-keymap
          "p" 'magit-previous-reference
          "N" 'magit-previous-reference
          "n" 'magit-next-reference)))

;;;; Magit status buffer

(with-eval-after-load 'magit-status
  (setq magit-status-mode-map
        (define-keymap
          :parent magit-mode-map
          "<remap> <dired-jump>" 'magit-dired-jump
          "/"   'magit-status-jump
          "g z" 'magit-jump-to-stashes
          "g t" 'magit-jump-to-tracked
          "g n" 'magit-jump-to-untracked
          "g s" 'magit-jump-to-staged
          "g u" 'magit-jump-to-unstaged
          "g f" 'magit-jump-to-unpulled-from-upstream
          "g F" 'magit-jump-to-unpulled-from-pushremote
          "g p" 'magit-jump-to-unpushed-to-upstream
          "g P" 'magit-jump-to-unpushed-to-pushremote)))

;;;; Magit diff

(with-eval-after-load 'magit-diff
  (setq magit-diff-mode-map
        (define-keymap
          :parent magit-mode-map
          "C-c C-d" 'magit-diff-while-committing
          "C-c C-b" 'magit-go-backward
          "C-c C-f" 'magit-go-forward
          "C-o"     'magit-go-backward
          "C-i"     'magit-go-forward
          "g d"     'magit-jump-to-diffstat-or-diff ;; "j"
          "<remap> <write-file>" 'magit-patch-save))

  (hel-keymap-set magit-diff-section-map
    ", t" 'magit-diff-trace-definition
    ", e" 'magit-diff-edit-hunk-commit
    "C-j" nil)) ;; unbind `magit-diff-visit-worktree-file'

(with-eval-after-load 'magit
  (hel-keymap-set magit-log-mode-map
    "z j" 'magit-go-backward
    "z k" 'magit-go-forward
    "/"   'magit-log-move-to-revision
    "j"    nil) ;; unbind `magit-log-move-to-revision'

  (hel-keymap-set magit-blob-mode-map
    "z j" 'magit-blob-next      ;; "n"
    "z k" 'magit-blob-previous) ;; "p"

  (hel-keymap-set git-commit-mode-map :state 'normal
    "g k" 'git-commit-prev-message ;; "M-p"
    "g j" 'git-commit-next-message ;; "M-n"
    "z k" 'git-commit-prev-message
    "z j" 'git-commit-next-message)

  (hel-keymap-set magit-revision-mode-map
    "j" nil ;; unbind `magit-revision-jump'
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
  (add-hook 'magit-blame-mode-hook (defun helheim-magit-blame-h ()
                                     (if magit-blame-mode
                                         (hel-motion-state)
                                       (hel-normal-state))))
  (hel-keymap-set magit-blame-read-only-mode-map
    "y"   'magit-blame-copy-hash
    "j"   'magit-blame-next-chunk
    "k"   'magit-blame-previous-chunk
    "C-j" 'magit-blame-next-chunk-same-commit
    "C-k" 'magit-blame-previous-chunk-same-commit
    "RET" 'magit-diff-show-or-scroll-up))

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
          "i"   'undefined
          "v"   'helheim-git-rebase-toggle-selection
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

(defun helheim-git-rebase-toggle-selection ()
  "Toggle selection."
  (interactive)
  (if (use-region-p)
      (deactivate-mark)
    (set-mark-command nil)))

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
    (cl-flet ((key (str)
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

;;;; Commands

(defun helheim-magit-toggle-selection ()
  (interactive)
  (if (use-region-p)
      (deactivate-mark)
    (push-mark-command t)))

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
        (setq-local helheim-magit--previous-magit-mode major-mode)
        (text-mode))
    ;; else
    (funcall helheim-magit--previous-magit-mode)
    (setq-local helheim-magit--previous-magit-mode nil)
    (magit-refresh))
  (hel-switch-to-initial-state))

;;; Config

(use-package magit
  :ensure t
  :defer t
  :custom
  (magit-refresh-verbose debug-on-error)
  (magit-diff-refine-hunk t) ;; show granular diffs in selected hunk
  ;; (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-bury-buffer-function #'magit-restore-window-configuration)
  :config
  (magit-auto-revert-mode)
  ;;
  ;; Turn ref links into clickable buttons.
  (add-hook 'magit-process-mode-hook #'goto-address-mode)
  ;;
  ;; The mode-line isn't useful in these popups and take up valuable screen
  ;; estate, so free it up.
  (add-hook 'magit-popup-mode-hook #'hide-mode-line-mode))

;; project.el integration: Replace VC-dir with Magit
(with-eval-after-load 'project
  (hel-keymap-set project-prefix-map
    "v" 'helheim-project-magit)
  ;; In `project-switch-project' dispatch replace VC-Dir with Magit.
  (when-let* ((i (-elem-index '(project-vc-dir "VC-Dir")
                              project-switch-commands)))
    (setcar (nthcdr i project-switch-commands)
            '(helheim-project-magit "Magit"))))

(elpaca git-modes)

;;; .
(provide 'helheim-magit)
;;; helheim-magit.el ends here
