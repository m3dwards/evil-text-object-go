# evil-text-object-go.el

## Overview

This Emacs package (`evil-text-object-go`) extends Evil (`evil-mode`) with text objects that
operate on Python functions.

`evil-text-object-inner-go-function` is the 'inner' text object that selects the actual code of the current function(s)

`evil-text-object-outer-go-function` is the 'outer' text object that selects the current function(s) and surrounding whitespace.

The default key bindings are `if` and `af`, which can be memorised as 'inner function' and 'a function'.

## Installation

### Emacs

Install from Melpa:

`M-x package-install RET evil-text-object-go RET`

Then add this to `init.el`:

```elisp
(add-hook 'go-mode-hook 'evil-text-object-go-add-bindings)
```

### Spacemacs



Note that the implementation uses various Go navigation commands provided by `go-mode`.


## Customisation


The default key binding uses the letter `f` (`if` and `af`), but can be customised by changing `evil-text-object-go-statement-key`.
For example:

```elisp
(setq evil-text-object-go-statement-key "x")
```

Alternatively, use the Customize interface:

`M-x customize-group RET evil-text-object-go RET`
