;;; helheim-tree-sitter.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Code:

(use-package treesit
  :when (treesit-available-p)
  :defer t
  :hook (emacs-startup-hook . helheim-install-missing-treesit-grammars)
  :custom
  (treesit-font-lock-level 4)
  :preface
  (setq treesit-language-source-alist
        '((bash "https://github.com/tree-sitter/tree-sitter-bash"
                "v0.23.3")
          ;; (bibtex "https://github.com/latex-lsp/tree-sitter-bibtex")
          (c "https://github.com/tree-sitter/tree-sitter-c"
             "v0.21.3")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (cmake "https://github.com/uyha/tree-sitter-cmake")
          (c-sharp "https://github.com/tree-sitter/tree-sitter-c-sharp"
                   "v0.23.1")
          (css "https://github.com/tree-sitter/tree-sitter-css"
               "v0.23.2")
          (commonlisp "https://github.com/tree-sitter-grammars/tree-sitter-commonlisp"
                      "v0.4.1")
          (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
          (elixir "https://github.com/elixir-lang/tree-sitter-elixir")
          (go "https://github.com/tree-sitter/tree-sitter-go"
              "v0.23.4")
          (gomod "https://github.com/camdencheek/tree-sitter-go-mod"
                 "v1.0.2")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (java "https://github.com/tree-sitter/tree-sitter-java")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript"
                      "v0.23.1")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (latex "https://github.com/latex-lsp/tree-sitter-latex"
                 "v0.3.0")
          (lua "https://github.com/tree-sitter-grammars/tree-sitter-lua"
               "v0.3.0")
          (make "https://github.com/tree-sitter-grammars/tree-sitter-make")
          (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
                    "v0.3.2" "tree-sitter-markdown/src")
          (nix "https://github.com/nix-community/tree-sitter-nix")
          ;; (nu "https://github.com/nushell/tree-sitter-nu")
          (perl "https://github.com/ganezdragon/tree-sitter-perl")
          (python "https://github.com/tree-sitter/tree-sitter-python"
                  "v0.23.6")
          (r "https://github.com/r-lib/tree-sitter-r")
          (ruby "https://github.com/tree-sitter/tree-sitter-ruby")
          (rust "https://github.com/tree-sitter/tree-sitter-rust"
                "v0.23.3")
          (sql "https://github.com/DerekStride/tree-sitter-sql"
               "gh-pages")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript"
                      "v0.23.2" "typescript/src")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript"
               "v0.23.2" "tsx/src")
          (toml "https://github.com/tree-sitter-grammars/tree-sitter-toml")
          (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
          (zig "https://github.com/tree-sitter-grammars/tree-sitter-zig"
               "v1.1.2")))
  :mode
  ;; Emacs provides this setting in yaml-ts-mode.el, but it only works after
  ;; the package is loaded, defeating autoloading. So, we duplicate it here.
  ("\\.ya?ml\\'" . yaml-ts-mode)
  ("clang.format\\'" . yaml-ts-mode))

(defun helheim-install-missing-treesit-grammars ()
  "Install all missing tree-sitter grammars."
  (interactive)
  (cl-loop for (lang . _) in treesit-language-source-alist
           unless (treesit-language-available-p lang)
           do (treesit-install-language-grammar lang)))

;;; .
(provide 'helheim-tree-sitter)
;;; helheim-tree-sitter.el ends here
