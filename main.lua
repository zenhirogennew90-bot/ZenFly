-- ===================================================================
-- ZENITH STANDALONE FLY PANEL - SIDE SENSI CONTROLS EDITION
-- ===================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- -------------------------------------------------------------------
-- AUDIO SYSTEM (Satisfying Soft Click Sound)
-- -------------------------------------------------------------------
local function PlaySoftSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6895079853"
    sound.Volume = 0.35
    sound.Pitch = 1.25
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- -------------------------------------------------------------------
-- GUI CONTAINER SETUP
-- -------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ZenFlyStandalone"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local targetParent
local success = pcall(function()
    targetParent = (gethui and gethui()) or CoreGui
    local _ = targetParent.Name
end)
if not success or not targetParent then
    targetParent = player:WaitForChild("PlayerGui")
end

for _, v in ipairs(targetParent:GetChildren()) do
    if v.Name == "ZenFlyStandalone" then v:Destroy() end
end
gui.Parent = targetParent

-- -------------------------------------------------------------------
-- MAIN PANEL SETUP
-- -------------------------------------------------------------------
local allBtns = {}
local flyPanel = Instance.new("Frame", gui)
flyPanel.Size = UDim2.new(0, 240, 0, 240)
flyPanel.Position = UDim2.new(1, -260, 0.15, 0)
flyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
flyPanel.BorderSizePixel = 2
flyPanel.Active = true
flyPanel.Draggable = true
flyPanel.ClipsDescendants = true

local flyPanelCorner = Instance.new("UICorner", flyPanel)
flyPanelCorner.CornerRadius = UDim.new(0, 8)

local flyTitle = Instance.new("TextLabel", flyPanel)
flyTitle.Size = UDim2.new(1, 0, 0, 34)
flyTitle.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
flyTitle.Text = "✈️ Zen Fly Panel"
flyTitle.Font = Enum.Font.SourceSansBold
flyTitle.TextSize = 15
flyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local flyTitleCorner = Instance.new("UICorner", flyTitle)
flyTitleCorner.CornerRadius = UDim.new(0, 8)

local btnFlyMin = Instance.new("TextButton", flyTitle)
btnFlyMin.Size = UDim2.new(0, 34, 0, 34)
btnFlyMin.Position = UDim2.new(1, -34, 0, 0)
btnFlyMin.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
btnFlyMin.TextColor3 = Color3.fromRGB(255, 255, 255)
btnFlyMin.Text = "-"
btnFlyMin.Font = Enum.Font.SourceSansBold
btnFlyMin.TextSize = 16
btnFlyMin.BorderSizePixel = 0

local btnMinCorner = Instance.new("UICorner", btnFlyMin)
btnMinCorner.CornerRadius = UDim.new(0, 8)

local isFlyMin = false
btnFlyMin.MouseButton1Click:Connect(function()
    PlaySoftSound()
    isFlyMin = not isFlyMin
    btnFlyMin.Text = isFlyMin and "+" or "-"
    
    flyPanel.Size = isFlyMin and UDim2.new(0, 240, 0, 34) or UDim2.new(0, 240, 0, 240)
    
    for _, c in ipairs(flyPanel:GetChildren()) do
        if c ~= flyTitle then
            c.Visible = not isFlyMin
        end
    end
end)

local function mkFlyBtn(text, pos, size)
    local b = Instance.new("TextButton", flyPanel)
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.AutoButtonColor = true
    
    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0, 6)
    
    table.insert(allBtns, b)
    return b
end

-- -------------------------------------------------------------------
-- BUTTONS LAYOUT DI DALAM PANEL UTAMA
-- -------------------------------------------------------------------
-- Speed Control Bar
local btnFlyM = mkFlyBtn("-", UDim2.new(0, 10, 0, 44), UDim2.new(0, 36, 0, 32))
local lblFlySpd = Instance.new("TextLabel", flyPanel)
lblFlySpd.Size = UDim2.new(0, 138, 0, 32)
lblFlySpd.Position = UDim2.new(0, 51, 0, 44)
lblFlySpd.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
lblFlySpd.TextColor3 = Color3.fromRGB(255, 255, 255)
lblFlySpd.Text = "Spd: 50 [Normal]"
lblFlySpd.Font = Enum.Font.SourceSansBold
lblFlySpd.TextSize = 12

