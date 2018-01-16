

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/elisp")

;;(require 'ox-confluence)
;;(require 'org-mime)
(require 'gopher)


;; sentences end with single space
(setq sentence-end-double-space nil)
;; No mouse mode
(xterm-mouse-mode nil)
;; Always want visual-line-mode
(global-visual-line-mode 1)
(global-hl-line-mode 1)
;; (global-linum-mode 1) ;; Too slow, need an alternative
;; No spash screen, we know all that stuffs.
(setq inhibit-splash-screen t)
;; Show time in modeline as I like it
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)
;; Only really want to answer y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; Setup a nice cool theme to be easy on my eyes.
(use-package kaolin-themes
 :ensure t
 :config
 (load-theme 'kaolin-ocean))

(use-package yaml-mode
  :ensure t
  :config (add-hook 'yaml-mode-hook
		    '(lambda ()
		       (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  )

(use-package ob-http
  :ensure t
  )

(use-package edit-server
  :ensure t
  :config (edit-server-start)
  )

(use-package exec-path-from-shell
  :ensure t
  :config (when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize)))

(use-package emojify
  :ensure t
  :config (add-hook 'after-init-hook #'global-emojify-mode)
  )

(use-package mastodon
  :ensure t
  :config (setq mastodon-instance-url "https://mastodon.sdf.org")
  )

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh . t)
   (emacs-lisp . t)
   (ruby . t)
   (python . t)
   (http . t)
   (restclient . t)
   (ditaa . t)
   ))


;; Setup Org-mode capture config
(setq org-default-notes-file "~/org/capture.org")
(setq org-agenda-files (quote ("~/.plan")))
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates
       '(("t" "todo" entry (file+headline "~/.plan" "Tasks")
	  "* TODO [#A] %?"))
       )


;; Define package archives
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                           ("melpa" . "http://melpa.milkbox.net/packages/")))

