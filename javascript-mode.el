;; javascript-mode.el --- major mode for editing javascript (.js) files
;;
;; Copyright (C) 1997 Peter Kruse

;; Author: Peter Kruse <pete@netzblick.de>
;; Keywords: languages
;; Time-stamp: <2006-06-01 15:16:33 weeksie>

;; This file is *NOT* part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; javascript-mode.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; Get the latest version from
;; <http://www.brigadoon.de/peter/javascript-mode.el>

;; Basically this is c-mode, for indentation, that's where the line
;; (load-library "c-mode") comes from. colorization is done via hilit19.el.
;; Actually did not do much programming myself, just wanted to have
;; colorization, indentation and some functions (hm that's what major modes
;; are about?) hey, this is my first try!

;;; HOW TO INSTALL:
;; Put the following forms in your .emacs to enable autoloading of JavaScript
;; mode, and auto-recognition of ".js" files.
;;
;;   (autoload 'javascript-mode "javascript-mode" "JavaScript mode" t)
;;   (setq auto-mode-alist (append '(("\\.js$" . javascript-mode))
;;				   auto-mode-alist))
;;
;;   This mode requires another lisp file, tempo.el. This can be
;;     retrieved from ftp://ftp.lysator.liu.se/pub/emacs/tempo.el
;;
;;   You might want to get browse-url.el, for the online help.
;;   Get it from
;;   http://wombat.doc.ic.ac.uk/emacs/browse-url.el

;;; Change Log:
;;
;; Sun Apr 12 19:48:48 1998
;;
;;	included a menu
;;
;; Mon Sep 22 20:03:12 MET DST 1997
;;
;;	improvement of Syntax-table
;;
;; Sun Sep  7 17:57:50 MET DST 1997
;;
;;	new variable: javascript-interactive
;;
;; Mon Sep  1 14:52:37 MET DST 1997 
;;
;;	javascript online help - all it does, is browse-url to
;;      javascript-base-help-href
;;
;; Fri Aug 29 21:01:22 MET DST 1997 Peter Kruse
;;	<peter.kruse@psychologie.uni-regensburg.de>
;;
;;	1st release


;;; TODO
;;  
;;  - online help should work like describe-\(function\|variable\),
;;  but get the info from the web. Netscape's documention is in progress,
;;  there is no final complete docu on JavaScript1.2, so perhaps we wait.
;;
;;  - should include an interface to signing scripts, but zigbert is not
;;  available for linux

;;; Bugs
;;
;;  - strings in single-quotes do not highlight

;;; Code:

;; user-variables

(defvar javascript-indentation 2
  "The width for further indentation in JavaScript mode.")

(defvar javascript-base-help-href "http://developer.netscape.com/library/documentation/communicator/jsguide/"
  "URL where the javascript guide can be found.")

(defvar javascript-browse-url-function 'browse-url-w3
  "how to view online help.")

(defvar javascript-interactive t
  "If t user will be prompted for strings in templates.")

;;;

(defvar javascript-mode-map (make-sparse-keymap)
  "Keymap for javascript-mode")

(defvar javascript-mode-syntax-table ()
    "Syntax table for javascript-mode.")


(defvar javascript-mode-hook nil
  "*Hook run when javascript-mode is started.")


(if javascript-mode-syntax-table
    ()
  (progn 
    (setq javascript-mode-syntax-table (make-syntax-table c-mode-syntax-table))
    (modify-syntax-entry ?_ "w" javascript-mode-syntax-table)
    (modify-syntax-entry ?' "\"" javascript-mode-syntax-table)
    (modify-syntax-entry ?% "_" javascript-mode-syntax-table)
    (modify-syntax-entry ?\" "\"" javascript-mode-syntax-table)
    (modify-syntax-entry ?\\ "\\" javascript-mode-syntax-table)    
    (modify-syntax-entry ?/ ". 12" javascript-mode-syntax-table)
    (modify-syntax-entry ?\n ">b" javascript-mode-syntax-table)
    (modify-syntax-entry ?. "_" javascript-mode-syntax-table)))

  
(defvar javascript-mode-abbrev-table nil
  "Abbrev table used while in javascript-mode.")
(define-abbrev-table 'javascript-mode-abbrev-table ())

(require 'tempo)

(tempo-define-template
 "javascript-for"
 (list "for (" '(p "initial: ") "; " '(p "condition: ") "; " '(p "increment: ") ") {" 'n> 'p 'n "}" '>)
 nil "insert a for loop" nil)

(tempo-define-template
 "javascript-for-in"
 (list "for (" '(p "variable: ") " in " '(p "object: ") ") {" '> 'n> 'p 'n "}" '>)
 nil "insert a for loop" nil)

(tempo-define-template
 "javascript-if"
 (list "if (" '(p "condition: ") ") {" 'n> 'p 'n "}" '>)
 nil "insert an if statement" nil)

(tempo-define-template
 "javascript-while"
 (list "while (" '(p "condition: ") ") {" 'n> 'p 'n "}" '>)
 nil "insert a while statement" nil)

(tempo-define-template
 "javascript-do"
 (list "do {" '> 'n> 'p 'n "} while(" '(p "condition: ") ");" '>)
 nil "insert a do-while statement" nil)

(tempo-define-template
 "javascript-with"
 (list "with (" '(p "with what? ") ") {" 'n> 'p 'n "}" '>)
 nil "insert a with statement" nil)

(tempo-define-template
 "javascript-defun"
 (list "function " '(p "function name: ") "(" '(p "arguments: ") ") {" 'n> 'p 'n "}" '>)
 nil "insert a function definition" nil)

(tempo-define-template
 "javascript-switch"
 (list "switch (" '(p "variable: ") ") {" '> 'n> "case '" 'p "' :" '> 'n> "break;" '> 'n> "default :" '> 'n> "}" '>)
 nil "insert a switch statement" nil)

(tempo-define-template
 "javascript-case"
 (list "case '" 'p "' :" '> 'n> "break;" '>)
 nil "insert a case" nil)

;;; now for the help facility
;;; from man.el

(defun javascript-help (entry)
  "Opens a browser via browse-url with a help entry on the current word."
  (interactive
   (list (let* ((default-entry (current-word))
		(input (read-string
			(format "Help entry%s: "
				(if (string= default-entry "")
				    ""
				  (format " (default %s)" default-entry))))))
	   (if (string= input "")
	       (if (string= default-entry "")
		   (error "No entry given")
		 default-entry)
	     input))))
  (let ((url (concat javascript-base-help-href "contents.htm" "#" entry))
	(browse-url-browser-function javascript-browse-url-function))
    (if (boundp 'browse-url-browser-function)
	(progn
	  (pop-to-buffer " javascript-help")
	  (apply browse-url-browser-function (list url)))
      (error "browse-url not found"))))
      
(modify-frame-parameters (selected-frame) '((menu-bar-lines . 2)))
(define-key javascript-mode-map [menu-bar javascript]
  (cons "JavaScript" javascript-mode-map))
(define-key javascript-mode-map [menu-bar javascript Help]
  '("Help" . javascript-help))
(define-key javascript-mode-map [menu-bar javascript for]
  '("for" . tempo-template-javascript-for))
(define-key javascript-mode-map [menu-bar javascript forin]
  '("for .. in" . tempo-template-javascript-for-in))
(define-key javascript-mode-map [menu-bar javascript if]
  '("if" . tempo-template-javascript-if))
(define-key javascript-mode-map [menu-bar javascript while]
  '("while" . tempo-template-javascript-while))
(define-key javascript-mode-map [menu-bar javascript with]
  '("with" . tempo-template-javascript-with))
(define-key javascript-mode-map [menu-bar javascript switch]
  '("switch" . tempo-template-javascript-switch))
(define-key javascript-mode-map [menu-bar javascript case]
  '("case" . tempo-template-javascript-case))
(define-key javascript-mode-map [menu-bar javascript do]
  '("do" . tempo-template-javascript-do))
(define-key javascript-mode-map [menu-bar javascript function]
  '("function" . tempo-template-javascript-defun))


(defun js-emit-void ()
  (interactive)
  (princ "javascript:void(0)" (current-buffer)))

(define-key javascript-mode-map "\C-c\C-h" 'javascript-help)
(define-key javascript-mode-map "\C-c\C-f" 'tempo-template-javascript-for)
(define-key javascript-mode-map "\C-c\C-n" 'tempo-template-javascript-for-in)
(define-key javascript-mode-map "\C-c\C-i" 'tempo-template-javascript-if)
(define-key javascript-mode-map "\C-c\C-w" 'tempo-template-javascript-while)
(define-key javascript-mode-map "\C-c\C-t" 'tempo-template-javascript-with)
(define-key javascript-mode-map "\C-c\C-s" 'tempo-template-javascript-switch)
(define-key javascript-mode-map "\C-c\C-c" 'tempo-template-javascript-case)
(define-key javascript-mode-map "\C-c\C-d" 'tempo-template-javascript-do)
(define-key javascript-mode-map "\C-c(" 'tempo-template-javascript-defun)
(define-key javascript-mode-map "[" 'js-electric-bracket)
(define-key javascript-mode-map "]" 'js-electric-close-bracket)
(define-key javascript-mode-map "{" 'js-electric-brace)
(define-key javascript-mode-map "}" 'js-electric-close-brace)
(define-key javascript-mode-map "(" 'js-electric-paren)
(define-key javascript-mode-map ")" 'js-electric-close-paren)
(define-key javascript-mode-map "\"" 'js-electric-quote)
(define-key javascript-mode-map "'" 'js-electric-prime)
(define-key javascript-mode-map [backspace] 'js-electric-delete)

(defun javascript-mode ()
  "Major mode for editing javascript code. Basically this is c-mode,
because it does a nice indentation. c-mode gets called via `load-library'.
Colorization is done with hilit19. A few commands are defined through
`tempo.el'. The online help facility gets done through browse-url.el.
\\{javascript-mode-map}
You can set the indentation level by setting the variable
`javascript-indentation' to an integer-value. Default is 4.
The variable javascript-base-help-href sets the URL for the JavaScript guide."
  (interactive)
  (kill-all-local-variables)
  (load-library "cc-mode")
  (require 'browse-url)
  (use-local-map javascript-mode-map)
  (setq major-mode 'javascript-mode)
  (setq mode-name "JavaScript")
  (setq indent-tabs-mode t)
  (set (make-local-variable 'comment-start) "//")
  (set-syntax-table javascript-mode-syntax-table)
  
  (make-local-variable 'tempo-interactive)
  (setq tempo-interactive javascript-interactive)
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'js-indent-line)
  (make-local-variable 'c-indent-level)
  (setq c-indent-level javascript-indentation)
  (set (make-local-variable 'font-lock-defaults)
  `(
    ((,(rx (and "/*" (*? anything) "*/")) . font-lock-comment-delimiter-face)
     (,(rx (and "//" (*? anything) eol)) . font-lock-comment-delimiter-face) 
     (,(rx (and word-start (group "function") word-end (1+ space) (group (1+ (in alnum "_")))))
      (1 font-lock-keyword-face) (2 font-lock-function-name-face))
     (,(rx (and word-start (1+ numeric) word-end)) . font-lock-constant-face)
     (,(rx (and word-start (group (1+ (in alnum "_"))) word-end ":" (1+ space) word-start (group "function") word-end))
      (1 font-lock-function-name-face) (2 font-lock-keyword-face))
     (,(rx (and word-start (group (1+ (in alnum "_"))) word-end ":" (1+ space) (group (1+ (in alnum "_")))))
      (1 font-lock-function-name-face))
     (,(rx (and word-start upper-case (1+ word) word-end)) . font-lock-type-face)    
     (,(rx (and word-start (group "new") word-end (1+ space) (group (1+ word))))
      (1 font-lock-keyword-face) (2 font-lock-type-face))    
     (,(rx (and word-start
		(or "do" "while" "for" "if" "else" "instanceof" "function"
		    "true" "false" "this" "return" "case" "break" "var"
		    "default" "undefined" 
		    "try" "catch" "switch" "with" "prototype") word-end)) . font-lock-keyword-face))))
  
  (run-hooks 'javascript-mode-hook))


(defvar javascript-font-lock-keywords
  "Default font lock keywords for Javascript mode")

(defun js-electric-brace () 
  (interactive)
  (js-surround "{" "}"))

(defun js-electric-close-brace ()
  (interactive)
  (js-check-and-close "}"))

(defun js-electric-bracket () 
  (interactive)
  (js-surround "[" "]"))

(defun js-electric-close-bracket ()
  (interactive)
  (js-check-and-close "]"))

(defun js-electric-paren () 
  (interactive)
  (js-surround "(" ")"))

(defun js-electric-close-paren ()
  (interactive)
  (js-check-and-close ")"))

(defun js-electric-quote () 
  (interactive)
  (if (looking-at "\"") 
      (forward-char 1) 
    (progn
      (js-surround "\"" "\""))))

(defun js-electric-prime () 
  (interactive)
  (if (looking-at "'") 
      (forward-char 1) 
    (progn
      (js-surround "'" "'"))))

(defun js-electric-delete ()
  (interactive)
  (if (or
       (js-between "\\[" "\\]")
       (js-between "{" "}")
       (js-between "(" ")")
       (js-between "\"" "\"")
       (js-between "'" "'"))
	(progn
	  (forward-char 1)
	  (delete-char -2))
    (delete-char -1)))

(defun js-surround (x y)
  (princ x (current-buffer))
  (save-excursion (princ y (current-buffer))))
  
(defun js-between (x y)
  (and (char-is-at -1 x)
       (looking-at y)))
	    
(defun js-check-and-close (x)
  (if (looking-at x)
      (forward-char 1)
    (princ x (current-buffer))))


(defun js-indent-line ()
  "Indent current line in javascript mode"
  (interactive)

    (beginning-of-line)
    (if (bobp)
	(indent-line-to 0)
      (let ((not-indented t) cur-indent)
	(if (looking-at "^[\s\t]*},?")
	    (progn
	      (save-excursion
		(forward-line -1)
		(setq cur-indent (- (current-indentation) javascript-indentation)))
		(if (< cur-indent 0)
		    (setq cur-indent 0)))
	      (save-excursion
		(while not-indented
		  (forward-line -1)
		  (if (looking-at "^[\s\t]*},?")
		      (progn
			(setq cur-indent (current-indentation))
			(setq not-indented nil))
		    ;; TODO, cater for switch statements which are fucked
		    (if (looking-at ".*\\({\\)[\s\t]*$")
			(progn
			  (setq cur-indent (+ (current-indentation) javascript-indentation))
			  (setq not-indented nil))
		      (if (bobp)
			  (setq not-indented nil)))))))
	  (if cur-indent 
	    (indent-line-to cur-indent)
	    (indent-line-to 0)))))
  
				  
  
  
(provide 'javascript-mode)

;; javascript-mode.el ends here
