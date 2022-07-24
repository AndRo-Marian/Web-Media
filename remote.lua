--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- Author:  Andronachi Marian
-- Version: 1.0.0
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--

local keyboard = libs.keyboard;
local device = libs.device;
local win = libs.win;

--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--

local browsers = {
    ["firefox"] = { "Firefox", "firefox.exe" },
    ["chrome"] = { "Chrome", "chrome.exe" },
    ["opera"] = { "Opera", "opera.exe" },
    ["edge"] = { "Edge", "msedge.exe" },
    ["brave"] = { "Brave", "brave.exe" }
};

--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--

--- Check if the string is empty
--- @param str string
function IsEmpty(str)
    return str == "";
end

--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--

function RefreshBrowsers()
    for k, v in pairs(browsers) do
        if (win.window(v[2]) ~= 0) then
            layout[k].image = "icons/" .. k .. "-logo.png";
        else
            layout[k].image = "icons/" .. k .. "-offline-logo.png";
        end
    end
end

--- Update the browsers
function UpdateBrowser()
    local name = settings.browser;

    if (IsEmpty(name)) then return; end

    local data = browsers[name];

    if (win.window(data[2]) ~= 0) then
        layout[name].color = "#408040";
        layout.preview.image = "icons/" .. name .. "-logo.png";
    else
        layout[name].color = "#406A80";
        layout.preview.image = "icons/" .. name .. "-offline-logo.png";
    end

    layout.message.text = data[1];
end

--- Focus the browser
function FocusBrowser()
    local name = settings.browser;

    if (IsEmpty(name)) then return; end

    win.switchtowait(browsers[name][2]);
end

--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--

--- Focus event
events.focus  = function()
    RefreshBrowsers();
    UpdateBrowser();
end

--- Command event
--- @param name string
events.action = function (name, _)
    local command;
    local params = {};

    for v in name:gmatch("%S+") do
        if (not command) then
            command = v;
        else
            table.insert(params, v);
        end
    end

    params = unpack(params);

    if (actions[command]) then
        actions[command](params);
    end
end

--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--

--- Switch the browser
--- @param browser string
actions.switch_browser = function(browser)
    local name = settings.browser;
    local data = browsers[browser];
    local index = win.window(data[2]);

    if (not IsEmpty(name)) then
        layout[name].color = "grey";
    end

    if (index ~= 0) then
        layout[browser].color = "#408040";
        layout.preview.image = "icons/" .. browser .. "-logo.png";
    else
        layout[browser].color = "#406A80";
        layout.preview.image = "icons/" .. browser .. "-offline-logo.png";
    end

    layout.message.text = data[1];
    settings.browser = browser;
end

--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--

--- Reopen tab
actions.tab_reopen = function() FocusBrowser(); keyboard.stroke("RCtrl", "RShift", "T"); end

--- Close tab
actions.tab_close = function() FocusBrowser(); keyboard.stroke("RCtrl", "W"); end

--- New tab
actions.tab_new = function() FocusBrowser(); keyboard.stroke("RCtrl", "T"); end

--- Search tab
actions.tab_search = function() FocusBrowser(); keyboard.stroke("RCtrl", "L"); device.keyboard(); end

--- Navigate back on history
actions.history_back = function() FocusBrowser(); keyboard.stroke("LAlt", "Left"); end

--- Navigate next in history
actions.history_next = function() FocusBrowser(); keyboard.stroke("LAlt", "Right"); end

--- Select previous tab
actions.tab_back = function() FocusBrowser(); keyboard.stroke("RCtrl", "PageUp"); end

--- Select next tab
actions.tab_next = function() FocusBrowser(); keyboard.stroke("RCtrl", "PageDown"); end

--- Refresh tab
actions.tab_refresh = function() FocusBrowser(); keyboard.stroke("RCtrl", "R"); end

--- Mute volume
actions.volume_mute = function() FocusBrowser(); keyboard.stroke("M"); end

--- Raise volume
actions.volume_up = function() FocusBrowser(); keyboard.stroke("RShift", "Up"); end

--- Lower volume
actions.volume_down = function() FocusBrowser(); keyboard.stroke("RShift", "Down"); end

--- Seek backwards
actions.seek_back = function() FocusBrowser(); keyboard.stroke("Left"); end

--- Seek forward
actions.seek_next = function() FocusBrowser(); keyboard.stroke("Right"); end

--- Seek to
--- @param key string
actions.seek_to = function(key) FocusBrowser(); keyboard.stroke(key); end

--- Toggle fullscreen
actions.fullscreen = function() FocusBrowser(); keyboard.stroke("F"); end

--- Toggle play / pause
actions.play_pause = function() FocusBrowser(); keyboard.stroke("Space"); end

--- Next track
actions.next_track = function() FocusBrowser(); keyboard.stroke("RShift", "N"); end

--- Back track
actions.back_track = function() FocusBrowser(); keyboard.stroke("RShift", "P"); end
