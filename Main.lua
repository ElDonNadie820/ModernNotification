--[[
  Made By: Kai
  Made With Love <3
  V1.0 (beta)
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Notification = {}

Notification.BarHeight = 6
Notification.DurationDefault = 5
Notification.SlideTime = 0.4
Notification.FadeTime = 0.2
Notification.WidthScale = 0.5

Notification.Styles = {
    Info    = {BG = Color3.fromRGB(52,152,219), Text = Color3.new(1,1,1), Icon = "rbxassetid://87995783720912"},
    Success = {BG = Color3.fromRGB(46,204,113), Text = Color3.new(1,1,1), Icon = "rbxassetid://132290828086464"},
    Warning = {BG = Color3.fromRGB(241,196,15), Text = Color3.new(0,0,0), Icon = "rbxassetid://126337702969156"},
    Error   = {BG = Color3.fromRGB(231,76,60), Text = Color3.new(1,1,1), Icon = "rbxassetid://86279777621841"},
}

local function getHolder()
    local gui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local holder = gui:FindFirstChild("NotificationHolder")
    if not holder then
        holder = Instance.new("ScreenGui")
        holder.Name = "NotificationHolder"
        holder.ResetOnSpawn = false
        holder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        holder.Parent = gui

        local container = Instance.new("Frame")
        container.Name = "Container"
        container.AnchorPoint = Vector2.new(0.5, 0)
        container.Position = UDim2.new(0.5, 0, 0.05, 0)
        container.Size = UDim2.new(Notification.WidthScale, 0, 0, 0)
        container.BackgroundTransparency = 1
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.ClipsDescendants = false
        container.Parent = holder

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container
    end
    return holder.Container
end

function Notification:Send(title, text, duration, style)
    duration = duration or self.DurationDefault
    local cfg = self.Styles[style] or self.Styles.Info
    local holder = getHolder()

    local frame = Instance.new("Frame")
    frame.Name = "Notification"
    frame.Size = UDim2.new(1, 0, 0, 80)
    frame.BackgroundColor3 = cfg.BG
    frame.BackgroundTransparency = 1
    frame.ClipsDescendants = true
    frame.ZIndex = 10
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, -100)
    frame.Parent = holder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Image = cfg.Icon
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 12, 0, 12)
    icon.BackgroundTransparency = 1
    icon.ImageTransparency = 1
    icon.ZIndex = 11
    icon.Parent = frame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "Title"
    titleLbl.Text = title or "Title"
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 20
    titleLbl.TextColor3 = cfg.Text
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size = UDim2.new(1, -52, 0, 24)
    titleLbl.Position = UDim2.new(0, 44, 0, 12)
    titleLbl.ZIndex = 11
    titleLbl.TextTransparency = 1
    titleLbl.Parent = frame

    local textLbl = Instance.new("TextLabel")
    textLbl.Name = "Body"
    textLbl.Text = text or "Message body."
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextSize = 14
    textLbl.TextWrapped = true
    textLbl.TextColor3 = cfg.Text
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.BackgroundTransparency = 1
    textLbl.Size = UDim2.new(1, -24, 0, 36)
    textLbl.Position = UDim2.new(0, 12, 0, 36)
    textLbl.ZIndex = 11
    textLbl.TextTransparency = 1
    textLbl.Parent = frame

    local bar = Instance.new("Frame")
    bar.Name = "ProgressBar"
    bar.Size = UDim2.new(1, -24, 0, self.BarHeight)
    bar.Position = UDim2.new(0, 12, 1, -self.BarHeight - 8)
    bar.BackgroundColor3 = cfg.Text
    bar.BackgroundTransparency = 0.6
    bar.ZIndex = 11
    bar.Parent = frame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = cfg.Text
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.ZIndex = 12
    fill.Name = "Fill"
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = fill

    -- Hover effect
    local overlay = Instance.new("TextButton")
    overlay.Name = "Overlay"
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Text = ""
    overlay.ZIndex = 20
    overlay.Parent = frame

    overlay.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {
            BackgroundColor3 = cfg.BG:Lerp(Color3.new(1, 1, 1), 0.05)
        }):Play()
    end)

    overlay.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {
            BackgroundColor3 = cfg.BG
        }):Play()
    end)

    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true

        TweenService:Create(icon, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
        TweenService:Create(titleLbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(textLbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(frame, TweenInfo.new(Notification.FadeTime), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, -100)
        }):Play()
        task.delay(Notification.FadeTime + 0.1, function()
            frame:Destroy()
        end)
    end

    overlay.MouseButton1Click:Connect(dismiss)

    -- Animate in
    TweenService:Create(frame, TweenInfo.new(self.SlideTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, 0, 0, 0)
    }):Play()
    TweenService:Create(icon, TweenInfo.new(0.4), {ImageTransparency = 0}):Play()
    TweenService:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(textLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

    TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    task.delay(duration, dismiss)
end

function Notification:Info(t1, t2, d)    self:Send(t1, t2, d, "Info")    end
function Notification:Success(t1, t2, d) self:Send(t1, t2, d, "Success") end
function Notification:Warning(t1, t2, d) self:Send(t1, t2, d, "Warning") end
function Notification:Error(t1, t2, d)   self:Send(t1, t2, d, "Error")   end

return Notification
