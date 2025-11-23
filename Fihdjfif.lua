local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")
mouse.Button1Down:Connect(function()
    local targetPos = mouse.Hit.p
    if targetPos then
        humanoidRoot.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)
    end
end)
