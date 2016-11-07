;Create repositories cache, if required
(when (not package-archive-contents)
  (package-refresh-contents))

;Declare a list of required packages
(defvar super-emacs--required-packages
  '())

;Install required packages
(mapc (lambda (p)
        (package-install p))
      super-emacs--required-packages)

;; multiple-cursors
(use-package multiple-cursors
  :ensure t
  :bind
  ("C-}" . mc/mark-next-like-this)
  ("C-{" . mc/mark-previous-like-this)
  ("C-|" . mc/mark-all-like-this)
  ("C-c C-}" . mc/skip-to-next-like-this)
  ("C-c C-{" . mc/skip-to-previous-like-this))

(use-package switch-window
  :ensure t
  :bind ("C-<tab>" . switch-window))

(use-package buffer-move
  :ensure t
  :bind
  ("C-s-<up>" . buf-move-up)
  ("C-s-<down>" . buf-move-down)
  ("C-s-<left>" . buf-move-left)
  ("C-s-<right>" . buf-move-right))

(use-package ztree
  :ensure t)

(use-package material-theme
  :ensure t)

(use-package meta-presenter
  :ensure t)

;;Load default auto-complete configs
(use-package auto-complete
  :config
  (ac-config-default))

;;Start undo-tree
(use-package undo-tree
  :bind (("M-/" . undo-tree-visualize))
  :config
(global-undo-tree-mode))


(use-package ace-jump-mode
  :commands ace-jump-mode
  :bind* (("M-h" . ace-jump-mode))
  :config (setq ace-jump-mode-submode-list
                '(ace-jump-char-mode
                  ace-jump-word-mode
                  ace-jump-line-mode))
  )


