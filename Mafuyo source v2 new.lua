--[[
    Mafuyo Premium UI Library
    A comprehensive, high-performance UI library for Roblox
    
    Features:
    - Advanced smooth draggable UI with physics
    - Comprehensive UI elements with animations
    - Customizable themes with presets
    - Responsive layout system
    - Advanced effects and transitions
    - Optimized performance
    - Clean, modern design
]]

local MafuyoUI = {}
MafuyoUI.__index = MafuyoUI

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

-- Constants
local TOGGLE_KEY = Enum.KeyCode.RightShift
local DRAG_ACCELERATION = 0.1
local DRAG_DECELERATION = 0.95
local DRAG_ELASTICITY = 0.8
local TWEEN_SPEED = 0.2
local EFFECT_SPEED = 0.3
local RIPPLE_SPEED = 0.5
local TOOLTIP_DELAY = 0.5
local DOUBLE_CLICK_TIME = 0.3
local SCROLL_SPEED = 0.1
local SNAP_THRESHOLD = 10
local CORNER_RADIUS = 6
local SHADOW_SIZE = 15
local SHADOW_TRANSPARENCY = 0.2
local GLOW_SIZE = 24
local GLOW_TRANSPARENCY = 0.8
local ANIMATION_FPS = 60

-- Themes
local Themes = {
    Default = {
        -- Main Colors
        Background = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(255, 0, 0), -- Red accent
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(175, 175, 175),
        Muted = Color3.fromRGB(125, 125, 125),
        
        -- UI Elements
        TopBar = Color3.fromRGB(30, 30, 30),
        Section = Color3.fromRGB(35, 35, 35),
        Button = Color3.fromRGB(40, 40, 40),
        ButtonHover = Color3.fromRGB(50, 50, 50),
        ButtonPress = Color3.fromRGB(35, 35, 35),
        Toggle = Color3.fromRGB(40, 40, 40),
        ToggleAccent = Color3.fromRGB(255, 0, 0),
        Slider = Color3.fromRGB(40, 40, 40),
        SliderAccent = Color3.fromRGB(255, 0, 0),
        Dropdown = Color3.fromRGB(40, 40, 40),
        DropdownOption = Color3.fromRGB(45, 45, 45),
        Input = Color3.fromRGB(45, 45, 45),
        Scroll = Color3.fromRGB(45, 45, 45),
        ScrollBar = Color3.fromRGB(55, 55, 55),
        
        -- Notification
        NotificationBackground = Color3.fromRGB(35, 35, 35),
        NotificationSuccess = Color3.fromRGB(0, 255, 0),
        NotificationError = Color3.fromRGB(255, 0, 0),
        NotificationInfo = Color3.fromRGB(0, 170, 255),
        NotificationWarning = Color3.fromRGB(255, 255, 0),
        
        -- Logo
        LogoBackground = Color3.fromRGB(30, 30, 30),
        LogoAccent = Color3.fromRGB(255, 0, 0),
        
        -- Effects
        GlowColor = Color3.fromRGB(255, 0, 0),
        RippleColor = Color3.fromRGB(255, 255, 255),
        
        -- Tooltip
        TooltipBackground = Color3.fromRGB(40, 40, 40),
        TooltipText = Color3.fromRGB(255, 255, 255),
        
        -- Context Menu
        ContextBackground = Color3.fromRGB(35, 35, 35),
        ContextOption = Color3.fromRGB(45, 45, 45),
        ContextSeparator = Color3.fromRGB(55, 55, 55),
        
        -- Fonts
        HeaderFont = Enum.Font.GothamBold,
        TextFont = Enum.Font.Gotham,
        MonoFont = Enum.Font.Code,
    },
    
    Dark = {
        Background = Color3.fromRGB(15, 15, 15),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(175, 175, 175),
        Muted = Color3.fromRGB(125, 125, 125),
        
        TopBar = Color3.fromRGB(20, 20, 20),
        Section = Color3.fromRGB(25, 25, 25),
        Button = Color3.fromRGB(30, 30, 30),
        ButtonHover = Color3.fromRGB(40, 40, 40),
        ButtonPress = Color3.fromRGB(25, 25, 25),
        Toggle = Color3.fromRGB(30, 30, 30),
        ToggleAccent = Color3.fromRGB(0, 120, 255),
        Slider = Color3.fromRGB(30, 30, 30),
        SliderAccent = Color3.fromRGB(0, 120, 255),
        Dropdown = Color3.fromRGB(30, 30, 30),
        DropdownOption = Color3.fromRGB(35, 35, 35),
        Input = Color3.fromRGB(35, 35, 35),
        Scroll = Color3.fromRGB(35, 35, 35),
        ScrollBar = Color3.fromRGB(45, 45, 45),
        
        NotificationBackground = Color3.fromRGB(25, 25, 25),
        NotificationSuccess = Color3.fromRGB(0, 200, 0),
        NotificationError = Color3.fromRGB(200, 0, 0),
        NotificationInfo = Color3.fromRGB(0, 120, 255),
        NotificationWarning = Color3.fromRGB(200, 200, 0),
        
        LogoBackground = Color3.fromRGB(20, 20, 20),
        LogoAccent = Color3.fromRGB(0, 120, 255),
        
        GlowColor = Color3.fromRGB(0, 120, 255),
        RippleColor = Color3.fromRGB(255, 255, 255),
        
        TooltipBackground = Color3.fromRGB(30, 30, 30),
        TooltipText = Color3.fromRGB(255, 255, 255),
        
        ContextBackground = Color3.fromRGB(25, 25, 25),
        ContextOption = Color3.fromRGB(35, 35, 35),
        ContextSeparator = Color3.fromRGB(45, 45, 45),
        
        HeaderFont = Enum.Font.GothamBold,
        TextFont = Enum.Font.Gotham,
        MonoFont = Enum.Font.Code,
    },
    
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(40, 40, 40),
        SubText = Color3.fromRGB(80, 80, 80),
        Muted = Color3.fromRGB(120, 120, 120),
        
        TopBar = Color3.fromRGB(250, 250, 250),
        Section = Color3.fromRGB(245, 245, 245),
        Button = Color3.fromRGB(230, 230, 230),
        ButtonHover = Color3.fromRGB(220, 220, 220),
        ButtonPress = Color3.fromRGB(210, 210, 210),
        Toggle = Color3.fromRGB(230, 230, 230),
        ToggleAccent = Color3.fromRGB(0, 120, 255),
        Slider = Color3.fromRGB(230, 230, 230),
        SliderAccent = Color3.fromRGB(0, 120, 255),
        Dropdown = Color3.fromRGB(230, 230, 230),
        DropdownOption = Color3.fromRGB(220, 220, 220),
        Input = Color3.fromRGB(220, 220, 220),
        Scroll = Color3.fromRGB(220, 220, 220),
        ScrollBar = Color3.fromRGB(200, 200, 200),
        
        NotificationBackground = Color3.fromRGB(245, 245, 245),
        NotificationSuccess = Color3.fromRGB(0, 180, 0),
        NotificationError = Color3.fromRGB(180, 0, 0),
        NotificationInfo = Color3.fromRGB(0, 120, 255),
        NotificationWarning = Color3.fromRGB(180, 180, 0),
        
        LogoBackground = Color3.fromRGB(250, 250, 250),
        LogoAccent = Color3.fromRGB(0, 120, 255),
        
        GlowColor = Color3.fromRGB(0, 120, 255),
        RippleColor = Color3.fromRGB(0, 0, 0),
        
        TooltipBackground = Color3.fromRGB(230, 230, 230),
        TooltipText = Color3.fromRGB(40, 40, 40),
        
        ContextBackground = Color3.fromRGB(245, 245, 245),
        ContextOption = Color3.fromRGB(235, 235, 235),
        ContextSeparator = Color3.fromRGB(220, 220, 220),
        
        HeaderFont = Enum.Font.GothamBold,
        TextFont = Enum.Font.Gotham,
        MonoFont = Enum.Font.Code,
    },
    
    Midnight = {
        Background = Color3.fromRGB(20, 20, 30),
        Accent = Color3.fromRGB(130, 80, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(175, 175, 200),
        Muted = Color3.fromRGB(125, 125, 150),
        
        TopBar = Color3.fromRGB(25, 25, 35),
        Section = Color3.fromRGB(30, 30, 40),
        Button = Color3.fromRGB(35, 35, 45),
        ButtonHover = Color3.fromRGB(45, 45, 55),
        ButtonPress = Color3.fromRGB(30, 30, 40),
        Toggle = Color3.fromRGB(35, 35, 45),
        ToggleAccent = Color3.fromRGB(130, 80, 255),
        Slider = Color3.fromRGB(35, 35, 45),
        SliderAccent = Color3.fromRGB(130, 80, 255),
        Dropdown = Color3.fromRGB(35, 35, 45),
        DropdownOption = Color3.fromRGB(40, 40, 50),
        Input = Color3.fromRGB(40, 40, 50),
        Scroll = Color3.fromRGB(40, 40, 50),
        ScrollBar = Color3.fromRGB(50, 50, 60),
        
        NotificationBackground = Color3.fromRGB(30, 30, 40),
        NotificationSuccess = Color3.fromRGB(80, 255, 80),
        NotificationError = Color3.fromRGB(255, 80, 80),
        NotificationInfo = Color3.fromRGB(80, 130, 255),
        NotificationWarning = Color3.fromRGB(255, 255, 80),
        
        LogoBackground = Color3.fromRGB(25, 25, 35),
        LogoAccent = Color3.fromRGB(130, 80, 255),
        
        GlowColor = Color3.fromRGB(130, 80, 255),
        RippleColor = Color3.fromRGB(255, 255, 255),
        
        TooltipBackground = Color3.fromRGB(35, 35, 45),
        TooltipText = Color3.fromRGB(255, 255, 255),
        
        ContextBackground = Color3.fromRGB(30, 30, 40),
        ContextOption = Color3.fromRGB(40, 40, 50),
        ContextSeparator = Color3.fromRGB(50, 50, 60),
        
        HeaderFont = Enum.Font.GothamBold,
        TextFont = Enum.Font.Gotham,
        MonoFont = Enum.Font.Code,
    },
    
    Crimson = {
        Background = Color3.fromRGB(30, 20, 20),
        Accent = Color3.fromRGB(220, 60, 60),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 175, 175),
        Muted = Color3.fromRGB(150, 125, 125),
        
        TopBar = Color3.fromRGB(35, 25, 25),
        Section = Color3.fromRGB(40, 30, 30),
        Button = Color3.fromRGB(45, 35, 35),
        ButtonHover = Color3.fromRGB(55, 45, 45),
        ButtonPress = Color3.fromRGB(40, 30, 30),
        Toggle = Color3.fromRGB(45, 35, 35),
        ToggleAccent = Color3.fromRGB(220, 60, 60),
        Slider = Color3.fromRGB(45, 35, 35),
        SliderAccent = Color3.fromRGB(220, 60, 60),
        Dropdown = Color3.fromRGB(45, 35, 35),
        DropdownOption = Color3.fromRGB(50, 40, 40),
        Input = Color3.fromRGB(50, 40, 40),
        Scroll = Color3.fromRGB(50, 40, 40),
        ScrollBar = Color3.fromRGB(60, 50, 50),
        
        NotificationBackground = Color3.fromRGB(40, 30, 30),
        NotificationSuccess = Color3.fromRGB(80, 255, 80),
        NotificationError = Color3.fromRGB(255, 80, 80),
        NotificationInfo = Color3.fromRGB(80, 130, 255),
        NotificationWarning = Color3.fromRGB(255, 255, 80),
        
        LogoBackground = Color3.fromRGB(35, 25, 25),
        LogoAccent = Color3.fromRGB(220, 60, 60),
        
        GlowColor = Color3.fromRGB(220, 60, 60),
        RippleColor = Color3.fromRGB(255, 255, 255),
        
        TooltipBackground = Color3.fromRGB(45, 35, 35),
        TooltipText = Color3.fromRGB(255, 255, 255),
        
        ContextBackground = Color3.fromRGB(40, 30, 30),
        ContextOption = Color3.fromRGB(50, 40, 40),
        ContextSeparator = Color3.fromRGB(60, 50, 50),
        
        HeaderFont = Enum.Font.GothamBold,
        TextFont = Enum.Font.Gotham,
        MonoFont = Enum.Font.Code,
    }
}

