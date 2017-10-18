;;;; tmux.lisp

(in-package #:tmux)

;;; "tmux" goes here. Hacks and glory await!

(defun list-sessions (&key details)
  (mapcar
   #'(lambda (s)
       (if details
           (cl-ppcre:split ": *" s :limit 2)
           (list s)))
   (split-string
    (string-trim '(#\newline)
                 (run-shell-command
                  (format nil "tmux list-sessions~:[ -F \"#S\"~;~]" details) t)))))

(defun list-windows (&key details (session (select-session-from-menu)))
  (mapcar
   #'(lambda (w)
       (if details
           (cl-ppcre:split ": *" w :limit 2)
           (list w)))
   (split-string
    (string-trim '(#\newline)
                 (run-shell-command
                  (format nil
                          "tmux list-windows -t ~a~:[ -F \"#I\"~;~]"
                          session details) t)))))

(defun list-panes (&key details
                     (session (select-session-from-menu))
                     (window (select-window-from-menu :session session)))
  (mapcar
   #'(lambda (p)
       (if details
           (cl-ppcre:split ": *" p :limit 2)
           (list p)))
   (split-string
    (string-trim '(#\newline)
                 (run-shell-command
                  (format nil
                          "tmux list-panes -t ~a~:[ -F \"#P\"~;~]"
                          window details) t)))))

(defun select-session-from-menu ()
  (let* ((sessions (list-sessions :details t))
         (sessions* (mapcar (lambda (s)
                              (cons (format nil "~a: ~a" (first s) (second s))
                                    (first s))) sessions)))
    (cdr (select-from-menu (current-screen) sessions* "Session: "))))

(defun select-window-from-menu (&key (session (select-session-from-menu)))
  (let* ((windows (list-windows :details t :session session))
         (windows* (mapcar (lambda (w)
                              (cons (format nil "~a: ~a" (first w) (second w))
                                    (first w))) windows)))
    (format nil "~a:~a" session
            (cdr (select-from-menu (current-screen) windows* "Window: ")))))

(defun select-pane-from-menu (&key
                                (session (select-session-from-menu))
                                (window (select-window-from-menu :session session)))
  (let* ((panes (list-panes :details t :session session :window window))
         (panes* (mapcar (lambda (p)
                              (cons (format nil "~a: ~a" (first p) (second p))
                                    (first p))) panes)))
    (format nil "~a:~a.~a" session window
            (cdr (select-from-menu (current-screen) panes* "Pane: ")))))



(defun run-command-in-tmux (&key
                              (session (select-session-from-menu))
                              (window )
                              (pane)))
