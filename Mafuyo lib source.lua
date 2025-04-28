--[[
    Mafuyo UI Library for Roblox Executors
    Features:
    - Buttons, sliders, dropdowns, toggles, labels, text inputs
    - Themes and customization
    - Notifications system with 5-minute reminders
    - Mini UI that can be opened and closed
    - Key system for authentication
]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local library = {
    title = "Mafuyo UI Library",
    theme = "Dark",
    toggled = true,
    key = "MAFUYO", -- Default key
    notifications = {},
    flags = {},
    options = {},
    tabs = {},
    currentTab = nil
}

-- Themes
local themes = {
    Dark = {
        background = Color3.fromRGB(30, 30, 30),
        foreground = Color3.fromRGB(45, 45, 45),
        accent = Color3.fromRGB(0, 120, 215),
        textColor = Color3.fromRGB(255, 255, 255),
        elementBackground = Color3.fromRGB(60, 60, 60),
        elementBorder = Color3.fromRGB(80, 80, 80),
        success = Color3.fromRGB(0, 180, 0),
        warning = Color3.fromRGB(255, 165, 0),
        error = Color3.fromRGB(255, 0, 0),
    },
    Light = {
        background = Color3.fromRGB(240, 240, 240),
        foreground = Color3.fromRGB(225, 225, 225),
        accent = Color3.fromRGB(0, 120, 215),
        textColor = Color3.fromRGB(0, 0, 0),
        elementBackground = Color3.fromRGB(200, 200, 200),
        elementBorder = Color3.fromRGB(180, 180, 180),
        success = Color3.fromRGB(0, 180, 0),
        warning = Color3.fromRGB(255, 165, 0),
        error = Color3.fromRGB(255, 0, 0),
    },
    Neon = {
        background = Color3.fromRGB(20, 20, 20),
        foreground = Color3.fromRGB(30, 30, 30),
        accent = Color3.fromRGB(0, 255, 255),
        textColor = Color3.fromRGB(255, 255, 255),
        elementBackground = Color3.fromRGB(40, 40, 40),
        elementBorder = Color3.fromRGB(0, 255, 255),
        success = Color3.fromRGB(0, 255, 0),
        warning = Color3.fromRGB(255, 255, 0),
        error = Color3.fromRGB(255, 0, 0),
    },
    Blurple = {
        background = Color3.fromRGB(54, 57, 63),
        foreground = Color3.fromRGB(47, 49, 54),
        accent = Color3.fromRGB(114, 137, 218),
        textColor = Color3.fromRGB(255, 255, 255),
        elementBackground = Color3.fromRGB(66, 70, 77),
        elementBorder = Color3.fromRGB(114, 137, 218),
        success = Color3.fromRGB(67, 181, 129),
        warning = Color3.fromRGB(250, 166, 26),
        error = Color3.fromRGB(240, 71, 71),
    }
}

-- Utility functions
local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local tInfo = TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tInfo, properties)
    return tween
end

local function makeRound(instance, radius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius or 5)
    uiCorner.Parent = instance
    return uiCorner
end

