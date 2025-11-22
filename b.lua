local p=game:GetService("Players").LocalPlayer;local uis=game:GetService("UserInputService");local chr=p.Character or p.CharacterAdded("Humanoid");
uis.JumpRequest:Connect(function()if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end)
spawn(function()while wait()do if h and not h:GetState().Name:find("Jump")then h.Jump=true end end end)
local flying=false
uis.InputBegan:Connect(function(k)if k.KeyCode==Enum.KeyCode.F then flying=not flying if flying then local bv=Instance.new("BodyVelocity",chr.PrimaryPart) bv.Velocity=Vector3.new(0,50,0) bv.MaxForce=Vector3.new(0,math.huge,0) chr.PrimaryPart.Anchored=false spawn(function()while flying do wait() chr.Humanoid.PlatformStand=true;bv.Velocity=Vector3.new(0,50,0)end end) else for _,v in pairs(chr.PrimaryPart:GetChildren())do if v:IsA("BodyVelocity")then v:Destroy()end end chr.Humanoid.PlatformStand("Head")and (v.Parent.Head.Position-chr.Head.Position).Magnitude<12)then v.Health=0 end end end end)
