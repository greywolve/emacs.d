(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(yas-global-mode 1)

(setq yas-prompt-functions '(yas/ido-prompt yas/completing-prompt))