;Enable powerline
(use-package powerline
  :config
  (powerline-center-theme)
  (setq powerline-default-separator 'wave))


;;Configure theme-looper
(use-package theme-looper
  :bind (("C-\"" . theme-looper-enable-next-theme))
  :config
  (theme-looper-set-theme-set '(deeper-blue
                                wheatgrass
                                wombat
                                material
                                monokai
                                solarized-dark
                                solarized-light))
  (theme-looper-set-customizations 'powerline-reset))

;Configure myterminal-controls
(use-package myterminal-controls
  :commands myterminal-controls-open-controls
  :bind (("C-M-'" . myterminal-controls-open-controls))
  :config
  (myterminal-controls-set-controls-data
   '(("t" "Change color theme" theme-looper-enable-next-theme)
     ("r" "Reload file" super-emacs-reload-current-file))))

;; Set up helm-mode
;; (require 'helm)
;; (require 'helm-config)
;; (require 'helm-ag nil t)
(use-package helm
  :init
  :bind (("M-x" . helm-M-x)
    ("C-x b" . helm-mini)
    ("C-x C-b" . helm-buffers-list)
    ("C-x C-f" . helm-find-files)
    ("C-x C-r" . helm-recentf)
    ("M-y" . helm-show-kill-ring)
    ("C-c h" . helm-command-prefix)
    :map helm-map
    ;;("<tab>" . helm-execute-persistent-action)
    ("C-j" .  helm-execute-persistent-action)
    ("C-z" . helm-select-action))
  :config
  (helm-mode 1)
  (helm-autoresize-mode t)
  (setq helm-split-window-in-side-p t
        ;helm-move-to-line-cycle-in-source t
        helm-ff-file-name-history-use-recentf t
        helm-ff-search-library-in-sexp t)
  (use-package helm-ag
    :ensure t)
  (require 'helm-config))



; anaconda-mode
;; (add-hook 'python-mode-hook 'anaconda-mode)
;; (add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(setq python-indent 4)


; multi term
(use-package multi-term
  :bind (("C-x t" . multi-term))
  :config
  (require 'multi-term)
  (setq multi-term-program "/bin/zsh")
  ;; set PS1
  (setq system-uses-terminfo nil)
  ;; tab complete
  (add-hook 'term-mode-hook
            (lambda()
              (setq yas-dont-activate t))))


;;================================================================================
;;================================================================================


;; org-mode

(add-hook 'org-mode-hook
          (lambda ()
            (org-bullets-mode t)))

(setq org-ellipsis "⤵")

;; show utf-8
(setq org-pretty-entities t)

(setq org-src-fontify-natively t)

(setq org-src-tab-acts-natively t)

(setq org-src-window-setup 'current-window)

;; export html get rid of footer
(setq org-html-postamble nil)
(setq org-html-toc nil)

;; execute in emacs
(setenv "PATH"
        (concat (getenv "PATH")
                ":" "/usr/local/bin"))
(setenv "PATH"
        (concat (getenv "PATH")
                ":" "/Library/TeX/texbin/"))

(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path (append exec-path '("/Library/TeX/texbin/")))

;;================================================================================
;;================================================================================

;; org-mode  export pdf
;; (setq org-latex-pdf-process
;;       '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;;         "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;;         "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-to-pdf-process
      '("xelatex -shell-escape -file-line-error -interaction=nonstopmode  -synctex=1 -output-directory %o %f"
        "xelatex -shell-escape -file-line-error -interaction=nonstopmode  -synctex=1 -output-directory %o %f"
        "xelatex -shell-escape -file-line-error -interaction=nonstopmode  -synctex=1 -output-directory %o %f"))




;; add minted package highlight source code
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

;; org latex preview inline
(setq org-latex-create-formula-image-program 'imagemagick)
;; scale image inline default set to 1.5
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

;; org-narrow-forward
(defun zl/org-narrow-forward ()
  "Move to the next subtree at same level, and narrow to it."
  (interactive)
  (widen)
  (org-forward-heading-same-level 1)
  (org-narrow-to-subtree))

(defun zl/org-narrow-backward ()
  "Move to the previous subtree at same level, and narrow to it."
  (interactive)
  (widen)
  (org-backward-heading-same-level 1)
  (org-narrow-to-subtree))

(defun zl/set-org-keys ()
  (local-set-key "\C-xnm" 'zl/org-narrow-forward)
  (local-set-key "\C-xnp" 'zl/org-narrow-backward))

(add-hook 'org-mode-hook 'zl/set-org-keys)

;; (setq org-src-fontify-natively t)
;; Tex config
(setq TeX-parse-self t)

(setq TeX-PDF-mode t)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (LaTeX-math-mode)
            (setq TeX-master t)))



(require 'ox-md)
(require 'ox-beamer)
(require 'ox-twbs)
(require 'ox-gfm)


(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ruby . t)
   (python . t)
   (sh . t)
   (C . t)
   (lua . t )
   (dot . t)))

(setq org-confirm-babel-evaluate nil)

(setq org-export-with-smart-quotes t)

(setq org-log-done 'time)

(defun mark-done-and-archive ()
  "Mark the state of an org-mode item as DONE and archive it."
  (interactive)
  (org-todo 'done)
  (org-archive-subtree))

(define-key global-map "\C-c\C-x\C-s" 'mark-done-and-archive)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)


;; dired config
(require 'dired-x)
(require 'dired+)
(require 'dired-open)

(setq dired-open-extensions
      '(("pdf" . "preview")
        ("md" . "emacs")
        ("mkv" . "vlc")
        ("mp4" . "vlc")
        ("avi" . "vlc")))

(setq-default dired-listing-switches "-lha")

(setq dired-clean-up-buffers-too t)

(setq dired-recursive-copies 'always)

(setq dired-recursive-deletes 'top)

;;================================================================================
;;================================================================================

;; ido
(use-package ido
  :ensure t
  :init  (setq ido-enable-flex-matching t
               ido-ignore-extensions t
               ido-use-virtual-buffers t
               ido-everywhere t)
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (add-to-list 'completion-ignored-extensions ".pyc")
  ;; don't confirm to create new buffers
  (setq ido-create-new-buffer 'always))

(use-package flx-ido
   :ensure t
   :init (setq ido-enable-flex-matching t)
   :config (flx-ido-mode 1))

(use-package ido-vertical-mode
  :ensure t
  :init               ; I like up and down arrow keys:
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
  :config
  (ido-vertical-mode 1))

(use-package ido-ubiquitous
  :ensure t
  :config
  (ido-ubiquitous))

;; smex
;; (smex-initialize)

;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)


;;================================================================================
;;================================================================================

;; yasnippet config
(require 'yasnippet)
(yas-global-mode 1)


;;================================================================================
;;================================================================================

;; auto-complete-c-header
(use-package auto-complete-c-headers
  :ensure t
  :config
  (defun zl/ac-complete-c-header-init ()
    (require 'auto-complete-c-headers)

    (add-to-list 'ac-sources 'ac-source-c-headers)

    (add-to-list 'achead:include-directories '"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include/c++/4.2.1")

    (add-to-list 'achead:include-directories '"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include"))

  (add-hook 'c++-mode-hook 'zl/ac-complete-c-header-init)
  (add-hook 'c-mode-hook 'zl/ac-complete-c-header-init))


;; iedit
(use-package iedit
  :ensure t
  :bind (("C-c o" . iedit-mode)))



;;================================================================================
;;================================================================================

;; flymake google cpp
(defun zl/flymake-google-init ()
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
  (flymake-google-cpplint-load))
(add-hook 'c-mode-hook 'zl/flymake-google-init)
(add-hook 'c++-mode-hook 'zl/flymake-google-init)

(setq-default tab-always-indent 'complete)

;;================================================================================
;;================================================================================

;; google-c-style
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)



;;================================================================================
;;================================================================================

;; cedet
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(semantic-mode 1)
(require 'stickyfunc-enhance)

;; add senmatic as a suggestion backend to auto complete
(defun zl/add-senmantic-to-autocompelte ()
  (add-to-list 'ac-sources 'ac-source-semantic)
  (add-to-list 'ac-sources 'ac-source-gtags)
  )

(add-hook 'c-mode-common-hook 'zl/add-senmantic-to-autocompelte)
(add-hook 'c-mode-common-hook 'global-semantic-mru-bookmark-mode)

;; local set key
(defun zl/set-semantic-keys ()
  (local-set-key "\C-c,d" 'semantic-ia-show-doc)
  (local-set-key "\C-c,c" 'semantic-ia-describe-class)
  (local-set-key "\C-c,s" 'semantic-ia-show-summary)
  (local-set-key "\C-c,>" 'semantic-ia-fast-jump)
  (local-set-key "\C-c,-" 'senator-fold-tag)
  (local-set-key "\C-c,+" 'senator-unfold-tag))


(add-hook 'c-mode-common-hook 'zl/set-semantic-keys)


(global-ede-mode 1)

(ede-cpp-root-project "my project" :file "~/code/cplusplus/my_program/src/main.cpp"
                      :include-path '("/../my_inc"))

(global-semantic-idle-scheduler-mode 1)

(semantic-add-system-include "/usr/local/Cellar/gsl/1.16/include" 'c++-mode)

(defun zl/semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hook 'zl/semantic-hook)

;;================================================================================
;;================================================================================

;; Package: smartparens
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;; when you press RET, the curly braces automatically
;; add another newline
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))
;;================================================================================
;;================================================================================

;; Package: clean-aindent-mode
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

;; Package: ws-butler
(require 'ws-butler)
(add-hook 'c-mode-common-hook 'ws-butler-mode)
(add-hook 'prog-mode-hook 'ws-butler-mode)


;;================================================================================
;;================================================================================

;; elpy

(use-package elpy
  :ensure t
  :config
  ;;  (define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
  (require 'elpy)
  (elpy-enable)
  (setq elpy-rpc-python-command "/usr/local/bin/python")
  ;; remove indention hightlight
  (delq 'elpy-module-highlight-indentation elpy-modules)
  (elpy-use-ipython)

  ;;(setq elpy-rpc-backend "jedi")
  (setq elpy-rpc-backend "jedi")

  (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
  (defun zl/switch-to-python3 ()
    (interactive)
    (setq elpy-rpc-python-command "python3")
    (elpy-use-ipython "ipython3"))
  (defun zl/switch-to-python2 ()
    (interactive)
    (setq elpy-rpc-python-command "python")
    (elpy-use-ipython "ipython"))
  (use-package flycheck
    :ensure t
    :config
    (require 'flycheck)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))


;; ein for ipython-notebook
(use-package ein
  :ensure t
  :config
  (require 'ein)
  (setq ein:use-auto-complete-superpack t)
  (setq ein:use-smartrep t))

;;================================================================================
;;================================================================================

;; indention setup
; automatically indent when press RET
(global-set-key (kbd "RET") 'newline-and-indent)


;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-c w") 'whitespace-mode)

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 4)


;;================================================================================
;;================================================================================

;; projectile
(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  )
(use-package  helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  ;; (setq projectile-switch-project-action 'helm-projectile-find-file)
  (setq projectile-switch-project-action 'helm-projectile)
  (setq projectile-enable-caching t)
  )


;; auto save
(defun save-all ()
  "Saves all dirty buffers without asking for confirmation."
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

;; tags
(require 'etags)

(use-package ctags-update
  :ensure t
  :bind (("C-c C-r" . ctags-update))
  :config
  ;;;###autoload
  (defun turn-on-ctags-auto-update-mode()
    "turn on `ctags-auto-update-mode'."
    (interactive)
    (ctags-update-minor-mode 1))
  (add-hook 'prog-mode-hook  'turn-on-ctags-auto-update-mode)
  (setq ctags-update-command "/usr/local/bin/ctags-zl")
  :diminish ctags-auto-update-mode)

;; ag
(use-package ag
  :ensure    t
  :commands  ag
  :init      (setq ag-highlight-search t)
  :config    (add-to-list 'ag-arguments "--word-regexp"))

;; shell
(use-package exec-path-from-shell
  :ensure t
  :config (when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)))

;; git-gutter+
(use-package git-gutter+
  :ensure t
  :config (global-git-gutter+-mode))


;; graphviz-dot
(add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))

;; magit
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; markdown mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; camcorder
(use-package camcorder
  :ensure t)

;; lua mode
(use-package lua-mode
  :ensure t
  :interpreter "lua5.1"
  :config
  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
  (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
  :bind
  (
   :map lua-mode-map
        ("C-<return>" . lua-send-current-line)
        ("C-c C-c" . lua-send-region)
        ("C-M-x" . lua-send-defun)
  )
)

;; impatient-mode
;; useage: httpd start impatient-mode
;; localhost:8080/imp
(use-package impatient-mode
  :ensure t
  :config
  (require 'impatient-mode))


;; sh-mode bug org-mode fontification error
;; (add-to-list 'load-path "~/.emacs.d/elpa/sh-mode/")

;; (use-package neotree
;;   :ensure t)

;; eproject
(use-package eproject
  :ensure t)

;; etags-select
(use-package etags-select
  :ensure t
  :config
  (defun build-ctags ()
    (interactive)
    (message "building project tags")
    (let ((root (eproject-root)))
      (shell-command (concat "ctags-zl -e -R --extra=+fq --exclude=db --exclude=test --exclude=.git --exclude=public -f " root "TAGS " root))\
)
    (visit-project-tags)
    (message "tags built successfully"))

  (defun visit-project-tags ()
    (interactive)
    (let ((tags-file (concat (eproject-root) "TAGS")))
      (visit-tags-table tags-file)
      (message (concat "Loaded " tags-file))))

  (defun my-find-tag ()
    (interactive)
    (if (file-exists-p (concat (eproject-root) "TAGS"))
        (visit-project-tags)
      (build-ctags))
    (etags-select-find-tag-at-point))

  (global-set-key (kbd "M-.") 'my-find-tag)

  )

;; hs-minor-mode
(use-package hideshow
  :ensure t
  :bind (("S-+" . toggle-hiding)
         ("C-\\" . toggle-selective-display))
  :init
  (defun toggle-selective-display (column)
    (interactive "P")
    (set-selective-display
     (or column
         (unless selective-display
           (1+ (current-column))))))

  (defun toggle-hiding (column)
    (interactive "P")
    (if hs-minor-mode
        (if (condition-case nil
                (hs-toggle-hiding)
              (error t))
            (hs-show-all))
      (toggle-selective-display column)))
  :config
  (add-hook 'c-mode-common-hook   'hs-minor-mode)
  ;; (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
  (add-hook 'elpy-mode-hook 'hs-minor-mode)
  (add-hook 'lua-mode-hook 'hs-minor-mode)
  )


;; bookmark+
 ; (use-package bookmark+
 ;   :ensure t
 ;   :config
 ;   (require 'bookmark+)
 ;   (setq bookmark-save-flag 1)
 ;   (setq inhibit-splash-screen t)
 ;   (require 'bookmark)
 ;   (bookmark-bmenu-list)
 ;   (switch-to-buffer "*Bookmark List*")
 ;   ;; (bookmark-load bookmark-default-file t)
 ;   )

(use-package smart-mode-line
  :ensure t)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package macrostep
  :ensure t
  :bind ("C-c m e" . macrostep-expand))
