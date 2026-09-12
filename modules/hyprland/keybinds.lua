local mainMod = "SUPER"
local ipc = "noctalia msg "

local function workspace_in_group(i)
  local curr = hl.get_active_workspace().id
  local workspaceGroupSize = 10
  local newVal = math.floor((curr - 1) / workspaceGroupSize) * workspaceGroupSize + i
  return newVal
end


hl.bind(mainMod .. "+ SUPER_L", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+ comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(mainMod .. "+ I", hl.dsp.exec_cmd(ipc .. "settings-toggle"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

-- Window layout
hl.bind(mainMod .. "+ J", hl.dsp.layout("togglesplit"))

-- Lock session
hl.bind(mainMod .. "+L", hl.dsp.exec_cmd(ipc .. "session lock"))

-- Close window
hl.bind("ALT + F4",
  function()
    hl.exec_cmd(
      "notify-send \"Wrong close keybind\" \"Super+Q to close. Use Alt+F4 for Windows VMs\" -a Hyprland")
  end,
  { non_consuming = true })
hl.bind(mainMod .. "+ Q", hl.dsp.window.close())
hl.bind(mainMod .. "+ SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))

-- Move windows
--#/# bind = SUPER + ALT, ←/↑/→/↓,, -- Move in direction
for i = 1, 4 do
  local arrowkey = { "Left", "Right", "Up", "Down" }
  local focusdir = { "l", "r", "u", "d" }
  hl.bind(mainMod .. "+ALT + " .. arrowkey[i], hl.dsp.window.move({ direction = focusdir[i] }))
end
--#/# bind = SUPER+SHIFT, Hash,, -- Send to workspace -- (1, 2, 3,...)
for i = 1, 10 do
  hl.bind(mainMod .. "+ SHIFT + " .. (i % 10), function()
    hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = true }))
  end)
end
--# We also use raw keycodes because some keyboard layouts register number keys as different chars. The codes can be verified with `wev`
for i = 1, 10 do
  local numberkey = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }
  hl.bind(mainMod .. "+ SHIFT + code:" .. numberkey[i], function()
    hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = true }))
  end)
end
--# keypad numbers
for i = 1, 10 do
  local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
  hl.bind(mainMod .. "+ SHIFT + code:" .. numpadkey[i], function()
    hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = true }))
  end)
end
--# #/# bind = SUPER+SHIFT, Scroll ↑/↓,, -- Send to workspace left/right
for i = 1, 4 do
  local key = { mainMod .. "+ SHIFT + mouse_", mainMod .. "+ ALT + mouse_" }
  local keycombos = { key[1] .. "down", key[1] .. "up", key[2] .. "down", key[2] .. "up" }
  local prefix = { "r-", "r+", "r-", "r+" }
  hl.bind(keycombos[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }))
end
--#/# bind = SUPER+SHIFT, Page_↑/↓,, -- Send to workspace left/right
for i = 1, 2 do
  local keydirs = { "Up", "Down" }
  local prefix = { "r-", "r+" }
  hl.bind(mainMod .. "+ SHIFT + Page_" .. keydirs[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }))
end
for i = 1, 4 do
  local key = { mainMod .. "+ ALT + Page_", "CTRL + SUPER + SHIFT + " }
  local keycombos = { key[1] .. "down", key[1] .. "up", key[2] .. "Right", key[2] .. "Left" }
  local prefix = { "r+", "r-", "r+", "r-" }
  hl.bind(keycombos[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }))
end

--##! Workspace
--# Switching
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("ALT + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))
--#/# bind = SUPER, Hash,, -- Focus workspace -- (1, 2, 3,...)
for i = 1, 10 do
  hl.bind(mainMod .. "+" .. (i % 10), function()
    hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
  end)
end
--# We also use raw keycodes because some keyboard layouts register number keys as different chars. The codes can be verified with `wev`
for i = 1, 10 do
  local numberkey = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }
  hl.bind(mainMod .. "+ code:" .. numberkey[i], function()
    hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
  end)
end
--# keypad numbers
for i = 1, 10 do
  local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
  hl.bind(mainMod .. "+code:" .. numpadkey[i], function()
    hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
  end)
end

--#/# bind = CTRL+SUPER, ←/→,, -- Focus left/right
--#/# bind = CTRL+SUPER+ALT, ←/→,, -- # [hidden] Focus busy left/right
for i = 1, 2 do
  local keys = { "Left", "Right" }
  local prefix = { "r-", "r+" }
  hl.bind("CTRL + SUPER + " .. keys[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
end
for i = 1, 2 do
  local keys = { "Left", "Right" }
  local prefix = { "m-", "m+" }
  hl.bind("CTRL + SUPER + ALT + " .. keys[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
end
--#/# bind = SUPER, Page_↑/↓,, -- Focus left/right
for i = 1, 4 do
  local key = { mainMod .. "+Page_Down", mainMod .. "+Page_Up" }
  local keycombos = { key[1], key[2], "CTRL + " .. key[1], "CTRL + " .. key[2] }
  local prefix = { "r+", "r-", "r+", "r-" }
  hl.bind(keycombos[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
end
--#/# bind = SUPER, Scroll ↑/↓,, -- Focus left/right
for i = 1, 4 do
  local key = { mainMod .. "+ mouse_up", mainMod .. "+ mouse_down" }
  local keycombos = { key[1], key[2], "CTRL + " .. key[1], "CTRL + " .. key[2] }
  local prefix = { "+", "-", "r+", "r-" }
  hl.bind(keycombos[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
end
--## Special
hl.bind(mainMod .. "+ S", hl.dsp.workspace.toggle_special("special"))
hl.bind(mainMod .. "+ mouse:275", hl.dsp.workspace.toggle_special("special"))
for i = 1, 4 do
  local key = { "BracketLeft", "BracketRight", "Up", "Down" }
  local prefix = { "-1", "+1", "r-5", "r+5" }
  hl.bind("CTRL + SUPER + " .. key[i], hl.dsp.focus({ workspace = prefix[i] }))
end

-- Special workspace
hl.bind(mainMod .. "+ ALT + S",
  hl.dsp.window.move({ workspace = "special:special", follow = false }))
hl.bind("CTRL + SUPER + S", hl.dsp.workspace.toggle_special("special"))

-- Clipboard history
hl.bind(mainMod .. "+ V", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd(ipc .. "screenshot-region"))

--##! Apps
hl.bind(mainMod .. "+ T", hl.dsp.exec_cmd("kitty -1"))
hl.bind(mainMod .. "+ Z", hl.dsp.exec_cmd("zen-beta"))
hl.bind(mainMod .. "+ E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. "+ C", hl.dsp.exec_cmd("zeditor"))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("kitty -1 fish -c btop"))

-- Others
hl.bind(mainMod .. "+ Space", hl.dsp.exec_cmd("$HOME/.config/home-manager/modules/hyprland/scripts/toggle-layout.sh"))
hl.bind(mainMod .. "+ F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
