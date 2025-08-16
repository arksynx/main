--// Allostra.lua
local Allostra = {}

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Internal storage for GUIs
Allostra.GUIs = {}

-- Function to create a main window
function Allostra:CreateWindow(title, size)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = title or "Allostra"
    screenGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = size or UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Window"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Parent = mainFrame

    self.GUIs[title] = mainFrame
    return mainFrame
end

-- Function to add a button
function Allostra:AddButton(parentFrame, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, #parentFrame:GetChildren() * 45)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text or "Button"
    button.Parent = parentFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

-- Function to add a toggle
function Allostra:AddToggle(parentFrame, text, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 40)
    toggle.Position = UDim2.new(0, 10, 0, #parentFrame:GetChildren() * 45)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Text = text .. ": " .. (default and "ON" or "OFF")
    toggle.Parent = parentFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = toggle

    local toggled = default or false

    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggle.Text = text .. ": " .. (toggled and "ON" or "OFF")
        if callback then
            callback(toggled)
        end
    end)

    return toggle
end

return Allostra