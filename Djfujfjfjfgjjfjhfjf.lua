-- ESP VERMELHO ILIMITADO - Todos Players (Delta Mobile + HyperOS 3.0)
-- Boxes vermelhos, nomes, distância | Distância INFINITA | Sem lag/erros | Toggle GUI Arrastrável

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local espEnabled = false
local drawings = {} -- [player] = {box, name, dist, tracer}

-- Função pra limpar drawings de um player
local function clearDrawings(plr)
    if drawings[plr] then
        for _, drawing in pairs(drawings[plr]) do
            if drawing then drawing:Remove() end
        end
        drawings[plr] = nil
    end
end

-- Função pra criar drawings pra um player
local function createDrawings(plr)
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    box.Visible = false

    local name = Drawing.new("Text")
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Size = 16
    name.Center = true
    name.Outline = true
    name.Font = 2
    name.Visible = false

    local dist = Drawing.new("Text")
    dist.Color = Color3.fromRGB(255, 255, 255)
    dist.Size = 14
    dist.Center = true
    dist.Outline = true
    dist.Font = 2
    dist.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Color = Color3.fromRGB(255, 0, 0)
    tracer.Thickness = 2
    tracer.Transparency = 1
    tracer.Visible = false

    drawings[plr] = {box, name, dist, tracer}
end

-- Loop principal ESP (otimizado, sem erros)
local espConnection
local function updateESP()
    if not espEnabled then return end
    pcall(function()
        for plr, _ in pairs(drawings) do
            if plr and plr.Parent and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr ~= player then
                local char = plr.Character
                local root = char.HumanoidRootPart
                local hum = char.Humanoid

                local vector, onScreen = Camera:WorldToViewportPoint(root.Position)
                local head = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 0.5, 0))
                local leg = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                local height = (head - leg).Magnitude
                local width = height * 0.5

                -- Box
                local box = drawings[plr][1]
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(vector.X - width / 2, vector.Y - height / 2)
                box.Visible = onScreen

                -- Nome
                local name = drawings[plr][2]
                name.Text = plr.Name
                name.Position = Vector2.new(vector.X, vector.Y - height / 2 - 20)
                name.Visible = onScreen

                -- Distância (ilimitada!)
                local dist = drawings[plr][3]
                local distance = math.floor((player.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                dist.Text = distance .. "m"
                dist.Position = Vector2.new(vector.X, vector.Y + height / 2 + 5)
                dist.Visible = onScreen

                -- Tracer (linha do centro da tela)
                local tracer = drawings[plr][4]
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                tracer.From = screenCenter
                tracer.To = Vector2.new(vector.X, vector.Y)
                tracer.Visible = onScreen

            else
                clearDrawings(plr)
            end
        end
    end)
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        espConnection = RunService.RenderStepped:Connect(updateESP)
        print("🔴 ESP VERMELHO ATIVADO - Ilimitado!")
    else
        if espConnection then espConnection:Disconnect() end
        for plr, _ in pairs(drawings) do
            clearDrawings(plr)
        end
        print("⚫ ESP DESATIVADO")
    end
end

-- GUI Arrastrável Simples
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPVermelho"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 120)
Frame.Position = UDim2.new(0.5, -150, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderSizePixel = 3
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "🔴 ESP VERMELHO ILIMITADO"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -20, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ToggleBtn.Text = "ATIVAR ESP"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Frame

ToggleBtn.MouseButton1Click:Connect(function()
    toggleESP()
    ToggleBtn.Text = espEnabled and "DESATIVAR ESP" or "ATIVAR ESP"
    ToggleBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
end)

CloseBtn.MouseButton1Click:Connect(function()
    espEnabled = false
    if espConnection then espConnection:Disconnect() end
    for plr, _ in pairs(drawings) do clearDrawings(plr) end
    ScreenGui:Destroy()
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        createDrawings(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() createDrawings(plr) end)
end)

Players.PlayerRemoving:Connect(function(plr) clearDrawings(plr) end)
