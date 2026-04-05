-- Mastr UI - 최종 정리 버전 (Valkyrie 삭제)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MastrUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 메인 프레임
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 380)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.45
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 22)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2.2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.55
stroke.Parent = mainFrame

-- 제목
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 80)
title.BackgroundTransparency = 1
title.Text = "Mastr"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = mainFrame

-- 버튼들
local buttons = {}

local function createButton(name, yPos, defaultText)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.85, 0, 0, 55)
	btn.Position = UDim2.new(0.075, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundTransparency = 0.8
	btn.Text = defaultText
	btn.TextColor3 = Color3.fromRGB(240, 240, 255)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamSemibold
	btn.Parent = mainFrame
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 16)
	c.Parent = btn
	
	buttons[name] = btn
end

createButton("Speed",    100, "Speed : OFF")
createButton("Fly",      165, "Fly : OFF")
createButton("Headless", 230, "Headless : OFF")
createButton("Koblox",   295, "Koblox : OFF")

-- ==================== 드래그 기능 ====================
local dragging = false
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- ==================== 기능 로직 ====================
local speedEnabled = false
local flyEnabled = false
local headlessEnabled = false
local kobloxEnabled = false

local humanoid = nil
local flyConnection
local bodyVelocity = nil
local originalRightLeg = nil

local function getHumanoid()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		humanoid = player.Character.Humanoid
	end
end
player.CharacterAdded:Connect(getHumanoid)
getHumanoid()

-- Speed
buttons["Speed"].MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	buttons["Speed"].Text = "Speed : " .. (speedEnabled and "ON" or "OFF")
	if humanoid then humanoid.WalkSpeed = speedEnabled and 100 or 16 end
end)

-- Fly
buttons["Fly"].MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	buttons["Fly"].Text = "Fly : " .. (flyEnabled and "ON" or "OFF")
	
	if flyEnabled then
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Parent = root
			
			flyConnection = RunService.RenderStepped:Connect(function()
				if not flyEnabled or not bodyVelocity then return end
				local cam = workspace.CurrentCamera
				local move = Vector3.new()
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
				
				bodyVelocity.Velocity = move.Magnitude > 0 and move.Unit * 60 or Vector3.new(0,0,0)
			end)
		end
	else
		if flyConnection then flyConnection:Disconnect() end
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	end
end)

-- Headless
buttons["Headless"].MouseButton1Click:Connect(function()
	headlessEnabled = not headlessEnabled
	buttons["Headless"].Text = "Headless : " .. (headlessEnabled and "ON" or "OFF")
	
	local character = player.Character
	if character then
		local head = character:FindFirstChild("Head")
		if head then
			if headlessEnabled then
				head.Size = Vector3.new(0.1, 0.1, 0.1)
				head.Transparency = 1
			else
				head.Size = Vector3.new(1.2, 1.2, 1.2)  -- 기본 크기
				head.Transparency = 0
			end
		end
	end
end)

-- Koblox (한쪽 다리 제거)
buttons["Koblox"].MouseButton1Click:Connect(function()
	kobloxEnabled = not kobloxEnabled
	buttons["Koblox"].Text = "Koblox : " .. (kobloxEnabled and "ON" or "OFF")
	
	local character = player.Character
	if character then
		local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg")
		if rightLeg then
			if kobloxEnabled then
				originalRightLeg = rightLeg:Clone()
				rightLeg.Transparency = 1
				rightLeg.Size = Vector3.new(0.1, 0.1, 0.1)
			else
				if originalRightLeg then
					rightLeg.Transparency = 0
					rightLeg.Size = originalRightLeg.Size
				end
			end
		end
	end
end)

-- ==================== F1 키로 열고 닫기 (토글) ====================
local uiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.F1 then
		uiVisible = not uiVisible
		
		if uiVisible then
			-- 열기
			mainFrame.Visible = true
			mainFrame.GroupTransparency = 1
			TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {GroupTransparency = 0}):Play()
		else
			-- 닫기
			local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {GroupTransparency = 1})
			tween:Play()
			tween.Completed:Connect(function()
				mainFrame.Visible = false
			end)
		end
	end
end)

print("✅ Mastr UI 로드 완료! F1 키로 열고 닫기 됩니다.")
