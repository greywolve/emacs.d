;; Clojure related 
(setq auto-mode-alist (cons '("\\.edn$" . clojure-mode) auto-mode-alist))  ; *.edn are Clojure files
(setq auto-mode-alist (cons '("\\.cljs$" . clojure-mode) auto-mode-alist)) ; *.cljs are Clojure files


(add-hook 'clojure-mode-hook 'cider-mode)                                ; Use paredit in clojure buffers

;; nREPL customizations
(setq cider-popup-stacktraces nil)                                      ; Don't aggresively popup stacktraces
(setq cider-repl-popup-stacktraces t)
;;(setq nrepl-popup-stacktraces-in-repl t)                               

(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)         ; Enable eldoc - shows fn argument list in echo area
(add-hook 'cider-repl-mode-hook 'paredit-mode)                                  ; Use paredit in *nrepl* buffer
(add-hook 'clojure-mode-hook 'paredit-mode)                                ; Use paredit in clojure buffers

(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

(add-hook 'clojure-mode-hook 'esk-pretty-fn)
(add-hook 'clojurescript-mode-hook 'esk-pretty-fn)


(defun esk-pretty-fn ()
    (font-lock-add-keywords nil `(("(\\(\\<fn\\>\\)"
                                   (0 (progn (compose-region (match-beginning 1)
                                                             (match-end 1)
                                                             "\u0192"
                                                             'decompose-region)))))))
  
