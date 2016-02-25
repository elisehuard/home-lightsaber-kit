;;; init --- A home light saber kit

;; Copyright (C) 2016 Mastodon C Ltd

;;; Commentary:

;; Everything will be configured using packages from melpa or
;; elsewhere.  This is a minimal setup to get packages going.

;;; Code:

(require 'package)
(setq package-archives '(("elpa" . "http://elpa.gnu.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

(setq package-pinned-packages
      '((aggressive-indent . "melpa-stable")
        (bind-key . "melpa-stable")
        (cider . "melpa-stable")
        ;; (dash . "melpa-stable")
        (diminish . "melpa-stable")
        (epl . "melpa-stable")
        (flycheck-pos-tip . "melpa-stable")
        (flycheck . "melpa-stable")
        (highlight-symbol . "melpa-stable")
        (magit . "melpa-stable")
        (paredit . "melpa-stable")
        (pkg-info . "melpa-stable")
        (pos-tip . "melpa-stable")
        (rainbow-delimiters . "melpa-stable")
        (seq . "elpa")
        (use-package . "melpa-stable")))

;; This means we prefer things from ~/.emacs.d/elpa over the standard
;; packages.
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(defvar use-package-verbose t)
(require 'bind-key)
(require 'diminish)

;; Remember: :config only gets called when the *package* is loaded and
;; some modes are defined in packages with different names.
;; (use-package lisp-mode
;;   :config
;;   (progn
;;     (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'highlight-symbol-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'show-paren-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'paredit-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; minor modes
(defvar lisp-mode-hooks '(emacs-lisp-mode-hook lisp-mode-hook))
(defvar lisp-interaction-mode-hooks '(lisp-interaction-modes-hook))

(use-package aggressive-indent
  :ensure t
  :diminish aggressive-indent-mode
  :init (dolist (hook lisp-mode-hooks)
          (add-hook hook #'aggressive-indent-mode)))

(use-package eldoc
  :diminish eldoc-mode
  :init (dolist (hook (append lisp-mode-hooks lisp-interaction-mode-hook))
          (add-hook hook #'eldoc-mode)))

(use-package paredit
  :ensure t
  :diminish paredit-mode
  :init (dolist (hook lisp-mode-hooks)
          (add-hook hook #'paredit-mode)))

(use-package flycheck-pos-tip
  :ensure t
  :config
  (eval-after-load 'flycheck
    '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package highlight-symbol
  :ensure t
  :bind (("C-c n" . highlight-symbol-next)
         ("C-c p" . highlight-symbol-previous))
  :init (add-hook 'prog-mode-hook #'highlight-symbol-mode))

(use-package rainbow-delimiters
  :ensure t
  :init (dolist (hook (append lisp-mode-hooks lisp-interaction-mode-hook))
          (add-hook hook #'rainbow-delimiters-mode)))

(use-package paren
  :init (dolist (hook (append lisp-mode-hooks lisp-interaction-mode-hook))
          (add-hook hook #'show-paren-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; major modes

(use-package magit
  :ensure t
  :bind (("C-c g" . magit-status)))

(use-package ediff
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain))

;; (use-package cider
;;   :ensure t
;;   :defer t
;;   :diminish subword-mode
;;   :config
;;   (add-hook 'cider-mode-hook #'highlight-symbol-mode)
;;   (add-hook 'cider-mode-hook #'clj-refactor-mode)
;;   (add-hook 'cider-mode-hook #'rainbow-delimiters-mode)
;;   (add-hook 'cider-mode-hook #'show-paren-mode)
;;   (add-hook 'cider-mode-hook #'paredit-mode)
;;   (add-hook 'cider-mode-hook #'eldoc-mode)
;;   (add-hook 'cider-mode-hook #'aggressive-indent-mode)
;;   (setq cider-repl-history-file (concat user-emacs-directory "cider-history")
;; 	cider-font-lock-dynamically '(macro core function var)
;; 	cider-repl-use-clojure-font-lock t
;; 	cider-overlays-use-font-lock t
;; 	cider-repl-result-prefix ";; => "
;; 	cider-interactive-eval-result-prefix ";; => ")
;;   (cider-repl-toggle-pretty-printing))

;; (use-package smex
;;   :ensure t
;;   :pin melpa-stable
;;   :bind (("M-x" . smex))
;;   :config (smex-initialize))  ; smart meta-x (use IDO in minibuffer)

;; (use-package ido
;;   :ensure t
;;   :demand t
;;   :pin melpa-stable
;;   :bind (("C-x b" . ido-switch-buffer))
;;   :config (ido-mode 1)
;;   (setq ido-create-new-buffer 'always  ; don't confirm when creating new buffers
;;         ido-enable-flex-matching t     ; fuzzy matching
;;         ido-everywhere t  ; tbd
;;         ido-case-fold t)) ; ignore case

;; (use-package ido-ubiquitous
;;   :ensure t
;;   :pin melpa-stable
;;   :config (ido-ubiquitous-mode 1))

;; (use-package flx-ido
;;   :ensure t
;;   :pin melpa-stable
;;   :config (flx-ido-mode 1))

;; (use-package ido-vertical-mode
;;   :ensure t
;;   :pin melpa-stable
;;   :config (ido-vertical-mode 1))

;; (use-package projectile
;;   :ensure t
;;   :pin melpa-stable
;;   :diminish projectile-mode
;;   :config
;;   (setq projectile-enable-caching t)
;;   (projectile-global-mode 1))

;; (use-package company
;;   :ensure t
;;   :pin melpa-stable
;;   :diminish company-mode
;;   :config
;;   (global-company-mode))

;; (use-package paredit
;;   :ensure t
;;   :pin melpa-stable
;;   :defer t
;;   :diminish paredit-mode)

;; (use-package rainbow-delimiters
;;   :ensure t
;;   :pin melpa-stable
;;   :defer t)

;; (use-package clojure-mode
;;   :ensure t
;;   :pin melpa-stable
;;   :mode (("\\.clj\\'" . clojure-mode)
;; 	 ("\\.edn\\'" . clojure-mode))
;;   :config
;;   (add-hook 'clojure-mode-hook #'eldoc-mode)
;;   (add-hook 'clojure-mode-hook #'show-paren-mode)
;;   (add-hook 'clojure-mode-hook #'paredit-mode)
;;   (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

;; (use-package cider-eval-sexp-fu
;;   :ensure t
;;   :pin melpa-stable
;;   :defer t)

;; (use-package clj-refactor
;;   :ensure t
;;   :pin melpa-stable
;;   :defer t)

;; (use-package flycheck-clojure
;;   :ensure t
;;   :pin melpa
;;   :defer t
;;   :config
;;   (eval-after-load 'flycheck '(flycheck-clojure-setup)))

;; (use-package swiper
;;   :ensure t
;;   :pin melpa-stable
;;   :bind (("\C-s" . swiper)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display Tweaking
(load-theme 'wheatgrass)

;; no toolbar
(tool-bar-mode -1)

;; no scroll bar
(scroll-bar-mode -1)

;; no horizontal scroll bar
(when (boundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

;; show line and column numbers
(line-number-mode 1)
(column-number-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other useful defaults

(global-set-key (kbd "C-;") 'comment-dwim)

;; keep autobackups under control
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups

;; put custom stuff in a different file
(setq custom-file (concat user-emacs-directory "custom.el"))

;; uniquify buffers with the same file name but different actual files
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

;; Delete that horrible trailing whitespace
(add-hook 'before-save-hook
          (lambda nil
            (delete-trailing-whitespace)))

;; downcase, upcase and narrow-to-region
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; tab indentation (outside of makefiles) is evil
(setq-default indent-tabs-mode nil)

;; human readable dired
(setq dired-listing-switches "-alh")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Platform specific stuff

;; No # on UK Macs
(when (memq window-system '(mac ns))
  (global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#"))))

;; Handle unicode better
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; get the path from shell
;; (use-package exec-path-from-shell
;;   :ensure t
;;   :defer t
;;   :pin melpa-stable
;;   :config (exec-path-from-shell-initialize))

;; fix yer speling
(when (memq window-system '(mac ns))
  (setq ispell-program-name (executable-find "aspell")))

;; Handle unicode better
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;;; init.el ends here
