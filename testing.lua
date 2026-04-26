local UIProtect = {}
UIProtect.__index = UIProtect

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Helper: Simple Dragging Functionality
local function MakeDraggable(frame, dragPoint)
    local dragging, dragInput, dragStart, startPos
    dragPoint.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function UIProtect.Init(title)
    local self = setmetatable({}, UIProtect)
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "Library_" .. math.random(100, 999)
    self.ScreenGui.Parent = game:GetService("CoreGui") -- Change to PlayerGui for Studio testing
    
    -- Main Frame
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 450, 0, 300)
    self.Main.Position = UDim2.new(0.5, -225, 0.5, -150)
    self.Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.Main.BorderSizePixel = 0
    self.Main.Parent = self.ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Main

    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.Main
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.Parent = self.TitleBar
    
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Text = title or "UI Library"
    self.TitleText.Size = UDim2.new(1, -10, 1, 0)
    self.TitleText.Position = UDim2.new(0, 10, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Font = Enum.Font.GothamBold
    self.TitleText.Parent = self.TitleBar

    -- Container for Elements
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Size = UDim2.new(1, -20, 1, -55)
    self.Container.Position = UDim2.new(0, 10, 0, 45)
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.ScrollBarThickness = 2
    self.Container.Parent = self.Main
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = self.Container

    MakeDraggable(self.Main, self.TitleBar)
    return self
end

function UIProtect:CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -5, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(230, 230, 230)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.AutoButtonColor = true
    Button.Parent = self.Container
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 4)
    BCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

return UIProtect
