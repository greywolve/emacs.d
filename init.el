;; Directories
;; need to find a smarter way to do this
(defvar emacs-dir (file-name-directory load-file-name)
  "Top level emacs directory")

(defvar vendor-dir (concat emacs-dir "vendor/")
  "Packages not yet avilable in ELPA or built from source")

(defvar evil-dir (concat emacs-dir "vendor/evil/")
  "Evil mode source")

(defvar evil-libs-dir (concat emacs-dir "vendor/evil/lib")
  "Evil mode source")

(defvar evil-leader-dir (concat emacs-dir "vendor/evil-leader/")
  "Evil mode source")

(defvar evil-paredit-dir (concat emacs-dir "vendor/evil-paredit/")
  "Evil mode source")

(defvar cider-dir (concat emacs-dir "vendor/cider/")
  "CIDER mode source")

(defvar module-dir (concat emacs-dir "modules/")
  "The core of my emacs config")

(defvar settings-dir (concat emacs-dir "settings/")
  "The core of my emacs config")

;; Load paths
(add-to-list 'load-path vendor-dir)
(add-to-list 'load-path evil-dir)
(add-to-list 'load-path evil-libs-dir)
(add-to-list 'load-path evil-leader-dir)
(add-to-list 'load-path evil-paredit-dir)
(add-to-list 'load-path cider-dir)
(add-to-list 'load-path module-dir)
(add-to-list 'load-path settings-dir)

(require 'package)

(add-to-list 'package-archives
  '("marmalade" . "http://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives
'("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Packages which should be present
(defvar my-packages '(autopair
                      company
                      dash
											pkg-info
											queue
                      auctex
                      paredit
                      magit
                      flx-ido
                      clojure-mode
                      ido-ubiquitous
                      idle-highlight-mode
                      rainbow-delimiters
                      projectile
                      solarized-theme
                      multiple-cursors
                      js2-mode
                      ack-and-a-half
                      markdown-mode
                      skewer-mode
                      smex
                      hlinum
                      yasnippet
                      popup)
  "A list of packages to ensure are installed at launch.")

;; Install any missing packages
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))



(require 'setup-ui)
(require 'setup-evil)
(require 'setup-projectile)
(require 'setup-autofill)
(require 'setup-bindings)
(require 'setup-clojure)
(require 'setup-dired)
(require 'setup-elisp)
(require 'setup-flx)
(require 'setup-flyspell)
(require 'setup-idle-highlight-mode)
(require 'setup-ido-mode)
(require 'setup-js2mode)
(require 'setup-latex)
(require 'setup-magit)
(require 'setup-multiple-cursors)
(require 'setup-rainbow-delimiters)
(require 'setup-skewer)
(require 'setup-smex)
(require 'setup-whitespace)
(require 'setup-yasnippet)
(require 'setup-company)
(require 'setup-octave-mode)

;; setup markdown-mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook 'outline-minor-mode)

;; Make Clipboard work properly
(setq x-select-enable-clipboard t)

;; Require packages in modules/
(mapc 'load (directory-files module-dir nil "^[^#].*el$"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-default-browser))
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "1f3304214265481c56341bcee387ef1abb684e4efbccebca0e120be7b1a13589" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" default)))
 '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-drill org-learn)))
 '(preview-gs-options (quote ("-q" "-dNOPAUSE" "-DNOPLATFONTS" "-dPrinted" "-dTextAlphaBits=4" "-dGraphicsAlphaBits=4"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Store temporary autosave files / backup files in '/tmp' rather than in the same directory as the file being edited

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
