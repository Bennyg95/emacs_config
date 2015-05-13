;;============================== Melpa =======================================;;
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;===========================  General =====================================;;
; no startup msg
(setq inhibit-startup-message t)
; auto refresh files when changed from disk
(global-auto-revert-mode t)
; Show column number
(column-number-mode t)
; Don't have backups
(setq backup-inhibited t)
; Don't suspend emacs, so ANNOYING
(global-unset-key (kbd "C-z"))
;; for all langs
(define-key global-map (kbd "C-c o") 'iedit-mode)
;; this saves typing
(define-key global-map (kbd "RET") 'newline-and-indent)
;; sometimes need this
(define-key global-map (kbd "C-j") 'newline)
;; Line numbers baby
(global-linum-mode 1)
;; Global electric mode
(electric-pair-mode)
;; Org-mode languagle eval
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (java . t)))
;; switch-window
(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)
;; Stop cursor from going into minibuffer prompt text
(setq minibuffer-prompt-properties
      (quote (read-only t point-entered minibuffer-avoid-prompt
                        face minibuffer-prompt)))
;;=============================  NeoTree ===================================;;
(neotree)
;; keybindings
(global-set-key [f8] 'neotree-toggle)
(global-set-key (kbd "C-c C-n") 'neotree-change-root)
(add-hook 'neotree-mode (linum-mode -1))

;;==============================  PHP mode ===================================;; 
(unless (package-installed-p 'ac-php)
  (package-refresh-contents)
  (package-install 'ac-php)
  )
(require 'cl)
(require 'php-mode)
(add-hook 'php-mode-hook '(lambda ()
                           (auto-complete-mode t)
                           (require 'ac-php)
                           (setq ac-sources  '(ac-source-php ) )
                           (yas-global-mode 1)

                           (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
                           (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back   ) ;go back
                           ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; IRONY TRUE AUTO COMPLETE 
;; C/C++ Mode
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default indent-tabs-mode nil)
;; disable Semantic in all non-cc-mode buffers.
(setq semantic-inhibit-functions
      (list (lambda () (not (and (featurep 'cc-defs)
                                 c-buffer-is-cc-mode)))))

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)


;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async)
  ;; Documentation
  (irony-eldoc)
  ;; Auto complete dialog
  (company-mode)
  ;; on the fly syntax checking
  (flycheck-mode))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(add-hook 'python-mode-hook '(lambda () (eldoc-mode 1)) t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(display-battery-mode t)
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'neotree-mode (linum-mode -1))
;;================================ Python (elpy) =============================;;
(elpy-enable)
;; Fix bindings (bugs)
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; spacing between operators
(require 'py-smart-operator)
(add-hook 'python-mode-hook 'py-smart-operator-mode)
;; make lambdas pretty
(add-hook 'python-mode-hook 'pretty-lambda-mode)
(defun my-compile ()
  "Use compile to run python programs"
  (interactive)
  (compile (concat "python " (buffer-name))))
(setq compilation-scroll-output t)
;; Keymaps to navigate to the errors
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-cn" 'flymake-goto-next-error)))
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-cp" 'flymake-goto-prev-error)))
;; Configure flymake for Python
    (when (load "flymake" t)
      (defun flymake-pylint-init ()
        (let* ((temp-file (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
          (list "epylint" (list local-file))))
            (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))
;; Set as a minor mode for Python
(add-hook 'python-mode-hook '(lambda () (flymake-mode)))
;; To avoid having to mouse hover for the error message, these functions make flymake error messages
;; appear in the minibuffer
(defun show-fly-err-at-point ()
  "If the cursor is sitting on a flymake error, display the message in the minibuffer"
  (require 'cl)
  (interactive)
  (let ((line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info)
      (if (eq (car elem) line-no)
      (let ((err (car (second elem))))
        (message "%s" (flymake-ler-text err)))))))

(add-hook 'post-command-hook 'show-fly-err-at-point)
(local-set-key "\C-c\C-c" 'my-compile)
;; Configure to wait a bit longer after edits before starting
(setq-default flymake-no-changes-timeout '3)
;; real time spell cheking
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
    (dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))
    (dolist (hook '(change-log-mode-hook log-edit-mode-hook))
      (add-hook hook (lambda () (flyspell-mode -1))))
(eval-after-load "flyspell"
      '(progn
         (fset 'flyspell-emacs-popup 'flyspell-emacs-popup-textual)))

