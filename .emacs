;; create an invisible backup directory and make the backups also invisible
(defun make-backup-file-name (filename)
  (defvar backups-dir "./.backups/")
  (make-directory backups-dir t)
  (expand-file-name
   (concat backups-dir "." (file-name-nondirectory filename) "~")
   (file-name-directory filename)))  

(defmacro def-interactive (name args  &rest body)
  "Used to define interactive functions, use like defun."
  (if (stringp (car body))
  `(defun ,name ,args ,(car body) (interactive)  ,@(cdr body))
  `(defun ,name ,args (interactive) ,@body)))

(defmacro def-shortcut-point-mark (short-name name &rest args)
  "Define shortcuts for M-x commands operating on region with the syntax:
    (def-shortcut-point-mark shortcut-name long-name [optional args on top of point and mark])"
  `(def-interactive ,short-name () ,(concat "shortcut for " (symbol-name name))
     (,name (min (point) (mark)) (max (point) (mark)) ,@args)))
 
(def-shortcut-point-mark ir indent-region nil)
(def-shortcut-point-mark cr comment-region)
(def-shortcut-point-mark ucr uncomment-region) 

(defun increment (&optional sign)
  (interactive)
  (skip-chars-forward "^0-9")
  (let ((beg (point))
       (end (save-excursion
              (skip-chars-forward "0-9")
              (point))))
    (let ((my-number (filter-buffer-substring beg end t)))
      (let ((incr (if (numberp sign) sign 1) ))
        (if (not (eq (length my-number) 0))
            (insert (int-to-string
                     (+ (* incr 1)
                        (string-to-int my-number)))))))))

(defun decrement ()
  (interactive)
  (increment (- 0 1)))

(defun increment-in-region (&optional sign)
  (interactive)
  (let ( (end (max (point) (mark)))
         (beg (min (point) (mark))))
    (goto-char beg)
    (while (< (point) end)
      (let ((incr (if (numberp sign) sign 1)))
        (increment incr)))))

(defun decrement-in-region ()
  (interactive)
  (increment-in-region (- 0 1)))

