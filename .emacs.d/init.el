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
;;(menu-bar-mode -1)
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
 '(custom-enabled-themes (quote (deeper-blue))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; End general config
;; Octave Configuration
(require 'ac-octave)
(defun ac-octave-mode-setup()
  (setq ac-sources '(ac-source-octave)))
(add-hook 'octave-mode-hook
	  '(lambda () (ac-octave-mode-setup)))

;; Flycheck
(require 'flycheck)
(define-key flycheck-mode-map (kbd "C-c C-n") #'flycheck-next-error)
(define-key flycheck-mode-map (kbd "C-c C-p") #'flycheck-previous-error)

;; C/C++ Mode
;; disable Semantic in all non-cc-mode buffers.
(setq semantic-inhibit-functions
      (list (lambda () (not (and (featurep 'cc-defs)
			    c-buffer-is-cc-mode)))))
;;; IRONY TRUE AUTO COMPLETE
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)

;; Python (elpy)
(elpy-enable)

;; flyspell
(require 'flyspell-lazy)
(flyspell-lazy-mode 1)
(flyspell-mode 1)
;; Markdown mode
(setq olivetti-body-width 90)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook
	  '(lambda ()
	    (set (make-local-variable 'company-backends) '(company-dabbrev))
	    (linum-mode -1) ;; There's a bug that won't let olivetti work with this.
	    (olivetti-mode)
	    (flyspell-mode 1)))
(defhydra dh-hydra-markdown-mode (:hint nil)
  "
Formatting        C-c C-s    _s_: bold          _e_: italic     _b_: blockquote   _p_: pre-formatted    _c_: code

Headings          C-c C-t    _h_: automatic     _1_: h1         _2_: h2           _3_: h3               _4_: h4

Lists             C-c C-x    _m_: insert item

Demote/Promote    C-c C-x    _l_: promote       _r_: demote     _u_: move up      _d_: move down

Links, footnotes  C-c C-a    _L_: link          _U_: uri        _F_: footnote     _W_: wiki-link      _R_: reference

"

  ("s" markdown-insert-bold)
  ("e" markdown-insert-italic)
  ("b" markdown-insert-blockquote :color blue)
  ("p" markdown-insert-pre :color blue)
  ("c" markdown-insert-code)

  ("h" markdown-insert-header-dwim)
  ("1" markdown-insert-header-atx-1)
  ("2" markdown-insert-header-atx-2)
  ("3" markdown-insert-header-atx-3)
  ("4" markdown-insert-header-atx-4)

  ("m" markdown-insert-list-item)

  ("l" markdown-promote)
  ("r" markdown-demote)
  ("d" markdown-move-down)
  ("u" markdown-move-up)

  ("L" markdown-insert-link :color blue)
  ("U" markdown-insert-uri :color blue)
  ("F" markdown-insert-footnote :color blue)
  ("W" markdown-insert-wiki-link :color blue)
  ("R" markdown-insert-reference-link-dwim :color blue))

(require 'markdown-mode)
(define-key markdown-mode-map (kbd "C-c m") 'dh-hydra-markdown-mode/body)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-livedown"))
(require 'livedown)
