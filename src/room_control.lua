--[[
  Q-SYS Sample Project: Room Control
  ----------------------------------
  Paste into a Script component in Q-SYS Designer.

  Script component controls (add these in the Script's control pins):
    Power        Button (Toggle)
    Source       Knob   (Integer, Min 1, Max 3)
    Volume       Knob   (Float, Min -60, Max 0)  -- dB
    Mute         Button (Toggle)
    AutoOffMin   Knob   (Integer, Min 0, Max 240) -- 0 = disabled
    Status       Text   (Indicator)

  Named components needed in the design (Component Name in Properties):
    "SourceSelector"  Source Selector (or Router) with Input Select control "select.1"
    "MainGain"        Gain block, controls "gain" and "mute"
]]

-- ---------- Configuration ----------
local CFG = {
  SourceNames = { "Laptop", "Wireless", "Aux" },
  DefaultVolume = -25,       -- dB at power-on
  MaxVolume = -6,            -- safety ceiling in dB
  SourceComponent = "SourceSelector",
  GainComponent = "MainGain",
}

-- ---------- Helpers ----------
local function clamp(v, lo, hi)
  return math.max(lo, math.min(hi, v))
end

local function setStatus(msg)
  Controls.Status.String = msg
  print("[RoomControl] " .. msg)
end

-- Safely get a named component; returns nil (and reports) if missing
local function getComponent(name)
  local ok, comp = pcall(Component.New, name)
  if not ok or comp == nil then
    setStatus("Missing component: " .. name)
    return nil
  end
  return comp
end

local sourceComp = getComponent(CFG.SourceComponent)
local gainComp = getComponent(CFG.GainComponent)

-- ---------- Audio actions ----------
local function applySource()
  local idx = clamp(math.floor(Controls.Source.Value), 1, #CFG.SourceNames)
  if sourceComp then
    sourceComp["select.1"].Value = idx
  end
  setStatus("Source: " .. CFG.SourceNames[idx])
end

local function applyVolume()
  local vol = clamp(Controls.Volume.Value, -60, CFG.MaxVolume)
  if vol ~= Controls.Volume.Value then
    Controls.Volume.Value = vol -- pull knob back under the ceiling
  end
  if gainComp then
    gainComp["gain"].Value = vol
  end
end

local function applyMute()
  if gainComp then
    gainComp["mute"].Boolean = Controls.Mute.Boolean
  end
  setStatus(Controls.Mute.Boolean and "Muted" or "Unmuted")
end

-- ---------- Auto-off timer ----------
local autoOffTimer = Timer.New()

local function restartAutoOff()
  autoOffTimer:Stop()
  local minutes = Controls.AutoOffMin.Value
  if Controls.Power.Boolean and minutes > 0 then
    autoOffTimer:Start(minutes * 60)
  end
end

autoOffTimer.EventHandler = function()
  autoOffTimer:Stop()
  setStatus("Auto-off: powering down")
  Controls.Power.Boolean = false
  -- Setting .Boolean from script does not fire EventHandler on some
  -- versions, so run the power-off logic directly as well.
  Controls.Power.EventHandler(Controls.Power)
end

-- ---------- Power ----------
Controls.Power.EventHandler = function(ctl)
  if ctl.Boolean then
    Controls.Mute.Boolean = false
    Controls.Volume.Value = CFG.DefaultVolume
    applySource()
    applyVolume()
    applyMute()
    setStatus("System ON")
  else
    Controls.Mute.Boolean = true
    applyMute()
    setStatus("System OFF")
  end
  restartAutoOff()
end

-- ---------- Control handlers ----------
Controls.Source.EventHandler = function()
  if Controls.Power.Boolean then
    applySource()
    restartAutoOff()
  end
end

Controls.Volume.EventHandler = function()
  applyVolume()
  restartAutoOff()
end

Controls.Mute.EventHandler = function()
  applyMute()
end

Controls.AutoOffMin.EventHandler = function()
  restartAutoOff()
end

-- ---------- Startup ----------
Controls.Power.Boolean = false
Controls.Mute.Boolean = true
Controls.Status.String = "Ready"
