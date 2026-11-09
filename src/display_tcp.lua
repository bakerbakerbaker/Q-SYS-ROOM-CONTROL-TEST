--[[
  Q-SYS Sample Project: TCP Display Driver
  ----------------------------------------
  Second Script component. Sends ASCII commands to a display over TCP
  and keeps the connection alive. Command strings are placeholders:
  replace them with your display's protocol.

  Script component controls:
    IPAddress    Text   (Controller)
    Port         Knob   (Integer, Min 1, Max 65535)  -- set default 23
    PowerOn      Button (Trigger)
    PowerOff     Button (Trigger)
    Connected    LED    (Indicator, Boolean)
    LastReply    Text   (Indicator)
]]

local CMD = {
  PowerOn  = "POWR1\r",
  PowerOff = "POWR0\r",
}

local sock = TcpSocket.New()
sock.ReconnectTimeout = 5   -- seconds between automatic reconnect attempts
sock.ReadTimeout = 0
sock.WriteTimeout = 0

local function connect()
  local ip = Controls.IPAddress.String
  local port = math.floor(Controls.Port.Value)
  if ip == "" then
    Controls.LastReply.String = "Enter an IP address"
    return
  end
  if sock.IsConnected then sock:Disconnect() end
  sock:Connect(ip, port)
end

sock.EventHandler = function(s, evt, err)
  if evt == TcpSocket.Events.Connected then
    Controls.Connected.Boolean = true
    print("Display connected")
  elseif evt == TcpSocket.Events.Reconnect then
    print("Reconnecting...")
  elseif evt == TcpSocket.Events.Data then
    -- Read every complete line that has arrived
    local line = s:ReadLine(TcpSocket.EOL.Any)
    while line do
      Controls.LastReply.String = line
      print("Display replied: " .. line)
      line = s:ReadLine(TcpSocket.EOL.Any)
    end
  elseif evt == TcpSocket.Events.Closed
      or evt == TcpSocket.Events.Error
      or evt == TcpSocket.Events.Timeout then
    Controls.Connected.Boolean = false
    print("Display socket: " .. tostring(err))
  end
end

local function send(cmd)
  if sock.IsConnected then
    sock:Write(cmd)
  else
    Controls.LastReply.String = "Not connected"
  end
end

Controls.PowerOn.EventHandler  = function() send(CMD.PowerOn) end
Controls.PowerOff.EventHandler = function() send(CMD.PowerOff) end

-- Reconnect whenever the address or port changes
Controls.IPAddress.EventHandler = connect
Controls.Port.EventHandler = connect

connect()
