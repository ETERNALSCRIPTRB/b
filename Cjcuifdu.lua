local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == game.Players.LocalPlayer then
        return
    end
    return old(self, ...)
end)
setreadonly(mt, true)

local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    local target = Mouse.Target
    if target and target.Parent:FindFirstChild("HumanoidRootPart") and target.Parent:IsA("Model") then
        local char = target.Parent
        local player = Players:FindFirstChild(char.Name)
        if player and player ~= Players.LocalPlayer then
            local hrp = char.HumanoidRootPart
            
            hrp.AssemblyLinearVelocity = Vector3.new(math.huge, math.huge, math.huge)
            hrp.AssemblyAngularVelocity = Vector3.new(math.huge, math.huge, math.huge)
            game:GetService("RunService").Heartbeat:Wait() -- Sync
            hrp.AssemblyLinearVelocity = Vector3.new(-math.huge, math.huge, -math.huge)
            hrp.AssemblyAngularVelocity = Vector3.new(-math.huge, -math.huge, math.huge)
        end
    end
end)

print("🚀 JUSTICEIRO ATIVO! Mira nos kids e CLICK pra BAN! (Anti-Kick ON) 🔥")
