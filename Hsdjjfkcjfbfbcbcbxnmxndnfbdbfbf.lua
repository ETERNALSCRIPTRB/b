local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local antiFling = false

local mt = getrawmetatable(game)
local oldnc = mt.__namecall
local oldidx = mt.__index
local oldnewidx = mt.__newindex
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    if not antiFling or not checkcaller() then return oldnc(self, ...) end
    
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "Kick" or method == "kick" then return end
    
    if self:IsA("Humanoid") or self:IsA("HumanoidRootPart") or self:IsA("BasePart") then
        if self.Parent == player.Character or self:IsDescendantOf(player.Character) then
            return -- bloqueia TUDO que tenta mexer no teu char
        end
    end
    
    return oldnc(self, ...)
end)

mt.__newindex = newcclosure(function(self, key, value)
    if not antiFling or not checkcaller() then return oldnewidx(self, key, value) end
    
    if (key == "CFrame" or key == "Position" or key == "Velocity" or key == "RotVelocity" or key == "AngularVelocity") then
        if self == player.Character:FindFirstChild("HumanoidRootPart") or self:IsDescendantOf(player.Character) then
            return
        end
    end
    
    if key == "PlatformStand" or key == "Sit" then
        if self:IsA("Humanoid") and self.Parent == player.Character then
            return
        end
    end
    
    return oldnewidx(self, key, value)
end)

setreadonly(mt, true)

local function lockAll()
    if not player.Character or not antiFling then return end
    pcall(function()
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part:SetNetworkOwner(player)
                part.CanCollide = true
            end
        end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum.Sit = false
            hum.Health = hum.MaxHealth
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if antiFling then
        lockAll()
    end
  end
  
local sg = Instance.new("ScreenGui")
sg.Name = "AntiFlingImortal"
sg.Parent = CoreGui
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 150)
frame.Position = UDim2.new(0.5, -200, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 4
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
title.Text = "IMORTAL DO VOID v999"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 26
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0, 70)
btn.Position = UDim2.new(0.05, 0, 0.35, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "ANTI-FLINGLEVANTAR: OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBlack
btn.TextSize = 28
btn.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -50, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.Parent = frame

btn.MouseButton1Click:Connect(function()
    antiFling = not antiFling
    if antiFling then
        btn.Text = "ANTI-FLINGLEVANTAR: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        lockAll()
        spawn(function()
            while antiFling and wait(0.1) do
                lockAll()
            end
        end)
    else
        btn.Text = "ANTI-FLINGLEVANTAR: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

close.MouseButton1Click:Connect(function()
    antiFling = false
    sg:Destroy()
end)

player.CharacterAdded:Connect(function()
    wait(1)
    if antiFling then
        lockAll()
    end
end)
