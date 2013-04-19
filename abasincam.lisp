;;;; abasincam.lisp

(in-package #:abasincam)

(defun download-image (url outfname)
  (let*
      ((instream (drakma:http-request url :want-stream t :force-binary t))
       (buf (make-array 4096 :element-type (stream-element-type instream))))
    (with-open-file (outstream outfname
                               :direction :output
                               :if-exists :supersede
                               :element-type '(unsigned-byte 8))
                    (loop for pos = (read-sequence buf instream)
                          while (plusp pos) do
                          (write-sequence buf outstream :end pos)))))

(defun is-between (start-hour start-minute start-second end-hour end-minute  end-second)
  (multiple-value-bind
      (second minute hour date month year day-of-week dst-p tz)
      (get-decoded-time)
    (let ((st (encode-universal-time start-second start-minute start-hour date month year tz))
          (et (encode-universal-time end-second end-minute end-hour date month year tz))
          (ct (encode-universal-time second minute hour date month year tz)))
      (and (> ct st) (< ct et)))))

(defun run-for-day ()
  (let ((count 0))
    (loop while (is-between 7 0 0 17 0 0) do
          (download-image "http://www.arapahoebasin.com/ABasin/assets/images/webcams/webcam5/abasincam5.jpg"
                          (format nil "lisp_images/~6,'0d.jpg" count))
          (setf count (+ count 1))
          (sleep (* 5 60)))))
(defun make-movie ()
  (multiple-value-bind
      (second minute hour date month year)
      (get-decoded-time)
    (run-program "/usr/bin/ffmpeg" '( "-i" "lisp_images/%6d.jpg" "-r" "30" "-b:v" "8000k" (format nil "~2,'0d-~2,'0d-~d.mpg" month date year)))))

(defun go ()
  (run-for-day)
  (make-movie))