local lblCorner = Instance.new("UICorner", lblFlySpd)
lblCorner.CornerRadius = UDim.new(0, 6)

local btnFlyP = mkFlyBtn("+", UDim2.new(0, 194, 0, 44), UDim2.new(0, 36, 0, 32))

-- Row 1: Maju, Naik, Turun
local btnFwd  = mkFlyBtn("⏫ Maju", UDim2.new(0, 10, 0, 82), UDim2.new(0, 68, 0, 38))
local btnUp   = mkFlyBtn("⬆️ Naik", UDim2.new(0, 86, 0, 82), UDim2.new(0, 68, 0, 38))
local btnDown = mkFlyBtn("⬇️ Turun", UDim2.new(0, 162, 0, 82), UDim2.new(0, 68, 0, 38))

-- Row 2: Tombol Kiri, Sensi, dan Kanan Sejajar
local btnLeftIn  = mkFlyBtn("⬅️ Kiri", UDim2.new(0, 10, 0, 126), UDim2.new(0, 52, 0, 38))
local btnFlySens = mkFlyBtn("⚙️ Sens: Normal", UDim2.new(0, 66, 0, 126), UDim2.new(0, 108, 0, 38))
local btnRightIn = mkFlyBtn("➡️ Kanan", UDim2.new(0, 178, 0, 126), UDim2.new(0, 52, 0, 38))

-- Bottom Control Button: Matikan Fly
local btnFlyOff  = mkFlyBtn("❌ Matikan Fly", UDim2.new(0, 10, 0, 170), UDim2.new(0, 220, 0, 38))

-- RGB Color Loop Accent
local p1 = {Color3.fromRGB(0,150,255), Color3.fromRGB(255,50,50), Color3.fromRGB(180,0,255), Color3.fromRGB(0,230,100), Color3.fromRGB(255,220,0)}
local p2 = {Color3.fromRGB(255,220,0), Color3.fromRGB(0,230,100)}
task.spawn(function()
    while gui and gui.Parent do
        local t = tick() * 0.4
        local c1 = p1[math.floor((t % 1) * 5) + 1]
        local c2 = p2[math.floor(((t + 0.5) % 1) * 2) + 1]
        flyTitle.TextColor3 = c1
        flyPanel.BorderColor3 = c2
        for i = 1, #allBtns do
            if allBtns[i] ~= btnFlyOff then
                allBtns[i].TextColor3 = c2
            end
        end
        task.wait(0.05)
    end
end)

-- -------------------------------------------------------------------
-- FLY LOGIC & TOUCH BINDING
-- -------------------------------------------------------------------
local isFly = true
local flySpd = 50
local flyConn = nil

-- Modul Level Sensi & Kecepatan Berpasangan
local sensModes = {
    {name = "Super Slow", speed = 10, color = Color3.fromRGB(150, 200, 255)},
    {name = "Slow", speed = 25, color = Color3.fromRGB(180, 255, 180)},
    {name = "Normal", speed = 50, color = Color3.fromRGB(255, 255, 255)},
    {name = "High Speed", speed = 150, color = Color3.fromRGB(255, 220, 0)},
    {name = "Super Speed", speed = 500, color = Color3.fromRGB(255, 120, 50)},
    {name = "Max Speed", speed = 1000, color = Color3.fromRGB(255, 50, 50)}
}
local currentSensIndex = 3

local successControls, playerModule = false, nil
task.spawn(function()
    while not player:FindFirstChild("PlayerScripts") do task.wait(0.5) end
    local pScripts = player.PlayerScripts
    while not pScripts:FindFirstChild("PlayerModule") do task.wait(0.5) end
    successControls, playerModule = pcall(function() return require(pScripts.PlayerModule):GetControls() end)
end)

