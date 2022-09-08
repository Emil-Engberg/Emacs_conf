(add-hook 'flymake-mode-hook
	  (lambda()
	    (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
	    (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)))
