local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportTroll"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 420, 0, 500)
Frame.Position = UDim2.new(0.5, -210, 0.5, -250)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
Frame.BorderSizePixel = 3
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Title.Text = "🚀 TELEPORT TROLL (Do Lado do Cara!)"
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -130)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 8
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Scroll

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = Scroll

-- Função teleport do lado (5 studs pro lado direito)
local function teleportTo(target)
    pcall(function()
        local myChar = player.Character
        local targetChar = target.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            local myHRP = myChar.HumanoidRootPart
            local targetHRP = targetChar.HumanoidRootPart
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(5, 0, 0) -- Do lado, sem clip
            print("🚀 Teleportado do lado de " .. target.Name .. "!")
        end
    end)
end

-- Atualiza lista
local function updateList()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 55)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.Text = "TP → " .. p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 18
            btn.Parent = Scroll
            
            btn.MouseButton1Click:Connect(function()
                teleportTo(p)
                btn.Text = "TP FEITO: " .. p.Name
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                wait(1)
                btn.Text = "TP → " .. p.Name
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)
        end
    end
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0.48, -10, 0, 45)
RefreshBtn.Position = UDim2.new(0, 10, 1, -55)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
RefreshBtn.Text = "🔄 REFRESH"
RefreshBtn.TextColor3 = Color3.new(1,1,1)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.48, -10, 0, 45)
CloseBtn.Position = UDim2.new(0.52, 0, 1, -55)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "❌ FECHAR"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Frame

RefreshBtn.MouseButton1Click:Connect(updateList)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)

player.CharacterAdded:Connect(function()
    wait(1)
end)

updateList()
