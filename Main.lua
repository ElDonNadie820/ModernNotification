--[[
  Made By: Kai
  Made With Love <3
  V1.1.4
]]

game:DefineFastFlag("UseEnhancedNotificationClicks", true)
Notification = {}

-- Settings
Notification.BarHeight       = 6               -- px height of duration bar
Notification.DurationDefault = 5               -- default duration (s)
Notification.SlideTime       = 0.4             -- slide in/out time (s)
Notification.FadeTime        = 0.2             -- fade out time (s)
Notification.WidthScale      = 0.5             -- width relative to screen

-- Styles (with updated icon IDs)
Notification.Styles = {
    Info    = {BG = Color3.fromRGB(52,152,219), Text = Color3.new(1,1,1), Icon = "rbxassetid://87995783720912"},
    Success = {BG = Color3.fromRGB(46,204,113), Text = Color3.new(1,1,1), Icon = "rbxassetid://132290828086464"},
    Warning = {BG = Color3.fromRGB(241,196,15), Text = Color3.new(0,0,0), Icon = "rbxassetid://126337702969156"},
    Error   = {BG = Color3.fromRGB(231,76,60), Text = Color3.new(1,1,1), Icon = "rbxassetid://86279777621841"},
}

-- Services
local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")

-- Create or return holder
local function getHolder()
    local player = Players.LocalPlayer
    local gui    = player:WaitForChild("PlayerGui")
    local sg     = gui:FindFirstChild("NotificationHolder")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name            = "NotificationHolder"
        sg.ResetOnSpawn    = false
        sg.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
        sg.Parent          = gui

        local container = Instance.new("Frame", sg)
        container.Name            = "Container"
        container.AnchorPoint     = Vector2.new(0.5, 0)
        container.Position        = UDim2.new(0.5, 0, 0.05, 0) -- 5% from top
        container.Size            = UDim2.new(Notification.WidthScale, 0, 0, 0)
        container.BackgroundTransparency = 1
        container.AutomaticSize   = Enum.AutomaticSize.Y
        container.ClipsDescendants = false

        local layout = Instance.new("UIListLayout", container)
        layout.Padding   = UDim.new(0.01, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
    end
    return sg.Container
end

-- Core send method
function Notification:Send(title, text, duration, style)
    duration = duration or self.DurationDefault
    local cfg = self.Styles[style] or self.Styles.Info
    local holder = getHolder()

    -- Notification frame
    local frame = Instance.new("Frame")
    frame.Name                   = "Notification"
    frame.Size                   = UDim2.new(1, 0, 0, 80)
    frame.AnchorPoint            = Vector2.new(0.5, 0)
    frame.Position               = UDim2.new(0.5, 0, 0, -100)
    frame.BackgroundColor3       = cfg.BG
    frame.BackgroundTransparency = 1
    frame.ZIndex                 = 10
    frame.Parent                 = holder

    -- Corner & shadow
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    local shadow = Instance.new("ImageLabel", frame)
    shadow.Name               = "Shadow"
    shadow.Size               = UDim2.new(1, 20, 1, 20)
    shadow.Position           = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image              = "rbxassetid://6014261993"
    shadow.ImageColor3        = Color3.new(0, 0, 0)
    shadow.ScaleType          = Enum.ScaleType.Slice
    shadow.SliceCenter        = Rect.new(30, 30, 60, 60)
    shadow.ImageTransparency  = 0.6

    -- Icon
    local icon = Instance.new("ImageLabel", frame)
    icon.Name                  = "Icon"
    icon.Size                  = UDim2.new(0, 24, 0, 24)
    icon.Position              = UDim2.new(0, 12, 0, 12)
    icon.BackgroundTransparency= 1
    icon.Image                 = cfg.Icon
    icon.ZIndex                = frame.ZIndex + 1

    -- Title
    local titleLbl = Instance.new("TextLabel", frame)
    titleLbl.Name               = "Title"
    titleLbl.Size               = UDim2.new(1, -52, 0, 24)
    titleLbl.Position           = UDim2.new(0, 44, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font               = Enum.Font.GothamBold
    titleLbl.TextSize           = 20
    titleLbl.TextColor3         = cfg.Text
    titleLbl.Text               = title or "Title"
    titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
    titleLbl.ZIndex             = frame.ZIndex + 1

    -- Body
    local textLbl = Instance.new("TextLabel", frame)
    textLbl.Name               = "Body"
    textLbl.Size               = UDim2.new(1, -24, 0, 36)
    textLbl.Position           = UDim2.new(0, 12, 0, 36)
    textLbl.BackgroundTransparency = 1
    textLbl.Font               = Enum.Font.Gotham
    textLbl.TextSize           = 14
    textLbl.TextColor3         = cfg.Text
    textLbl.Text               = text or "Message body."
    textLbl.TextWrapped        = true
    textLbl.TextXAlignment     = Enum.TextXAlignment.Left

    -- Duration bar
    local barBg = Instance.new("Frame", frame)
    barBg.Name                   = "BarBG"
    barBg.Size                   = UDim2.new(1, -24, 0, self.BarHeight)
    barBg.Position               = UDim2.new(0, 12, 1, -self.BarHeight - 8)
    barBg.BackgroundColor3       = Color3.fromRGB(70, 70, 70)
    barBg.BackgroundTransparency = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 2)

    local barFill = Instance.new("Frame", barBg)
    barFill.Name             = "BarFill"
    barFill.Size             = UDim2.new(1, 0, 1, 0)
    barFill.BackgroundColor3 = cfg.Text
    local fillCorner         = Instance.new("UICorner", barFill)
    fillCorner.CornerRadius  = UDim.new(0, 2)

    -- Animate in (Bounce)
    TweenService:Create(frame, TweenInfo.new(self.SlideTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position               = UDim2.new(0.5, 0, 0, 0)
    }):Play()

    -- Progress bar tween
    local barTween = TweenService:Create(barFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    })
    barTween:Play()

    -- Dismiss logic
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        barTween:Pause()
        -- Animate out (Fade-slide)
        TweenService:Create(frame, TweenInfo.new(self.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(frame, TweenInfo.new(self.SlideTime, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0, -80)
        }):Play()
        delay(math.max(self.FadeTime, self.SlideTime), function()
            frame:Destroy()
        end)
    end

    -- Click overlay
    local clickBtn = Instance.new("TextButton", frame)
    clickBtn.Name                   = "ClickOverlay"
    clickBtn.Size                   = UDim2.new(1, 0, 1, 0)
    clickBtn.Position               = UDim2.new(0, 0, 0, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text                   = ""
    clickBtn.ZIndex                 = frame.ZIndex + 1
    clickBtn.MouseButton1Click:Connect(dismiss)

    -- Auto dismiss
    delay(duration, dismiss)
end

-- Convenience wrappers
function Notification:Info(t1, t2, d)    self:Send(t1, t2, d, "Info")    end
function Notification:Success(t1, t2, d) self:Send(t1, t2, d, "Success") end
function Notification:Warning(t1, t2, d) self:Send(t1, t2, d, "Warning") end
function Notification:Error(t1, t2, d)   self:Send(t1, t2, d, "Error")   end
