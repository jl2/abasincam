;;;; abasincam.asd

(asdf:defsystem #:abasincam
  :serial t
  :depends-on (#:drakma)
  :components ((:file "package")
               (:file "abasincam")))

