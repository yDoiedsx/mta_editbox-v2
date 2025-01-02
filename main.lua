Inputs = {};
Inputs.__index = Inputs;

function Inputs.new (properties)
    local self = setmetatable ({}, Inputs);

    self.number = false;
    self.focus = false;
    
    self.lctrl = false;
    self.mask = false;

    self.x = 0;
    self.y = 0;
    self.width = 0;
    self.height = 0;

    self.length = 0;

    self.font = 'default';
    self.text = '';

    self.keys = {};

    self.search = false;

    for i in pairs ({ arrow_l = true, arrow_r = true, backspace = true, delete = true, enter = true }) do
        self.keys[i] = {
            state = false,
            last = 0
        }
    end;

    for i, k in pairs (properties) do
        self[i] = k
    end;

    self.tick = getTickCount ();

    self.current = 0;
    
    self.events = {
        click = function (...)
            return self:click (...)
        end;

        key = function (...)
            return self:key (...)
        end;

        character = function (...)
            return self:character (...)
        end;

        paste = function (...)
            return self:paste (...)
        end;
    };

    addEventHandler ('onClientKey', root, self.events.key);
    addEventHandler ('onClientPaste', root, self.events.paste);
    addEventHandler ('onClientCharacter', root, self.events.character);
    addEventHandler ('onClientClick', root, self.events.click, true, 'high');

    return self;
end;

function Inputs:render (place, x, y, width, height, colors, post, wordbreak)
    cursor:update ();

    if (cursor:box (x, y, width, height)) then
        self.hover = true
    else
        self.hover = false
    end

    self.wordbreak = wordbreak

    local text = place
    local color = colors.place

    local side = 'left'

    if (self.text ~= '') then
        if (self.focus) then
            color = colors.text
        end
        
        text = self.text
        
        if (self.mask) then
            local mask = '*'

            text = mask:rep (utf8.len (self.text))
        end
    end

    local text_w, text_h = dxGetTextSize (text, width, 1, self.font, wordbreak);
    
    local text_current_w = dxGetTextWidth (utf8.sub (text, 1, self.current), 1, self.font)
    local _, text_current_h = dxGetTextSize (utf8.sub (text, 1, self.current), width, 1, self.font, wordbreak)

    local rectangle_h = dxGetFontHeight (1, self.font);

    if (not wordbreak) then
        if (text_current_w > width and text_current_w < text_w) then
            text = string.sub (text, 1, self.current)
        end

        if (x + text_current_w > x + width) then
            side = 'right'
        end
    else
        if (self.focus) then
            if (self.text ~= '') then
                text = utf8.sub (text, 1, self.current) ..'|'.. utf8.sub (text, self.current + 1)
            else
                text = text..'|'
            end
        end
    end

    dxDrawText (
        text,
        x,
        y,
        width,
        height,
        color, 1, self.font, side, 'top', post, wordbreak
    )

    local now = getTickCount ();

    for i, v in pairs (self.keys) do
        if v.state and now - v.state >= 500 and now - v.last >= 30 then
            self:key (i, true)
        end
    end

    if (not self.focus) then
        return
    end

    local ry = y + text_current_h - rectangle_h
    local rx = clamp (x + text_current_w, x, x + width)
    
    if (self.current < 1) then
        ry = y + text_current_h
    end 
    
    if (not wordbreak) then
        local animation = interpolateBetween (20, 0, 0, 100, 0, 0, ((getTickCount () - self.tick) / 1400), 'SineCurve')
    
        local r, g, b = unpack (colors.rectangle)

        dxDrawRectangle (
            rx,
            ry,
            1,
            rectangle_h,
            tocolor (r, g, b, animation)
        )
    end

    if (self.lctrl) then
        local size_w = math.min (text_w, width)
        local size_h = math.min (text_h, height)

        dxDrawRectangle (
            x,
            y,
            size_w,
            size_h,
            tocolor (0, 170, 255, 35)
        )
    end
