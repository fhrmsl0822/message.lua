if game.CoreGui:FindFirstChild("MobileUniversalUI") then
	game.CoreGui.MobileUniversalUI:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- =========================
-- Main UI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "MobileUniversalUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromOffset(540, 380)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(30,30,35)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

local mainGrad = Instance.new("UIGradient", main)
mainGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(32,32,37)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,33))
}
mainGrad.Rotation = 90

-- =========================
-- Top Bar
-- =========================
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,45)
top.BackgroundColor3 = Color3.fromRGB(38,38,43)
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0,18)

local topGrad = Instance.new("UIGradient", top)
topGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(42,42,47)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(37,37,42))
}
topGrad.Rotation = 90

local function macDot(color,x)
	local dot = Instance.new("Frame", top)
	dot.Size = UDim2.fromOffset(12,12)
	dot.Position = UDim2.fromOffset(x,16)
	dot.BackgroundColor3 = color
	dot.BorderSizePixel = 0
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
	return dot
end

local red = macDot(Color3.fromRGB(255,95,87),15)
macDot(Color3.fromRGB(255,189,46),35)
macDot(Color3.fromRGB(39,201,63),55)

-- =========================
-- Show/Hide UI
-- =========================
local uiVisible = true
local function toggleUI()
	uiVisible = not uiVisible
	if uiVisible then
		main.Visible = true
		local tween = TweenService:Create(main,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(540,380)})
		tween:Play()
	else
		local tween = TweenService:Create(main,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.fromOffset(480,340),BackgroundTransparency=0.5})
		tween:Play()
		tween.Completed:Connect(function()
			main.Visible = false
			main.BackgroundTransparency = 0
		end)
	end
end

UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.F1 then
		toggleUI()
	end
end)

red.InputBegan:Connect(function()
	toggleUI()
end)

-- =========================
-- Sidebar
-- =========================
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0,70,1,-45)
sidebar.Position = UDim2.fromOffset(0,45)
sidebar.BackgroundColor3 = Color3.fromRGB(24,24,28)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,18)

local layout = Instance.new("UIListLayout", sidebar)
layout.Padding = UDim.new(0,18)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- =========================
-- Content Holder
-- =========================
local contentHolder = Instance.new("Frame", main)
contentHolder.Position = UDim2.fromOffset(80,55)
contentHolder.Size = UDim2.new(1,-95,1,-70)
contentHolder.BackgroundTransparency = 1

local function createPage()
	local page = Instance.new("Frame")
	page.Parent = contentHolder
	page.Size = UDim2.new(1,0,1,0)
	page.BackgroundTransparency = 1
	page.Visible = false
	return page
end

local profilePage = createPage()
local homePage = createPage()
local extraPage = createPage()
local settingsPage = createPage()
profilePage.Visible = true

local pages = {profilePage, homePage, extraPage, settingsPage}
local function switchPage(index)
	for i,v in ipairs(pages) do
		v.Visible = (i==index)
	end
end

local icons = {"👤","🏠","◉","⚙"}
for i,iconText in ipairs(icons) do
	local icon = Instance.new("TextButton", sidebar)
	icon.Size = UDim2.fromOffset(42,42)
	icon.Text = iconText
	icon.Font = Enum.Font.GothamBold
	icon.TextSize = 18
	icon.TextColor3 = Color3.new(1,1,1)
	icon.BackgroundColor3 = Color3.fromRGB(45,45,50)
	icon.BorderSizePixel = 0
	Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)
	icon.MouseButton1Click:Connect(function()
		switchPage(i)
	end)
end

-- =========================
-- Profile Page
-- =========================
local infoFrame = Instance.new("Frame", profilePage)
infoFrame.Size = UDim2.new(1,0,1,0)
infoFrame.BackgroundColor3 = Color3.fromRGB(40,40,45)
infoFrame.BorderSizePixel = 0
Instance.new("UICorner", infoFrame).CornerRadius = UDim.new(0,16)

local thumb = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
local avatar = Instance.new("ImageLabel", infoFrame)
avatar.Size = UDim2.fromOffset(100,100)
avatar.Position = UDim2.fromOffset(20,20)
avatar.BackgroundTransparency = 1
avatar.Image = thumb
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

local infoText = Instance.new("TextLabel", infoFrame)
infoText.Size = UDim2.new(1,-140,1,-40)
infoText.Position = UDim2.fromOffset(140,20)
infoText.BackgroundTransparency = 1
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 16
infoText.TextColor3 = Color3.new(1,1,1)
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Text =
	"DisplayName: "..player.DisplayName..
	"\nUsername: @"..player.Name..
	"\nUserId: "..player.UserId..
	"\nAccountAge: "..player.AccountAge.." days"

-- =========================
-- Settings Page: UI Scale
-- =========================
local currentScale = 1
local function updateSize()
	main.Size = UDim2.fromOffset(540*currentScale,380*currentScale)
end

local sizeFrame = Instance.new("Frame", settingsPage)
sizeFrame.Size = UDim2.fromOffset(250,120)
sizeFrame.Position = UDim2.fromOffset(20,20)
sizeFrame.BackgroundColor3 = Color3.fromRGB(40,40,45)
Instance.new("UICorner", sizeFrame).CornerRadius = UDim.new(0,16)

local sizeLabel = Instance.new("TextLabel", sizeFrame)
sizeLabel.Size = UDim2.new(1,0,0,40)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Scale: 1.0x"
sizeLabel.Font = Enum.Font.GothamBold
sizeLabel.TextSize = 16
sizeLabel.TextColor3 = Color3.new(1,1,1)

