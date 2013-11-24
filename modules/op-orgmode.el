(setq org-log-done 'time)
(setq org-agenda-files (list "~/org/tasks.org"
														 "~/org/events.org"))
(setq org-default-notes-file "~/org/notes.org")
     (define-key global-map "\C-cc" 'org-capture)

(setq org-hide-leading-stars t)
(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode t))
          t)
;;(add-hook 'after-init-hook 'org-agenda-list)

(defun org-tag-match-context (&optional todo-only match)
  "Identical search to `org-match-sparse-tree', but shows the content of the matches."
  (interactive "P")
  (org-prepare-agenda-buffers (list (current-buffer)))
  (org-overview) 
  (org-remove-occur-highlights) 
  (org-scan-tags '(progn (org-show-entry) 
                         (org-show-context)) 
                 (cdr (org-make-tags-matcher match)) todo-only))

