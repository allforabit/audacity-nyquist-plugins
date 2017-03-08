;nyquist plug-in
;version 3
;type generate
;categories "http://lv2plug.in/ns/lv2core#HighpassPlugin"
;name "Sample Data Import..."
;action "Generating audio..."
;info "by Steve Daulton (www.easyspacepro.com)\nReleased under GPL v2.\n"

;; by Steve Daulton June 2012
;; Released under terms of the GNU General Public License version 2:
;; http://www.gnu.org/licenses/old-licenses/gpl-2.0.html .

;control file "Input file" string "" "" 

;;; Read data from text file
(defun get-data ()
  (let (result)
    (setq fp (open file :direction :input))
    (do ((val (read-line fp)(read-line fp)))
       ((not val))
      (setq val (read (make-string-input-stream val)))
      (setf result (push (/ val 44100) result)))
    (close fp)
    (reverse result)))

; populate list with data
(setq mylist (get-data))

; set LEN so that we get a progress bar
(setq len (length mylist))

(setq myclass (send class :new '(val)))

(send myclass :answer :next '()
  '((if (not (boundp 'num))
    (setq num 0)
    (setq num (1+ num)))
  (setq val (nth num mylist))))

(defun sound-from-text ()
  (let (myobject)
    (setf myobject (send myclass :new))
  (snd-fromobject 0 *sound-srate* myobject)))

(sound-from-text)