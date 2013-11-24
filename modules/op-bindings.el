;; stop nagging when i try open a big file
(setq large-file-warning-threshold nil)

;; for navigating meta-x menu and non-evil modes
(define-key key-translation-map (kbd "C-j") [down])

(define-key key-translation-map (kbd "C-k") [up])

(global-set-key [C-tab] 'other-window)

;; open org-mode agenda
(global-set-key (kbd "<f1>") 'org-agenda-list)

;; key to open stuff i learned today
(global-set-key (kbd "<f3>") 'open-things-i-learned-today-file)

(defun open-things-i-learned-today-file ()
 (interactive)
 (find-file "~/org/things-i-learned-today.org"))

;; so i can instantly add bindings easily
(global-set-key (kbd "<f4>") 'open-emacs-bindings-file)

(defun open-emacs-bindings-file ()
	(interactive)
	(find-file "~/.emacs.d/modules/op-bindings.el"))

 (defun kill-all-dired-buffers()
      "Kill all dired buffers."
      (interactive)
      (save-excursion
        (let((count 0))
          (dolist(buffer (buffer-list))
            (set-buffer buffer)
            (when (equal major-mode 'dired-mode)
              (setq count (1+ count))
              (kill-buffer buffer)))
          (message "Killed %i dired buffer(s)." count ))))

(global-set-key (kbd "<f7>") 'open-dired-default-directory)

(global-set-key (kbd "<f8>") 'kill-all-dired-buffers)

(global-set-key (kbd "<f5>") 'magit-status)
;; switch branches
(global-set-key (kbd "<f6>") 'magit-checkout)

(global-set-key (kbd "<M-ESC>") 'delete-other-windows)

(global-set-key (kbd "C-,") 'switch-to-previous-buffer)

(defun switch-to-previous-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) nil)))

(defun op-open-dired-in-split-view ()
	(interactive)
	(delete-other-windows)
	(call-interactively 'dired)
	(split-window-vertically))

 (defun close-and-kill-next-pane ()
      "Close the other pane and kill the buffer in it also."
      (interactive)
      (other-window 1)
      (close-current-buffer)
      (delete-window))

(defun close-and-kill-this-pane ()
	"Close this pane and kill the buffer in it also."
	(interactive)
	(close-current-buffer)
	(delete-window))

(defun open-dired-default-directory ()
	(interactive)
	(dired default-directory))
