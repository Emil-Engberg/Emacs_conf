(when (eq system-type 'darwin)
  (setq mac-right-option-modifier 'none)
  (getenv "PATH")
 (setenv "PATH"
(concat
 "/Library/TeX/texbin" ":"

(getenv "PATH"))))
