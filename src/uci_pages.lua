--[[
  Q-SYS Sample Project: UCI Helper
  --------------------------------
  Third Script component. Shows a "System starting up" splash layer on the
  UCI when the room powers on, then returns to the control layer.

  No script control pins are required.

  Requirements:
    - A UCI named "RoomPanel" with page "Main" and layers "Controls", "Startup"
    - The RoomControl script component's Code Name is "RoomControl"
]]

local CFG = {
  UciName = "RoomPanel",
  PageName = "Main",
  SplashLayer = "Startup",
  SplashSeconds = 5,
  RoomComponent = "RoomControl",
}

local room = Component.New(CFG.RoomComponent)

local splashTimer = Timer.New()

local function showSplash(visible)
  -- Arguments: uciName, pageName, layerName, visible, transition
  Uci.SetLayerVisibility(CFG.UciName, CFG.PageName, CFG.SplashLayer, visible, "fade")
end

splashTimer.EventHandler = function()
  splashTimer:Stop()
  showSplash(false)
end

room["Power"].EventHandler = function(ctl)
  if ctl.Boolean then
    showSplash(true)
    splashTimer:Start(CFG.SplashSeconds)
  else
    splashTimer:Stop()
    showSplash(false)
  end
end

-- Make sure the splash is hidden on startup
showSplash(false)
