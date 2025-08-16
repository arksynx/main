--// Allostra GUI Library
local Library = {}
Library.__index = Library

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove existing GUI
local existingGui = playerGui:FindFirstChild("AllostraGUI")
if existingGui then
    existingGui:Destroy()
end

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllostraGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true -- mobile support

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 10)
uicorner.Parent = mainFrame

-- Title bar (dragging)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,0,1,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Allostra GUI"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Parent = titleBar

-- Drag function
local dragging = false
local dragInput, mousePos, framePos

local function update(input)
    local delta = input.Position - mousePos
    mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                   framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       (UserInputService.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

--// Library functions
function Library:CreateTab(tabName)
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 1, -50)
    tabFrame.Position = UDim2.new(0, 10, 0, 40)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame

    local tab = {}
    tab.__index = tab

    -- Button inside tab
    function tab:Button(name, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 30)
        button.Position = UDim2.new(0,10,0,#tabFrame:GetChildren()*35)
        button.BackgroundColor3 = Color3.fromRGB(70,70,70)
        button.TextColor3 = Color3.fromRGB(255,255,255)
        button.Text = name
        button.Parent = tabFrame

        button.MouseButton1Click:Connect(callback)
        return button
    end

    -- Toggle inside tab
    function tab:Toggle(name, callback)
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(1, -20, 0, 30)
        toggle.Position = UDim2.new(0,10,0,#tabFrame:GetChildren()*35)
        toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
        toggle.TextColor3 = Color3.fromRGB(255,255,255)
        toggle.Text = name.." [OFF]"
        toggle.Parent = tabFrame

        local state = false
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = name.." ["..(state and "ON" or "OFF").."]"
            callback(state)
        end)
        return toggle
    end

    -- Slider inside tab
    function tab:Slider(name, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -20, 0, 30)
        sliderFrame.Position = UDim2.new(0,10,0,#tabFrame:GetChildren()*35)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(70,70,70)
        sliderFrame.Parent = tabFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Text = name.." : "..default
        label.Parent = sliderFrame

        local dragging = false
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        sliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        sliderFrame.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relative = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X)/sliderFrame.AbsoluteSize.X,0,1)
                local value = math.floor(min + (max - min) * relative)
                label.Text = name.." : "..value
                callback(value)
            end
        end)

        return sliderFrame
    end

    -- TextBox inside tab
    function tab:TextBox(name, placeholder, callback)
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, -20, 0, 30)
        textBox.Position = UDim2.new(0,10,0,#tabFrame:GetChildren()*35)
        textBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
        textBox.TextColor3 = Color3.fromRGB(255,255,255)
        textBox.Text = placeholder
        textBox.Parent = tabFrame

        textBox.FocusLost:Connect(function(enter)
            if enter then
                callback(textBox.Text)
            end
        end)
        return textBox
    end

    return setmetatable(tab, tab)
end

return setmetatable({}, Library)
