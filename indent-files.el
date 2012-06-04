;; emacs lisp script to properly indent all files in a directory
;; Usage: Open this file in a convenient buffer and run interactively

(dolist (file (directory-files "./src/" t ".*f90$")) ; Replace with what you want
  (progn 
    (find-file file)
    (indent-region (point-min) (point-max))
    (untabify (point-min) (point-max))
    (save-buffer)
    (kill-buffer)))