;;(global-set-key (kbd "C-x t") 'sane-term)
;;(global-set-key (kbd "C-x T") 'sane-term-create)

;;(require 'multi-term)
;;(require 'ace-jump-mode)
;;(require 'key-chord)
;;(require 'yasnippet)

;; (key-chord-mode 1)
;; (setq key-chord-one-key-delay 0.15)
;; (key-chord-define-global "jj" 'ace-jump-mode)

(add-hook 'term-mode-hook (lambda ()
;;			    (setq yas/dont-activate nil)
;;			    (yas/minor-mode-on)
			    (add-to-list 'term-bind-key-alist '("C-c C-n" . multi-term-next))
			    (add-to-list 'term-bind-key-alist '("C-c C-p" . multi-term-prev))
			    (add-to-list 'term-bind-key-alist '("C-c C-j" . term-line-mode))
			    (add-to-list 'term-bind-key-alist '("C-c C-k" . term-char-mode))
			    ))

(global-set-key (kbd "C-c t") 'multi-term-next)
(global-set-key (kbd "C-c T") 'multi-term)

(global-set-key (kbd "C-z") 'undo) ; 【Ctrl+z】Undo

 (use-package shell-pop
   :ensure t
   :bind (("C-`" . shell-pop))
   :config
   (setq shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
   (setq shell-pop-term-shell "/bin/zsh")
   ;; need to do this manually or not picked up by `shell-pop'
   (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

;; highlight the current line; set a custom face, so we can
;; recognize from the normal marking (selection)
;;(defface hl-line '((t (:background "DarkGrey")))
;;  "Face to use for `hl-line-face'." :group 'hl-line)
;;(setq hl-line-face 'hl-line)
;;(global-hl-line-mode t) ; turn it on for all modes by default

;; See http://www.emacswiki.org/emacs/CPerlMode for details on options
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
 (add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
 (add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
 (add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
 (setq cperl-electric-keywords t)
 (setq cperl-auto-newline t)
 (setq cperl-hairy t)
 (setq cperl-invalid-face (quote off)) 

 ;;(load "~/elisp/post.el")

(setq eshell-prompt-function (lambda nil
    (concat
     (propertize (eshell/pwd) 'face `(:foreground "blue"))
     (propertize " $ " 'face `(:foreground "green")))))
  (setq eshell-highlight-prompt nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; toggle between most recent buffers ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://www.emacswiki.org/emacs/SwitchingBuffers#toc5
(defun switch-to-previous-buffer ()
  "Switch to most recent buffer. Repeated calls toggle back and forth between the most recent two buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; set key binding
(global-set-key (kbd "C-`") 'switch-to-previous-buffer)

;; comint-modes clear buffer - for eshell, inf-whatever, etc
(defun comint-clear-buffer ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

;; let's bind the new command to a keycombo
(define-key comint-mode-map "\C-c\M-o" #'comint-clear-buffer)


;; Hydra Example - Buffer Menu help menu (awesomesauce)
(defhydra hydra-buffer-menu (:color pink
				    :hint nil)
    "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
_~_: modified
"
    ("m" Buffer-menu-mark)
    ("u" Buffer-menu-unmark)
    ("U" Buffer-menu-backup-unmark)
    ("d" Buffer-menu-delete)
    ("D" Buffer-menu-delete-backwards)
    ("s" Buffer-menu-save)
    ("~" Buffer-menu-not-modified)
    ("x" Buffer-menu-execute)
    ("b" Buffer-menu-bury)
    ("g" revert-buffer)
    ("T" Buffer-menu-toggle-files-only)
    ("O" Buffer-menu-multi-occur :color blue)
    ("I" Buffer-menu-isearch-buffers :color blue)
    ("R" Buffer-menu-isearch-buffers-regexp :color blue)
    ("c" nil "cancel")
    ("v" Buffer-menu-select "select" :color blue)
    ("o" Buffer-menu-other-window "other-window" :color blue)
    ("q" quit-window "quit" :color blue))
(define-key Buffer-menu-mode-map "." 'hydra-buffer-menu/body)

(defhydra hydra-windows (global-map "C-M-s" :color pink :hint nil)
  "
Splitter    Window
   ^_k_^          ^_d_^
 _h_   _l_      _a_   _f_
   ^_j_^          ^_s_^
"
  ("h" hydra-move-splitter-left)
  ("j" hydra-move-splitter-down)
  ("k" hydra-move-splitter-up)
  ("l" hydra-move-splitter-right)
  ("a" windmove-left)
  ("s" windmove-down)
  ("d" windmove-up)
  ("f" windmove-right)
  ("q" nil "quit"))
(global-set-key (kbd "C-M-s") 'hydra-windows/body)

;; To be updated - Toggle modes - need to pick a shortcut that doesnt conflict with org
(defhydra hydra-toggle (:color pink)
    "
_a_ abbrev-mode:       %`abbrev-mode
_d_ debug-on-error:    %`debug-on-error
_f_ auto-fill-mode:    %`auto-fill-function
_t_ truncate-lines:    %`truncate-lines
_w_ whitespace-mode:   %`whitespace-mode
"
    ("a" abbrev-mode nil)
    ("d" toggle-debug-on-error nil)
    ("f" auto-fill-mode nil)
    ("t" toggle-truncate-lines nil)
    ("w" whitespace-mode nil)
    ("q" nil "quit"))
;; Recommended binding:
;; (global-set-key (kbd "C-c C-v") 'hydra-toggle/body)

(defhydra hydra-apropos (:color blue
				:hint nil)
    "
_a_propos        _c_ommand
_d_ocumentation  _l_ibrary
_v_ariable       _u_ser-option
^ ^          valu_e_"
    ("a" apropos)
    ("d" apropos-documentation)
    ("v" apropos-variable)
    ("c" apropos-command)
    ("l" apropos-library)
    ("u" apropos-user-option)
    ("e" apropos-value))
(global-set-key (kbd "C-c h") 'hydra-apropos/body)

;; Rectangle-mode helper
(defhydra hydra-rectangle (:body-pre (rectangle-mark-mode 1)
				     :color pink
				     :post (deactivate-mark))
    "
  ^_k_^     _d_elete    _s_tring
_h_   _l_   _o_k        _y_ank
  ^_j_^     _n_ew-copy  _r_eset
^^^^        _e_xchange  _u_ndo
^^^^        ^ ^         _p_aste
"
    ("h" backward-char nil)
    ("l" forward-char nil)
    ("k" previous-line nil)
    ("j" next-line nil)
    ("e" hydra-ex-point-mark nil)
    ("n" copy-rectangle-as-kill nil)
    ("d" delete-rectangle nil)
    ("r" (if (region-active-p)
	     (deactivate-mark)
	   (rectangle-mark-mode 1)) nil)
    ("y" yank-rectangle nil)
    ("u" undo nil)
    ("s" string-rectangle nil)
    ("p" kill-rectangle nil)
    ("o" nil nil))
(global-set-key (kbd "C-x SPC") 'hydra-rectangle/body)

;; eljabber setup for work
;;(setq jabber-account-list (quote (("kbrowne@mpls.digitalriver.com" (:network-server . "mtkcup01.minnetonka.digitalriver.com") (:connection-type . starttls)))))
;;(setq jabber-invalid-certificate-servers (quote ("mpls.digitalriver.com")))
(setq jabber-mode-line-compact t)
(setq jabber-mode-line-mode t)
(setq jabber-roster-show-title nil)
(setq jabber-show-offline-contacts nil)


(when (require 'term nil t)
  (defun term-handle-ansi-terminal-messages (message)
    (while (string-match "\eAnSiT.+\n" message)
      ;; Extract the command code and the argument.
      (let* ((start (match-beginning 0))
	     (command-code (aref message (+ start 6)))
	     (argument
	      (save-match-data
		(substring message
			   (+ start 8)
			   (string-match "\r?\n" message
					 (+ start 8))))))
	;; Delete this command from MESSAGE.
	(setq message (replace-match "" t t message))

	(cond ((= command-code ?c)
	       (setq term-ansi-at-dir argument))
	      ((= command-code ?h)
	       (setq term-ansi-at-host argument))
	      ((= command-code ?u)
	       (setq term-ansi-at-user argument))
	      ((= command-code ?e)
	       (save-excursion
		 (find-file-other-window argument)))
	      ((= command-code ?x)
	       (save-excursion
		 (find-file argument))))))

    (when (and term-ansi-at-host term-ansi-at-dir term-ansi-at-user)
      (setq buffer-file-name
	    (format "%s@%s:%s" term-ansi-at-user term-ansi-at-host term-ansi-at-dir))
      (set-buffer-modified-p nil)
      (setq default-directory (if (string= term-ansi-at-host (system-name))
				  (concatenate 'string term-ansi-at-dir "/")
				(format "/%s@%s:%s/" term-ansi-at-user term-ansi-at-host term-ansi-at-dir))))
        message))

;; show column number in status bar
(setq column-number-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(column-number-mode t)
 '(compilation-message-face (quote default))
 '(current-language-environment "UTF-8")
 '(cursor-type (quote bar))
 '(custom-safe-themes
   (quote
    ("8ec441ce12ad8f5e352ba6852436c7e724c2d1a343feb32ccf3107442b0ee8df" "7cd685de15277d96366f946c709cf51506b0a1ec02a9a21d8f7b3501ff8665e5" "d3b430f3712693fdffe0d76d11f0ae2823df265a02470a71ffaf0878d5873e83" "649ca960922e2176a451db44624bc4dbcd282bc1660d2621793145232f688836" "315eb1a60d4aa4262023e945d78b10f30314d6c66e2c0c2b8bc289481b51073b" "567ae52125f1010f8067a10959bd78c64d431d1db12ccd8ef90e829b3de01ecb" "8e23afd1939fb702db93df19271f48d44b22db8683fa9d1dab87a1f84a6484dc" "5f80e98c0162d217b42b0bf2d60a7002a789c2de693ee283033d4acd7ace3c31" "e6d83e70d2955e374e821e6785cd661ec363091edf56a463d0018dc49fbc92dd" "b6f42c69cf96795c75b1e79e5cd8ca62f9f9a0cb07bf11d1e0b49f97785358f1" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "5a1b191a74fbe85baff36fde163c884bae241f3ca7c54c33908deb1e55a41b30" "b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "758da0cfc4ecb8447acb866fb3988f4a41cf2b8f9ca28de9b21d9a68ae61b181" "11636897679ca534f0dec6f5e3cb12f28bf217a527755f6b9e744bd240ed47e1" "8fed5e4b89cf69107d524c4b91b4a4c35bcf1b3563d5f306608f0c48f580fdf8" "7997e0765add4bfcdecb5ac3ee7f64bbb03018fb1ac5597c64ccca8c88b1262f" "cc60d17db31a53adf93ec6fad5a9cfff6e177664994a52346f81f62840fe8e23" "94ba29363bfb7e06105f68d72b268f85981f7fba2ddef89331660033101eb5e5" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "6615e5aefae7d222a0c252c81aac52c4efb2218d35dfbb93c023c4b94d3fa0db" "211bb9b24001d066a646809727efb9c9a2665c270c753aa125bace5e899cb523" "944f3086f68cc5ea9dfbdc9e5846ad91667af9472b3d0e1e35a9633dcab984d5" "967c58175840fcea30b56f2a5a326b232d4939393bed59339d21e46cf4798ecf" "6b00751018da9a360ac8a7f7af8eb134921a489725735eba663700cebc12fa6f" "159bb8f86836ea30261ece64ac695dc490e871d57107016c09f286146f0dae64" "5e1d1564b6a2435a2054aa345e81c89539a72c4cad8536cfe02583e0b7d5e2fa" "6cfe5b2f818c7b52723f3e121d1157cf9d95ed8923dbc1b47f392da80ef7495d" "6bc195f4f8f9cf1a4b1946a12e33de2b156ce44e384fbc54f1bae5b81e3f5496" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "0bac11bd6a3866c6dee5204f76908ec3bdef1e52f3c247d5ceca82860cccfa9d" default)))
 '(default-input-method "rfc1345")
 '(display-battery-mode t)
 '(display-time-mode t)
 '(fringe-mode 6 nil (fringe))
 '(global-font-lock-mode t nil (font-lock))
 '(linum-format (quote dynamic))
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   (quote
    (org-jira slack jira jira-markup-mode ob-http ob-restclient restclient edit-server pandoc org-bullets org-ehtml org-evil org-mime org-ref orgtbl-aggregate orgtbl-ascii-plot orgtbl-join orgtbl-show-header ox-gfm evil mastodon emojify magit magithub ansible ansible-doc ansible-vault vagrant vagrant-tramp yaml-mode exec-path-from-shell tsdh-ocean shell-pop kaolin-themes kaolin-theme zenburn-theme zen-and-art-theme w3m use-package undo-tree underwater-theme twilight-theme twilight-anti-bright-theme swift-mode subatomic-theme solarized-theme seti-theme sane-term rainbow-mode rainbow-identifiers rainbow-delimiters pastels-on-dark-theme ox-twbs org-pandoc multi-term molokai-theme minesweeper markdown-toc markdown-mode+ lua-mode jumblr json-mode jenkins jabber inkpot-theme inf-ruby hydra httprepl http emoji-display elfeed ecb ebib dired-narrow cyberpunk-theme cherry-blossom-theme chef-mode calmer-forest-theme bbdb ascii apache-mode anti-zenburn-theme)))
 '(save-place t nil (saveplace))
 '(send-mail-function (quote sendmail-send-it))
 '(show-paren-mode t nil (paren))
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(defun org-mml-htmlize (arg)
  "Export a portion of an email body composed using `mml-mode' to html using `org-mode'. If called with an active region only export that region, otherwise export the entire body."
  (interactive "P")
  (let* ((region-p (org-region-active-p))
	 (html-start (or (and region-p (region-beginning))
			 (save-excursion (goto-char (point-min))
					 (search-forward mail-header-separator) (point))))
	 (html-end (or (and region-p (region-end))
		       ;; TODO: should catch signature...
		       (point-max)))
	 (body (buffer-substring html-start html-end))
	 (tmp-file (make-temp-name (expand-file-name "mail" "/tmp/"))) ;; because we probably don't want to skip part of our mail
	 (org-export-skip-text-before-1st-heading nil) ;; because we probably don't want to export a huge style file
	 (org-export-htmlize-output-type 'inline-css) ;; makes the replies with ">"s look nicer
	 (org-export-preserve-breaks t)
	 (html (if arg (format "<pre style=\"font-family: courier, monospace;\">\n%s</pre>\n" body)
		 (save-excursion (with-temp-buffer (insert body) (write-file tmp-file) ;; convert to html -- mimicing `org-run-like-in-org-mode'
						   (eval (list 'let org-local-vars (list 'org-export-as-html nil nil nil ''string t))))))))
    (delete-region html-start html-end)
    (save-excursion (goto-char html-start)
		    (insert (format "\n<#multipart type=alternative>\n<#part type=text/html>%s<#/multipart>\n" html))))
  )
