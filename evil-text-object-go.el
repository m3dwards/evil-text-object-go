(require 'evil)
(require 'go-mode)

(defgroup evil-text-object-go nil
  "Evil text objects for Go"
  :prefix "evil-text-object-go-"
  :group 'evil)

  (defcustom evil-text-object-go-function-key "f"
  "Key to use for a Go function in the text object maps."
  :type 'string
  :group 'evil-text-object-go)


(defun evil-text-object-go--detect-key(containing-map child)
  "Detect which key in CONTAINING-MAP maps to CHILD."
  ;; Note: this only uses the single match.
  (key-description (car (where-is-internal child containing-map))))

(defun evil-text-object-go--define-key (key text-objects-map text-object)
  "Bind KEY in TEXT-OBJECTS-MAP to TEXT-OBJECT."
  ;; Note: this only defines keys in local keymaps and does not change
  ;; the global text object maps. First detect the prefixes used in
  ;; the global maps (defaults are "i" for the inner text objects map,
  ;; and "a" for the outer text objects map), and use the same prefix
  ;; for the local bindings.
  (define-key evil-operator-state-local-map
    (kbd (format "%s %s" (evil-text-object-go--detect-key evil-operator-state-map text-objects-map) key))
    text-object)
  (define-key evil-visual-state-local-map
    (kbd (format "%s %s" (evil-text-object-go--detect-key evil-visual-state-map text-objects-map) key))
    text-object))

(defun evil-text-object-go--make-func-text-object (count type)
  "Helper to make text object for COUNT Go statements of TYPE."
  (let ((beg (save-excursion
               (go-beginning-of-defun)
               (when (or (eq this-command 'evil-delete) (eq type 'line))
                 (previous-line)
                 (end-of-line))
               (point)))
        (end (save-excursion
               (--dotimes (1- count)
                 (go-end-of-defun)
                 (forward-line))
               (go-beginning-of-defun)
               (go-end-of-defun)
               (when (eq type 'line)
                 (forward-line))
               (point))))
    (evil-range beg end)))

;;;###autoload (autoload 'evil-text-object-go-function "evil-text-object-go" nil t)
(evil-define-text-object evil-text-object-go-function (count &optional beg end type)
  "Inner text object for the Go statement under point."
  (evil-text-object-go--make-func-text-object count type))

;;;###autoload (autoload 'evil-text-object-go-function "evil-text-object-go" nil t)
(evil-define-text-object evil-text-object-outer-go-function (count &optional beg end type)
  "Inner text object for the Go statement under point."
  :type line
  (evil-text-object-go--make-func-text-object count type))

;;;###autoload
(defun evil-text-object-go-add-bindings ()
  "Add text object key bindings.
This function should be added to a major mode hook.  It modifies
buffer-local keymaps and adds bindings for Go text objects for
both operator state and visual state."
  (interactive)
  (when evil-text-object-go-function-key
    (evil-text-object-go--define-key
     evil-text-object-go-function-key
     evil-inner-text-objects-map
     'evil-text-object-go-function)
    (evil-text-object-go--define-key
     evil-text-object-go-function-key
     evil-outer-text-objects-map
     'evil-text-object-outer-go-function)))

(provide 'evil-text-object-go)