-- Multi-Touch Handler
local mUp, mDown, mLeft, mRight, mFwd = false, false, false, false, false
local function bindH(b, setVar)
    local activeTouches = {} 
    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            PlaySoftSound()
            activeTouches[i] = true
            setVar(true)
        end
    end)
    b.InputEnded:Connect(function(i)
        if activeTouches[i] then
            activeTouches[i] = nil
            if next(activeTouches) == nil then setVar(false) end
        end
    end)
end

bindH(btnUp, function(v) mUp = v end)
bindH(btnDown, function(v) mDown = v end)
bindH(btnFwd, function(v) mFwd = v end)
bindH(btnLeftIn, function(v) mLeft = v end)
bindH(btnRightIn, function(v) mRight = v end)

local function startFlyLogic(char)
    if flyConn then flyConn:Disconnect() flyConn = nil end
    local hrp = char:WaitForChild("HumanoidRootPart", 3)
    local hum = char:WaitForChild("Humanoid", 3)
    if not hrp or not hum then return end
    
    hum.PlatformStand = true
    local anchored = false
    flyConn = RunService.RenderStepped:Connect(function()
        if not hrp or not hrp.Parent then return end
        local dir = Vector3.zero
        local camCF = camera.CFrame
        
        if successControls and playerModule then
            local mv = playerModule:GetMoveVector()
            if mv.Magnitude > 0.15 then dir = dir + (camCF.RightVector * mv.X) + (camCF.LookVector * -mv.Z) end
        end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) or mFwd then dir = dir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or mLeft then dir = dir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) or mRight then dir = dir + camCF.RightVector end
        if mUp or UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if mDown or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir + Vector3.new(0, -1, 0) end

        if dir.Magnitude > 0 then
            if anchored then hrp.Anchored = false anchored = false end
            hrp.AssemblyLinearVelocity = dir.Unit * flySpd
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)
        else
            if not anchored then
                hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
                hrp.Anchored, anchored = true, true
            end
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)
        end
    end)
end

local function toggleFly(state)
    isFly = state
    if isFly then
        btnFlyOff.Text = "❌ Matikan Fly"
        btnFlyOff.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
        flyPanel.Visible = true
        if player.Character then startFlyLogic(player.Character) end
    else
        btnFlyOff.Text = "✅ Hidupkan Fly"
        btnFlyOff.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Anchored = false end
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

btnFlyOff.MouseButton1Click:Connect(function()
    PlaySoftSound()
    toggleFly(not isFly)
end)

-- Update Tampilan UI Kecepatan & Sensi
local function updateSpeedUI()
    lblFlySpd.Text = "Spd: " .. flySpd
    local matchedMode = false
    
    for i, mode in ipairs(sensModes) do
        if flySpd == mode.speed then
            lblFlySpd.Text = "Spd: " .. flySpd .. " [" .. mode.name .. "]"
            lblFlySpd.TextColor3 = mode.color
            btnFlySens.Text = "⚙️ " .. mode.name
            currentSensIndex = i
            matchedMode = true
            break
        end
    end
    
    if not matchedMode then
        lblFlySpd.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnFlySens.Text = "⚙️ Custom (" .. flySpd .. ")"
    end
end

-- Klik Tombol Sensi untuk Berganti Mode Kecepatan
btnFlySens.MouseButton1Click:Connect(function()
    PlaySoftSound()
    currentSensIndex = (currentSensIndex % #sensModes) + 1
    local mode = sensModes[currentSensIndex]
    flySpd = mode.speed
    updateSpeedUI()
end)

-- Tombol Tambah/Kurang Kecepatan Manual
btnFlyM.MouseButton1Click:Connect(function()
    PlaySoftSound()
    flySpd = math.clamp(flySpd - 10, 10, 1000)
    updateSpeedUI()
end)

btnFlyP.MouseButton1Click:Connect(function()
    PlaySoftSound()
    flySpd = math.clamp(flySpd + 10, 10, 1000)
    updateSpeedUI()
end)

-- Respawn Handler
player.CharacterAdded:Connect(function(newC)
    task.spawn(function()
        task.wait(1)
        if isFly then startFlyLogic(newC) end
    end)
end)

-- Inisialisasi awal
if player.Character then
    startFlyLogic(player.Character)
end

print("Zenith Standalone Fly Panel (Side Sensi Controls) Loaded Successfully!")