-- Current theme
local Theme = Themes.Default

-- Utility Functions
local function Create(instanceType)
    return function(properties)
        local instance = Instance.new(instanceType)
        for property, value in pairs(properties) do
            if property ~= "Parent" then
                instance[property] = value
            end
        end
        if properties.Parent then
            instance.Parent = properties.Parent
        end
        return instance
    end
end

local function Tween(object, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(
        object, 
        TweenInfo.new(duration or TWEEN_SPEED, style, direction), 
        properties
    )
    tween:Play()
    return tween
end

local function RoundBox(radius)
    return Create("UICorner")({
        CornerRadius = UDim.new(0, radius or CORNER_RADIUS)
    })
end

local function Shadow(instance, size, transparency)
    local shadow = Create("ImageLabel")({
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, size or SHADOW_SIZE, 1, size or SHADOW_SIZE),
        ZIndex = -1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or SHADOW_TRANSPARENCY,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = instance
    })
    return shadow
end

local function Glow(instance, color, transparency, size)
    local glow = Create("ImageLabel")({
        Name = "Glow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, size or GLOW_SIZE, 1, size or GLOW_SIZE),
        ZIndex = -1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = color or Theme.GlowColor,
        ImageTransparency = transparency or GLOW_TRANSPARENCY,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = instance
    })
    return glow
end

local function Ripple(parent, rippleColor)
    local ripple = Create("Frame")({
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = rippleColor or Theme.RippleColor,
        BackgroundTransparency = 0.8,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        Parent = parent
    })
    
    RoundBox(999).Parent = ripple
    
    local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, 36)
    local relPos = mousePos - parent.AbsolutePosition
    ripple.Position = UDim2.new(0, relPos.X, 0, relPos.Y)
    
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, RIPPLE_SPEED)
    
    task.delay(RIPPLE_SPEED, function()
        ripple:Destroy()
    end)
    
    return ripple
end

local function AddHoverEffect(button, hoverColor, normalColor, pressColor)
    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = hoverColor}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        if not button:GetAttribute("Pressed") then
            Tween(button, {BackgroundColor3 = normalColor}, 0.2)
        end
    end)
    
    if pressColor then
        button.MouseButton1Down:Connect(function()
            button:SetAttribute("Pressed", true)
            Tween(button, {BackgroundColor3 = pressColor}, 0.1)
        end)
        
        button.MouseButton1Up:Connect(function()
            button:SetAttribute("Pressed", false)
            if button.MouseEnter then
                Tween(button, {BackgroundColor3 = hoverColor}, 0.1)
            else
                Tween(button, {BackgroundColor3 = normalColor}, 0.1)
            end
        end)
    end
end

local function AddClickEffect(button)
    button.MouseButton1Down:Connect(function()
        Ripple(button)
        Tween(button, {Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset * 0.95, button.Size.Y.Scale, button.Size.Y.Offset * 0.95)}, 0.1)
    end)
    
    button.MouseButton1Up:Connect(function()
        Tween(button, {Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset / 0.95, button.Size.Y.Scale, button.Size.Y.Offset / 0.95)}, 0.1)
    end)
end

