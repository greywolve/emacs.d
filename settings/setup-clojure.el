(setq auto-mode-alist (cons '("\\.edn$" . clojure-mode) auto-mode-alist))  ; *.edn are Clojure files

(setq auto-mode-alist (cons '("\\.cljs$" . clojure-mode) auto-mode-alist)) ; *.cljs are Clojure files

(add-hook 'temp-buffer-show-hook 'clojure-mode)

(setq initial-major-mode 'clojure-mode)

;;(add-hook 'clojure-mode-hook 'cider-mode)                                ; Use paredit in clojure buffers

;; CIDER customizations
;; don't pop up a repl buffer on connect
(setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-popup-stacktraces t)                                      ; Don't aggresively popup stacktraces
(setq cider-repl-popup-stacktraces nil)
;; switching to CIDER buffer does so in the current window
(setq cider-repl-display-in-current-window t)
;;(setq nrepl-popup-stacktraces-in-repl t)

(defun turn-on-paredit ()
(message "sup")
  (paredit-mode 1))

(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)         ; Enable eldoc - shows fn argument list in echo area
(add-hook 'cider-repl-mode-hook 'turn-on-paredit)                                  ; Use paredit in *nrepl* buffer
(add-hook 'clojure-mode-hook 'turn-on-paredit)                                ; Use paredit in clojure buffers

(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

(add-hook 'clojure-mode-hook 'esk-pretty-fn)
(add-hook 'clojurescript-mode-hook 'esk-pretty-fn)

(add-hook 'cider-popup-buffer-mode-hook 'clojure-mode)         ; Enable eldoc - shows fn argument list in echo area

(defun esk-pretty-fn ()
    (font-lock-add-keywords nil `(("(\\(\\<fn\\>\\)"
                                   (0 (progn (compose-region (match-beginning 1)
                                                             (match-end 1)
                                                             "\u0192"
                                                             'decompose-region)))))))

(provide 'setup-clojure)
