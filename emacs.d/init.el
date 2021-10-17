;; TODO splash screen
;; TODO recent hist, files and projects
;; Perf
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(setq delete-old-versions -1 )
(setq ring-bell-function 'ignore )
(setq coding-system-for-read 'utf-8 )
(setq coding-system-for-write 'utf-8 )
(setq sentence-end-double-space nil)
(setq default-fill-column 100)

(setq initial-scratch-message "This is a scratch buffer m8888")

(setq-default mode-line-format nil)
(global-auto-revert-mode t)
(electric-pair-mode)

;; Package Management
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(use-package mood-line
  :ensure t
  :config (mood-line-mode))
(add-to-list 'default-frame-alist '(font . "IBM Plex Mono-20" ))
(set-face-attribute 'default t :font "IBM Plex Mono-20" )

;;; ehh
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Func
(defun edit-emacs-configuration ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun toggle-buffers ()
  (interactive)
  (switch-to-buffer nil))

;; Editor
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (setq-default evil-escape-delay 0.2))

(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))

(use-package hl-todo
  :ensure t
  :init
  (setq hl-todo-keyward-faces
    '(("TODO"   . "#FF0000")
    ("FIXME"  . "#FF0000")
    ("DEBUG"  . "#A020F0")
    ("GOTCHA" . "#FF4500")
    ("STUB"   . "#1E90FF")))
  :config
  (global-hl-todo-mode))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package corfu
  :init (corfu-global-mode))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles .(partial-completion))))))

(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package emacs
  :ensure t
  :init
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  (setq enable-recursive-minibuffers t)
  (setq completion-cycle-threshold 3)
  (setq tab-always-indent 'complete))


(use-package marginalia
  :ensure t
  :config (marginalia-mode))
(use-package consult
  :ensure t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-file consult--source-project-file consult--source-bookmark
   :preview-key (kbd "M-."))
  (setq consult-narrow-key "<")
)

(use-package evil-nerd-commenter :ensure t)

(use-package projectile
  ;; TODO consult
  :ensure t
  ;;:init
  ;;(setq projectile-completion-system 'ivy)
  :config
  (projectile-mode))

(use-package perspective
  :ensure t
  :config
  (persp-mode))
(use-package persp-projectile
  :ensure t)

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; Term
;; (use-package multi-term
;;   :ensure t
;;   :init
;;   (setq multi-term-program "/bin/bash"))

;; Editing
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-tomorrow-night t))

;; Keybindings
;; (use-package key-chord
;;   :ensure t
;;   :config
;;   (key-chord-mode 1)
;;   ;; (key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
;;   ;; (key-chord-define evil-insert-state-map "gc" 'evilnc-comment-or-uncomment-lines)
;; )
(use-package general
  :ensure t
  :config 
  (general-define-key
   "M-x"   'execute-extended-command)
  (general-define-key
   :states '(normal visual emacs)
   "/" 'consult-line ;; TODO search jumping
   "gcc" 'evilnc-comment-or-uncomment-lines) ;; TODO make sure this works in web-mode
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   ;; "'"   'multi-term ;; TODO use vterm if os == nix
   ;; "/"   'counsel-rg ;; TODO find alt
   "f"   'find-file
   ":"   'execute-extended-command
   "."   'edit-emacs-configuration
   "TAB" 'toggle-buffers

   "p" 'projectile-command-map
   "pp" 'projectile-persp-switch-project
   ;; "pf" 'counsel-projectile ;; TODO wire up consult and projectile
   "pl" 'test-counsel-describe-function

   "b" '(:ignore t :which-key "Buffers")
   "bb"  'consult-buffer
   "bd"  'kill-buffer

   "w" '(:ignore t :which-key "Window")
   "wl"  'windmove-right
   "wh"  'windmove-left
   "wk"  'windmove-up
   "wj"  'windmove-down
   "w/"  'split-window-right
   "w-"  'split-window-below
   "wd"  'delete-window
   "ws"  'consult-buffer-other-window

   "a" '(:ignore t :which-key "Applications")

   "s" '(:ignore t :which-key "Search")
   "sc" 'evil-ex-nohighlight

   "t" '(:ignore t :which-key "Toggles")
   "tn" 'display-line-numbers-mode
   "tl" 'toggle-truncate-lines

   "x" '(:ignore t :which-key "Text")
   "xl" '(:ignore t :which-key "Lines")
   "xls" 'sort-lines
   
   "g" '(:ignore t :which-key "Code?")
   )
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(corfu vertico olivetti which-key use-package multi-term general exec-path-from-shell evil doom-themes counsel-projectile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
