;; This is primarily for developing Clojurescript with Figwheel see
;; https://github.com/bhauman/lein-figwheel/wiki/Running-figwheel-with-Emacs-Inferior-Clojure-Interaction-Mode

(require 'clojure-mode)
(require 'inf-clojure)

(defun set-inf-clojure-mode-when-cljs-file ()
  (when (and (stringp buffer-file-name)
           (string-match "\\.cljs\\'" buffer-file-name))
      (inf-clojure-minor-mode)))

(add-hook 'clojure-mode-hook 'set-inf-clojure-mode-when-cljs-file)

(defun figwheel-repl ()
  (interactive)
  (run-clojure "lein figwheel"))

(provide 'setup-inf-clojure)
