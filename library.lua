-- // ALLOSTRA UI Library - Mobile & PC Supported
local Library = {}

local Player = game:GetService("Players").LocalPlayer
local TS, UIS = game:GetService("TweenService"), game:GetService("UserInputService")

function Library:Create(name, subname, keybind)
    if game.CoreGui:FindFirstChild(name) then
        game.CoreGui:FindFirstChild(name):Destroy()
    end

    -- Main GUI
    local xz = Instance.new("ScreenGui")
    xz.Name = name
    xz.Parent = game.CoreGui
    xz.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = xz
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Size = UDim2.new(0.9, 0, 0.8, 0)
    Main.Position = UDim2.new(0.05, 0, 0.1, 0)
    Main.BorderSizePixel = 0

    local UICornerMain = Instance.new("UICorner")
    UICornerMain.CornerRadius = UDim.new(0, 4)
    UICornerMain.Parent = Main

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.01, 0, 0, 0)
    Title.Size = UDim2.new(0.5, 0, 0, 34)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = name

    -- Subtitle
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Parent = Main
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0.01, 0, 0.1, 0)
    SubTitle.Size = UDim2.new(0.5, 0, 0, 18)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.TextColor3 = Color3.fromRGB(157, 157, 157)
    SubTitle.Text = subname

    -- Tabs Holder
    local TabsHolder = Instance.new("Frame")
    TabsHolder.Parent = Main
    TabsHolder.BackgroundTransparency = 1
    TabsHolder.Position = UDim2.new(0.01, 0, 0.16, 0)
    TabsHolder.Size = UDim2.new(0.25, 0, 0.8, 0)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabsHolder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Page Holder
    local PageHolder = Instance.new("Frame")
    PageHolder.Parent = Main
    PageHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    PageHolder.Position = UDim2.new(0.27, 0, 0.02, 0)
    PageHolder.Size = UDim2.new(0.7, 0, 0.95, 0)
    PageHolder.BorderSizePixel = 0

    local UICornerPage = Instance.new("UICorner")
    UICornerPage.CornerRadius = UDim.new(0, 4)
    UICornerPage.Parent = PageHolder

    -- Dragging support (PC + Mobile)
    local function dragify(Frame)
        local dragToggle, dragInput, dragStart, startPos
        local function updateInput(input)
            local Delta = input.Position - dragStart
            local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
            TS:Create(Frame, TweenInfo.new(0.25), {Position = Position}):Play()
        end

        Frame.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
                dragToggle = true
                dragStart = input.Position
                startPos = Frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragToggle = false
                    end
                end)
            end
        end)

        Frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragToggle then
                updateInput(input)
            end
        end)
    end
    dragify(Main)

    -- Toggle UI visibility with keybind (optional)
    UIS.InputBegan:Connect(function(key, gp)
        if not gp then
            if key.KeyCode == Enum.KeyCode.RightShift then
                Main.Visible = not Main.Visible
            end
        end
    end)

    -- Tab system
    local Window = {}
    function Window:tab(tabname, showonstartup)
        local Tab = Instance.new("TextButton")
        Tab.Name = tabname
        Tab.Parent = TabsHolder
        Tab.Size = UDim2.new(1, 0, 0, 26)
        Tab.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Tab.Font = Enum.Font.Gotham
        Tab.Text = tabname
        Tab.TextSize = 14
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)

        local UICornerTab = Instance.new("UICorner")
        UICornerTab.CornerRadius = UDim.new(0, 4)
        UICornerTab.Parent = Tab

        local Page = Instance.new("Frame")
        Page.Name = tabname
        Page.Parent = PageHolder
        Page.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = showonstartup
        Page.BorderSizePixel = 0

        local PageContainer = Instance.new("ScrollingFrame")
        PageContainer.Parent = Page
        PageContainer.Active = true
        PageContainer.BackgroundTransparency = 1
        PageContainer.Size = UDim2.new(1, -10, 1, -10)
        PageContainer.Position = UDim2.new(0, 5, 0, 5)
        PageContainer.ScrollBarThickness = 5

        local UIListLayoutPage = Instance.new("UIListLayout")
        UIListLayoutPage.Parent = PageContainer
        UIListLayoutPage.Padding = UDim.new(0, 8)
        UIListLayoutPage.SortOrder = Enum.SortOrder.LayoutOrder

        if not showonstartup then
            Tab.TextTransparency = 0.5
        end

        Tab.MouseButton1Click:Connect(function()
            for _, v in pairs(PageHolder:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            for _, z in pairs(TabsHolder:GetChildren()) do
                if z:IsA("TextButton") then
                    z.TextTransparency = 0.5
                end
            end
            Page.Visible = true
            Tab.TextTransparency = 0
        end)

        local pageitems = {}

        -- Label
        function pageitems:label(text)
            local Label = Instance.new("Frame")
            Label.Parent = PageContainer
            Label.Size = UDim2.new(1, 0, 0, 32)
            Label.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            local UICornerLabel = Instance.new("UICorner")
            UICornerLabel.Parent = Label
            UICornerLabel.CornerRadius = UDim.new(0, 4)

            local LabelText = Instance.new("TextLabel")
            LabelText.Parent = Label
            LabelText.BackgroundTransparency = 1
            LabelText.Size = UDim2.new(1, -10, 1, 0)
            LabelText.Position = UDim2.new(0, 5, 0, 0)
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextSize = 14
            LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Text = text
        end

        -- Button
        function pageitems:button(text, callback)
            local callback = callback or function() end
            local Button = Instance.new("Frame")
            Button.Parent = PageContainer
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            local UICornerButton = Instance.new("UICorner")
            UICornerButton.Parent = Button
            UICornerButton.CornerRadius = UDim.new(0, 4)

            local BtnText = Instance.new("TextButton")
            BtnText.Parent = Button
            BtnText.Size = UDim2.new(1, -10, 1, 0)
            BtnText.Position = UDim2.new(0, 5, 0, 0)
            BtnText.BackgroundTransparency = 1
            BtnText.Font = Enum.Font.Gotham
            BtnText.TextSize = 14
            BtnText.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnText.TextXAlignment = Enum.TextXAlignment.Left
            BtnText.Text = text

            BtnText.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    pcall(callback)
                end
            end)
        end

        -- Toggle
        function pageitems:toggle(text, state, callback)
            local callback = callback or function() end
            local toggled = state

            local Toggle = Instance.new("Frame")
            Toggle.Parent = PageContainer
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            local UICornerToggle = Instance.new("UICorner")
            UICornerToggle.Parent = Toggle
            UICornerToggle.CornerRadius = UDim.new(0, 4)

            local BtnText = Instance.new("TextButton")
            BtnText.Parent = Toggle
            BtnText.Size = UDim2.new(1, -40, 1, 0)
            BtnText.Position = UDim2.new(0, 5, 0, 0)
            BtnText.BackgroundTransparency = 1
            BtnText.Font = Enum.Font.Gotham
            BtnText.TextSize = 14
            BtnText.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnText.TextXAlignment = Enum.TextXAlignment.Left
            BtnText.Text = text

            local ToggleImg = Instance.new("Frame")
            ToggleImg.Parent = Toggle
            ToggleImg.Size = UDim2.new(0, 24, 0, 24)
            ToggleImg.Position = UDim2.new(1, -30, 0, 4)
            ToggleImg.BackgroundColor3 = toggled and Color3.fromRGB(106,90,205) or Color3.fromRGB(50,50,50)
            local UICornerImg = Instance.new("UICorner")
            UICornerImg.Parent = ToggleImg
            UICornerImg.CornerRadius = UDim.new(0, 4)

            BtnText.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    toggled = not toggled
                    ToggleImg.BackgroundColor3 = toggled and Color3.fromRGB(106,90,205) or Color3.fromRGB(50,50,50)
                    pcall(callback, toggled)
                end
            end)
        end

        -- Input Box
        function pageitems:input(text, placeholder, clearonreturn, callback)
            local callback = callback or function() end

            local Input = Instance.new("Frame")
            Input.Parent = PageContainer
            Input.Size = UDim2.new(1, 0, 0, 32)
            Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            local UICornerInput = Instance.new("UICorner")
            UICornerInput.Parent = Input
            UICornerInput.CornerRadius = UDim.new(0, 4)

            local LabelText = Instance.new("TextLabel")
            LabelText.Parent = Input
            LabelText.BackgroundTransparency = 1
            LabelText.Position = UDim2.new(0, 5, 0, 0)
            LabelText.Size = UDim2.new(0.65, 0, 1, 0)
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextSize = 14
            LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Text = text

            local TextBox = Instance.new("TextBox")
            TextBox.Parent = Input
            TextBox.Size = UDim2.new(0.3, 0, 1, 0)
            TextBox.Position = UDim2.new(0.68, 0, 0, 0)
            TextBox.Text = ""
            TextBox.PlaceholderText = placeholder or ""
            TextBox.ClearTextOnFocus = false
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 14

            TextBox.FocusLost:Connect(function()
                pcall(callback, TextBox.Text)
                if clearonreturn then
                    TextBox.Text = ""
                end
            end)
        end

        return pageitems
    end

    return Window
end

return Library
