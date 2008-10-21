(in-package :parser-combinator)

(defun memoize? (p)
  "Create identical, but memoized, parser"
  (let ((memo-table (make-hash-table)))
    #'(lambda (inp)
	(let ((result (gethash inp memo-table :first-time-called)))
	  (if (eql result :first-time-called)
	      (copy-list (setf (gethash inp memo-table)
			       (funcall p inp)))
	      (copy-list result))))))

(defun left-recursive? (p)
  (let ((memo-table (make-hash-table))
	(count-table (make-hash-table))
	(length-table (make-hash-table)))
    #'(lambda (inp)
	(unless (gethash inp length-table)
	  (setf (gethash inp length-table) (length inp)))
	(incf (gethash inp count-table 0))
	(if (> (print (1+ (gethash inp count-table)))
	       (print (gethash inp length-table)))
	    nil
	    (let ((result (gethash inp memo-table :first-time-called)))
	      (if (eql result :first-time-called)
		  (copy-list (setf (gethash inp memo-table)
				   (funcall p inp)))
		  (copy-list result))))))
  )