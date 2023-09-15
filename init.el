(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(nix-mode company auctex switch-window multi-term pdf-tools magit general doom-themes all-the-icons counsel helpful ivy-rich which-key rainbow-delimiters doom-modeline use-package ivy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq inhibit-startup-message t)
(if (display-graphic-p)
    (progn
      (scroll-bar-mode -1)
      (set-fringe-mode 10)))
(tool-bar-mode -1)
(tooltip-mode -1)

(scroll-bar-mode -1)
(setq split-width-threshold 1 )

(menu-bar-mode -1)

(setq visible-bell t)
(set-face-attribute 'default nil :height 120)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa". "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))


(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package all-the-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-dely 0.3))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind 
 ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(global-set-key (kbd "C-<tab>") 'dabbrev-expand)
(define-key minibuffer-local-map (kbd "C-<tab>") 'dabbrev-expand)

(load "~/.emacs.d/language/c.el")
(load "~/.emacs.d/flymake/flymake.el")
(load "~/.emacs.d/os/mac.el")
(load "~/.emacs.d/language/tex.el")

(use-package switch-window
  :ensure t
  :bind
  ;; default C-x o is other-window
  ;; default C-x C-o is delete-blank-lines
  (("C-x o" . switch-window)
   ("C-x C-o" . switch-window))
  :config
  (setq switch-window-multiple-frames t)
  (setq switch-window-shortcut-style 'qwerty)
  ;; when Emacs is run as client, the first shortcut does not appear
  ;; "x" acts as a dummy; remove first entry if not running server
  (setq switch-window-qwerty-shortcuts '("a" "s" "d" "f" "j" "k" "l" "ö" "w" "e" "r" "u" "i" "o" "q" "t" "y" "p"))
  (setq switch-window-increase 3))

(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)
(setq switch-window-multiple-frames t)

(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)
(display-battery-mode 1)
(require 'exwm)
(require 'exwm-config)

(unless (get 'exwm-workspace-number 'saved-value)
    (setq exwm-workspace-number 4))
  ;; Make class name the buffer name
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))
  ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
    (setq exwm-input-global-keys
          `(
            ;; 's-r': Reset (to line-mode).
            ([?\s-r] . exwm-reset)
            ;; 's-w': Switch workspace.
            ([?\s-w] . exwm-workspace-switch)
            ;; 's-&': Launch application.
            ([?\s-d] . (lambda (command)
                         (interactive (list (read-shell-command "$ ")))
                         (start-process-shell-command command nil command)))
            ;; 's-N': Switch to certain workspace.
            ,@(mapcar (lambda (i)
                        `(,(kbd (format "s-%d" i)) .
                          (lambda ()
                            (interactive)
                            (exwm-workspace-switch-create ,i))))
                      (number-sequence 0 9)))))
  ;; Line-editing shortcuts
  (unless (get 'exwm-input-simulation-keys 'saved-value)
    (setq exwm-input-simulation-keys
          '(([?\C-b] . [left])
            ([?\C-f] . [right])
            ([?\C-p] . [up])
            ([?\C-n] . [down])
            ([?\C-a] . [home])
            ([?\C-e] . [end])
            ([?\M-v] . [prior])
            ([?\C-v] . [next])
            ([?\C-d] . [delete])
            ([?\C-k] . [S-end delete]))))
  ;; Enable EXWM
  (exwm-enable)

(defun checkname (name)
  "Return true if the system we are running on is the same as name"
  (or
    (string-equal system-name name)
    (string-equal system-name (concat name ".lan"))
    ))
(require 'exwm-randr)
(if (checkname "arch-desktop")
    (progn
      (setq exwm-randr-workspace-output-plist '(0 "DP-1" 1 "DP-3" 2 "HDMI-3"))
      (add-hook 'exwm-randr-screen-change-hook
		(lambda ()
		  (start-process-shell-command
		   "xrandr" nil "xrandr --output DP-3 --mode 1920x1080 --rate 165 --left-of DP-1 --left-of HDMI-3 --auto")))
      (exwm-randr-enable)))

(require 'exwm-systemtray)
(exwm-systemtray-enable)

(defun pavucontrol ()
  (interactive)
  (call-process-shell-command "pavucontrol" nil 0))


(defun lowervolume ()
    (interactive)
  (call-process-shell-command "pactl set-sink-volume @DEFAULT_SINK@ -5%" nil 0))

(defun raisevolume ()
    (interactive)
  (call-process-shell-command "pactl set-sink-volume @DEFAULT_SINK@ +5%" nil 0))

(defalias 'terminal
  (kmacro "C-x 3 M-x other-window <return> M-x a n s i - t e r m <return> <return>"))

(defalias 'close-program
   (kmacro "C-x k <return> C-x 0"))

(exwm-input-set-key (kbd "C-c p") 'pavucontrol)
(exwm-input-set-key (kbd "s-<return>") 'terminal)
(exwm-input-set-key (kbd "s-q") 'close-program)
(exwm-input-set-key (kbd "<XF86AudioRaiseVolume>") 'raisevolume)

(exwm-input-set-key (kbd "<XF86AudioLowerVolume>") 'lowervolume)
