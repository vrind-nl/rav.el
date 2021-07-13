;;; rav.el --- Generate unique passwords  -*- lexical-binding: t; -*-

;; Copyright (C) 2021 https://dwim.nl

;; Author: Vrind <vrind@dwim.nl>
;; Created: July 13, 2021
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.1"))
;; Keywords: convenience
;; URL: https://github.com/vrind-nl/rav.el

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Generate a hash for user input, e.g. site name and password.

;;; Code:


;;; Customization

(defgroup rav nil
  "Generate random passwords"
  :prefix "rav-"
  :group 'convenience)


(defcustom rav-length 16 "Length of generated password"
  :group 'rav
  :type 'integer)


;;; Utilities

(defun rav-decode-hex-string (hex-string)
  "Convert HEX string to ASCII string"
  ;; as per https://stackoverflow.com/questions/12003231/how-do-i-convert-a-string-of-hex-into-ascii-using-elisp
  (let ((res nil))
    (dotimes (i (/ (length hex-string) 2) (apply #'concat (reverse res)))
      (let ((hex-byte (substring hex-string (* 2 i) (* 2 (+ i 1)))))
        (push (format "%c" (string-to-number hex-byte 16)) res)))))


(defun rav-b64_md5 (s)
  "Returns an base64 encoded MD5 hash of s"
  ;; Replica of http://pajhome.org.uk/crypt/md5/
  (base64-encode-string
   (rav-decode-hex-string (secure-hash 'md5 (downcase s)))))


;; Interactive functions

;;;###autoload
(defun rav-hash ()
  "Get hash for user values and put in kill ring"
  (interactive)
  (let ((all "") (val "dummy"))
    (while (not (string= val ""))
      (setq val (read-passwd "Value (RET to end): " nil ""))
      (setq all (concat all val)))
    (setq pwd (substring (rav-b64_md5 all) 0 rav-length))
    (kill-new pwd)
    (message "Result %s is in kill-ring" pwd)))

(provide 'rav)
;;; rav.el ends here
