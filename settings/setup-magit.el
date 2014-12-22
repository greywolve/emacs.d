;; cosmetics for diff output
(eval-after-load 'magit
  '(progn
     (set-face-foreground 'magit-diff-add "green4")
     (set-face-foreground 'magit-diff-del "red3")))

;; start magit in its own buffer rather
;;(setq magit-status-buffer-switch-function 'switch-to-buffer)

(provide 'setup-magit)
