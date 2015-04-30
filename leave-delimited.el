;;; leave-delimited.el --- Leave a string or paren/brace/bracket

;; Copyright (C) 2015  Andreas Roehler

;; Author: Andreas Roehler <andreas.roehler@online.de>
;; Keywords: lisp, convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(setq ar-leave-delimited-test-code
  "{
\"name\": \"api\",
\"version\": \"0.3.0\",
\"author\": {
\"name\": \"A A A\",
\"email\": \"k@gmail.com\"
},
\"description\": \"A json wrapper AsdfI\",
\"repository\": {
\"type\": \"git\",
\"url\": \"https://github.com/k/a.git\"
},
\"contributors\": [
{
\"name\": \"AsdfHðar\",
\"email\": \"a@gmail.com\"
},
{
\"name\": \"AsdfR Þór AsdfV (rthor)\",
\"email\": \"k@gmail.com\",
\"url\": \"http://k.is\"
},
{
\"name\": \"A M A\",
\"email\": \"m@gmail.com\"
},
{
\"name\": \"AsdfB D AsdfV (benediktvaldez)\",
\"email\": \"s@gmail.com\",
\"url\": \"http://info\"
},
{
\"name\": \"A A (k)\",
\"email\": \"k@gmail.com\",
\"url\": \"https://k.com\"
}
],
\"dependencies\": {
\"file\": \"~0.2.1\",
\"isn2wgs\": \"0.0.2\",
\"underscore\": \"~1.5.2\",
\"moment\": \"~2.1.0\",
\"xml2js\": \"~0.2.8\",
\"request\": \"~2.27.0\",
\"redis\": \"~0.8.4\",
\"xregexp\": \"~2.0.0\",
\"cheerio\": \"~0.12.4\",
\"mocha\": \"~1.15.1\",
\"express\": \"~3.20.1\",
\"apis-helpers\": \"0.0.1\"
},
\"scripts\": {
\"test\": \"node_modules/mocha/bin/mocha test/integration\",
\"coveralls\": \"exit 0\"
}
}
")

(ert-deftest ar-leave-delimited-forward-ert-test ()
  ""
  (with-temp-buffer
    (insert ar-leave-delimited-test-code)
    (switch-to-buffer (current-buffer))
    (js-mode)
    (font-lock-fontify-buffer)
    (goto-char (point-min))
    (search-forward "ðar")
    (ar-leave-delimited-forward)
    (should (eq (char-after) ?,))
    (ar-leave-delimited-forward)
    (should (eq (char-after) ?,))
    (ar-leave-delimited-forward)
    (should (eq (char-after) ?,))
    (should (eq (char-before) ?\]))
    (ar-leave-delimited-forward)
    (should (eq (char-after) 10))
    (should (eq (point) (1- (point-max)))) ))

(ert-deftest ar-leave-delimited-backward-ert-test ()
  ""
  (with-temp-buffer
    (insert ar-leave-delimited-test-code)
    (switch-to-buffer (current-buffer))
    (js-mode)
    (goto-char (point-min))
    (search-forward "ðar")
    (ar-leave-delimited-backward)
    (should (eq (char-after) 32))
    (ar-leave-delimited-backward)
    (should (eq (char-after) 10))
    (ar-leave-delimited-backward)
    (should (eq (char-after) 32))
    (ar-leave-delimited-backward)
    (should (eq (char-after) ?{))
    (should (eq (point) (point-min)))))

(defun ar-beginn-of-delimited ()
  "Go to beginn of a string or parentized/braced/bracketed. "
  (let ((pps (parse-partial-sexp (point-min) (point))))
    (cond
     ((nth 3 pps)
      (goto-char (nth 8 pps)))
     ((nth 1 pps)
      (goto-char (nth 1 pps))))))

(defun ar-leave-delimited-backward ()
  "Go one char beyond string, paren, bracket etc. "
  (interactive)
  (ar-beginn-of-delimited)
  (unless (bobp) (forward-char -1)))

(defun ar-leave-delimited-forward ()
  "Go one char beyond string, paren, bracket etc. "
  (interactive)
  (ar-beginn-of-delimited)
  (forward-sexp))

(provide 'leave-delimited)
;;; leave-delimited.el ends here
