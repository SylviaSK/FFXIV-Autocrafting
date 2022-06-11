# FFXIV-Autocrafting
An AHK script to manage lengthy macros with ease


Current Hotkeys:<br>
================<br>
Numpad3 lets you write in whether the macro will loop indefinitely, or for a set number of times before automatically stopping<br>
Numpad4 lets you write in new commands on the fly without relaunching the entire script
i.e. putting in `=, 2000, =, 2000,[, 500,,,100` would setup Numpad5 to send on repeat:<br>
`=, followed by a 2s delay`<br>
`=, followed by a 2s delay`<br>
`\[ followed by a .5s delay`<br>
`, followed by a .1s delay`<br>
(spaces make no difference)

Numpad5 starts looping through the command from Numpad4, for the number of times specified via Numpad3 (defaults to indefinetly(
Numpad6 stops the loop effectively immediately (i.e. no more keys will be pressed)

Numpad7 starts a timer, and pressing it again pops up a window with the time between presses in ms 
