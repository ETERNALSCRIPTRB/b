-- ANTI-FLINGLEVANTAR / ANTI-GRAB IMBATÍVEL V2 (FTAP Legacy 2025 - Delta Mobile)
-- Bloqueia poison/fire/explosion/ragdoll/velocity | 100% sem erro | Xandão vs BOPE mode

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local antiFling = false

-- Hook avançado (bloqueia remotes + metamethods + velocity)
local mt = getrawmetatable(game)
local oldnc = mt.__namecall
local oldni = mt.__newindex
local oldidx = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    if not antiFling or not checkcaller() then return oldnc(self, ...) end
    
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "Kick" or method == "FireServer" or method == "InvokeServer" then
        local name = tostring(self):lower()
        if name:find("fling") or name:find("grab") or name:find("throw") or name:find("ragdoll") or name:find("void") or name:find("explosion") then
            return -- Spoof silencioso
        end
    end
   
    if self:IsDescendantOf(player.Character) then
        if method == "Destroy" or method == "BreakJoints" or method == "SetNetworkOwner" then
            return
        end
    end
    
    return oldnc(self, ...)
end)

mt.__newindex = newcclosure(function(self, idx, val)
    if not antiFling or not checkcaller() then return oldni(self, idx, val) end
    
    if self:IsDescendantOf(player.Character) and (idx == "Velocity" or idx == "RotVelocity" or idx == "CFrame" or idx == "Position" or idx == "AngularVelocity") then
        return
    end
    
    if self:IsA("Humanoid") and self.Parent == player.Character and (idx == "PlatformStand" or idx == "Sit" or idx == "Health" or idx == "MaxHealth") then
        if idx == "Health" then val = self.MaxHealth end
        return oldni(self, idx, val)
    end
    
    return oldni(self, idx, val)
end)

setreadonly(mt, true)
local function fullLock()
    pcall(function()
        if not player.Character then return end
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part:SetNetworkOwner(player)
                part.CanCollide = true
                part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 1, 1) -- Massa infinita anti-fling
            elseif part:IsA("Humanoid") then
                part.PlatformStand = false
                part.Sit = false
                part.Health = part.MaxHealth
            end
      end
      local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

local heartConn, stepConn
RunService.Heartbeat:Connect(function()
    if antiFling then fullLock() end
end)
RunService.Stepped:Connect(function()
    if antiFling then fullLock() end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "AntiFlingBOPE"
sg.Parent = CoreGui
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 160)
frame.Position = UDim2.new(0.5, -210, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local uic = Instance.new("UICorner")
uic.CornerRadius = UDim.new(0, 12)
uic.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.Text = "🛡️ BOPE vs XANDÃO - ANTI-FLINGLEVANTAR V2"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0, 60)
btn.Position = UDim2.new(0.05, 0, 0.35, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "ATIVAR BOPE MODE: OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBlack
btn.TextSize = 24
btn.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -45, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.Parent = frame

btn.MouseButton1Click:Connect(function()
    antiFling = not antiFling
    if antiFling then
        btn.Text = "ATIVAR BOPE MODE: ON (IMORTAL!)"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        fullLock()
        
        spawn(function()
            while antiFling and wait(0.05) do
                fullLock()
            end
        end)
        print("🛡️ BOPE ATIVADO - Ninguém te pega mais!")
    else
        btn.Text = "ATIVAR BOPE MODE: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        print("⚫ BOPE DESATIVADO")
    end
end)

close.MouseButton1Click:Connect(function()
    antiFling = false
    heartConn, stepConn = nil, nil
    sg:Disconnect()
    sg:Destroy()
end)

player.CharacterAdded:Connect(function()
    wait(0.5)
    if antiFling then
        fullLock()
    end
end)
