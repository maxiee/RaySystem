(provide 'ray-info)

(defun ray-info-buffer ()
  (get-buffer-create "*ray-info*"))

(defun ray-info ()
  "Enter RayInfo."
  (interactive)
  (switch-to-buffer (ray-info-buffer))
  )

(defvar ray-info-site-list
  '((:name "Google" :url "https://www.google.com")
    (:name "Emacs" :url "https://www.gnu.org/software/emacs/")
    (:name "Example" :url "https://example.com"))
  "List of Websites, each element is a plist: (:name NAME :url URL).")

(defun ray-info-site--build-entries ()
  "Build `'tabulated-list-entries' from `ray-info-site-list'."
  (mapcar (lambda (site)
	    (let ((name (plist-get site :name))
		  (url (plist-get site :url)))
	      (list site (vector name url))))
	  ray-info-site-list))

(defun ray-info-site-refresh ()
  "Refresh the website list in the buffer."
  (interactive)
  (setq tabulated-list-entries (ray-info-site--build-entries))
  (tabulated-list-print t))

(defun ray-info-site-add-site (name url)
  "Add a new site with NAME and URL to `ray-info-site-list'."
  (push (list :name name :url url) ray-info-site-list)
  (ray-info-site-refresh))

(defun ray-info-site-edit-site (site new-name new-url)
  "Edit SITE to have NEW-NAME and NEW-URL."
  (setf (plist-get site :name) new-name)
  (setf (plist-get site :url) new-url)
  (ray-info-site-refresh))

(defun ray-info-site-delete-site (site)
  "Delete SITE from `ray-info-site-list'."
  (setq ray-info-site-list (delq site ray-info-site-list))
  (ray-info-site-refresh))

(defun ray-info-site--current-site ()
  "Return the site data of the current line."
  (let* ((entry (tabulated-list-get-entry))
	 (site (tabulated-list-get-id)))
    site))

(defun ray-info-site-add-command ()
  "Command to add a new site."
  (interactive)
  (let ((name (read-string "Enter site name: "))
	(url (read-string "Enter site URL: ")))
    ;; 未来扩展点：可在此增加一轮对频道（Channel）的选择或者创建交互
    (ray-info-site-add-site name url)))

(defun ray-info-site-edit-command ()
  "Command to edit the current site."
  (interactive)
  (let ((site (ray-info-site--current-site)))
    (unless site
      (error "No site selected"))
      (let ((new-name (read-string "Enter new site name: " (plist-get site :name)))
	    (new-url (read-string "Enter new site url: " (plist-get site :url))))
	;;未来扩展点，可在此编辑频道信息
	(ray-info-site-edit-site new-name new-url))))

(defun ray-info-site-delete-command ()
  "Command to delete the current site."
  (interactive)
  (let ((site (ray-info-site--current-site)))
    (unless site
      (error "No site selected"))
    (when (y-or-n-p (format "Delete site '%s'?" (plist-get site :name)))
      (ray-info-site-delete-site site))))

(defvar ray-info-site-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "c") 'ray-info-site-add-command)
    (define-key map (kbd "e") 'ray-info-site-edit-command)
    (define-key map (kbd "d") 'ray-info-site-delete-command)
    (define-key map (kbd "q") 'kill-current-buffer)
    map)
  "Keymap for `ray-info-site-mode'.")

(define-derived-mode ray-info-site-mode tabulated-list-mode "Ray-Info-Site"
  "Major mode for viewing and managing a list of websites."
  (setq tabulated-list-format [("Name" 20 t)
			       ("URL" 40 t)])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Name" nil))
  (hl-line-mode 1)
  (ray-info-site-refresh))

;;;###autoload
(defun ray-info-site ()
  "Open the Ray Info Site management buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*Ray Info Site*"))
  (ray-info-site-mode))

(provide 'ray-info-site)
