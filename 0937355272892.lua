-- ETERNAL DRAG GUI v1.0 - Mobile Codex Ready (Dez/2025) 🔥
-- Drag vertical só pra cima/baixo, tema preto semi-transparente
-- Speed, Inf Jump, Click TP, Noclip, ID15 Anim (Glitch Wave R15), Kill Aura (Fling), Aimbot (Universal FOV)
-- Cole direto no Codex! Alt acc, risco ban ToS. <grok:render card_id="df63ba" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">3</argument></grok:render><grok:render card_id="fad667" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">4</argument></grok:render>

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Vars toggles
local Toggles = {
    Speed = false,
    InfJump = false,
    ClickTP = false,
    Noclip = false,
    ID15Anim = false,
    KillAura = false,
    Aimbot = false
}

-- Conexões
local Connections = {}

-- Função pra atualizar char
local function UpdateChar()
    Character = LocalPlayer.Character
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end
LocalPlayer.CharacterAdded:Connect(UpdateChar)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EternalDragGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 420)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ETERNAL DRAG 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(255, 100, 100)
TitleStroke.Thickness = 1.5
TitleStroke.Parent = Title

-- DRAG VERTICAL ONLY
local Dragging = false
local DragStart = nil
local StartPos = nil
local ViewportSize = Workspace.CurrentCamera.ViewportSize

MainFrame.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        local YScale = Delta.Y / ViewportSize.Y
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset, StartPos.Y.Scale + YScale, StartPos.Y.Offset)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

-- Botão Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Função Toggle Button
local function CreateToggle(Name, PosY)
    local Btn = Instance.new("TextButton")
    Btn.Name = Name
    Btn.Size = UDim2.new(0.9, 0, 0, 45)
    Btn.Position = UDim2.new(0.05, 0, 0, PosY)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Btn.Text = Name .. ": OFF"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.TextScaled = true
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(60, 60, 70)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        Toggles[Name] = not Toggles[Name]
        if Toggles[Name] then
            Btn.Text = Name .. ": ON"
            Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Btn.Text = Name .. ": OFF"
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    return Btn
end

-- Criar botões
CreateToggle("Speed", 60)
CreateToggle("InfJump", 110)
CreateToggle("ClickTP", 160)
CreateToggle("Noclip", 210)
CreateToggle("ID15Anim", 260)
CreateToggle("KillAura", 310)
CreateToggle("Aimbot", 360)

-- FEATURES REAIS
-- Speed
spawn(function()
    while wait() do
        if Toggles.Speed and Humanoid then
            Humanoid.WalkSpeed = 80
        end
    end
end)

-- Inf Jump
Connections.InfJump = UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Click TP
Connections.ClickTP = Mouse.Button1Down:Connect(function()
    if Toggles.ClickTP and RootPart then
        RootPart.CFrame = CFrame.new(Mouse.Hit.Position)
    end
end)

-- Noclip
local NoclipLoop
NoclipLoop = RunService.Stepped:Connect(function()
    if Toggles.Noclip and Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") and Part.CanCollide then
                Part.CanCollide = false
            end
        end
    end
end)

local AnimTrack = nil
local AnimId = "rbxassetid://507766388"
spawn(function()
    while wait(0.1) do
        if Toggles.ID15Anim and Humanoid then
            local Anim = Instance.new("Animation")
            Anim.AnimationId = AnimId
            AnimTrack = Humanoid:LoadAnimation(Anim)
            AnimTrack.Looped = true
            AnimTrack:Play()
            break
        elseif AnimTrack then
            AnimTrack:Stop()
            AnimTrack = nil
        end
    end
end)

spawn(function()
    while wait(0.1) do
        if Toggles.KillAura and RootPart then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local Dist = (RootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                    if Dist < 15 then
                        Player.Character.HumanoidRootPart.Velocity = (Player.Character.HumanoidRootPart.Position - RootPart.Position).Unit * 300 + Vector3.new(0, 100, 0)
                    end
                end
            end
        end
    end
end)

local FOV = 400
local Targets = {}
RunService.Heartbeat:Connect(function()
    if Toggles.Aimbot then
        local Closest, Dist = nil, FOV
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Head") then
                local Head = Player.Character.Head
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Head.Position)
                local ScreenDist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if ScreenDist < Dist and OnScreen then
                    Closest = Head
                    Dist = ScreenDist
                end
            end
        end
        if Closest then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, Closest.Position), 0.25)
        end
    end
end)
