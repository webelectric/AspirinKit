# AspirinKit
A set of extensions and classes used to reduce headaches in iOS/macOS/tvOS development

## Status

Additions in progress!

## Quickdocs

At the moment the most useful class is (perhaps) `Keyboard` which supports both in-app and global hotkey registration and wraps some of the Carbon APIs for keyboard/hotkey control with a friendlier interface.

It also includes a pure Swift 3 implementation of global hotkeys, which I haven't yet found elsewhere.

```
        let cmdShiftSpaceCombo = Keyboard.KeyCombo(keyCode: Keyboard.Keys.Space,
                                                    modifierFlags: [.command, .shift])

        //register (bind) global keycombo
        Keyboard.sharedKeyboard.bindGlobalKeyCombo(cmdShiftSpaceCombo, action: { [unowned self] (keyCombo:Keyboard.KeyCombo, event: NSEvent?) -> Void  in

                print("CMD-Shift-Space pressed")
        })

        ....


        //deregister (unbind) global keycombo
        Keyboard.sharedKeyboard.unbindGlobalKeyCombo(cmdShiftSpaceCombo1)


    ```
