(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(setq  x-meta-keysym 'super
       x-super-keysym 'meta)

(tool-bar-mode -1)

(load "~/.emacs.d/xclip.el")
(require 'xclip)
(xclip-mode 1)

(require 'package)
(setq package-archives
      '(;;("GNU ELPA" . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA" . "https://melpa.org/packages/"))
      package-archive-priorities
      '(;;("GNU ELPA" . 10)
        ("MELPA Stable" . 5)
        ("MELPA" . 0)))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(mapc 'package-install '(evil avy helm-ag zenburn-theme))

(require 'evil)
(evil-mode 1)

(global-set-key (kbd "C-\\") 'avy-goto-word-0)

(load-theme 'zenburn t)

;; set transparency
(defun on-frame-open (&optional frame)
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))

(add-hook 'after-make-frame-functions 'on-frame-open)