local function AddTooltip(object, text)
    local tooltip = nil
    local tooltipShown = false
    local tooltipDebounce = false
    
    object.MouseEnter:Connect(function()
        if tooltipDebounce then return end
        tooltipDebounce = true
        
        task.delay(TOOLTIP_DELAY, function()
            if not object.MouseEnter then return end
            
            tooltipShown = true
            
            tooltip = Create("Frame")({
                Name = "Tooltip",
                BackgroundColor3 = Theme.TooltipBackground,
                Position = UDim2.new(0, UserInputService:GetMouseLocation().X + 15, 0, UserInputService:GetMouseLocation().Y - 30),
                Size = UDim2.new(0, 0, 0, 30),
                ZIndex = 10000,
                Parent = CoreGui:FindFirstChild("MafuyoUI")
            })
            
            RoundBox(4).Parent = tooltip
            Shadow(tooltip, 10, 0.2)
            
            local tooltipText = Create("TextLabel")({
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                Font = Theme.TextFont,
                Text = text,
                TextColor3 = Theme.TooltipText,
                TextSize = 14,
                TextTransparency = 1,
                ZIndex = 10000,
                Parent = tooltip
            })
            
            local textSize = TextService:GetTextSize(text, 14, Theme.TextFont, Vector2.new(math.huge, math.huge))
            
            Tween(tooltip, {Size = UDim2.new(0, textSize.X + 20, 0, 30), BackgroundTransparency = 0}, 0.2)
            Tween(tooltipText, {TextTransparency = 0}, 0.2)
            
            -- Update position on mouse move
            local connection
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if tooltip then
                        tooltip.Position = UDim2.new(0, UserInputService:GetMouseLocation().X + 15, 0, UserInputService:GetMouseLocation().Y - 30)
                    else
                        connection:Disconnect()
                    end
                end
            end)
        end)
    end)
    
    object.MouseLeave:Connect(function()
        tooltipDebounce = false
        
        if tooltip and tooltipShown then
            tooltipShown = false
            
            Tween(tooltip, {Size = UDim2.new(0, 0, 0, 30), BackgroundTransparency = 1}, 0.2)
            
            for _, child in pairs(tooltip:GetChildren()) do
                if child:IsA("TextLabel") then
                    Tween(child, {TextTransparency = 1}, 0.2)
                end
            end
            
            task.delay(0.2, function()
                if tooltip then
                    tooltip:Destroy()
                    tooltip = nil
                end
            end)
        end
    end)
end

-- Advanced Draggable System
local function MakeDraggable(topBarObject, object)
    local dragParams = {
        Dragging = false,
        DragInput = nil,
        MousePos = nil,
        FramePos = nil,
        Velocity = Vector2.new(0, 0),
        LastPos = nil,
        LastTime = nil,
        SnapPositions = {},
        SnapThreshold = SNAP_THRESHOLD
    }
    
    -- Add physics update
    local physicsConnection
    
    local function StartDragging()
        if physicsConnection then
            physicsConnection:Disconnect()
        end
        
        physicsConnection = RunService.Heartbeat:Connect(function(deltaTime)
            if not dragParams.Dragging and dragParams.Velocity.Magnitude > 0.1 then
                -- Apply deceleration
                dragParams.Velocity = dragParams.Velocity * DRAG_DECELERATION
                
                -- Apply velocity to position
                local newPos = object.Position + UDim2.new(0, dragParams.Velocity.X, 0, dragParams.Velocity.Y)
                
                -- Check screen boundaries
                local screenSize = workspace.CurrentCamera.ViewportSize
                local objectSize = object.AbsoluteSize
                local minX = 0
                local minY = 0
                local maxX = screenSize.X - objectSize.X
                local maxY = screenSize.Y - objectSize.Y
                
                local absPos = object.AbsolutePosition
                local newAbsX = math.clamp(absPos.X + dragParams.Velocity.X, minX, maxX)
                local newAbsY = math.clamp(absPos.Y + dragParams.Velocity.Y, minY, maxY)
                
                -- If hitting boundaries, bounce with elasticity
                if (absPos.X + dragParams.Velocity.X < minX) or (absPos.X + dragParams.Velocity.X > maxX) then
                    dragParams.Velocity = Vector2.new(-dragParams.Velocity.X * DRAG_ELASTICITY, dragParams.Velocity.Y)
                end
                
                if (absPos.Y + dragParams.Velocity.Y < minY) or (absPos.Y + dragParams.Velocity.Y > maxY) then
                    dragParams.Velocity = Vector2.new(dragParams.Velocity.X, -dragParams.Velocity.Y * DRAG_ELASTICITY)
                end
                
                -- Check for snapping
                for _, snapPos in ipairs(dragParams.SnapPositions) do
                    if (math.abs(newAbsX - snapPos.X) < dragParams.SnapThreshold) then
                        newAbsX = snapPos.X
                        dragParams.Velocity = Vector2.new(0, dragParams.Velocity.Y)
                    end
                    
                    if (math.abs(newAbsY - snapPos.Y) < dragParams.SnapThreshold) then
                        newAbsY = snapPos.Y
                        dragParams.Velocity = Vector2.new(dragParams.Velocity.X, 0)
                    end
                end
                
                -- Convert back to UDim2
                local newUDimX = UDim2.new(0, newAbsX, object.Position.Y.Scale, object.Position.Y.Offset)
                local newUDimY = UDim2.new(object.Position.X.Scale, object.Position.X.Offset, 0, newAbsY)
                
                object.Position = UDim2.new(newUDimX.X.Scale, newAbsX, newUDimY.Y.Scale, newAbsY)
                
                -- Stop physics if velocity is very small
                if dragParams.Velocity.Magnitude < 0.1 then
                    dragParams.Velocity = Vector2.new(0, 0)
                    physicsConnection:Disconnect()
                    physicsConnection = nil
                end
            end
        end)
    end
    
    -- Add double-click to center
    local lastClickTime = 0
    
    topBarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Check for double-click
            local currentTime = tick()
            if currentTime - lastClickTime < DOUBLE_CLICK_TIME then
                -- Double-click detected, center the window
                local screenSize = workspace.CurrentCamera.ViewportSize
                local objectSize = object.AbsoluteSize
                local centerX = (screenSize.X - objectSize.X) / 2
                local centerY = (screenSize.Y - objectSize.Y) / 2
                
                Tween(object, {Position = UDim2.new(0, centerX, 0, centerY)}, 0.3, Enum.EasingStyle.Back)
                
                -- Reset velocity
                dragParams.Velocity = Vector2.new(0, 0)
                if physicsConnection then
                    physicsConnection:Disconnect()
                    physicsConnection = nil
                end
            else
                -- Start dragging
                dragParams.Dragging = true
                dragParams.MousePos = input.Position
                dragParams.FramePos = object.Position
                dragParams.LastPos = input.Position
                dragParams.LastTime = tick()
                
                -- Stop any ongoing physics
                if physicsConnection then
                    physicsConnection:Disconnect()
                    physicsConnection = nil
                end
                
                -- Add elastic effect on drag start
                Tween(object, {Size = UDim2.new(object.Size.X.Scale, object.Size.X.Offset * 0.98, object.Size.Y.Scale, object.Size.Y.Offset * 0.98)}, 0.1)
                task.delay(0.1, function()
                    Tween(object, {Size = UDim2.new(object.Size.X.Scale, object.Size.X.Offset / 0.98, object.Size.Y.Scale, object.Size.Y.Offset / 0.98)}, 0.1)
                end)
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragParams.Dragging = false
                        
                        -- Calculate final velocity for physics
                        local currentTime = tick()
                        local timeDiff = currentTime - dragParams.LastTime
                        
                        if timeDiff > 0 then
                            local posDiff = input.Position - dragParams.LastPos
                            dragParams.Velocity = Vector2.new(posDiff.X / timeDiff, posDiff.Y / timeDiff)
                            
                            -- Limit maximum velocity
                            local maxVel = 1000
                            if dragParams.Velocity.Magnitude > maxVel then
                                dragParams.Velocity = dragParams.Velocity.Unit * maxVel
                            end
                            
                            -- Start physics simulation
                            StartDragging()
                        end
                    end
                end)
            end
            
            lastClickTime = currentTime
        end
    end)
    
    topBarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragParams.DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragParams.DragInput and dragParams.Dragging then
            local delta = input.Position - dragParams.MousePos
            
            -- Apply acceleration to make dragging feel more responsive
            delta = delta * (1 + DRAG_ACCELERATION)
            
            -- Calculate new position
            local newPosition = UDim2.new(
                dragParams.FramePos.X.Scale, 
                dragParams.FramePos.X.Offset + delta.X, 
                dragParams.FramePos.Y.Scale, 
                dragParams.FramePos.Y.Offset + delta.Y
            )
            
            -- Check screen boundaries
            local screenSize = workspace.CurrentCamera.ViewportSize
            local objectSize = object.AbsoluteSize
            local minX = 0
            local minY = 0
            local maxX = screenSize.X - objectSize.X
            local maxY = screenSize.Y - objectSize.Y
            
            local newAbsX = math.clamp(dragParams.FramePos.X.Offset + delta.X, minX, maxX)
            local newAbsY = math.clamp(dragParams.FramePos.Y.Offset + delta.Y, minY, maxY)
            
            -- Check for snapping
            for _, snapPos in ipairs(dragParams.SnapPositions) do
                if (math.abs(newAbsX - snapPos.X) < dragParams.SnapThreshold) then
                    newAbsX = snapPos.X
                end
                
                if (math.abs(newAbsY - snapPos.Y) < dragParams.SnapThreshold) then
                    newAbsY = snapPos.Y
                end
            end
            
            -- Update position
            object.Position = UDim2.new(0, newAbsX, 0, newAbsY)
            
            -- Update velocity tracking
            dragParams.LastPos = input.Position
            dragParams.LastTime = tick()
        end
    end)
    
    -- Add snap positions (e.g., screen edges, center)
    local function UpdateSnapPositions()
        local screenSize = workspace.CurrentCamera.ViewportSize
        local objectSize = object.AbsoluteSize
        
        dragParams.SnapPositions = {
            Vector2.new(0, 0), -- Top-left
            Vector2.new(screenSize.X - objectSize.X, 0), -- Top-right
            Vector2.new(0, screenSize.Y - objectSize.Y), -- Bottom-left
            Vector2.new(screenSize.X - objectSize.X, screenSize.Y - objectSize.Y), -- Bottom-right
            Vector2.new((screenSize.X - objectSize.X) / 2, (screenSize.Y - objectSize.Y) / 2), -- Center
            Vector2.new((screenSize.X - objectSize.X) / 2, 0), -- Top-center
            Vector2.new(0, (screenSize.Y - objectSize.Y) / 2), -- Left-center
            Vector2.new(screenSize.X - objectSize.X, (screenSize.Y - objectSize.Y) / 2), -- Right-center
            Vector2.new((screenSize.X - objectSize.X) / 2, screenSize.Y - objectSize.Y) -- Bottom-center
        }
    end
    
    -- Update snap positions when window is resized
    object:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSnapPositions)
    
    -- Initial setup
    UpdateSnapPositions()
    
    return dragParams
