;; highlights part of line greater than 100 chars
(require 'whitespace)
(setq whitespace-line-column 100)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

(setq-default indent-tabs-mode nil)
