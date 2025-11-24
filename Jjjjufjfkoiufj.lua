local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local originalAppearance = {}
local copiedPlayer = nil
local copies = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkinCopier"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 420, 0, 520)
Frame.Position = UDim2.new(0.5, -210, 0.5, -260)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
Title.Text = "🎭 COPY SKIN SERVER-SIDE (TODO MUNDO VÊ!)"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local UICornerT = Instance.new("UICorner")
UICornerT.CornerRadius = UDim.new(0, 12)
UICornerT.Parent = Title

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0.32, -10, 0, 45)
RefreshBtn.Position = UDim2.new(0, 10, 0, 70)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
RefreshBtn.Text = "🔄 REFRESH"
RefreshBtn.TextColor3 = Color3.new(1,1,1)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 16
RefreshBtn.Parent = Frame

local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Size = UDim2.new(0.32, -10, 0, 45)
RestoreBtn.Position = UDim2.new(0.34, 0, 0, 70)
RestoreBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
RestoreBtn.Text = "🔄 RESTORE ORIGINAL"
RestoreBtn.TextColor3 = Color3.new(1,1,1)
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.TextSize = 16
RestoreBtn.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.32, -10, 0, 45)
CloseBtn.Position = UDim2.new(0.68, 0, 0, 70)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
CloseBtn.Text = "❌ FECHAR"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Frame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -140)
Scroll.Position = UDim2.new(0, 10, 0, 125)
Scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 8
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 0)
Scroll.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.Name
UIListLayout.Parent = Scroll

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = Scroll

local function saveOriginal(char)
    pcall(function()
        originalAppearance = {
            Shirt = char:FindFirstChildOfClass("Shirt") and char:FindFirstChildOfClass("Shirt").ShirtTemplate,
            Pants = char:FindFirstChildOfClass("Pants") and char:FindFirstChildOfClass("Pants").PantsTemplate,
            BodyColors = char:FindFirstChildOfClass("BodyColors") and char:FindFirstChildOfClass("BodyColors"):Clone()
        }
    end)
end

local function restoreOriginal(char)
    pcall(function()
        local shirt = char:FindFirstChildOfClass("Shirt")
        if shirt then shirt.ShirtTemplate = originalAppearance.Shirt or "" end
        
        local pants = char:FindFirstChildOfClass("Pants")
        if pants then pants.PantsTemplate = originalAppearance.Pants or "" end
        
        local bodyColors = char:FindFirstChildOfClass("BodyColors")
        if bodyColors and originalAppearance.BodyColors then
            originalAppearance.BodyColors.Parent = char
            bodyColors:Destroy()
        end
        
        for _, acc in pairs(char:GetChildren()) do
            if acc:IsA("Accessory") and acc.Name ~= "BodyColors" then
                acc:Destroy()
            end
        end
        
        copiedPlayer = nil
        print("✅ SKIN ORIGINAL RESTAURADA!")
    end)
end

local function copySkin(target)
    pcall(function()
        local char = player.Character
        if not char then return end
        
        local targetChar = target.Character
        if not targetChar then return end
        
        local tShirt = targetChar:FindFirstChildOfClass("Shirt")
        local tPants = targetChar:FindFirstChildOfClass("Pants")
        if tShirt then
            local shirt = char:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", char)
            shirt.ShirtTemplate = tShirt.ShirtTemplate
        end
        if tPants then
            local pants = char:FindFirstChildOfClass("Pants") or Instance.new("Pants", char)
            pants.PantsTemplate = tPants.PantsTemplate
        end
        
        local tBodyColors = targetChar:FindFirstChildOfClass("BodyColors")
        if tBodyColors then
            local bodyColors = char:FindFirstChildOfClass("BodyColors")
            if bodyColors then bodyColors:Destroy() end
            local newBC = tBodyColors:Clone()
            newBC.Parent = char
        end
        
        for _, acc in pairs(char:GetChildren()) do
            if acc:IsA("Accessory") then acc:Destroy() end
        end
        for _, acc in pairs(targetChar:GetChildren()) do
            if acc:IsA("Accessory") then
                local newAcc = acc:Clone()
                newAcc.Parent = char
            end
        end
        
        copiedPlayer = target.Name
        print("🎭 SKIN COPIADA DE " .. target.Name .. " - TODO MUNDO VÊ!")
    end)
end

local function toggleCopy(target)
    if copiedPlayer == target.Name then
        restoreOriginal(player.Character)
    else
        copySkin(target)
    end
end

local function updateList()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 55)
            btn.BackgroundColor3 = copiedPlayer == p.Name and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
            btn.Text = p.Name .. (copiedPlayer == p.Name and " ✅ COPIADO" or "")
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16
            btn.TextScaled = true
            btn.Parent = Scroll
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                toggleCopy(p)
                updateList()
            end)
        end
    end
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end

RefreshBtn.MouseButton1Click:Connect(updateList)
RestoreBtn.MouseButton1Click:Connect(function()
    restoreOriginal(player.Character)
    updateList()
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

player.CharacterAdded:Connect(function(char)
    saveOriginal(char)
    wait(2)
    if copiedPlayer then
        local target = Players:FindFirstChild(copiedPlayer)
        if target then copySkin(target) end
    end
end)

if player.Character then saveOriginal(player.Character) end

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)

updateList()