end

-- Notification System
local NotificationHolder = nil

local function CreateNotificationHolder()
    if NotificationHolder then return NotificationHolder end
    
    NotificationHolder = Create("ScreenGui")({
        Name = "MafuyoNotifications",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = CoreGui
    })
    
    local Frame = Create("Frame")({
        Name = "NotificationFrame",
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 300, 1, -40),
        Parent = NotificationHolder
    })
    
    local UIListLayout = Create("UIListLayout")({
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = Frame
    })
    
    return NotificationHolder
end

function MafuyoUI:Notify(title, message, notificationType, duration, callback)
    notificationType = notificationType or "Info"
    duration = duration or 5
    
    local typeColors = {
        Success = Theme.NotificationSuccess,
        Error = Theme.NotificationError,
        Info = Theme.NotificationInfo,
        Warning = Theme.NotificationWarning
    }
    
    local color = typeColors[notificationType] or Theme.NotificationInfo
    
    local Holder = CreateNotificationHolder()
    local Frame = Holder.NotificationFrame
    
    local Notification = Create("Frame")({
        Name = "Notification",
        BackgroundColor3 = Theme.NotificationBackground,
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Parent = Frame
    })
    
    RoundBox(CORNER_RADIUS).Parent = Notification
    Shadow(Notification, 15, 0.2)
    Glow(Notification, color, 0.9)
    
    local Bar = Create("Frame")({
        Name = "Bar",
        BackgroundColor3 = color,
        Size = UDim2.new(0, 5, 1, 0),
        Parent = Notification
    })
    
    RoundBox(CORNER_RADIUS).Parent = Bar
    
    local Content = Create("Frame")({
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -15, 1, 0),
        Parent = Notification
    })
    
    local Title = Create("TextLabel")({
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, -10, 0, 20),
        Font = Theme.HeaderFont,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Content
    })
    
    local Message = Create("TextLabel")({
        Name = "Message",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, -10, 0, 0),
        Font = Theme.TextFont,
        Text = message,
        TextColor3 = Theme.SubText,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = Content
    })
    
    -- Calculate text height
    local textSize = TextService:GetTextSize(
        Message.Text,
        Message.TextSize,
        Message.Font,
        Vector2.new(Message.AbsoluteSize.X, math.huge)
    )
    
    local height = math.max(60, textSize.Y + 40)
    Message.Size = UDim2.new(1, -10, 0, textSize.Y)
    
    -- Close button
    local CloseButton = Create("TextButton")({
        Name = "CloseButton",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -5, 0, 5),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Theme.HeaderFont,
        Text = "×",
        TextColor3 = Theme.SubText,
        TextSize = 20,
        Parent = Notification
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        -- Close notification early
        Tween(Notification, {BackgroundTransparency = 1}, 0.3)
        Tween(Bar, {BackgroundTransparency = 1}, 0.3)
        Tween(Title, {TextTransparency = 1}, 0.3)
        Tween(Message, {TextTransparency = 1}, 0.3)
        Tween(CloseButton, {TextTransparency = 1}, 0.3)
        
        task.delay(0.35, function()
            Notification:Destroy()
        end)
    end)
    
    -- Add callback if provided
    if callback then
        local CallbackButton = Create("TextButton")({
            Name = "CallbackButton",
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = color,
            Position = UDim2.new(1, -10, 1, -10),
            Size = UDim2.new(0, 80, 0, 25),
            Font = Theme.TextFont,
            Text = "Action",
            TextColor3 = Theme.Text,
            TextSize = 14,
            Parent = Notification
        })
        
        RoundBox(4).Parent = CallbackButton
        AddHoverEffect(CallbackButton, Color3.fromRGB(
            math.min(color.R * 1.1 * 255, 255),
            math.min(color.G * 1.1 * 255, 255),
            math.min(color.B * 1.1 * 255, 255)
        ), color)
        AddClickEffect(CallbackButton)
        
        CallbackButton.MouseButton1Click:Connect(function()
            callback()
            
            -- Close notification after callback
            Tween(Notification, {BackgroundTransparency = 1}, 0.3)
            Tween(Bar, {BackgroundTransparency = 1}, 0.3)
            Tween(Title, {TextTransparency = 1}, 0.3)
            Tween(Message, {TextTransparency = 1}, 0.3)
            Tween(CloseButton, {TextTransparency = 1}, 0.3)
            Tween(CallbackButton, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
            
            task.delay(0.35, function()
                Notification:Destroy()
            end)
        end)
        
        -- Adjust height for callback button
        height = height + 30
    end
    
    -- Animate in
    Notification.Size = UDim2.new(1, 0, 0, height)
    Notification.BackgroundTransparency = 1
    Bar.BackgroundTransparency = 1
    Title.TextTransparency = 1
    Message.TextTransparency = 1
    CloseButton.TextTransparency = 1
    
    -- Slide in from right
    Notification.Position = UDim2.new(1, 300, 0, 0)
    
    Tween(Notification, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Back)
    Tween(Bar, {BackgroundTransparency = 0}, 0.3)
    Tween(Title, {TextTransparency = 0}, 0.3)
    Tween(Message, {TextTransparency = 0}, 0.3)
    Tween(CloseButton, {TextTransparency = 0}, 0.3)
    
    -- Progress bar
    local ProgressBar = Create("Frame")({
        Name = "ProgressBar",
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = Notification
    })
    
    Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration)
    
    -- Remove after duration
    task.delay(duration, function()
        if not Notification or not Notification.Parent then return end
        
        Tween(Notification, {Position = UDim2.new(1, 300, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Bar, {BackgroundTransparency = 1}, 0.3)
        Tween(Title, {TextTransparency = 1}, 0.3)
        Tween(Message, {TextTransparency = 1}, 0.3)
        Tween(CloseButton, {TextTransparency = 1}, 0.3)
        Tween(ProgressBar, {BackgroundTransparency = 1}, 0.3)
        
        if callback then
            Tween(Notification:FindFirstChild("CallbackButton"), {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
        end
        
        task.delay(0.35, function()
            if Notification and Notification.Parent then
                Notification:Destroy()
            end
        end)
    end)
    
    return Notification
end

-- Context Menu System
function MafuyoUI:CreateContextMenu(options)
    local ContextMenu = {}
    ContextMenu.Visible = false
    ContextMenu.Options = options or {}
    
    -- Create context menu frame
    ContextMenu.Frame = Create("Frame")({
        Name = "ContextMenu",
        BackgroundColor3 = Theme.ContextBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 150, 0, 0),
        Visible = false,
        ZIndex = 10000,
        Parent = self.GUI
    })

    RoundBox(CORNER_RADIUS).Parent = ContextMenu.Frame
    Shadow(ContextMenu.Frame, 10, 0.2)
    
    -- Create options container
    ContextMenu.Container = Create("ScrollingFrame")({
        Name = "Container",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.ScrollBar,
        ZIndex = 10000,
        Parent = ContextMenu.Frame
    })
    
    local UIListLayout = Create("UIListLayout")({
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = ContextMenu.Container
    })
    
    local UIPadding = Create("UIPadding")({
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = ContextMenu.Container
    })
    
    -- Update canvas size when elements are added
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContextMenu.Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    end)
    
    -- Add options
    function ContextMenu:AddOption(text, callback, icon)
        local Option = Create("TextButton")({
            Name = text.."Option",
            BackgroundColor3 = Theme.ContextOption,
            Size = UDim2.new(1, 0, 0, 30),
            Text = "",
            ZIndex = 10001,
            Parent = ContextMenu.Container
        })
        
        RoundBox(4).Parent = Option
        AddHoverEffect(Option, Theme.ButtonHover, Theme.ContextOption)
        AddClickEffect(Option)
        
        local OptionText = Create("TextLabel")({
            Name = "Text",
            BackgroundTransparency = 1,
            Position = icon and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, icon and -40 or -20, 1, 0),
            Font = Theme.TextFont,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 10001,
            Parent = Option
        })
        
        if icon then
            local Icon = Create("ImageLabel")({
                Name = "Icon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = icon,
                ZIndex = 10001,
                Parent = Option
            })
        end
        
        Option.MouseButton1Click:Connect(function()
            self:CloseContextMenu()
            callback()
        end)
        
        return Option
    end
    
    -- Add separator
    function ContextMenu:AddSeparator()
        local Separator = Create("Frame")({
            Name = "Separator",
            BackgroundColor3 = Theme.ContextSeparator,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            ZIndex = 10001,
            Parent = ContextMenu.Container
        })
        
        return Separator
    end
    
    -- Show context menu
    function ContextMenu:Show(position)
        -- Close any open context menus
        self:CloseContextMenu()
        
        -- Position menu
        ContextMenu.Frame.Position = position
        
        -- Calculate height based on options
        local height = ContextMenu.Container.CanvasSize.Y.Offset + 10
        
        -- Check if menu would go off screen
        local screenSize = workspace.CurrentCamera.ViewportSize
        local menuPos = ContextMenu.Frame.AbsolutePosition
        local menuSize = Vector2.new(150, height)
        
        if menuPos.X + menuSize.X > screenSize.X then
            ContextMenu.Frame.Position = UDim2.new(0, position.X.Offset - menuSize.X, 0, position.Y.Offset)
        end
        
        if menuPos.Y + menuSize.Y > screenSize.Y then
            ContextMenu.Frame.Position = UDim2.new(0, ContextMenu.Frame.Position.X.Offset, 0, position.Y.Offset - menuSize.Y)
        end
        
        -- Show menu with animation
        ContextMenu.Frame.Size = UDim2.new(0, 150, 0, 0)
        ContextMenu.Frame.Visible = true
        ContextMenu.Visible = true
        
        Tween(ContextMenu.Frame, {Size = UDim2.new(0, 150, 0, height)}, 0.2, Enum.EasingStyle.Back)
        
        -- Close menu when clicking outside
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mousePos = UserInputService:GetMouseLocation()
                local menuPos = ContextMenu.Frame.AbsolutePosition
                local menuSize = ContextMenu.Frame.AbsoluteSize
                
                if mousePos.X < menuPos.X or mousePos.X > menuPos.X + menuSize.X or
                   mousePos.Y < menuPos.Y or mousePos.Y > menuPos.Y + menuSize.Y then
                    self:CloseContextMenu()
                    connection:Disconnect()
                end
            end
        end)
    end
    
    return ContextMenu
