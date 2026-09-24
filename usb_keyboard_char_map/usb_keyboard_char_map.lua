-- MIT License
-- Copyright (c) 2025 Robert Hess 

-- USB Keyboard character map
-- extracts modifier, scan code and decoded key from "Leftover Capture Data" 
-- (usb.capdata) in the USB interrupt messages
do
    local usb_keyboard = Proto("usb_keyboard", "USB Keyboard Decoder")
    
    local f_key = ProtoField.string("usb_keyboard.key", "Decoded Key")
    local f_modifier = ProtoField.uint8("usb_keyboard.modifier", "Modifier", base.HEX)
    local f_scancode = ProtoField.uint8("usb_keyboard.scancode", "Scancode", base.HEX)
    usb_keyboard.fields = {f_key, f_modifier, f_scancode}
    
    local scancodes = {
        [0x04] = "a", [0x05] = "b", [0x06] = "c", [0x07] = "d",
        [0x08] = "e", [0x09] = "f", [0x0A] = "g", [0x0B] = "h",
        [0x0C] = "i", [0x0D] = "j", [0x0E] = "k", [0x0F] = "l",
        [0x10] = "m", [0x11] = "n", [0x12] = "o", [0x13] = "p",
        [0x14] = "q", [0x15] = "r", [0x16] = "s", [0x17] = "t",
        [0x18] = "u", [0x19] = "v", [0x1A] = "w", [0x1B] = "x",
        [0x1C] = "y", [0x1D] = "z",
        [0x1E] = "1", [0x1F] = "2", [0x20] = "3", [0x21] = "4",
        [0x22] = "5", [0x23] = "6", [0x24] = "7", [0x25] = "8",
        [0x26] = "9", [0x27] = "0",
        [0x28] = "Enter", [0x29] = "Esc", [0x2A] = "Backspace",
        [0x2B] = "Tab", [0x2C] = "Space"
    }
    
    -- Get reference to the USB leftover capture data field
    local usb_capdata_field = Field.new("usb.capdata")
    
    function usb_keyboard.dissector(buffer, pinfo, tree)
        -- Extract the leftover capture data field
        local capdata = usb_capdata_field()
        
        if not capdata then
            return
        end
        
        local kbd_data = capdata.range
        
        -- Check if we have at least 8 bytes (keyboard report size)
        if kbd_data:len() < 8 then
            return
        end
        
        local subtree = tree:add(usb_keyboard, kbd_data)
        local modifier = kbd_data(0,1):uint()
        local key = kbd_data(2,1):uint()
        
        subtree:add(f_modifier, kbd_data(0,1))
        subtree:add(f_scancode, kbd_data(2,1))
        
        if key > 0 and scancodes[key] then
            local keystr = scancodes[key]
            if modifier == 0x02 or modifier == 0x20 then
                keystr = string.upper(keystr)
            end
            subtree:add(f_key, keystr)
            pinfo.cols.info:append(" [" .. keystr .. "]")
        end
    end
    
    -- Register as a postdissector
    register_postdissector(usb_keyboard)
end
