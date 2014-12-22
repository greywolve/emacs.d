(setq org-mode-hook
      '(lambda nil
	 (setq fill-column 80)
	 (auto-fill-mode 1)))

(provide 'setup-autofill)
