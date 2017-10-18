;;;; tmux.asd

(asdf:defsystem #:tmux
  :description "Describe tmux here"
  :author "Wojciech Gac <wojciech.s.gac@gmail.com>"
  :license "Specify license here"
  :depends-on (:cl-ppcre)
  :serial t
  :components ((:file "package")
               (:file "tmux")))

