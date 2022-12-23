(defun part () (parse-integer (nth 2 sb-ext:*posix-argv*)))
(defun not-yet-implemented (part)
  (if (= part 1)
    "Part 1 not yet implemented"
    "Part 2 not yet implemented"))

(format t (not-yet-implemented (part)))
(terpri)