local function makeDraggable(frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Create main GUI
local function createMainGUI()
    -- Check if GUI already exists and remove it
    if CoreGui:FindFirstChild("MafuyoUILibrary") then
        CoreGui:FindFirstChild("MafuyoUILibrary"):Destroy()
    end
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MafuyoUILibrary"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to use CoreGui (for exploits), fallback to PlayerGui
    local success, err = pcall(function()
        screenGui.Parent = CoreGui
    end)
    
    if not success then
        screenGui.Parent = player:WaitForChild("PlayerGui")
    end
    
    return screenGui
end

-- Create notification system
function library:CreateNotification(title, message, notificationType, duration)
    local theme = themes[self.theme]
    local screenGui = CoreGui:FindFirstChild("MafuyoUILibrary")
    
    if not screenGui then return end
    
    -- Create notification container if it doesn't exist
    if not screenGui:FindFirstChild("NotificationContainer") then
        local container = Instance.new("Frame")
        container.Name = "NotificationContainer"
        container.Size = UDim2.new(0, 250, 1, 0)
        container.Position = UDim2.new(1, -260, 0, 10)
        container.BackgroundTransparency = 1
        container.Parent = screenGui
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.Parent = container
    end
    
    local container = screenGui:FindFirstChild("NotificationContainer")
    
    -- Create notification
    local notifType = notificationType or "info"
    local typeColor
    
    if notifType == "success" then
        typeColor = theme.success
    elseif notifType == "warning" then
        typeColor = theme.warning
    elseif notifType == "error" then
        typeColor = theme.error
    else
        typeColor = theme.accent
    end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification_" .. HttpService:GenerateGUID(false)
    notification.Size = UDim2.new(1, -10, 0, 80)
    notification.BackgroundColor3 = theme.foreground
    notification.BorderSizePixel = 0
    notification.Parent = container
    makeRound(notification)
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Name = "Title"
    notifTitle.Size = UDim2.new(1, -10, 0, 25)
    notifTitle.Position = UDim2.new(0, 5, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = typeColor
    notifTitle.TextSize = 16
    notifTitle.Font = Enum.Font.SourceSansBold
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Parent = notification
    
    local notifMessage = Instance.new("TextLabel")
    notifMessage.Name = "Message"
    notifMessage.Size = UDim2.new(1, -10, 0, 40)
    notifMessage.Position = UDim2.new(0, 5, 0, 30)
    notifMessage.BackgroundTransparency = 1
    notifMessage.Text = message
    notifMessage.TextColor3 = theme.textColor
    notifMessage.TextSize = 14
    notifMessage.Font = Enum.Font.SourceSans
    notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    notifMessage.TextYAlignment = Enum.TextYAlignment.Top
    notifMessage.TextWrapped = true
    notifMessage.Parent = notification
    
    local closeNotifButton = Instance.new("TextButton")
    closeNotifButton.Name = "CloseButton"
    closeNotifButton.Size = UDim2.new(0, 20, 0, 20)
    closeNotifButton.Position = UDim2.new(1, -25, 0, 5)
    closeNotifButton.BackgroundTransparency = 1
    closeNotifButton.Text = "X"
    closeNotifButton.TextColor3 = theme.textColor
    closeNotifButton.TextSize = 14
    closeNotifButton.Font = Enum.Font.SourceSansBold
    closeNotifButton.Parent = notification
    
    -- Animation
    notification.Position = UDim2.new(1, 0, 0, 0)
    local tween = createTween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
    tween:Play()
    
    -- Auto-remove after duration
    local function removeNotification()
        local removeTween = createTween(notification, {Position = UDim2.new(1, 0, 0, 0)}, 0.3)
        removeTween:Play()
        removeTween.Completed:Connect(function()
            notification:Destroy()
        end)
    end
    
    closeNotifButton.MouseButton1Click:Connect(removeNotification)
    
    delay(duration or 5, removeNotification)
    
    return notification
end

-- Start periodic notifications
function library:StartPeriodicNotifications(interval)
    spawn(function()
        while true do
            wait(interval or 300) -- Default 5 minutes (300 seconds)
            self:CreateNotification("Mafuyo Reminder", "This is your 5-minute reminder notification.", "info")
        end
    end)
end

-- Create key system
function library:CreateKeySystem(callback)
    local theme = themes[self.theme]
    local screenGui = createMainGUI()
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Name = "KeyFrame"
    keyFrame.Size = UDim2.new(0, 300, 0, 150)
    keyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    keyFrame.BackgroundColor3 = theme.background
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = screenGui
    makeRound(keyFrame)
    makeDraggable(keyFrame)
    
    local keyTitle = Instance.new("TextLabel")
    keyTitle.Name = "KeyTitle"
    keyTitle.Size = UDim2.new(1, 0, 0, 30)
    keyTitle.BackgroundColor3 = theme.foreground
    keyTitle.BorderSizePixel = 0
    keyTitle.Text = "Mafuyo Key System"
    keyTitle.TextColor3 = theme.textColor
    keyTitle.TextSize = 16
    keyTitle.Font = Enum.Font.SourceSansBold
    keyTitle.Parent = keyFrame
    makeRound(keyTitle)
    
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(1, -20, 0, 30)
    keyInput.Position = UDim2.new(0, 10, 0, 50)
    keyInput.BackgroundColor3 = theme.elementBackground
    keyInput.BorderSizePixel = 0
    keyInput.PlaceholderText = "Enter your key..."
    keyInput.Text = ""
    keyInput.TextColor3 = theme.textColor
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.SourceSans
    keyInput.Parent = keyFrame
    makeRound(keyInput)
    
    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(0, 100, 0, 30)
    submitButton.Position = UDim2.new(0.5, -50, 0, 100)
    submitButton.BackgroundColor3 = theme.accent
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Submit"
    submitButton.TextColor3 = theme.textColor
    submitButton.TextSize = 14
    submitButton.Font = Enum.Font.SourceSansBold
    submitButton.Parent = keyFrame
    makeRound(submitButton)
    
    submitButton.MouseButton1Click:Connect(function()
        if keyInput.Text == self.key then
            keyFrame:Destroy()
            if callback then callback(true) end
        else
            self:CreateNotification("Error", "Invalid key. Please try again.", "error")
            keyInput.Text = ""
        end
    end)
    
    return keyFrame
end

-- Create main window
function library:CreateWindow(customTitle)
    local theme = themes[self.theme]
    local screenGui = createMainGUI()
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainFrame.BackgroundColor3 = theme.background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    makeRound(mainFrame)
    makeDraggable(mainFrame)
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = theme.foreground
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    makeRound(titleBar)
    
    -- Create title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = customTitle or self.title
    title.TextColor3 = theme.textColor
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Create close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -28, 0, 3)
    closeButton.BackgroundColor3 = theme.error
    closeButton.Text = "X"
    closeButton.TextColor3 = theme.textColor
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = titleBar
    makeRound(closeButton)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Create minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 24, 0, 24)
    minimizeButton.Position = UDim2.new(1, -56, 0, 3)
    minimizeButton.BackgroundColor3 = theme.warning
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = theme.textColor
    minimizeButton.TextSize = 14
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.Parent = titleBar
    makeRound(minimizeButton)
    
    -- Create content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -40)
    contentFrame.Position = UDim2.new(0, 10, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Create tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.BackgroundColor3 = theme.foreground
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = contentFrame
    makeRound(tabContainer)
    
    -- Create tab content container
    local tabContentContainer = Instance.new("Frame")
    tabContentContainer.Name = "TabContentContainer"
    tabContentContainer.Size = UDim2.new(1, 0, 1, -35)
    tabContentContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContentContainer.BackgroundTransparency = 1
    tabContentContainer.Parent = contentFrame
    
    -- Create mini UI button (for minimizing to a small floating button)
    local miniUIButton = Instance.new("TextButton")
    miniUIButton.Name = "MiniUIButton"
    miniUIButton.Size = UDim2.new(0, 50, 0, 50)
    miniUIButton.Position = UDim2.new(0, 20, 0, 20)
    miniUIButton.BackgroundColor3 = theme.accent
    miniUIButton.Text = "M"
    miniUIButton.TextColor3 = theme.textColor
    miniUIButton.TextSize = 18
    miniUIButton.Font = Enum.Font.SourceSansBold
    miniUIButton.Visible = false
    miniUIButton.Parent = screenGui
    makeRound(miniUIButton, 25)
    makeDraggable(miniUIButton)
    
    -- Minimize/restore functionality
    local isMinimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            mainFrame.Visible = false
            miniUIButton.Visible = true
        else
            mainFrame.Visible = true
            miniUIButton.Visible = false
        end
    end)
    
    miniUIButton.MouseButton1Click:Connect(function()
        isMinimized = false
        mainFrame.Visible = true
        miniUIButton.Visible = false
    end)
    
    -- Window API
    local window = {}
    window.tabs = {}
    window.tabButtons = {}
    window.currentTab = nil
    
    -- Function to select a tab
    function window:SelectTab(tabName)
        for name, tab in pairs(self.tabs) do
            if name == tabName then
                tab.Visible = true
                self.tabButtons[name].BackgroundColor3 = theme.accent
            else
                tab.Visible = false
                self.tabButtons[name].BackgroundColor3 = theme.elementBackground
            end
        end
        self.currentTab = tabName
    end
    
    -- Create a new tab
    function window:AddTab(tabName)
        -- Create tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Button"
        tabButton.BackgroundColor3 = #self.tabs == 0 and theme.accent or theme.elementBackground
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabName
        tabButton.TextColor3 = theme.textColor
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Parent = tabContainer
        makeRound(tabButton, 4)

                -- Position the tab button
        local tabCount = 0
        for _ in pairs(self.tabs) do tabCount = tabCount + 1 end
        tabButton.Size = UDim2.new(0, 100, 1, -6)
        tabButton.Position = UDim2.new(0, 5 + (tabCount * 105), 0, 3)
        
        -- Create tab content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.Visible = tabCount == 0
        tabContent.Parent = tabContentContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        contentLayout.Parent = tabContent
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 5)
        contentPadding.PaddingBottom = UDim.new(0, 5)
        contentPadding.Parent = tabContent
        
        -- Store tab references
        self.tabs[tabName] = tabContent
        self.tabButtons[tabName] = tabButton
        
        if tabCount == 0 then
            self.currentTab = tabName
        end
        
        -- Tab button click event
        tabButton.MouseButton1Click:Connect(function()
            self:SelectTab(tabName)
        end)
        
        -- Tab API
        local tab = {}
        
        -- Add a section to the tab
        function tab:AddSection(sectionName)
            local section = Instance.new("Frame")
            section.Name = sectionName .. "Section"
            section.Size = UDim2.new(1, -10, 0, 30) -- Will be resized based on content
            section.BackgroundColor3 = theme.foreground
            section.BorderSizePixel = 0
            section.Parent = tabContent
            makeRound(section)
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, 0, 0, 25)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = sectionName
            sectionTitle.TextColor3 = theme.textColor
            sectionTitle.TextSize = 14
            sectionTitle.Font = Enum.Font.SourceSansBold
            sectionTitle.Parent = section
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.Size = UDim2.new(1, 0, 0, 5) -- Will be resized based on content
            sectionContent.Position = UDim2.new(0, 0, 0, 25)
            sectionContent.BackgroundTransparency = 1
            sectionContent.Parent = section
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 5)
            contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            contentLayout.Parent = sectionContent
            
            local contentPadding = Instance.new("UIPadding")
            contentPadding.PaddingTop = UDim.new(0, 5)
            contentPadding.PaddingBottom = UDim.new(0, 5)
            contentPadding.PaddingLeft = UDim.new(0, 5)
            contentPadding.PaddingRight = UDim.new(0, 5)
            contentPadding.Parent = sectionContent
            
            -- Update section size based on content
            local function updateSectionSize()
                local contentSize = contentLayout.AbsoluteContentSize
                sectionContent.Size = UDim2.new(1, 0, 0, contentSize.Y + 10)
                section.Size = UDim2.new(1, -10, 0, contentSize.Y + 35)
            end
            
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)
            
            -- Section API
            local sectionAPI = {}
            
            -- Add a button
            function sectionAPI:AddButton(buttonText, callback)
                local button = Instance.new("TextButton")
                button.Name = buttonText .. "Button"
                button.Size = UDim2.new(1, 0, 0, 30)
                button.BackgroundColor3 = theme.elementBackground
                button.BorderSizePixel = 0
                button.Text = buttonText
                button.TextColor3 = theme.textColor
                button.TextSize = 14
                button.Font = Enum.Font.SourceSans
                button.Parent = sectionContent
                makeRound(button)
                
                button.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                
                updateSectionSize()
                return button
            end
            
            -- Add a toggle
            function sectionAPI:AddToggle(toggleText, default, callback, flag)
                local toggleValue = default or false
                
                if flag then
                    library.flags[flag] = toggleValue
                end
                
                local toggleContainer = Instance.new("Frame")
                toggleContainer.Name = toggleText .. "Container"
                toggleContainer.Size = UDim2.new(1, 0, 0, 30)
                toggleContainer.BackgroundTransparency = 1
                toggleContainer.Parent = sectionContent
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Name = "Label"
                toggleLabel.Size = UDim2.new(1, -50, 1, 0)
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text = toggleText
                toggleLabel.TextColor3 = theme.textColor
                toggleLabel.TextSize = 14
                toggleLabel.Font = Enum.Font.SourceSans
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Parent = toggleContainer
                
                local toggleButton = Instance.new("Frame")
                toggleButton.Name = "ToggleButton"
                toggleButton.Size = UDim2.new(0, 40, 0, 20)
                toggleButton.Position = UDim2.new(1, -45, 0.5, -10)
                toggleButton.BackgroundColor3 = toggleValue and theme.accent or theme.elementBackground
                toggleButton.BorderSizePixel = 0
                toggleButton.Parent = toggleContainer
                makeRound(toggleButton, 10)
                
                local toggleCircle = Instance.new("Frame")
                toggleCircle.Name = "Circle"
                toggleCircle.Size = UDim2.new(0, 16, 0, 16)
                toggleCircle.Position = UDim2.new(toggleValue and 0.6 or 0, toggleValue and 0 or 2, 0.5, -8)
                toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleCircle.BorderSizePixel = 0
                toggleCircle.Parent = toggleButton
                makeRound(toggleCircle, 8)
                
                local toggleClick = Instance.new("TextButton")
                toggleClick.Name = "ClickDetector"
                toggleClick.Size = UDim2.new(1, 0, 1, 0)
                toggleClick.BackgroundTransparency = 1
                toggleClick.Text = ""
                toggleClick.Parent = toggleContainer
                
                local function updateToggle()
                    toggleValue = not toggleValue
                    local pos = toggleValue and 0.6 or 0
                    local color = toggleValue and theme.accent or theme.elementBackground
                    
                    createTween(toggleCircle, {Position = UDim2.new(pos, toggleValue and 0 or 2, 0.5, -8)}, 0.2):Play()
                    createTween(toggleButton, {BackgroundColor3 = color}, 0.2):Play()
                    
                    if flag then
                        library.flags[flag] = toggleValue
                    end
                    
                    if callback then callback(toggleValue) end
                end
                
                toggleClick.MouseButton1Click:Connect(updateToggle)
                
                updateSectionSize()
                
                -- Toggle API
                local toggleAPI = {}
                
                function toggleAPI:Set(value)
                    if value ~= toggleValue then
                        updateToggle()
                    end
                end
                
                function toggleAPI:Get()
                    return toggleValue
                end
                
                return toggleAPI
            end
            
            -- Add a slider
            function sectionAPI:AddSlider(sliderText, min, max, default, callback, flag)
                min = min or 0
                max = max or 100
                default = default or min
                
                local sliderValue = default
                
                if flag then
                    library.flags[flag] = sliderValue
                end
                
                local sliderContainer = Instance.new("Frame")
                sliderContainer.Name = sliderText .. "Container"
                sliderContainer.Size = UDim2.new(1, 0, 0, 50)
                sliderContainer.BackgroundTransparency = 1
                sliderContainer.Parent = sectionContent
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "Label"
                sliderLabel.Size = UDim2.new(1, 0, 0, 20)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = sliderText .. ": " .. default
                sliderLabel.TextColor3 = theme.textColor
                sliderLabel.TextSize = 14
                sliderLabel.Font = Enum.Font.SourceSans
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = sliderContainer
                
                local sliderBackground = Instance.new("Frame")
                sliderBackground.Name = "Background"
                sliderBackground.Size = UDim2.new(1, 0, 0, 10)
                sliderBackground.Position = UDim2.new(0, 0, 0.5, 0)
                sliderBackground.BackgroundColor3 = theme.elementBackground
                sliderBackground.BorderSizePixel = 0
                sliderBackground.Parent = sliderContainer
                makeRound(sliderBackground, 5)
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.BackgroundColor3 = theme.accent
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderBackground
                makeRound(sliderFill, 5)
                
                local sliderKnob = Instance.new("Frame")
                sliderKnob.Name = "Knob"
                sliderKnob.Size = UDim2.new(0, 16, 0, 16)
                sliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
                sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderKnob.BorderSizePixel = 0
                sliderKnob.Parent = sliderBackground
                makeRound(sliderKnob, 8)
                
                local sliderClick = Instance.new("TextButton")
                sliderClick.Name = "ClickDetector"
                sliderClick.Size = UDim2.new(1, 0, 1, 0)
                sliderClick.BackgroundTransparency = 1
                sliderClick.Text = ""
                sliderClick.Parent = sliderBackground
                
                local function updateSlider(input)
                    local pos = input.Position.X
                    local size = sliderBackground.AbsoluteSize.X
                    local start = sliderBackground.AbsolutePosition.X
                    
                    local relativePos = math.clamp((pos - start) / size, 0, 1)
                    local value = min + (max - min) * relativePos
                    value = math.floor(value + 0.5) -- Round to nearest integer
                    
                    sliderValue = value
                    sliderLabel.Text = sliderText .. ": " .. value
                    sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                    sliderKnob.Position = UDim2.new(relativePos, -8, 0.5, -8)
                    
                    if flag then
                        library.flags[flag] = value
                    end
                    
                    if callback then callback(value) end
                end
                
                local dragging = false
                
                sliderClick.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                sliderClick.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                updateSectionSize()
                
                -- Slider API
                local sliderAPI = {}
                
                function sliderAPI:Set(value)
                    value = math.clamp(value, min, max)
                    local relativePos = (value - min) / (max - min)
                    
                    sliderValue = value
                    sliderLabel.Text = sliderText .. ": " .. value
                    sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                    sliderKnob.Position = UDim2.new(relativePos, -8, 0.5, -8)
                    
                    if flag then
                        library.flags[flag] = value
                    end
                    
                    if callback then callback(value) end
                end
                
                function sliderAPI:Get()
                    return sliderValue
                end
                
                return sliderAPI
            end
            
            -- Add a dropdown
            function sectionAPI:AddDropdown(dropdownText, options, default, callback, flag)
                options = options or {}
                local selectedOption = default or (options[1] or "")
                
                if flag then
                    library.flags[flag] = selectedOption
                end
                
                local isOpen = false
                
                local dropdownContainer = Instance.new("Frame")
                dropdownContainer.Name = dropdownText .. "Container"
                dropdownContainer.Size = UDim2.new(1, 0, 0, 50)
                dropdownContainer.BackgroundTransparency = 1
                dropdownContainer.Parent = sectionContent
                
                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Name = "Label"
                dropdownLabel.Size = UDim2.new(1, 0, 0, 20)
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Text = dropdownText
                dropdownLabel.TextColor3 = theme.textColor
                dropdownLabel.TextSize = 14
                dropdownLabel.Font = Enum.Font.SourceSans
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownLabel.Parent = dropdownContainer
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "Button"
                dropdownButton.Size = UDim2.new(1, 0, 0, 30)
                dropdownButton.Position = UDim2.new(0, 0, 0, 20)
                dropdownButton.BackgroundColor3 = 
                theme.elementBackground
                dropdownButton.BorderSizePixel = 0
                dropdownButton.Text = selectedOption
                dropdownButton.TextColor3 = theme.textColor
                dropdownButton.TextSize = 14
                dropdownButton.Font = Enum.Font.SourceSans
                dropdownButton.Parent = dropdownContainer
                makeRound(dropdownButton)
                
                local dropdownList = Instance.new("Frame")
                dropdownList.Name = "List"
                dropdownList.Size = UDim2.new(1, 0, 0, 0)
                dropdownList.Position = UDim2.new(0, 0, 1, 0)
                dropdownList.BackgroundColor3 = theme.elementBackground
                dropdownList.BorderSizePixel = 0
                dropdownList.ClipsDescendants = true
                dropdownList.Visible = false
                dropdownList.Parent = dropdownButton
                makeRound(dropdownList)
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 2)
                listLayout.Parent = dropdownList
                
                local function updateDropdown()
                    isOpen = not isOpen
                    
                    if isOpen then
                        dropdownList.Visible = true
                        createTween(dropdownList, {Size = UDim2.new(1, 0, 0, #options * 30)}, 0.2):Play()
                    else
                        local closeTween = createTween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        closeTween:Play()
                        closeTween.Completed:Connect(function()
                            dropdownList.Visible = false
                        end)
                    end
                end
                
                dropdownButton.MouseButton1Click:Connect(updateDropdown)
                
                -- Create option buttons
                for i, option in ipairs(options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option .. "Option"
                    optionButton.Size = UDim2.new(1, 0, 0, 30)
                    optionButton.BackgroundColor3 = theme.elementBackground
                    optionButton.BorderSizePixel = 0
                    optionButton.Text = option
                    optionButton.TextColor3 = theme.textColor
                    optionButton.TextSize = 14
                    optionButton.Font = Enum.Font.SourceSans
                    optionButton.Parent = dropdownList
                    
                    optionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        dropdownButton.Text = option
                        updateDropdown()
                        
                        if flag then
                            library.flags[flag] = option
                        end
                        
                        if callback then callback(option) end
                    end)
                end
                
                updateSectionSize()
                
                -- Dropdown API
                local dropdownAPI = {}
                
                function dropdownAPI:Set(option)
                    if table.find(options, option) then
                        selectedOption = option
                        dropdownButton.Text = option
                        
                        if flag then
                            library.flags[flag] = option
                        end
                        
                        if callback then callback(option) end
                    end
                end

                                
                function dropdownAPI:Get()
                    return selectedOption
                end
                
                function dropdownAPI:Refresh(newOptions, keepSelection)
                    options = newOptions or {}
                    
                    -- Clear existing options
                    for _, child in pairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Update selection if needed
                    if not keepSelection or not table.find(options, selectedOption) then
                        selectedOption = options[1] or ""
                        dropdownButton.Text = selectedOption
                        
                        if flag then
                            library.flags[flag] = selectedOption
                        end
                    end
                    
                    -- Create new option buttons
                    for i, option in ipairs(options) do
                        local optionButton = Instance.new("TextButton")
                        optionButton.Name = option .. "Option"
                        optionButton.Size = UDim2.new(1, 0, 0, 30)
                        optionButton.BackgroundColor3 = theme.elementBackground
                        optionButton.BorderSizePixel = 0
                        optionButton.Text = option
                        optionButton.TextColor3 = theme.textColor
                        optionButton.TextSize = 14
                        optionButton.Font = Enum.Font.SourceSans
                        optionButton.Parent = dropdownList
                        
                        optionButton.MouseButton1Click:Connect(function()
                            selectedOption = option
                            dropdownButton.Text = option
                            updateDropdown()
                            
                            if flag then
                                library.flags[flag] = option
                            end
                            
                            if callback then callback(option) end
                        end)
                    end
                end
                
                return dropdownAPI
            end
            
            -- Add a text input
            function sectionAPI:AddTextbox(boxText, default, placeholder, callback, flag)
                default = default or ""
                placeholder = placeholder or "Enter text..."
                
                if flag then
                    library.flags[flag] = default
                end
                
                local boxContainer = Instance.new("Frame")
                boxContainer.Name = boxText .. "Container"
                boxContainer.Size = UDim2.new(1, 0, 0, 50)
                boxContainer.BackgroundTransparency = 1
                boxContainer.Parent = sectionContent
                
                local boxLabel = Instance.new("TextLabel")
                boxLabel.Name = "Label"
                boxLabel.Size = UDim2.new(1, 0, 0, 20)
                boxLabel.BackgroundTransparency = 1
                boxLabel.Text = boxText
                boxLabel.TextColor3 = theme.textColor
                boxLabel.TextSize = 14
                boxLabel.Font = Enum.Font.SourceSans
                boxLabel.TextXAlignment = Enum.TextXAlignment.Left
                boxLabel.Parent = boxContainer
                
                local textBox = Instance.new("TextBox")
                textBox.Name = "TextBox"
                textBox.Size = UDim2.new(1, 0, 0, 30)
                textBox.Position = UDim2.new(0, 0, 0, 20)
                textBox.BackgroundColor3 = theme.elementBackground
                textBox.BorderSizePixel = 0
                textBox.Text = default
                textBox.PlaceholderText = placeholder
                textBox.TextColor3 = theme.textColor
                textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                textBox.TextSize = 14
                textBox.Font = Enum.Font.SourceSans
                textBox.Parent = boxContainer
                makeRound(textBox)
                
                textBox.FocusLost:Connect(function(enterPressed)
                    if flag then
                        library.flags[flag] = textBox.Text
                    end
                    
                    if callback then callback(textBox.Text, enterPressed) end
                end)
                
                updateSectionSize()
                
                -- Textbox API
                local textboxAPI = {}
                
                function textboxAPI:Set(text)
                    textBox.Text = text
                    
                    if flag then
                        library.flags[flag] = text
                    end
                    
                    if callback then callback(text, false) end
                end
                
                function textboxAPI:Get()
                    return textBox.Text
                end
                
                return textboxAPI
            end
            
            -- Add a label
            function sectionAPI:AddLabel(labelText)
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1, 0, 0, 20)
                label.BackgroundTransparency = 1
                label.Text = labelText
                label.TextColor3 = theme.textColor
                label.TextSize = 14
                label.Font = Enum.Font.SourceSans
                label.TextWrapped = true
                label.Parent = sectionContent
                
                -- Adjust height based on text wrapping
                local textSize = game:GetService("TextService"):GetTextSize(
                    labelText,
                    14,
                    Enum.Font.SourceSans,
                    Vector2.new(sectionContent.AbsoluteSize.X - 10, 1000)
                )
                
                label.Size = UDim2.new(1, 0, 0, textSize.Y)
                
                updateSectionSize()
                
                -- Label API
                local labelAPI = {}
                
                function labelAPI:Set(text)
                    label.Text = text
                    
                    -- Adjust height based on new text
                    local newTextSize = game:GetService("TextService"):GetTextSize(
                        text,
                        14,
                        Enum.Font.SourceSans,
                        Vector2.new(sectionContent.AbsoluteSize.X - 10, 1000)
                    )
                    
                    label.Size = UDim2.new(1, 0, 0, newTextSize.Y)
                    updateSectionSize()
                end
                
                return labelAPI
            end
            
            return sectionAPI
        end
        
        return tab
    end
    
    return window
end

-- Initialize the library
function library:Init(customConfig)
    -- Apply custom config
    if customConfig then
        for key, value in pairs(customConfig) do
            self[key] = value
        end
    end
    
    -- Create key system
    self:CreateKeySystem(function(success)
        if success then
            -- Create main window
            local window = self:CreateWindow(self.title)
            
            -- Start periodic notifications
            self:StartPeriodicNotifications(300) -- 5 minutes
            
            -- Return window for further customization
            return window
        end
    end)
end

-- Return the library
return library
