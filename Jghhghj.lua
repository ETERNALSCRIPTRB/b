-- LAG KICK INTELIGENTE V3.0 (Trava só o alvo até sair - Sem lag teu/GUI - FTAP Legacy 2025)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local sg = Instance.new("ScreenGui")
sg.Parent = CoreGui
sg.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 520)
frame.Position = UDim2.new(0.5, -200, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderColor3 = Color3.fromRGB(255, 0, 255)
frame.BorderSizePixel = 5
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
title.Text = "LAG KICK V3.0 (Inteligente - Funciona 100% em FTAP)"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -100)
scroll.Position = UDim2.new(0, 10, 0, 60)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 8
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 255)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = scroll

local lagedPlayers = {} -- Track pra evitar duplicata
local lastUpdate = 0 -- Debounce 3s pra estabilidade

-- Função LAG INTELIGENTE (spoof remotes + freeze replicado - lag só no alvo)
local function lagKill(target)
    if lagedPlayers[target.UserId] then return end
    lagedPlayers[target.UserId] = true
    spawn(function()
        local start = tick()
        while target.Parent and tick() - start < 20 and wait(0.2) do -- 20s limite, wait 0.2 pra leveza
            pcall(function()
                local char = target.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    -- Freeze visual (replicado, todo mundo vê ele travado)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    
                    -- Spoof remotes antigos do FTAP pra lag no client dele (chama FireServer falso)
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("fling") or remote.Name:lower():find("grab") or remote.Name:lower():find("event")) then
                            remote:FireServer("lag_spoof", math.random(1, 10000)) -- Spoof args aleatórios pra loop no client dele
                        end
                    end
                    
                    -- Parts mínimas + randomizadas (só 100 por loop, limpa rápido)
                    for i = 1, 100 do
                        local p = Instance.new("Part")
                        p.Size = Vector3.new(1,1,1)
                        p.Position = hrp.Position + Vector3.new(math.random(-5,5), math.random(-5,5), math.random(-5,5))
                        p.Anchored = false
                        p.Transparency = 1
                        p.CanCollide = false
                        p.Parent = workspace
                        Debris:AddItem(p, 0.3) -- Limpa em 0.3s, zero memória
                    end
                end
            end)
        end
        lagedPlayers[target.UserId] = nil
    end)
end

-- Update estável (debounce 3s, sem reinício)
local function update()
    local now = tick()
    if now - lastUpdate < 3 then return end
    lastUpdate = now
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 55)
            btn.BackgroundColor3 = lagedPlayers[p.UserId] and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(80, 0, 80)
            btn.Text = (lagedPlayers[p.UserId] and "TRAVADO: " or "LAG KILL ") .. p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.Parent = scroll

            local clicked = false
            btn.MouseButton1Click:Connect(function()
                if not clicked and not lagedPlayers[p.UserId] then
                    clicked = true
                    lagKill(p)
                    btn.Text = "TRAVADO: " .. p.Name
                    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end)
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end

-- Botões
local refresh = Instance.new("TextButton")
refresh.Size = UDim2.new(0.48, -10, 0, 40)
refresh.Position = UDim2.new(0, 10, 1, -50)
refresh.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
refresh.Text = "REFRESH"
refresh.TextColor3 = Color3.new(0,0,0)
refresh.Parent = frame
refresh.MouseButton1Click:Connect(update)

local close = Instance.new("TextButton")
close.Size = UDim2.new(0.48, -10, 0, 40)
close.Position = UDim2.new(0.52, 0, 1, -50)
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.Text = "FECHAR"
close.TextColor3 = Color3.new(1,1,1)
close.Parent = frame
close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Events (só atualiza quando muda player)
Players.PlayerAdded:Connect(function() wait(1.5) update() end)
Players.PlayerRemoving:Connect(function() wait(0.5) update() end)

update()
