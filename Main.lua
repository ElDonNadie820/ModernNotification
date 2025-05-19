-- Made by:
-- Owner:Kai (maxlol2023k)
-- Uploader: eldonnadie820

game:DefineFastFlag("UseEnhancedNotificationClicks", true)
Notification = {}
Notification.BarHeight       = 6       -- Height of the duration bar
Notification.DurationDefault = 5       -- Default duration in seconds
Notification.SlideTime       = 0.4     -- Slide in/out time
Notification.FadeTime        = 0.2     -- Fade out time
Notification.Styles = {
    Info    = {BG = Color3.fromRGB(52,152,219), Text = Color3.new(1,1,1), Icon = "rbxassetid://84318479516741"}, -- info icon
    Success = {BG = Color3.fromRGB(46,204,113), Text = Color3.new(1,1,1), Icon = "rbxassetid://73203776287584"}, -- check_circle icon
    Warning = {BG = Color3.fromRGB(241,196,15), Text = Color3.new(0,0,0), Icon = "rbxassetid://94100274038166"}, -- warning icon
    Error   = {BG = Color3.fromRGB(231,76,60), Text = Color3.new(1,1,1), Icon = "rbxassetid://125517729432790"}, -- error_outline icon
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
        sg.Name = "NotificationHolder"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = gui

        local container = Instance.new("Frame", sg)
        container.Name        = "Container"
        container.AnchorPoint = Vector2.new(0.5,0)
        container.Position    = UDim2.new(0.5,0,0,50)
        container.Size        = UDim2.new(0,320,0,0)
        container.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", container)
        layout.Padding   = UDim.new(0,8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
    end
    return sg.Container
end

-- Core send method
function Notification:Send(title, text, duration, style)
    duration = duration or self.DurationDefault
    local cfg = self.Styles[style] or self.Styles.Info
    local holder = getHolder()

    -- Main frame
    local frame = Instance.new("Frame", holder)
    frame.Size        = UDim2.new(0,320,0,80)
    frame.Position    = UDim2.new(0.5,0,0,-100)
    frame.AnchorPoint = Vector2.new(0.5,0)
    frame.BackgroundColor3    = cfg.BG
    frame.BackgroundTransparency = 1
    frame.ZIndex = 10

    -- Rounded corners & shadow
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,20)
    local shadow = Instance.new("ImageLabel", frame)
    shadow.Name               = "Shadow"
    shadow.Size               = UDim2.new(1,20,1,20)
    shadow.Position           = UDim2.new(0,-10,0,-10)
    shadow.BackgroundTransparency = 1
    shadow.Image              = "rbxassetid://6014261993"
    shadow.ScaleType          = Enum.ScaleType.Slice
    shadow.SliceCenter        = Rect.new(30,30,60,60)
    shadow.ImageTransparency  = 0.7

    -- Icon
    local icon = Instance.new("ImageLabel", frame)
    icon.Size               = UDim2.new(0,24,0,24)
    icon.Position           = UDim2.new(0,12,0,12)
    icon.BackgroundTransparency = 1
    icon.Image              = cfg.Icon
    icon.ImageColor3        = cfg.Text

    -- Title label
    local titleLbl = Instance.new("TextLabel", frame)
    titleLbl.Size                   = UDim2.new(1,-52,0,24)
    titleLbl.Position               = UDim2.new(0,44,0,12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 22
    titleLbl.TextColor3             = cfg.Text
    titleLbl.Text                   = title or "Title"
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left

    -- Body text label
    local textLbl = Instance.new("TextLabel", frame)
    textLbl.Size                   = UDim2.new(1,-24,0,36)
    textLbl.Position               = UDim2.new(0,12,0,36)
    textLbl.BackgroundTransparency = 1
    textLbl.Font                   = Enum.Font.Gotham
    textLbl.TextSize               = 16
    textLbl.TextColor3             = cfg.Text
    textLbl.Text                   = text or "Message body."
    textLbl.TextWrapped            = true
    textLbl.TextXAlignment         = Enum.TextXAlignment.Left

    -- Duration bar background
    local barBg = Instance.new("Frame", frame)
    barBg.Name                   = "BarBG"
    barBg.Size                   = UDim2.new(1,-24,0,self.BarHeight)
    barBg.Position               = UDim2.new(0,12,1,-self.BarHeight-8)
    barBg.BackgroundColor3       = Color3.fromRGB(70,70,70)
    barBg.BackgroundTransparency = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0,4)

    -- Duration bar fill
    local barFill = Instance.new("Frame", barBg)
    barFill.Size             = UDim2.new(1,0,1,0)
    barFill.BackgroundColor3 = cfg.Text
    local fillCorner = Instance.new("UICorner", barFill)
    fillCorner.CornerRadius = UDim.new(0,4)

    -- Animate in
    TweenService:Create(frame, TweenInfo.new(self.SlideTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5,0,0,0)
    }):Play()

    -- Bar tween
    local barTween = TweenService:Create(barFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0,0,1,0)
    })
    barTween:Play()

    -- Dismiss logic
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        barTween:Pause()
        TweenService:Create(frame, TweenInfo.new(self.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(frame, TweenInfo.new(self.SlideTime, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5,0,0,-100)
        }):Play()
        delay(math.max(self.FadeTime, self.SlideTime), function()
            frame:Destroy()
        end)
    end

    -- Invisible button for clicks
    local clickBtn = Instance.new("TextButton", frame)
    clickBtn.Size                 = UDim2.new(1,0,1,0)
    clickBtn.Position             = UDim2.new(0,0,0,0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text                 = ""
    clickBtn.ZIndex               = frame.ZIndex + 1
    clickBtn.MouseButton1Click:Connect(dismiss)

    -- Auto dismiss
    delay(duration, dismiss)
end

-- Convenience wrappers
function Notification:Info(t1,t2,d)    self:Send(t1,t2,d,"Info")    end
function Notification:Success(t1,t2,d) self:Send(t1,t2,d,"Success") end
function Notification:Warning(t1,t2,d) self:Send(t1,t2,d,"Warning") end
function Notification:Error(t1,t2,d)   self:Send(t1,t2,d,"Error")   end
