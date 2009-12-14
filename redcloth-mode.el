(defgroup redcloth nil
  "Mode hacked together for authoring textile/redcloth docs."
  :group 'applications)



(defvar redcloth-mode-map
  (let ((redcloth-mode-map (make-keymap)))
    (define-key redcloth-mode-map (kbd "C-c C-c") 'redcloth-to-html)
    (define-key redcloth-mode-map (kbd "C-c C-l") 'redcloth-to-latex)
    (define-key redcloth-mode-map (kbd "C-c c") 'redcloth-code-tag)
    (define-key redcloth-mode-map (kbd "C-c C-e") 'redcloth-pre-tag)
    (define-key redcloth-mode-map (kbd "C-c b") 'redcloth-bold)
    (define-key redcloth-mode-map (kbd "C-c t") 'redcloth-code-tag)
    (define-key redcloth-mode-map (kbd "C-c i") 'redcloth-italic)
    redcloth-mode-map)
  "Mode map for redcloth editing commands")

(defface font-redcloth-italic-face
  (let ((font (cond ((assq :inherit custom-face-attributes) '(:inherit italic))
		    ((assq :slant custom-face-attributes) '(:slant italic))
		    (t '(:italic t)))))
    `((((class grayscale) (background light))
       (:foreground "DimGray" ,@font))
      (((class grayscale) (background dark))
       (:foreground "LightGray" ,@font))
      (((class color) (background light))
       (:foreground "DarkOliveGreen" ,@font))
      (((class color) (background dark))
       (:foreground "OliveDrab" ,@font))
      (t (,@font))))
  "Face used to highlight text to be typeset in italic."
  :group 'font-latex-highlighting-faces)

(defface font-redcloth-bold-face
  (let ((font (cond ((assq :inherit custom-face-attributes) '(:inherit bold))
		    ((assq :weight custom-face-attributes) '(:weight bold))
		    (t '(:bold t)))))
    `((((class grayscale) (background light))
       (:foreground "DimGray" ,@font))
      (((class grayscale) (background dark))
       (:foreground "LightGray" ,@font))
      (((class color) (background light))
       (:foreground "DarkOliveGreen" ,@font))
      (((class color) (background dark))
       (:foreground "OliveDrab" ,@font))
      (t (,@font))))
  "Face used to highlight text to be typeset in bold."
  :group 'font-latex-highlighting-faces)

(defface font-redcloth-header-face  
    '((((type tty pc) (class color) (background light))
       (:height 120 :foreground "blue4" :weight bold))
      (((type tty pc) (class color) (background dark))
       (:height 120 :foreground "yellow" :weight bold))
      (((class color) (background light))
       (:height 120 :weight bold :inherit variable-pitch :foreground "blue4"))
      (((class color) (background dark))
       (:height 120 :weight bold :inherit variable-pitch :foreground "yellow"))
      (t (:height 120 :weight bold :inherit variable-pitch)))
  "Face for sectioning commands at level 5."
  :group 'font-latex-highlighting-faces)

(defface font-redcloth-cite-face  
    '((((type tty pc) (class color) (background light))
       (:height 90 :foreground "blue4" :weight bold))
      (((type tty pc) (class color) (background dark))
       (:height 90 :foreground "yellow" :weight bold))
      (((class color) (background light))
       (:height 90 :weight bold :inherit variable-pitch :foreground "DarkOliveGreen"))
      (((class color) (background dark))
       (:height 90 :weight bold :inherit variable-pitch :foreground "yellow"))
      (t (:height 90 :weight bold :inherit variable-pitch)))
  "Face for sectioning commands at level 5."
  :group 'font-latex-highlighting-faces)



(defvar font-redcloth-italic-face 'font-redcloth-italic-face)
(defvar font-redcloth-bold-face 'font-redcloth-bold-face)
(defvar font-redcloth-header-face 'font-redcloth-header-face)
(defvar font-redcloth-cite-face 'font-redcloth-cite-face)


(defun redcloth-mode ()
  "Major mode for editing blahhhhhgs"
  (interactive)
  (kill-all-local-variables)
  (use-local-map redcloth-mode-map)
  (setq major-mode 'redcloth-mode)
  (setq mode-name "Redcloth Mode")
  (set (make-local-variable 'font-lock-defaults)
  `(
    ((,(rx (and "\"" (*? anything) "\"")) . font-lock-string-face)
     (,(rx (and "_" (*? anything) "_")) . font-redcloth-italic-face)
     (,(rx (and "*" (*? anything) "*")) . font-redcloth-bold-face)
     (,(rx (and "??" (*? anything) "??")) . font-redcloth-cite-face)
     (,(rx (and bol "h" numeric "."  (*? anything) eol)) . font-redcloth-header-face)     
     ))) 
  (run-hooks 'redcloth-mode-hook))

;;; actions


(defun redcloth-to-html ()
  (interactive)
  (let 
      ((fname 
	(concat 
	 (file-name-sans-extension (expand-file-name (buffer-name)))))
       (bname (expand-file-name (buffer-name))))
    (shell-command (concat "rc2latex --output --template=default --format=html " bname " > " fname ".html"))
    (shell-command (concat "open " fname ".html"))))

(defun redcloth-to-latex ()
  (interactive)
  (let 
      ((fname 
	(concat (file-name-sans-extension (expand-file-name (buffer-name)))))
       (bname (expand-file-name (buffer-name)))
       (dname (file-name-directory (expand-file-name (buffer-name)))))
    (progn 
      (shell-command (concat "rc2latex --output --template=default " bname))
      (shell-command (concat "pdflatex " fname ".tex"))
;      (message (concat "mv " dname "texput.pdf " fname ".pdf"))
      (shell-command (concat "mv " dname "texput.pdf " fname ".pdf"))
      (shell-command (concat "open " fname ".pdf")))))


(defun redcloth-code-tag (p m)
  (interactive "r")
  (surround-or-print p m "<code>" "</code>"))


(defun redcloth-pre-tag (p m)
  (interactive "r")
  (surround-or-print p m "<pre>" "</pre>"))


(defun redcloth-bold (p m)
  (interactive "r")
  (surround-or-print p m "*" "*"))

(defun redcloth-italic (p m)
  (interactive "r")
  (surround-or-print p m "_" "_"))


(defun surround-or-print (p m start end)
  (if (not mark-active)

      ;; just print out the tags
      (progn
	(princ start (current-buffer))
	(save-excursion 
	  (princ end (current-buffer))))

    ;; otherwise print them out at the end and the beginning of the
    ;; mark
    (save-excursion
      (goto-char m)
      (princ end (current-buffer))
      (goto-char p)
      (princ start (current-buffer)))))

  
  

(provide 'redcloth-mode)