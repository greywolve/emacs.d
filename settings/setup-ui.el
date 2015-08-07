(load-theme 'solarized-dark t)
(set-face-attribute 'mode-line nil :box nil)
(set-face-attribute 'mode-line-inactive nil :box nil)
;; font
(if (eq system-type 'darwin)
    (set-face-attribute 'default nil :height 110 :family "Monaco")
    (set-face-attribute 'default nil :height 110 :family "Monaco"))

(global-visual-line-mode t)

;;(set-cursor-color "#000")
;;hack to get cursor color set when using the solarized theme
(add-hook 'window-setup-hook '(lambda () (set-cursor-color "#fffacd")))
(add-hook 'after-make-frame-functions '(lambda (f) (with-selected-frame f (set-cursor-color "#fffacd"))))

(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))

(global-set-key [f11] 'toggle-fullscreen)

;; Remove uncessary UI elements
(scroll-bar-mode -1)
(tool-bar-mode -1)
(fringe-mode -1)
(setq inhibit-startup-screen t)
(menu-bar-mode -1)

;; scratch starts empty
(setq initial-scratch-message nil)

;; Modeline
(setq-default tab-width 2)
(global-linum-mode t)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;;behavior
(fset 'yes-or-no-p 'y-or-n-p)

;; linum-mode style
(setq linum-format "%d ")

;;hl-line
;;(global-hl-line-mode)

;;misc emacs starter kit settings
(setq visible-bell t
      inhibit-startup-message t
      color-theme-is-global t
      sentence-end-double-space nil
      shift-select-mode nil
      mouse-yank-at-point t
      uniquify-buffer-name-style 'forward
      whitespace-style '(face trailing lines-tail tabs)
      whitespace-line-column 80
      ediff-window-setup-function 'ediff-setup-windows-plain
      oddmuse-directory (concat user-emacs-directory "oddmuse")
      save-place-file (concat user-emacs-directory "places")
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      diff-switches "-u")

;; highlight matching parens
(show-paren-mode 1)
(require 'paren)
;; customize colors for above
(set-face-background 'show-paren-match-face "#ff0000")
(set-face-foreground 'show-paren-match-face (face-background 'default))
(set-face-attribute 'show-paren-match-face nil :weight 'extra-bold)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (mouse-wheel-mode t)
  (blink-cursor-mode -1))


;;Cursor


(blink-cursor-mode 1)

(defun cursor-color-set ()
  (interactive)
  (set-cursor-color "#fffacd"))

;; center windows, taken from the center-window-mode package

;; Prevent popup windows from vertically splitting (conflicts with center window mode)
(setq split-width-threshold 9999)

(defun center-window ()
  (set-fringe-mode
   (/ (- (frame-pixel-width)
         (* 110 (frame-char-width)))
      2)))

(defun center-window-reset ()
  (set-fringe-mode nil))

(setq window-centered 1)

(defun center-window-toggle ()
  "Toggle window centered"
  (interactive)
  (if (= window-centered 1)
      (center-window-reset)
      (center-window))
  (setq window-centered (if (= window-centered 1) 0 1)))

(center-window)


(provide 'setup-ui)
