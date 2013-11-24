(add-hook 'markdown-mode-hook 'turn-on-flyspell)
(add-hook 'org-mode-hook 'turn-on-flyspell)

(defun turn-on-flyspell ()
  "Force flyspell-mode on using a positive arg.  For use in hooks."
  (interactive)
  (flyspell-mode 1))
