(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(align-to-tab-stop nil)
 '(aquamacs-additional-fontsets nil t)
 '(aquamacs-customization-version-id 182 t)
 '(cua-mode nil nil (cua-base))
 '(default-frame-alist (quote ((tool-bar-lines . 0) (cursor-type . box) (vertical-scroll-bars) (internal-border-width . 0) (modeline . t) (fringe) (background-mode . light) (menu-bar-lines . 1) (right-fringe . 10) (left-fringe . 2) (border-color . "black") (cursor-color . "Red") (mouse-color . "black") (background-color . "#FEF1C6") (foreground-color . "Black") (font . "-apple-profontisolatin1-medium-r-normal--9-0-72-72-m-0-iso10646-1"))))
 '(desktop-save-mode nil)
 '(display-time-mode nil)
 '(mac-option-modifier nil)
 '(mac-pass-command-to-system nil)
 '(quack-programs (quote ("chicken" "bigloo" "csi" "csi -hygienic" "gosh" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "mred -z" "mzscheme" "mzscheme" "mzscheme -M errortrace" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi")))
 '(quack-smart-open-paren-p t)
 '(safe-local-variable-values (quote ((TeX-master . t))))
 '(show-paren-mode nil)
 '(tabbar-mode t nil (tabbar))
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(transient-mark-mode t)
 '(whitespace-auto-cleanup t)
 '(whitespace-silent t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#FEF1C6" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :family "apple-profont"))))
 '(autoface-default ((t (:inherit default :strike-through nil :underline nil :slant normal :weight normal :height 90 :width normal :family "ProFontIsoLatin1"))))
 '(fixed-pitch ((t (:family "apple-profont"))))
 '(tabbar-default-face ((t (:inherit variable-pitch :background "gray72" :foreground "gray9" :height 1.0 :family "helv"))))
 '(text-mode-default ((t (:inherit autoface-default :strike-through nil :underline nil :slant normal :weight normal :height 90 :width normal :family "profontisolatin1"))) t)
 '(textile-emph-face ((t (:foreground "dark green" :slant italic))))
 '(textile-h1-face ((t (:weight bold :height 2.0)))))

;; for compatibility with older Aquamacs versions
 (defvar aquamacs-140-custom-file-upgraded t)
 (unless (fboundp 'auto-detect-longlines) (defun auto-detect-longlines () t))