local minusBtn = Instance.new("TextButton", sizeFrame)
minusBtn.Size = UDim2.fromOffset(60,40)
minusBtn.Position = UDim2.fromOffset(30,60)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 22
minusBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0,12)

local plusBtn = Instance.new("TextButton", sizeFrame)
plusBtn.Size = UDim2.fromOffset(60,40)
plusBtn.Position = UDim2.fromOffset(140,60)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 22
plusBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,12)

minusBtn.MouseButton1Click:Connect(function()
	if currentScale>0.6 then
		currentScale-=0.1
		updateSize()
		sizeLabel.Text = "Scale: "..string.format("%.1f",currentScale).."x"
	end
end)

plusBtn.MouseButton1Click:Connect(function()
	if currentScale<1.8 then
		currentScale+=0.1
		updateSize()
		sizeLabel.Text = "Scale: "..string.format("%.1f",currentScale).."x"
	end
end)

-- =========================
-- Home Page: Infinite Jump, Speed, Fly
-- =========================
local homeFrame = Instance.new("Frame", homePage)
homeFrame.Size = UDim2.fromOffset(280,220)
homeFrame.Position = UDim2.fromOffset(20,20)
homeFrame.BackgroundColor3 = Color3.fromRGB(40,40,45)
Instance.new("UICorner", homeFrame).CornerRadius = UDim.new(0,16)

-- Infinite Jump
local infJumpLabel = Instance.new("TextLabel", homeFrame)
infJumpLabel.Size = UDim2.new(1,0,0,30)
infJumpLabel.Position = UDim2.fromOffset(0,10)
infJumpLabel.BackgroundTransparency = 1
infJumpLabel.Text = "Infinite Jump: OFF"
infJumpLabel.Font = Enum.Font.GothamBold
infJumpLabel.TextSize = 16
infJumpLabel.TextColor3 = Color3.new(1,1,1)

local infJumpToggle = Instance.new("TextButton", homeFrame)
infJumpToggle.Size = UDim2.fromOffset(100,30)
infJumpToggle.Position = UDim2.fromOffset(90,40)
infJumpToggle.Text = "Toggle"
infJumpToggle.Font = Enum.Font.GothamBold
infJumpToggle.TextSize = 16
infJumpToggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
Instance.new("UICorner", infJumpToggle).CornerRadius = UDim.new(0,12)

local infJumpEnabled = false
infJumpToggle.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infJumpLabel.Text = "Infinite Jump: "..(infJumpEnabled and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
	if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Walk Speed
local speed = 23
local speedLabel = Instance.new("TextLabel", homeFrame)
speedLabel.Size = UDim2.new(1,0,0,30)
speedLabel.Position = UDim2.fromOffset(0,80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..speed
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 16
speedLabel.TextColor3 = Color3.new(1,1,1)

local speedMinus = Instance.new("TextButton", homeFrame)
speedMinus.Size = UDim2.fromOffset(50,30)
speedMinus.Position = UDim2.fromOffset(40,110)
speedMinus.Text = "-"
speedMinus.Font = Enum.Font.GothamBold
speedMinus.TextSize = 18
speedMinus.BackgroundColor3 = Color3.fromRGB(60,60,70)
Instance.new("UICorner", speedMinus).CornerRadius = UDim.new(0,12)

local speedPlus = Instance.new("TextButton", homeFrame)
speedPlus.Size = UDim2.fromOffset(50,30)
speedPlus.Position = UDim2.fromOffset(190,110)
speedPlus.Text = "+"
speedPlus.Font = Enum.Font.GothamBold
speedPlus.TextSize = 18
speedPlus.BackgroundColor3 = Color3.fromRGB(60,60,70)
Instance.new("UICorner", speedPlus).CornerRadius = UDim.new(0,12)

local function updateSpeed()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
	end
	speedLabel.Text = "Speed: "..speed
end
updateSpeed()

speedMinus.MouseButton1Click:Connect(function()
	if speed>1 then speed-=1 updateSpeed() end
end)
speedPlus.MouseButton1Click:Connect(function()
	if speed<200 then speed+=1 updateSpeed() end
end)

-- Fly
local fly = false
local flySpeed = 50
local flyLabel = Instance.new("TextLabel", homeFrame)
flyLabel.Size = UDim2.new(1,0,0,30)
flyLabel.Position = UDim2.fromOffset(0,150)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "Fly: OFF"
flyLabel.Font = Enum.Font.GothamBold
flyLabel.TextSize = 16
flyLabel.TextColor3 = Color3.new(1,1,1)

local flyToggle = Instance.new("TextButton", homeFrame)
flyToggle.Size = UDim2.fromOffset(100,30)
flyToggle.Position = UDim2.fromOffset(90,180)
flyToggle.Text = "Toggle"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 16
flyToggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
Instance.new("UICorner", flyToggle).CornerRadius = UDim.new(0,12)

flyToggle.MouseButton1Click:Connect(function()
	fly = not fly
	flyLabel.Text = "Fly: "..(fly and "ON" or "OFF")
end)

local bodyVelocity
RunService.RenderStepped:Connect(function()
	if fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		if not bodyVelocity then
			bodyVelocity = Instance.new("BodyVelocity", hrp)
			bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
		end
		local moveDir = Vector3.new(0,0,0)
		if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
		bodyVelocity.Velocity = moveDir.Magnitude>0 and moveDir.Unit*flySpeed or Vector3.new(0,0,0)
	else
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity=nil end
	end
end)
