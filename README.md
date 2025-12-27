# wireshark_plugins
wireshark plugins created by me for training purposes

## plugins

### usb_keyboard_char_map.lua

When capturing USB packets from a keyboard, it 
extracts modifier, scan code and decoded key from "Leftover Capture Data" (usb.capdata) in the USB interrupt messages.

These Items are shown in a subsection USB Keyboard Decoder at the end of the tree

The decoded key is also appended in the Info column

These is a sample capture usb-keyboard.pcapng to verify the function of the plugin.
