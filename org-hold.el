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
the place specified by LOCATOR.  Specifically, it calls LOCATOR first, which
goes to the right place, and then use `org-paste-subtree' to put the entry
returned by FEEDER as a child of the current point."
  (lambda ()
    (interactive)
    (org-paste-subtree (+ (funcall locator)) (funcall feeder) t)))

;; Datetree-related locator helpers

(defun org-hold-locator-monthly-datetree-in (date prev)
  "A locator to the month in format (MONTH DAY YEAR) returned by function DATE in the datetree in PREV."
  (lambda ()
    (let (lvl (funcall prev))
      (org-datetree-find-month-create (funcall date) 'subtree-at-point)
      (+ lvl (* 2 (org-level-increment))))))

(defun org-hold-locator-daily-datetree-in (date prev)
  "A locator to the day in format (MONTH DAY YEAR) returned by function DATE which takes no arguments in the datetree in PREV."
  (lambda ()
    (let (lvl (funcall prev))
      (org-datetree-find-date-create (funcall date) 'subtree-at-point)
      (+ lvl (* 2 (org-level-increment))))))

;; Miscellaneous locator helpers

(defun org-hold-locator-end-of-subtree (prev)
  "A locator to the end of the subtree PREV."
  (lambda ()
    (let (lvl (funcall prev))
      (org-end-of-subtree t)
      lvl)))

(defun org-hold-locator-olp-in (olp prev)
  "A locator to the specified olp OLP in PREV."
  (lambda ()
    (funcall prev)
    (let ((olp-pos (condition-case
		       _
                       (org-find-olp olp t)
                     (error (error "Aborting template expansion: Cannot find OLP")))))
      (goto-char olp-pos)
      (org-current-level))))

(defun org-hold-locator-file (filename)
  "A locator to the file FILENAME in a new window."
  (lambda ()
    (when (string-blank-p filename)
      (error "FILENAME should not be blank"))
    (find-file-other-window filename)))

;; Miscellaneous helper functions

(defun org-hold-decode-time-mdy (time)
  "Decode timestamp TIME to (MONTH DAY YEAR)."
  (let ((lst (decode-time time)))
    (list (nth 4 lst) (nth 3 lst) (nth 5 lst))))

(provide 'org-hold)

;;; org-hold.el ends here
