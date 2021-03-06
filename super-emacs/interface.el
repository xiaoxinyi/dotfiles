;Change title-bar text
(setq frame-title-format
      "emacs")

;;Disable menu-bar
;; (menu-bar-mode -1)

;;Disable tool-bar
(tool-bar-mode -1)

;Disable scroll-bar
(scroll-bar-mode -1)

(defun hrs/mac? ()
  (eq system-type 'darwin))


;; (use-package color-theme
;;   :ensure t)

;; (use-package color-theme-solarized
;;   :ensure t
;;   :config
;;   (when window-system
;;     (setq solarized-use-variable-pitch nil)
;;     (setq solarized-height-plus-1 1.0)
;;     (setq solarized-height-plus-2 1.0)
;;     (setq solarized-height-plus-3 1.0)
;;     (setq solarized-height-plus-4 1.0)
;;     (setq solarized-use-less-bold t)
;;     (setq solarized-termcolors 256)
;;     (setq solarized-high-contrast-mode-line t)
;;     (load-theme 'solarized-dark t)
;;     )
;;)

;;(when window-system
(use-package hl-line
  :config
  (global-hl-line-mode))
;;)

(when (hrs/mac?)
  (set-frame-parameter nil 'fullscreen 'fullboth))


;; ;Set font
;; (custom-set-faces
;;  '(default ((t (:height 120)))))

;; (add-to-list 'default-frame-alist '(font . "Fira Code-15" ))


;; font config

;; (setq hrs/default-font "Inconsolata")
(setq hrs/default-font "Fira Code")
;; (setq hrs/default-font "Source Code Pro")
(setq hrs/default-font-size 15)
(setq hrs/current-font-size hrs/default-font-size)

;; (if (hrs/mac?)
;;     (setq hrs/default-font-size 16)
;;     (setq hrs/default-font-size 12))

(setq hrs/font-change-increment 1.1)



(defun hrs/set-font-size ()
  "Set the font to `hrs/default-font' at `hrs/current-font-size'."
  (set-frame-font
   (concat hrs/default-font "-" (number-to-string hrs/current-font-size))))

(defun hrs/reset-font-size ()
  "Change font size back to `hrs/default-font-size'."
  (interactive)
  (setq hrs/current-font-size hrs/default-font-size)
  (hrs/set-font-size))

(defun hrs/increase-font-size ()
  "Increase current font size by a factor of `hrs/font-change-increment'."
  (interactive)
  (setq hrs/current-font-size
        (ceiling (* hrs/current-font-size hrs/font-change-increment)))
  (hrs/set-font-size))

(defun hrs/decrease-font-size ()
  "Decrease current font size by a factor of `hrs/font-change-increment', down to a minimum size of 1."
  (interactive)
  (setq hrs/current-font-size
        (max 1
             (floor (/ hrs/current-font-size hrs/font-change-increment))))
  (hrs/set-font-size))

(hrs/set-font-size)

(bind-key "C-)" 'hrs/reset-font-size)
(bind-key "C-)" 'hrs/reset-font-size)
(bind-key "C-+" 'hrs/increase-font-size)
(bind-key "C-=" 'hrs/increase-font-size)
(bind-key "C-_" 'hrs/decrease-font-size)
(bind-key "C--" 'hrs/decrease-font-size)


(global-prettify-symbols-mode t)
