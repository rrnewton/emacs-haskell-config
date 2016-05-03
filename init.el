
;; Standard libraries needed

(require 'cl-lib)


;; Packages and configs to load

(defvar packages
  '(haskell-mode
;    smex
;    magit
    )
  "Packages whose location follows the
  packages/package-name/package-name.el format.")

(defvar custom-load-paths
  '("structured-haskell-mode/elisp"
    "hindent/elisp"
    "git-modes")
  "Custom load paths that don't follow the normal
  package-name/module-name.el format.")

(defvar configs
  '( "global"
     "haskell")
  "Configuration files that follow the config/foo.el file path
  format.")


;; Load packages

(cl-loop for location in custom-load-paths
         do (add-to-list 'load-path
                         (concat (file-name-directory (or load-file-name
                                                          (buffer-file-name)))
                                 "packages/"
                                 location)))

(cl-loop for name in packages
         do (progn (unless (fboundp name)
                     (add-to-list 'load-path
                                  (concat (file-name-directory (or load-file-name
                                                                   (buffer-file-name)))
                                          "packages/"
                                          (symbol-name name)))
                     (require name))))


(require 'hindent)

;; [2016.02.21] Disabling until I can fix problems on my little macbook:
;; e.g.:
;    Configuring descriptive-0.9.4...
;;      setup-Simple-Cabal-1.18.1.5-ghc-7.8.4: /usr/bin/ar: permission denied
(defun load-structured-haskell-mode ()
  "Load required files to enable SHM"
  (interactive)
  (require 'shm)
  (require 'shm-case-split)
  (require 'shm-reformat)

  (define-key shm-map (kbd "C-c C-p") 'shm/expand-pattern)
  (define-key shm-map (kbd "SPC") 'shm-contextual-space)
  (define-key shm-map (kbd "C-\\") 'shm/goto-last-point)
  (define-key shm-map (kbd "C-c C-f") 'shm-fold-toggle-decl)
  (define-key shm-map (kbd "C-c i") 'shm-reformat-decl)

  ; (define-key shm-map (kbd "C-c C-s") 'shm/case-split)

  ;; Note, currently my SHM case-splitting is broken [2015.04.20].
  ;; Making ghc-mod case-splitting primary...
  (define-key shm-map (kbd "C-c C-s") 'ghc-case-split)

  (custom-set-faces
   '(shm-quarantine-face ((t (:inherit font-lock-error))))
   '(shm-current-face ((t (:background "#efefef")))))

  ;; Hack: we could enable it for subsequent buffers once it is turned on:
  ; (add-hook 'haskell-mode-hook 'structured-haskell-mode)
  ; (add-hook 'haskell-interactive-mode-hook 'structured-haskell-repl-mode)
  )

;; Emacs configurations

(cl-loop for name in configs
         do (load (concat (file-name-directory load-file-name)
                          "config/"
                          name ".el")))


;; Mode initializations

; (smex-initialize)
(turn-on-haskell-simple-indent)
(load "haskell-mode-autoloads.el")
