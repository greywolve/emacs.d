(setq auto-mode-alist (cons '("\\.m$" . octave-mode) auto-mode-alist))

 (setq inferior-octave-program
                   "matlab")

(provide 'setup-octave-mode)
