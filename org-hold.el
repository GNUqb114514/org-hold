;;; org-hold.el --- A super light alternative to org-capture with declarative locator and customizable feeder. -*- lexical-binding: t; -*-

;; Copyright (C) 2026 qb114514

;; Author: qb114514 <GNUqb114514@outlook.com>
;; Created: 31 Jan 2026;; Version: 0.1.0

;; Package-Requires: ((emacs "27.1") (org "9.5"))
;; Keywords: convenience, files
;; URL: https://github.com/GNUqb114514/org-hold

;; This file is not part of GNU Emacs.

;;; Commentary:
;; See README.org.

;;; Code:

;; Core functionality

(defun org-hold-template (feeder locator)
  "A template.

This function returns a function that calls FEEDER and put its return value to
the place specified by LOCATOR. Specifically, it calls LOCATOR first, which goes
to the right place, and then use `org-paste-subtree' to put the entry returned
by FEEDER as a child of the current point."
  (lambda ()
    (interactive)
    (org-paste-subtree (+ (funcall locator)) (funcall feeder) t)))

(provide 'org-hold)

;;; org-hold.el ends here
