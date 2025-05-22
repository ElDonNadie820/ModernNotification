--[[
  Made By: Kai
  Made With Love <3
  V1.1.3
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Notification = {}

-- Settings
Notification.BarHeight = 6
Notification.DurationDefault = 5
Notification.SlideTime = 0.4
Notification.FadeTime = 0.2
Notification.WidthScale = 0.5

-- Styles with Icons
Notification.Styles = {
    Info    = {BG = Color3.fromRGB(52,152,219), Text = Color3.new(1,1,1), Icon = "rbxassetid://87995783720912"},
    Success = {BG = Color3.fromRGB(46,204,113), Text = Color3.new(1,1,1), Icon = "rbxassetid://132290828086464"},
    Warning = {BG = Color3.fromRGB(241,196,15), Text = Color3.new(0,0,0), Icon = "rbxassetid://126337702969156"},
    Error   = {BG = Color3.fromRGB(231,76,60), Text = Color3.new(1,1,1), Icon = "rbxassetid://86279777621841"},
}

local function getHolder()
    local gui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local sg = gui:FindFirstChild("NotificationHolder")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name = "NotificationHolder"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = gui

        local container = Instance.new("Frame")
        container.Name = "Container"
        container.AnchorPoint = Vector2.new(0.5, 0)
        container.Position = UDim2.new(0.5, 0, 0.05, 0)
        container.Size = UDim2.new(Notification.WidthScale, 0, 0, 0)
        container.BackgroundTransparency = 1
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.ClipsDescendants = false
        container.Parent = sg

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0.01, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container
    end
    return sg.Container
end

function Notification:Send(title, text, duration, style)
    duration = duration or self.DurationDefault
    local cfg = self.Styles[style] or self.Styles.Info
    local holder = getHolder()

    local frame = Instance.new("Frame")
    frame.Name = "Notification"
    frame.Size = UDim2.new(1, 0, 0, 80)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, -100)
    frame.BackgroundColor3 = cfg.BG
    frame.BackgroundTransparency = 1
    frame.ZIndex = 10
    frame.Parent = holder
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 12, 0, 12)
    icon.BackgroundTransparency = 1
    icon.Image = cfg.Icon
    icon.ZIndex = 11
    icon.Parent = frame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "Title"
    titleLbl.Size = UDim2.new(1, -52, 0, 24)
    titleLbl.Position = UDim2.new(0, 44, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 20
    titleLbl.TextColor3 = cfg.Text
    titleLbl.Text = title or "Title"
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 11
    titleLbl.Parent = frame

    local textLbl = Instance.new("TextLabel")
    textLbl.Name = "Body"
    textLbl.Size = UDim2.new(1, -24, 0, 36)
    textLbl.Position = UDim2.new(0, 12, 0, 36)
    textLbl.BackgroundTransparency = 1
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextSize = 14
    textLbl.TextColor3 = cfg.Text
    textLbl.Text = text or "Message body."
    textLbl.TextWrapped = true
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.ZIndex = 11
    textLbl.Parent = frame

    local barBg = Instance.new("Frame")
    barBg.Name = "BarBG"
    barBg.Size = UDim2.new(1, -24, 0, self.BarHeight)
    barBg.Position = UDim2.new(0, 12, 1, -self.BarHeight - 8)
    barBg.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    barBg.BackgroundTransparency = 0
    barBg.ZIndex = 11
    barBg.Parent = frame
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 2)

    local barFill = Instance.new("Frame")
    barFill.Name = "BarFill"
    barFill.Size = UDim2.new(1, 0, 1, 0)
    barFill.BackgroundColor3 = cfg.Text
    barFill.ZIndex = 12
    barFill.Parent = barBg
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 2)

    local function dismiss()
        TweenService:Create(frame, TweenInfo.new(Notification.FadeTime), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, -100)
        }):Play()
        task.delay(Notification.FadeTime + 0.1, function()
            frame:Destroy()
        end)
    end

    local barTween = TweenService:Create(barFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    })
    barTween:Play()

    local hoverConnection
    local clickBtn = Instance.new("TextButton")
    clickBtn.Name = "ClickOverlay"
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 20
    clickBtn.Parent = frame

    clickBtn.MouseEnter:Connect(function()
        frame.BackgroundColor3 = cfg.BG:Lerp(Color3.new(1,1,1), 0.1)
    end)

    clickBtn.MouseLeave:Connect(function()
        frame.BackgroundColor3 = cfg.BG
    end)

    clickBtn.MouseButton1Click:Connect(dismiss)

    TweenService:Create(frame, TweenInfo.new(Notification.SlideTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, 0, 0, 0)
    }):Play()

    task.delay(duration, dismiss)
end

function Notification:Info(t1, t2, d)    self:Send(t1, t2, d, "Info")    end
function Notification:Success(t1, t2, d) self:Send(t1, t2, d, "Success") end
function Notification:Warning(t1, t2, d) self:Send(t1, t2, d, "Warning") end
function Notification:Error(t1, t2, d)   self:Send(t1, t2, d, "Error")   end

return Notification
