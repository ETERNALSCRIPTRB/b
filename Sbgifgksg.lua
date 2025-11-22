local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local p = Players.LocalPlayer

local remotes = {}
local animations = {}
for _, obj in pairs(getgc(true)) do
    if type(obj) == "table" and obj.__index and obj.__index.RemoteEvent then
        for _, v in pairs(obj) do if v:IsA("RemoteEvent") then table.insert(remotes, v) end end
    elseif type(obj) == "userdata" and obj.AnimationId then
        table.insert(animations, obj)
    end
end
print("Scan completo: " .. #remotes .. " remotes + " .. #animations .. " animações achadas! 🔥")

p.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local animator = hum:WaitForChild("Animator")
    
    hum.Died:Connect(function()
        
        local punchAnim = Instance.new("Animation")
        punchAnim.AnimationId = "rbxassetid://507766388"
        local track = animator:LoadAnimation(punchAnim)
        track.Looped = true
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
       
        local head = char:FindFirstChild("Head")
        if head then
            local neck = head:FindFirstChild("Neck") or char:FindFirstChild("Neck", true)
            if neck then neck:Destroy() end -- Detach replica via joint break
            head.CanCollide = true
            local bvHead = Instance.new("BodyVelocity", head)
            bvHead.MaxForce = Vector3.new(4000, 4000, 4000)
            bvHead.Velocity = hrp.CFrame.LookVector * 20 + Vector3.new(math.random(-10,10), 40, math.random(-10,10))
            bvHead.Parent = head
            
            TweenService:Create(bvHead, TweenInfo.new(4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Velocity = bvHead.Velocity * 1.5}):Play()
            TweenService:Create(head, TweenInfo.new(4, Enum.EasingStyle.Quart), {CFrame = head.CFrame * CFrame.new(0, 60, -80) * CFrame.Angles(math.rad(720), math.rad(180), 0)}):Play()
        end
      
        head.Transparency = 1
        
        local explodeRemote = nil
        for _, remote in pairs(remotes) do
            if remote.Name:lower():find("explode") or remote.Name:lower():find("effect") then
                explodeRemote = remote
                break
            end
        end
        if not explodeRemote then
            explodeRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemScrollState") or Instance.new("RemoteEvent", ReplicatedStorage) -- Fake se não achar
            explodeRemote.Name = "AkazaBoom"
        end
        wait(6)
        explodeRemote:FireServer(hrp.Position, "explode", 50, 1000000) -- Fire pro server: boom replica pra todos!
        
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part ~= hrp then
                part:BreakJoints() 
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e6,1e6,1e6)
                bv.Velocity = Vector3.new(math.random(-200,200), math.random(100,500), math.random(-200,200))
                bv.Parent = part
                game.Debris:AddItem(bv, 3)
            end
        end
        
        
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Scriptable
        local cfTarget = hrp.CFrame * CFrame.new(8, 5, 15)
        local connection = RunService.RenderStepped:Connect(function()
            if hrp and hrp.Parent then
                cfTarget = cfTarget:Lerp(hrp.CFrame * CFrame.new(math.sin(tick()*2)*10, 5, 15), 0.03)
                camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(cfTarget.Position, hrp.Position), 0.05)
            else
                connection:Disconnect()
            end
        end)
        wait(4)
        camera.CameraType = Enum.CameraType.Custom
        connection:Disconnect()
      end
