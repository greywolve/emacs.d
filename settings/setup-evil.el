(defun cider-start-and-split-window-repl-right ()
  (interactive)
  (call-interactively 'cider)
  (sleep-for 2)
  (split-window-horizontally-70-percent-left)
  (other-window 1)
  (switch-to-buffer (cider-find-or-create-repl-buffer))
  (other-window 1))

(require 'evil)
(require 'evil-paredit)
(require 'evil-leader)
(require 'dash)

(add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode)
(add-hook 'clojure-mode-hook 'evil-paredit-mode)

;; indents
(setq evil-auto-indent t)

(add-hook 'python-mode-hook
  (function (lambda ()
          (setq evil-shift-width python-indent))))
(add-hook 'ruby-mode-hook
  (function (lambda ()
          (setq evil-shift-width ruby-indent-level))))

(add-hook 'html-mode-hook
  (function (lambda ()
          (setq evil-shift-width 2))))
(add-hook 'java-mode-hook
  (function (lambda ()
          (setq evil-shift-width 2))))


(setq evil-leader/in-all-states t)
(evil-leader/set-leader ",")
(evil-mode nil)
(global-evil-leader-mode 1)
(evil-mode 1)

(evil-leader/set-key
  "," 'switch-to-previous-buffer
	"h" 'projectile-switch-to-buffer
  "p"  )

(defun clj-jump-to-tag ()
  (interactive)
  (find-tag (first (last (split-string (thing-at-point 'symbol) "/")))))

(evil-leader/set-key-for-mode 'clojure-mode
  "j" 'cider-start-and-split-window-repl-bottom
  "p" 'cider-pprint-eval-last-sexp
  "y" 'cider-eval-expression-at-point-and-paste-into-buffer
  "e" 'cider-eval-buffer
  "r" 'refresh-browser
  "s" 'paredit-forward-slurp-sexp
  "h" 'paredit-forward-barf-sexp
	"n" 'paredit-split-sexp
	"t" 'clj-jump-to-tag
  "c" 'paredit-reindent-defun)

(evil-leader/set-key-for-mode 'emacs-lisp-mode
	"e" 'eval-buffer
  "s" 'paredit-forward-slurp-sexp
  "h" 'paredit-forward-barf-sexp
	"n" 'paredit-split-sexp
	"t" 'paredit-join-sexps
  "c" 'paredit-reindent-defun)

(evil-leader/set-key-for-mode 'js2-mode
	"e" 'skewer-eval-last-expression
  "l" 'skewer-refresh-browser-then-load-buffer)

(defun evil-paste-from-zero-register ()
  (interactive)
  (evil-paste-after 1 ?0))

(defun evil-yank-to-zero-register ()
  (interactive)
  (evil-yank 1 ?0))

(defun projectile-grep-cljs ()
  "Perform rgrep in the project."
  (interactive)
  (let ((roots (projectile-get-project-directories))
        (search-regexp (if (and transient-mark-mode mark-active)
                           (buffer-substring (region-beginning) (region-end))
                         (read-string (projectile-prepend-project-name "Grep for: ")
                                      (projectile-symbol-at-point)))))
    (dolist (root-dir roots)
      (require 'grep)
      ;; in git projects users have the option to use `vc-git-grep' instead of `rgrep'
      (if (and (eq (projectile-project-vcs) 'git) projectile-use-git-grep)
          (vc-git-grep search-regexp "'*'" root-dir)
        ;; paths for find-grep should relative and without trailing /
        (let ((grep-find-ignored-directories (-union (-map (lambda (dir) (s-chop-suffix "/" (file-relative-name dir root-dir)))
                                                           (cdr (projectile-ignored-directories))) grep-find-ignored-directories))
              (grep-find-ignored-files (-union (-map (lambda (file) (file-relative-name file root-dir)) (projectile-ignored-files)) grep-find-ignored-files)))
          (grep-compute-defaults)
          (rgrep search-regexp "* .*" root-dir))))))

(defun cider-reset ()
  (interactive)
  (set-buffer "*cider*")
  (goto-char (point-max))
  (insert "(user/reset)")
  (cider-repl-return))

(defun refresh-browser ()
 (interactive)
 (shell-command "refresh-chrome"))

(defun skewer-refresh-browser-then-load-buffer ()
 (interactive)
 (shell-command "refresh-chrome")
 (sleep-for 1)
 (skewer-load-buffer))

(defun cider-eval-expression-at-point-and-paste-into-buffer ()
	(interactive)
	(setq current-prefix-arg '(4))
	(call-interactively 'cider-eval-last-expression))

(evil-leader/set-key-for-mode 'emacs-lisp-mode
	"e" 'eval-buffer
	"p" 'eval-expression-at-end-of-line)

(evil-leader/set-key-for-mode 'js2-mode
  "n" 'nodejs-send-region)

(evil-leader/set-key-for-mode 'html-mode
  "r" 'save-and-refresh-chrome)

(evil-leader/set-key-for-mode 'css-mode
  "r" 'save-and-refresh-chrome)

(defun eval-expression-at-end-of-line (arg)
   (interactive "P")
   (move-end-of-line 1)
   (eval-last-sexp arg)
   )

;;other-buffer's last arg is visible-ok, this must be nil in order for
;;it to not include buffers which are visible in a window in the
;;current frame
(defun switch-to-previous-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) nil)))


(define-key evil-normal-state-map (kbd "C-p") 'projectile-find-file)
(define-key evil-normal-state-map (kbd "C-d") 'smex)

(setq cider-popup-stacktraces nil)
(setq cider-popup-stacktraces-in-repl nil)

(defun window-resize-to-70-percent ()
  (interactive)
  (window-resize nil (- (truncate (* 0.7 (frame-width))) (window-width)) t))

(defun other-window-and-expand ()
  (interactive)
  (other-window 1)
  (window-resize-to-70-percent)
  )

(defun nodejs-send-region (start end)
  "Send the current region to the inferior Javascript process."
  (interactive "r")
  (comint-send-region (get-buffer-process "*nodejs*") start end)
  (comint-send-string (get-buffer-process "*nodejs*") "\n"))

;;for stuart sierra style workflow in clojure, resets the system to a clean working state, assumes you have a reset function in your user.clj
(defun cider-reset ()
  (interactive)
  (set-buffer "*cider*")
  (goto-char (point-max))
  (insert "(user/reset)")
  (cider-repl-return))


(defun create-clj-tags (dir-name)
 "Create tags file."
 (interactive "Directory: ")
 (shell-command
  (format "%s -f %s/TAGS -e -R %s" "ctags" dir-name (directory-file-name dir-name)))
 )



(defun jump-to-tag-from-selected-region (start end)
  (interactive "r")
  (find-tag (buffer-substring-no-properties start end)))


(evil-define-motion evil-jump-to-tag-visual (arg)
  "Jump to tag under point.
If called with a prefix argument, provide a prompt
for specifying the tag."
  :jump t
  (interactive "P")
  (if arg
      (call-interactively #'find-tag)
    (find-tag (buffer-substring-no-properties (region-beginning) (region-end)))
    ))

(define-key evil-visual-state-map "\C-]" 'evil-jump-to-tag-visual)

(defun switch-and-pause (x y)
  (switch-to-buffer "*scratch*")
  (read-from-minibuffer "Press any key to return: ")
  (switch-to-previous-buffer))

(defun cider-eval-form-and-display-in-popup-with-pause ()
  (interactive)
  (cider-pprint-eval-last-sexp)
  (read-from-minibuffer "Press any key to return: ")
  (delete-other-windows))


(defun cider-eval-expression-at-point-in-repl ()
  (interactive)
  (let ((form (cider-last-sexp)))
    ;; Strip excess whitespace
    (call-interactively 'cider-find-and-clear-repl-buffer)
    (cider-interactive-eval-to-repl form)
    (sleep-for 0.1)
    (set-buffer (cider-find-or-create-repl-buffer))
    (goto-char (point-max))
    (cider-repl-return)))



(defun cider-eval-expression-at-point-in-repl-old ()
  (interactive)
  (let ((form (cider-last-sexp)))
    ;; Strip excess whitespace
    (while (string-match "\\`\s+\\|\n+\\'" form)
      (setq form (replace-match "" t t form)))
    (cider-interactive-eval )
    (set-buffer (cider-find-or-create-repl-buffer))
    (goto-char (point-max))
    (insert form)
    (cider-repl-return)))
;; make it possible to change cursor color
(setq evil-default-cursor t)

;; easy access to ex mode
(define-key evil-normal-state-map ";" 'evil-ex)


;; alternative escapes since i've now bound capslock to ctrl
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

;;; esc quits
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

;; save and refresh chrome
(defun save-and-refresh-chrome ()
  (interactive)
	(save-buffer)
  ;; use if working remotely so shell code gets executed locally (switch-to-buffer "*scratch*")
  (shell-command "~/bin/refresh-chrome")
  ;;(switch-to-buffer (other-buffer (current-buffer) 1))
	)

(setq path-to-ctags "/usr/bin/ctags") ;; <- your ctags path here

(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory ")
		(message
		 (shell-command-to-string		(format "find . -iname '*.clj'"))))

(defun split-window-vertically-70-percent-top ()
  (interactive)
  (delete-other-windows)
  (split-window-vertically (floor (* 0.68 (window-height)))))


(defun split-window-horizontally-70-percent-left ()
  (interactive)
  (delete-other-windows)
  (split-window-horizontally (floor (* 0.72 (window-width)))))

(defun cider-start-and-split-window-repl-right ()
  (interactive)
  (call-interactively 'cider)
  (sleep-for 2)
  (split-window-horizontally-70-percent-left)
  (other-window 1)
  (switch-to-buffer (cider-find-or-create-repl-buffer))
  (other-window 1))

(defun cider-start-and-split-window-repl-bottom ()
  (interactive)
  (call-interactively 'cider)
  (sleep-for 2)
  (split-window-vertically-70-percent-top)
  (other-window 1)
  (switch-to-buffer (cider-find-or-create-repl-buffer))
  (other-window 1))

(define-key evil-insert-state-map "h" #'cofi/maybe-exit)

(evil-define-command cofi/maybe-exit ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "h")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?h))
    (delete-char -1)
    (set-buffer-modified-p modified)
    (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                          (list evt))))))))

(defun cider-run-tests ()
  (interactive)
  (let ((result-buffer (cider-popup-buffer cider-result-buffer nil)))
    (cider-tooling-eval "(clojure.pprint/pprint (run-tests))" 
                        (cider-popup-eval-out-handler result-buffer)
                        (cider-current-ns))))

(provide 'setup-evil)
