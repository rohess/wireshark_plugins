# wireshark_plugins
wireshark plugins created by me for training purposes

## plugins

### usb_keyboard_char_map.lua

When capturing USB packets in Linux from a keyboard, it 
extracts modifier, scan code and decoded key from "Leftover Capture Data" (usb.capdata) in the USB interrupt messages.

In order to see USB interfaces for capture in Wireshark run
```
sudo modprobe usbmon
```
These Items are shown in a subsection USB Keyboard Decoder at the end of the tree

The decoded key is also appended in the Info column

These is a sample capture usb-keyboard.pcapng to verify the function of the plugin.

Plugin verified with capture on CPD3 laptop/Ubuntu analysed in Wireshark 4.6.2 on MacOS Tahoe
