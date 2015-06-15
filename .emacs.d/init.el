;; Melpa packages
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa"."http://melpa.milkbox.net/packages/") t)
;; End Melpa packages

;; General Configuration
;; No startup message
(setq inhibit-startup-message t)
;; Start emacs full screen
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; UTF-8 encoding for everything
(prefer-coding-system 'utf-8)
;; No tool bar
(tool-bar-mode -1)
;; No menu bar
(menu-bar-mode -1)
;; Show column number
(column-number-mode t)
;; No backups
(setq backup-inhibitied t)
;; Mouse scroll one line at a time
(setq mouse-wheel-follow-mouse 't)
;; Keyboard scroll one line at a time
(setq scroll-step 1)
;; Line numbers
(global-linum-mode 1)
;; Global electric mode
(electric-pair-mode)
;; Clean white spaces on save
(add-hook 'before-save-hook 'whitespace-cleanup)
;; Tabs for makefiles
(add-hook 'makefile-mode 'indent-tabs-mode)
;; Stop curso from jumping into minibuffer by itself
(setq minibuffer-prompt-properties
      (quote (read-only t point-entered minibuffer-avoid-prompt
			face minibuffer-prompt)))
;; Prettify by Gopar!
(show-paren-mode t)
(set-face-background 'show-paren-match-face "#aaaaaa")
(set-face-attribute 'show-paren-match-face nil
		    :weight 'bold :underline nil :overline nil :slant 'normal)
(set-face-foreground 'show-paren-mismatch-face "red")
(set-face-attribute 'show-paren-mismatch-face nil
		    :weight 'bold :underline t :overline nil :slant 'normal)
;; make stuff pretty :D
(add-hook 'prog-mode-hook
	  (lambda ()
	    (push '(">=" . ?≥) prettify-symbols-alist)
	    (push '("<=" . ?≤) prettify-symbols-alist)
	    (push '("->" . ?→) prettify-symbols-alist)))
;; Global mode for it
(global-prettify-symbols-mode +1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(custom-enabled-themes (quote (manoj-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; End general config