end

-- Close any open context menus
function MafuyoUI:CloseContextMenu()
    for _, obj in pairs(self.GUI:GetChildren()) do
        if obj.Name == "ContextMenu" and obj.Visible then
            Tween(obj, {Size = UDim2.new(0, 150, 0, 0)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            
            task.delay(0.2, function()
                obj.Visible = false
            end)
        end
    end
end

-- Create Logo
function MafuyoUI:CreateLogo()
    -- Create logo container
    local LogoFrame = Create("Frame")({
        Name = "MafuyoLogo",
        BackgroundColor3 = Theme.LogoBackground,
        Position = UDim2.new(0, 20, 0, 20),
        Size = UDim2.new(0, 50, 0, 50),
        ZIndex = 1000,
        Parent = self.GUI
    })
    
    RoundBox(8).Parent = LogoFrame
    Shadow(LogoFrame, 10, 0.3)
    Glow(LogoFrame, Theme.LogoAccent, 0.8)
    
    -- Create logo accent
    local LogoAccent = Create("Frame")({
        Name = "Accent",
        BackgroundColor3 = Theme.LogoAccent,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2),
        ZIndex = 1001,
        Parent = LogoFrame
    })
    
    RoundBox(8).Parent = LogoAccent
    
    -- Create logo text
    local LogoText = Create("TextLabel")({
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Theme.HeaderFont,
        Text = "M",
        TextColor3 = Theme.Text,
        TextSize = 24,
        ZIndex = 1001,
        Parent = LogoFrame
    })
    
    -- Create hitbox
    local LogoButton = Create("TextButton")({
        Name = "Button",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 1002,
        Parent = LogoFrame
    })
    
    -- Make logo draggable with advanced physics
    MakeDraggable(LogoFrame, LogoFrame)
    
    -- Logo click functionality
    LogoButton.MouseButton1Click:Connect(function()
        self.Toggled = not self.Toggled
        
        for _, window in pairs(self.Windows) do
            if self.Toggled then
                window.Frame.Visible = true
                Tween(window.Frame, {Position = window.Frame.Position, BackgroundTransparency = 0}, EFFECT_SPEED)
            else
                Tween(window.Frame, {Position = UDim2.new(window.Frame.Position.X.Scale, window.Frame.Position.X.Offset, window.Frame.Position.Y.Scale - 0.1, window.Frame.Position.Y.Offset), BackgroundTransparency = 1}, EFFECT_SPEED)
                task.delay(EFFECT_SPEED, function()
                    window.Frame.Visible = false
                end)
            end
        end
        
        -- Animate logo
        if self.Toggled then
            Tween(LogoFrame, {Rotation = 0}, 0.3)
            Tween(LogoAccent, {BackgroundColor3 = Theme.LogoAccent}, 0.3)
        else
            Tween(LogoFrame, {Rotation = 45}, 0.3)
            Tween(LogoAccent, {BackgroundColor3 = Theme.SubText}, 0.3)
        end
        
        -- Create ripple effect
        Ripple(LogoFrame)
    end)
    
    -- Logo hover effects
    LogoButton.MouseEnter:Connect(function()
        Tween(LogoFrame, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
    end)
    
    LogoButton.MouseLeave:Connect(function()
        Tween(LogoFrame, {BackgroundColor3 = Theme.LogoBackground}, 0.2)
    end)
    
    -- Logo context menu
    LogoButton.MouseButton2Click:Connect(function()
        local contextMenu = self:CreateContextMenu()
        
        contextMenu:AddOption("Toggle UI", function()
            LogoButton.MouseButton1Click:Fire()
        end)
        
        contextMenu:AddOption("Notifications", function()
            self:Notify("Test Notification", "This is a test notification", "Info", 5)
        end)
        
        contextMenu:AddSeparator()
        
        -- Theme options
        local themeSubmenu = self:CreateContextMenu()
        
        for themeName, _ in pairs(Themes) do
            themeSubmenu:AddOption(themeName, function()
                self:SetTheme(themeName)
            end)
        end
        
        contextMenu:AddOption("Themes", function()
            themeSubmenu:Show(UDim2.new(0, contextMenu.Frame.AbsolutePosition.X + contextMenu.Frame.AbsoluteSize.X, 0, contextMenu.Frame.AbsolutePosition.Y))
        end)
        
        contextMenu:AddSeparator()
        
        contextMenu:AddOption("About", function()
            self:Notify("Mafuyo Premium UI", "Version 1.0.0\nCreated by Mafuyo", "Info", 5)
        end)
        
        contextMenu:Show(UDim2.new(0, UserInputService:GetMouseLocation().X, 0, UserInputService:GetMouseLocation().Y))
    end)
    
    -- Add tooltip
    AddTooltip(LogoFrame, "Mafuyo Premium UI")
    
    return LogoFrame
end

-- Set theme
function MafuyoUI:SetTheme(themeName)
    if Themes[themeName] then
        Theme = Themes[themeName]
        
        -- Update all UI elements with new theme
        self:Notify("Theme Changed", "Theme has been changed to " .. themeName, "Info", 3)
        
        -- Update logo
        if self.Logo then
            Tween(self.Logo, {BackgroundColor3 = Theme.LogoBackground}, 0.3)
            Tween(self.Logo.Accent, {BackgroundColor3 = Theme.LogoAccent}, 0.3)
            self.Logo.Text.TextColor3 = Theme.Text
        end
        
        -- Update watermark
        if self.Watermark then
            Tween(self.Watermark, {BackgroundColor3 = Theme.Background}, 0.3)
            Tween(self.Watermark.Accent, {BackgroundColor3 = Theme.Accent}, 0.3)
            self.Watermark.Label.TextColor3 = Theme.Text
        end
        
        -- Update windows
        for _, window in pairs(self.Windows) do
            Tween(window.Frame, {BackgroundColor3 = Theme.Background}, 0.3)
            Tween(window.TopBar, {BackgroundColor3 = Theme.TopBar}, 0.3)
            window.Title.TextColor3 = Theme.Text
            window.CloseButton.TextColor3 = Theme.Text
            window.MinimizeButton.TextColor3 = Theme.Text
            
            -- Update tabs
            for _, tab in pairs(window.Tabs) do
                if tab == window.ActiveTab then
                    Tween(tab.Button, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}, 0.3)
                else
                    Tween(tab.Button, {BackgroundColor3 = Theme.Button, TextColor3 = Theme.SubText}, 0.3)
                end
                
                -- Update sections
                for _, section in pairs(tab.Sections) do
                    Tween(section.Frame, {BackgroundColor3 = Theme.Section}, 0.3)
                    section.Title.TextColor3 = Theme.Text
                    
                    -- Update elements
                    for _, element in pairs(section.Elements) do
                        if element.Type == "Button" then
                            Tween(element.Instance, {BackgroundColor3 = Theme.Button}, 0.3)
                            element.Instance.TextColor3 = Theme.Text
                        elseif element.Type == "Toggle" then
                            Tween(element.Instance.Button, {BackgroundColor3 = element.Value and Theme.ToggleAccent or Theme.Toggle}, 0.3)
                            Tween(element.Instance.Indicator, {Position = element.Value and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.3)
                        elseif element.Type == "Slider" then
                            Tween(element.Instance.Background, {BackgroundColor3 = Theme.Slider}, 0.3)
                            Tween(element.Instance.Fill, {BackgroundColor3 = Theme.SliderAccent}, 0.3)
                            element.Instance.ValueLabel.TextColor3 = Theme.Text
                        elseif element.Type == "Dropdown" then
                            Tween(element.Instance.Button, {BackgroundColor3 = Theme.Dropdown}, 0.3)
                            element.Instance.ValueLabel.TextColor3 = Theme.Text
                            element.Instance.Arrow.ImageColor3 = Theme.Text
                        end
                    end
                end
            end
        end
    end
end

-- Main UI Creation
function MafuyoUI.new(options)
    local self = setmetatable({}, MafuyoUI)
    options = options or {}
    
    -- Create main GUI
    self.GUI = Create("ScreenGui")({
        Name = "MafuyoUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = CoreGui
    })
    
    -- Set theme
    if options.Theme and Themes[options.Theme] then
        Theme = Themes[options.Theme]
    end
    
    -- Create logo
    self.Logo = self:CreateLogo()
    
    -- Create watermark
    self.Watermark = Create("Frame")({
        Name = "Watermark",
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0, 80, 0, 20),
        Size = UDim2.new(0, 200, 0, 30),
        Parent = self.GUI
    })
    
    RoundBox(6).Parent = self.Watermark
    Shadow(self.Watermark)
    
    local WatermarkLabel = Create("TextLabel")({
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Theme.HeaderFont,
        Text = "Mafuyo Premium | v1.0.0",
        TextColor3 = Theme.Text,
        TextSize = 14,
        Parent = self.Watermark
    })
    
    local WatermarkAccent = Create("Frame")({
        Name = "Accent",
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = self.Watermark
    })
    
    RoundBox(6).Parent = WatermarkAccent
    
    -- Toggle UI with keybind
    self.Toggled = true
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == TOGGLE_KEY then
            self.Toggled = not self.Toggled
            
            for _, window in pairs(self.Windows) do
                if self.Toggled then
                    window.Frame.Visible = true
                    Tween(window.Frame, {Position = window.Frame.Position, BackgroundTransparency = 0}, EFFECT_SPEED)
                else
                    Tween(window.Frame, {Position = UDim2.new(window.Frame.Position.X.Scale, window.Frame.Position.X.Offset, window.Frame.Position.Y.Scale - 0.1, window.Frame.Position.Y.Offset), BackgroundTransparency = 1}, EFFECT_SPEED)
                    task.delay(EFFECT_SPEED, function()
                        window.Frame.Visible = false
                    end)
                end
            end
            
            -- Animate logo
            if self.Toggled then
                Tween(self.Logo, {Rotation = 0}, 0.3)
                Tween(self.Logo.Accent, {BackgroundColor3 = Theme.LogoAccent}, 0.3)
            else
                Tween(self.Logo, {Rotation = 45}, 0.3)
                Tween(self.Logo.Accent, {BackgroundColor3 = Theme.SubText}, 0.3)
            end
        end
    end)
    
    -- Initialize windows table
    self.Windows = {}
    
    -- Initialize keybinds
    self.Keybinds = {}
    
    -- Process keybinds
    RunService.Heartbeat:Connect(function()
        for key, callback in pairs(self.Keybinds) do
            if UserInputService:IsKeyDown(key) then
                callback()
            end
        end
    end)
    
    -- Welcome notification
    self:Notify("Mafuyo Premium UI", "Welcome to Mafuyo Premium UI Library", "Info", 5)
    
    return self