end;

function Inputs:key (key, press)
    if (not self.focus) then
        return false;
    end
    
    if (not press) then
        if self.keys[key] then
            self.keys[key].state = false
        end

        return
    end
    
    if (key == 'arrow_l') then
        if (self.current > 0) then
            self.current = self.current - 1
        end

        if (self.lctrl) then
            self.lctrl = false
        end
    end

    if (key == 'arrow_r') then
        local max = string.len (self.text)

        if (self.current < max) then
            self.current = self.current + 1
        end

        if (self.lctrl) then
            self.lctrl = false
        end
    end

    if (key == 'a') then
        if (getKeyState ('lctrl')) then
            self.lctrl = true
        end
    end

    if (key == 'c') then
        if (getKeyState ('lctrl')) then
            setClipboard (self.text)

            self.lctrl = false
        end
    end

    if (key == 'enter') then
        if (self.wordbreak and not self.mask) then
            self.text = utf8.sub (self.text, 1, self.current) ..'\n'.. utf8.sub (self.text, self.current + 1)

            self.current = self.current + 1
        end
    end

    if (key == 'backspace') then
        if (not self.lctrl) then
            if (self.text ~= '') then
                if (self.current > 0) then
                    self.text = string.sub (self.text, 1, self.current - 1)..string.sub (self.text, self.current + 1)

                    self.current = self.current - 1
                end
            end

            self.lctrl = false
        else
            self.text = ''

            self.current = 0
            
            self.lctrl = false
        end
    end

    if (self.search ~= false) then
        self.search (self.text)
    end

    if self.keys[key] then
        if self.keys[key].state then
            self.keys[key].last = getTickCount ()
        else
            self.keys[key].state = getTickCount ()
            self.keys[key].last = getTickCount ()
        end
    end
end;

function Inputs:paste (text)
    if (not self.focus) then
        return
    end

    if (self.number and not tonumber (text)) then
        return
    end
    
    if (self.length > 0 and ((utf8.len (self.text) + #text) >= self.length)) then
        return
    end

    if self.lctrl then
        self.text = text
        self.current = #text

        self.lctrl = false
    else
        self.text = utf8.sub (self.text, 1, self.current) ..text.. utf8.sub (self.text, self.current + 1)
        
        self.current = self.current + #text
    end

    if (self.search ~= false) then
        self.search (self.text)
    end
end;

function Inputs:character (character)
    if (not character) then
        return false
    end

    if (not self.focus) then
        return
    end

    if (self.number and not tonumber (character)) then
        return
    end

    if (not self.lctrl) then
        if (self.length > 0 and (utf8.len (self.text) >= self.length)) then
            return
        end
        
        self.text = utf8.sub (self.text, 1, self.current) .. character .. utf8.sub (self.text, self.current + 1)
    
        self.current = self.current + 1
    else
        self.text = character
        self.current = 1

        self.lctrl = false
    end
    
    if (self.search ~= false) then
        self.search (self.text)
    end
end;

function Inputs:click (button, state)
    if (state ~= 'down') then
        return
    end

    if (not self.hover) then
        self.focus = false

        guiSetInputMode ('allow_binds')

        return
    end

    if (not self.focus) then
        self.focus = true
        self.lctrl = false
        self.current = #self.text

        guiSetInputMode ('no_binds')
    else
        self.lctrl = false
    end
end;

function Inputs:destroy ()
    removeEventHandler ('onClientClick', root, self.events.click)
    removeEventHandler ('onClientCharacter', root, self.events.character)
    removeEventHandler ('onClientKey', root, self.events.key)
    removeEventHandler ('onClientPaste', root, self.events.paste)

    self = nil

    return self;
end;

function Inputs:setFocus (state)
    self.focus = state

    if state then
        guiSetInputMode ('no_binds')
    else
        guiSetInputMode ('allow_binds')
    end
end;
