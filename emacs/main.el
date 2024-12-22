(let* ((current-file (or load-file-name buffer-file-name))
       (current-dir (file-name-directory current-file))
       (el-files (directory-files current-dir t "\\.el$")))
  (dolist (file el-files)
    (unless (equal file current-file)
      (load file))))

;; Still explicitly require any specific features needed
(require 'ray-info)
