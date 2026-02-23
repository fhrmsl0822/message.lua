if game.CoreGui:FindFirstChild("MacUI") then
	game.CoreGui.MacUI:Destroy()
end

local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "MacUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("CanvasGroup")
main.Name = "MainWindow"
main.Parent = gui
main.Size = UDim2.new(0, 500, 0, 300)
main.Position = UDim2.new(0.5, -250, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.GroupTransparency = 0

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = main

local topBar = Instance.new("Frame")
topBar.Parent = main
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
topBar.BorderSizePixel = 0

local function createCircle(color, pos)
	local btn = Instance.new("Frame")
	btn.Parent = topBar
	btn.Size = UDim2.new(0, 14, 0, 14)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.BorderSizePixel = 0
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(1, 0)
	c.Parent = btn
	
	return btn
end

local red = createCircle(Color3.fromRGB(255, 95, 86), UDim2.new(0, 15, 0.5, -7))
local yellow = createCircle(Color3.fromRGB(255, 189, 46), UDim2.new(0, 35, 0.5, -7))
local green = createCircle(Color3.fromRGB(39, 201, 63), UDim2.new(0, 55, 0.5, -7))

red.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		gui:Destroy()
	end
end)
