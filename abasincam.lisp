;;;; abasincam.lisp

(in-package #:abasincam)

;;; "abasincam" goes here. Hacks and glory await!


(defun download-image (url idx)
  (let*
      ((outfname (format nil "lisp_images/~6,'0d.jpg" idx))
       (instream (drakma:http-request url :want-stream t :force-binary t))
       (buf (make-array 4096 :element-type (stream-element-type instream))))
    (with-open-file (outstream outfname
                               :direction :output
                               :if-exists :supersede
                               :element-type '(unsigned-byte 8))
                    (loop for pos = (read-sequence buf instream)
                          while (plusp pos) do
                          (write-sequence buf outstream :end pos)))))

;; "http://www.arapahoebasin.com/ABasin/assets/images/webcams/webcam5/abasincam5.jpg"
;; (let ((cnt 0))
;;   (multiple-value-bind
;;       (second minute hour date month year day-of-week dst-p tz)
;;       (get-decoded-time)
;;     (if (and (> hour 7) (and (< hour 17) (< minute 5)))
;;         (progn
;;           (download-image "http://www.arapahoebasin.com/ABasin/assets/images/webcams/webcam5/abasincam5.jpg" cnt)
;;           (setf cnt (+ cnt 1)))
      
;;       (if (and (= hour 17) (> minute 5))
;;           (let ((command (format nil "ffmpeg -i lisp_images/%6d.jpg -r 30 -b:v 8000k ~2,'0d-~2,'0d-~d.mpg" month date year)))
                
            
 
;;             (sleep (* 5 60))
;;             )))))
