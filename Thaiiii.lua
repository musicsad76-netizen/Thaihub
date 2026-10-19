-- THAIIIFMFYT GUI
-- For Roblox Studio
-- Place inside StarterPlayerScripts as a LocalScript
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local enabled = {
    Fly = false,
    InfiniteJump = false,
    AntiAFK = true,
    AntiLag = false
}
local speed = 50
local flyConnection
local jumpConnection
local gui = Instance.new("ScreenGui")
gui.Name = "THAIIIFMFYT"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 390)
frame.Position = UDim2.new(0.5, -140, 0.5, -195)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(120, 40, 220)
title.Text = "THAIIIFMFYT"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = frame
local function makeButton(text, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 15
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.Parent = frame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button
    button.Activated:Connect(callback)
    return button
end
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 50)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Text = "Speed: 50"
speedLabel.Parent = frame
makeButton("Speed +", 78, function()
    speed = math.clamp(speed + 10, 16, 200)
    speedLabel.Text = "Speed: " .. speed
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = speed end
end)
makeButton("Speed -", 118, function()
    speed = math.clamp(speed - 10, 16, 200)
    speedLabel.Text = "Speed: " .. speed
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = speed end
end)
local flyButton
flyButton = makeButton("Fly: OFF", 158, function()
    enabled.Fly = not enabled.Fly
    flyButton.Text = "Fly: " .. (enabled.Fly and "ON" or "OFF")
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    if enabled.Fly then
        local attachment = Instance.new("Attachment")
        attachment.Name = "ThaiiFlyAttachment"
        attachment.Parent = root
        local velocity = Instance.new("LinearVelocity")
        velocity.Name = "ThaiiFlyVelocity"
        velocity.Attachment0 = attachment
        velocity.MaxForce = 100000
        velocity.VectorVelocity = Vector3.zero
        velocity.RelativeTo = Enum.ActuatorRelativeTo.World
        velocity.Parent = root
        flyConnection = RunService.Heartbeat:Connect(function()
            if not root.Parent then return end
            local camera = workspace.CurrentCamera
            local direction = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction += camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction -= camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction -= camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction += camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction += Vector3.yAxis
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction -= Vector3.yAxis
            end
            velocity.VectorVelocity =
                direction.Magnitude > 0
                and direction.Unit * speed
                or Vector3.zero
        end)
        humanoid.PlatformStand = true
        flyConnection = RunService.Heartbeat:Connect(function()
            if not root.Parent then return end
            local v = root:FindFirstChild("ThaiiFlyVelocity")
            if v then
                local camera = workspace.CurrentCamera
                local direction = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.yAxis end
                v.VectorVelocity = direction.Magnitude > 0 and direction.Unit * speed or Vector3.zero
            end
        end)
    else
        local v = root:FindFirstChild("ThaiiFlyVelocity")
        local a = root:FindFirstChild("ThaiiFlyAttachment")
        if v then v:Destroy() end
        if a then a:Destroy() end
        humanoid.PlatformStand = false
    end
end)
local jumpButton
jumpButton = makeButton("Infinite Jump: OFF", 198, function()
    enabled.InfiniteJump = not enabled.InfiniteJump
    jumpButton.Text = "Infinite Jump: " ..
        (enabled.InfiniteJump and "ON" or "OFF")
end)
UserInputService.JumpRequest:Connect(function()
    if enabled.InfiniteJump then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
local afkButton
afkButton = makeButton("Anti-AFK: ON", 238, function()
    enabled.AntiAFK = not enabled.AntiAFK
    afkButton.Text = "Anti-AFK: " ..
        (enabled.AntiAFK and "ON" or "OFF")
end)
player.Idled:Connect(function()
    if enabled.AntiAFK then
        -- Add a permitted idle-handling implementation if needed.
    end
end)
local lagButton
lagButton = makeButton("Low Graphics: OFF", 278, function()
    enabled.AntiLag = not enabled.AntiLag
    lagButton.Text = "Low Graphics: " ..
        (enabled.AntiLag and "ON" or "OFF")
    if enabled.AntiLag then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end
end)
makeButton("Reset Character", 318, function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)
makeButton("Close GUI", 358, function()
    enabled.Fly = false
    if flyConnection then flyConnection:Disconnect() end
    gui:Destroy()
end)
player.CharacterAdded:Connect(function()
    task.wait(1)
    if enabled.Fly then
        enabled.Fly = false
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
    end
end)