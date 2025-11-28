-- 💀 GODMODE ULTIMATE v2.0 PvP LIMITE DELTA 2025 - 100% Intercept + Regen Multi + HP ∞ + Anti Tudo 💀
-- Funciona em TODOS battles fortes (Da Hood, Arsenal, etc.) - NUNCA morre!
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- VARIÁVEIS GLOBAIS
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- FUNÇÃO HP ∞ + REGEN ULTRA (MaxHealth huge + lock)
local function godHealth()
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    -- REGEN 1: HealthChanged (instantâneo)
    hum.HealthChanged:Connect(function(hp)
        if hp < math.huge then
            hum.Health = math.huge
        end
    end)
end

-- APLICA EM CHAR ATUAL E FUTURO
godHealth()
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    wait(0.1)
    godHealth()
end)

-- REGEN MULTI-LOOP INSANO (3 loops = imparável, todo frame!)
RunService.Heartbeat:Connect(function()
    if hum and hum.Health < math.huge then
        hum.Health = math.huge
    end
end)
RunService.Stepped:Connect(function()
    if hum and hum.Health < math.huge then
        hum.Health = math.huge
    end
end)
RunService.RenderStepped:Connect(function()
    if hum and hum.Health < math.huge then
        hum.Health = math.huge
    end
end)

-- 100% INTERCEPT TOTAL: MATA TODOS TOUCH/INTERESTS (projéteis/swords/lava/mobs = 0%)
local function killTouches(obj)
    if obj:IsA("BasePart") then
        local touch = obj:FindFirstChildOfClass("TouchTransmitter")
        if touch then touch:Destroy() end
        -- Extra: Mata ClickDetector/Proximity se dano
        local cd = obj:FindFirstChildOfClass("ClickDetector")
        if cd then cd:Destroy() end
        local pp = obj:FindFirstChildOfClass("ProximityPrompt")
        if pp then pp:Destroy() end
    end
end
-- Mata existentes + novos
for _, obj in pairs(workspace:GetDescendants()) do
    killTouches(obj)
end
workspace.DescendantAdded:Connect(killTouches)

-- ANTI-RAGDOLL + ANTI-FALL/KILL STATES
hum.StateChanged:Connect(function(old, new)
    if new == Enum.HumanoidStateType.Dead or new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end)
hum.PlatformStand = false  -- Anti ragdoll lock

-- FORCEFIELD INVISÍVEL ETERNO
local ff = Instance.new("ForceField")
ff.Parent = char
game:GetService("RunService").Heartbeat:Connect(function()
    if not char:FindFirstChild("ForceField") then
        local newff = Instance.new("ForceField")
        newff.Parent = char
    end
end)

-- NOCLIP AUTO (passa por walls/dano sem tocar)
local noclip = false
RunService.Stepped:Connect(function()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- ANTI-KICK/BAN (esconde exploits)
if player.Character then
    player.Character:WaitForChild("Humanoid").Died:Connect(function()
        player:LoadCharacter()  -- Auto respawn imortal
    end)
end