end

function MafuyoUI:CreateWindow(title)
    title = title or "Mafuyo Premium"
    
    -- Create window
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- Create main frame
    Window.Frame = Create("Frame")({
        Name = "Window",
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        Parent = self.GUI
    })
    
    RoundBox(CORNER_RADIUS).Parent = Window.Frame
    Shadow(Window.Frame)
    Glow(Window.Frame, Theme.Accent, 0.9)
    
    -- Create top bar
    Window.TopBar = Create("Frame")({
        Name = "TopBar",
        BackgroundColor3 = Theme.TopBar,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = Window.Frame
    })

    local topBarCorner = RoundBox(CORNER_RADIUS)
    topBarCorner.Parent = Window.TopBar
    
    -- Make window draggable with advanced physics
    MakeDraggable(Window.TopBar, Window.Frame)
    
    -- Create title
    Window.Title = Create("TextLabel")({
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Theme.HeaderFont,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Window.TopBar
    })
    
    -- Create close button
    Window.CloseButton = Create("TextButton")({
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Theme.HeaderFont,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 20,
        Parent = Window.TopBar
    })
    
    Window.CloseButton.MouseButton1Click:Connect(function()
        Tween(Window.Frame, {Position = UDim2.new(Window.Frame.Position.X.Scale, Window.Frame.Position.X.Offset, Window.Frame.Position.Y.Scale - 0.1, Window.Frame.Position.Y.Offset), BackgroundTransparency = 1}, EFFECT_SPEED)
        task.delay(EFFECT_SPEED, function()
            Window.Frame.Visible = false
        end)
        
        self.Toggled = false
        
        -- Animate logo
        Tween(self.Logo, {Rotation = 45}, 0.3)
        Tween(self.Logo.Accent, {BackgroundColor3 = Theme.SubText}, 0.3)
    end)
    
    -- Create minimize button
    Window.MinimizeButton = Create("TextButton")({
        Name = "MinimizeButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Theme.HeaderFont,
        Text = "-",
        TextColor3 = Theme.Text,
        TextSize = 20,
        Parent = Window.TopBar
    })
    
    local minimized = false
    local originalSize = Window.Frame.Size
    
    Window.MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            Tween(Window.Frame, {Size = UDim2.new(0, 600, 0, 30)}, EFFECT_SPEED)
            for _, tab in pairs(Window.Tabs) do
                tab.Frame.Visible = false
            end
        else
            Tween(Window.Frame, {Size = originalSize}, EFFECT_SPEED)
            if Window.ActiveTab then
                Window.ActiveTab.Frame.Visible = true
            end
        end
    end)
    
    -- Create tab container
    Window.TabContainer = Create("Frame")({
        Name = "TabContainer",
        BackgroundColor3 = Theme.TopBar,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 30),
        Parent = Window.Frame
    })
    
    -- Create tab button holder
    Window.TabButtonHolder = Create("ScrollingFrame")({
        Name = "TabButtonHolder",
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        Parent = Window.TabContainer
    })
    
    local TabButtonList = Create("UIListLayout")({
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = Window.TabButtonHolder
    })
    
    local TabButtonPadding = Create("UIPadding")({
        PaddingLeft = UDim.new(0, 5),
        Parent = Window.TabButtonHolder
    })
    
    -- Create tab content container
    Window.TabContentContainer = Create("Frame")({
        Name = "TabContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 60),
        Size = UDim2.new(1, 0, 1, -60),
        Parent = Window.Frame
    })
    
    -- Tab creation function
    function Window:CreateTab(name)
        local Tab = {}
        Tab.Name = name
        Tab.Sections = {}
        Tab.Elements = {}
        
        -- Create tab button
        Tab.Button = Create("TextButton")({
            Name = name.."Button",
            BackgroundColor3 = Theme.Button,
            Size = UDim2.new(0, 100, 1, -5),
            Font = Theme.TextFont,
            Text = name,
            TextColor3 = Theme.SubText,
            TextSize = 12,
            Parent = Window.TabButtonHolder
        })
        
        RoundBox(4).Parent = Tab.Button
        AddHoverEffect(Tab.Button, Theme.ButtonHover, Theme.Button)
        AddClickEffect(Tab.Button)
        
        -- Create tab content frame
        Tab.Frame = Create("ScrollingFrame")({
            Name = name.."Tab",
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            Visible = false,
            Parent = Window.TabContentContainer
        })
        
        local ContentList = Create("UIListLayout")({
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = Tab.Frame
        })
        
        local ContentPadding = Create("UIPadding")({
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            Parent = Tab.Frame
        })
        
        -- Update canvas size when elements are added
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Tab.Frame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab button functionality
        Tab.Button.MouseButton1Click:Connect(function()
            -- Deselect all tabs
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundColor3 = Theme.Button})
                Tween(tab.Button, {TextColor3 = Theme.SubText})
                
                if tab ~= Window.ActiveTab then
                    tab.Frame.Visible = false
                end
            end
            
            -- Select this tab
            Tween(Tab.Button, {BackgroundColor3 = Theme.Accent})
            Tween(Tab.Button, {TextColor3 = Theme.Text})
            
            -- Animate tab change
            if Window.ActiveTab then
                Tween(Window.ActiveTab.Frame, {Position = UDim2.new(0.1, 0, 0, 0), BackgroundTransparency = 1}, EFFECT_SPEED)
                task.delay(EFFECT_SPEED, function()
                    Window.ActiveTab.Frame.Visible = false
                    Tab.Frame.Position = UDim2.new(-0.1, 0, 0, 0)
                    Tab.Frame.BackgroundTransparency = 1
                    Tab.Frame.Visible = true
                    Tween(Tab.Frame, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, EFFECT_SPEED)
                end)
            else
                Tab.Frame.Position = UDim2.new(-0.1, 0, 0, 0)
                Tab.Frame.BackgroundTransparency = 1
                Tab.Frame.Visible = true
                Tween(Tab.Frame, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, EFFECT_SPEED)
            end
            
            Window.ActiveTab = Tab
        end)
        
        -- Section creation function
        function Tab:CreateSection(name)
            local Section = {}
            Section.Name = name
            Section.Elements = {}
            
            -- Create section frame
            Section.Frame = Create("Frame")({
                Name = name.."Section",
                BackgroundColor3 = Theme.Section,
                Size = UDim2.new(1, 0, 0, 40), -- Will be resized based on content
                Parent = Tab.Frame
            })
            
            RoundBox(CORNER_RADIUS).Parent = Section.Frame
            Shadow(Section.Frame, 6, 0.5)
            
            -- Create section title
            Section.Title = Create("TextLabel")({
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 8),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Theme.HeaderFont,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section.Frame
            })
            
            -- Create section content
            Section.Content = Create("Frame")({
                Name = "Content",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 30),
                Size = UDim2.new(1, 0, 0, 0), -- Will be resized based on content
                Parent = Section.Frame
            })
            
            local SectionList = Create("UIListLayout")({
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                Parent = Section.Content
            })
            
            local SectionPadding = Create("UIPadding")({
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                Parent = Section.Content
            })
            
            -- Update section size when elements are added
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Content.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                Section.Frame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y + 40)
            end)
            
            -- Button creation function
            function Section:CreateButton(text, callback, tooltip)
                callback = callback or function() end
                
                local Button = {}
                Button.Type = "Button"
                
                -- Create button
                Button.Instance = Create("TextButton")({
                    Name = text.."Button",
                    BackgroundColor3 = Theme.Button,
                    Size = UDim2.new(1, 0, 0, 32),
                    Font = Theme.TextFont,
                    Text = text,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Parent = Section.Content
                })
                
                RoundBox(4).Parent = Button.Instance
                AddHoverEffect(Button.Instance, Theme.ButtonHover, Theme.Button, Theme.ButtonPress)
                AddClickEffect(Button.Instance)
                
                if tooltip then
                    AddTooltip(Button.Instance, tooltip)
                end
                
                -- Button functionality
                Button.Instance.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                -- Add to elements
                table.insert(Section.Elements, Button)
                table.insert(Tab.Elements, Button)
                
                return Button
            end
            
            -- Toggle creation function
            function Section:CreateToggle(text, default, callback, tooltip)
                default = default or false
                callback = callback or function() end
                
                local Toggle = {}
                Toggle.Type = "Toggle"
                Toggle.Value = default
                
                -- Create toggle frame
                Toggle.Instance = Create("Frame")({
                    Name = text.."Toggle",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    Parent = Section.Content
                })
                
                -- Create toggle label
                Toggle.Instance.Label = Create("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    Font = Theme.TextFont,
                    Text = text,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Toggle.Instance
                })
                
                -- Create toggle button
                Toggle.Instance.Button = Create("Frame")({
                    Name = "Button",
                    BackgroundColor3 = default and Theme.ToggleAccent or Theme.Toggle,
                    Position = UDim2.new(1, -40, 0.5, -8),
                    Size = UDim2.new(0, 40, 0, 16),
                    Parent = Toggle.Instance
                })
                
                RoundBox(8).Parent = Toggle.Instance.Button
                
                -- Create toggle indicator
                Toggle.Instance.Indicator = Create("Frame")({
                    Name = "Indicator",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Theme.Text,
                    Position = default and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    Parent = Toggle.Instance.Button
                })
                
                RoundBox(6).Parent = Toggle.Instance.Indicator
                
                -- Create hitbox
                Toggle.Instance.Hitbox = Create("TextButton")({
                    Name = "Hitbox",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = Toggle.Instance
                })
                
                if tooltip then
                    AddTooltip(Toggle.Instance, tooltip)
                end
                
                -- Toggle functionality
                local function UpdateToggle()
                    Tween(Toggle.Instance.Button, {BackgroundColor3 = Toggle.Value and Theme.ToggleAccent or Theme.Toggle})
                    Tween(Toggle.Instance.Indicator, {Position = Toggle.Value and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
                    callback(Toggle.Value)
                end
                
                Toggle.Instance.Hitbox.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    UpdateToggle()
                    Ripple(Toggle.Instance.Button)
                end)
                
                -- Set default value
                if default then
                    callback(true)
                end
                
                -- Toggle methods
                function Toggle:SetValue(value)
                    Toggle.Value = value
                    UpdateToggle()
                end
                
                -- Add to elements
                table.insert(Section.Elements, Toggle)
                table.insert(Tab.Elements, Toggle)
                
                return Toggle
            end
            
            -- Slider creation function
            function Section:CreateSlider(text, min, max, default, callback, tooltip)
                min = min or 0
                max = max or 100
                default = default or min
                callback = callback or function() end
                
                local Slider = {}
                Slider.Type = "Slider"
                Slider.Value = default
                
                -- Create slider frame
                Slider.Instance = Create("Frame")({
                    Name = text.."Slider",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
                    Parent = Section.Content
                })
                
                -- Create slider label
                Slider.Instance.Label = Create("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Theme.TextFont,
                    Text = text,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Slider.Instance
                })
                
                -- Create value label
                Slider.Instance.ValueLabel = Create("TextLabel")({
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -40, 0, 0),
                    Size = UDim2.new(0, 40, 0, 20),
                    Font = Theme.TextFont,
                    Text = tostring(default),
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Slider.Instance
                })
                
                -- Create slider background
                Slider.Instance.Background = Create("Frame")({
                    Name = "Background",
                    BackgroundColor3 = Theme.Slider,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 10),
                    Parent = Slider.Instance
                })
                
                RoundBox(5).Parent = Slider.Instance.Background
                
                -- Create slider fill
                Slider.Instance.Fill = Create("Frame")({
                    Name = "Fill",
                    BackgroundColor3 = Theme.SliderAccent,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    Parent = Slider.Instance.Background
                })
                
                RoundBox(5).Parent = Slider.Instance.Fill
                
                -- Create slider hitbox
                Slider.Instance.Hitbox = Create("TextButton")({
                    Name = "Hitbox",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = Slider.Instance.Background
                })
                
                if tooltip then
                    AddTooltip(Slider.Instance, tooltip)
                end
                
                -- Slider functionality
                local isDragging = false
                
                Slider.Instance.Hitbox.MouseButton1Down:Connect(function()
                    isDragging = true
                    Ripple(Slider.Instance.Background)
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = false
                    end
                end)
                
                Slider.Instance.Hitbox.MouseMoved:Connect(function(_, y)
                    if isDragging then
                        local percentage = math.clamp((UserInputService:GetMouseLocation().X - Slider.Instance.Background.AbsolutePosition.X) / Slider.Instance.Background.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * percentage)
                        
                        Slider.Value = value
                        Slider.Instance.ValueLabel.Text = tostring(value)
                        Slider.Instance.Fill.Size = UDim2.new(percentage, 0, 1, 0)
                        
                        callback(value)
                    end
                end)
                
                -- Slider methods
                function Slider:SetValue(value)
                    value = math.clamp(value, min, max)
                    Slider.Value = value
                    
                    local percentage = (value - min) / (max - min)
                    Slider.Instance.ValueLabel.Text = tostring(value)
                    Slider.Instance.Fill.Size = UDim2.new(percentage, 0, 1, 0)
                    
                    callback(value)
                end
                
                -- Add to elements
                table.insert(Section.Elements, Slider)
                table.insert(Tab.Elements, Slider)
                
                return Slider
            end
            
            -- Add other UI element creation functions here...
            
            -- Add to sections
            table.insert(Tab.Sections, Section)
            
            return Section
        end
        
        -- Add tab to window tabs
        table.insert(Window.Tabs, Tab)
        
        -- Select this tab if it's the first one
        if #Window.Tabs == 1 then
            Tab.Button.BackgroundColor3 = Theme.Accent
            Tab.Button.TextColor3 = Theme.Text
            Tab.Frame.Visible = true
            Window.ActiveTab = Tab
        end
        
        return Tab
    end
    
    -- Add window to windows table
    table.insert(self.Windows, Window)
    
    -- Animate window in
    Window.Frame.Size = UDim2.new(0, 0, 0, 0)
    Window.Frame.BackgroundTransparency = 1
    
    Tween(Window.Frame, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, EFFECT_SPEED, Enum.EasingStyle.Back)
    
    return Window
end

-- Return the library
return MafuyoUI
