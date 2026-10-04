-- ============================================
-- Eocqzin Xits - SCRIPT COMPLETO
-- PT1 (Interface) + PT2 (Funcoes) + CHAMS/HOLOGRAMA
-- ============================================
print("[Eocqzin] Iniciando script completo...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- ============================================
-- LIMPEZA INICIAL
-- ============================================
for _, gui in ipairs(PlayerGui:GetChildren()) do
    if gui.Name == "EocqzinXits" then gui:Destroy() end
end

if _G.EocqzinConnections then
    for _, conn in ipairs(_G.EocqzinConnections) do
        pcall(function() conn:Disconnect() end)
    end
end

if _G.EocqzinFOV then pcall(function() _G.EocqzinFOV:Remove() end) end
if _G.EocqzinCleanup then pcall(_G.EocqzinCleanup); _G.EocqzinCleanup = nil end

-- ============================================
-- 🖼️ LOGO
-- ============================================
local LOGO_ASSET_ID = "136199726831051"

-- ============================================
-- SETTINGS
-- ============================================
_G.EocqzinSettings = {
    Aimbot = false, ShowFOV = false, FOVRadius = 150, Target = "Head",
    ESPLine = false, ESPBox = false, ESPSkeleton = false,
    ESPName = false, ESPHealth = false, ESPDistance = false,
    TeamCheck = false, MaxDistance = 2000,
    
    -- CHAMS / HOLOGRAMA
    ESPChams = false,
    ChamsColor = Color3.fromRGB(0, 200, 255),
    ChamsTransparency = 0.35,
    ChamsOutline = true,
}

_G.EocqzinConnections = {}
_G.EocqzinDrawings = {}

local Settings = _G.EocqzinSettings

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Header = Color3.fromRGB(200, 15, 15),
    Tab = Color3.fromRGB(180, 10, 10),
    TabInactive = Color3.fromRGB(25, 25, 25),
    ButtonOn = Color3.fromRGB(200, 15, 15),
    ButtonOff = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(255, 30, 30)
}

-- ============================================
-- SCREEN GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EocqzinXits"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 560)
MainFrame.Position = UDim2.new(0, 50, 0, 60)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Header
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- DRAG
local function MakeDraggable(frame, dragTarget)
    dragTarget = dragTarget or frame
    local dragging = false
    local dragStart, startPos

    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
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

    dragTarget.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- HEADER
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Header.Parent = MainFrame

-- LOGO COM BRILHO
local LogoContainer = Instance.new("Frame")
LogoContainer.Name = "LogoContainer"
LogoContainer.Size = UDim2.new(0, 34, 0, 34)
LogoContainer.Position = UDim2.new(0, 2, 0.5, -17)
LogoContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoContainer.BackgroundTransparency = 0.85
LogoContainer.BorderSizePixel = 0
LogoContainer.Parent = Header

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoContainer

local LogoGlow = Instance.new("UIStroke")
LogoGlow.Color = Color3.fromRGB(255, 50, 50)
LogoGlow.Thickness = 2
LogoGlow.Transparency = 0.2
LogoGlow.Parent = LogoContainer

local LogoGlow2 = Instance.new("UIStroke")
LogoGlow2.Color = Color3.fromRGB(255, 150, 150)
LogoGlow2.Thickness = 1
LogoGlow2.Transparency = 0.6
LogoGlow2.Parent = LogoContainer

local LogoImage = Instance.new("ImageLabel")
LogoImage.Name = "Logo"
LogoImage.Size = UDim2.new(1, -4, 1, -4)
LogoImage.Position = UDim2.new(0, 2, 0, 2)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://" .. LOGO_ASSET_ID
LogoImage.ScaleType = Enum.ScaleType.Fit
LogoImage.Parent = LogoContainer

task.spawn(function()
    local t = 0
    while LogoContainer.Parent do
        t = t + 0.05
        local pulse = (math.sin(t * 3) + 1) / 2
        LogoGlow.Transparency = 0.4 - (pulse * 0.3)
        LogoGlow.Thickness = 1.5 + (pulse * 1.5)
        task.wait(0.05)
    end
end)

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -140, 1, 0)
HeaderTitle.Position = UDim2.new(0, 42, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "@EocqzinXits.1.108.X"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -30, 0, 4)
CloseButton.BackgroundColor3 = Theme.Header
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Header

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -60, 0, 4)
MinimizeButton.BackgroundColor3 = Theme.Header
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = Header

MakeDraggable(MainFrame, Header)

-- TABS
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 26)
TabBar.Position = UDim2.new(0, 0, 0, 36)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -62)
ContentFrame.Position = UDim2.new(0, 0, 0, 62)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local currentTab = "Aimbot"
local tabContents = {}
local tabButtons = {}

local tabs = {
    {name = "Aimbot", order = 1},
    {name = "ESP", order = 2},
    {name = "Chams", order = 3},
    {name = "Info", order = 4}
}

for _, tabData in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 80, 1, 0)
    tabBtn.Position = UDim2.new(0, (tabData.order - 1) * 82 + 2, 0, 0)
    tabBtn.BackgroundColor3 = tabData.name == currentTab and Theme.Tab or Theme.TabInactive
    tabBtn.Text = tabData.name
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = TabBar
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Theme.Accent
    content.ScrollBarImageTransparency = 0.3
    content.Visible = tabData.name == currentTab
    content.CanvasSize = UDim2.new(0, 0, 0, 500)
    content.Parent = ContentFrame
    tabContents[tabData.name] = content
    tabButtons[tabData.name] = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Theme.TabInactive
        end
        for _, cnt in pairs(tabContents) do
            cnt.Visible = false
        end
        tabBtn.BackgroundColor3 = Theme.Tab
        content.Visible = true
        currentTab = tabData.name
    end)
end

-- ============================================
-- COMPONENTES UI
-- ============================================
local function CreateToggle(parent, text, yPos, settingKey)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 26)
    container.Position = UDim2.new(0, 5, 0, yPos)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local check = Instance.new("TextButton")
    check.Size = UDim2.new(0, 20, 0, 20)
    check.Position = UDim2.new(0, 3, 0.5, -10)
    check.BackgroundColor3 = Settings[settingKey] and Theme.ButtonOn or Color3.fromRGB(50, 50, 50)
    check.Text = Settings[settingKey] and "X" or ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.TextSize = 14
    check.Font = Enum.Font.GothamBold
    check.BorderSizePixel = 0
    check.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 28, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.Parent = container
    
    clickArea.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        check.BackgroundColor3 = Settings[settingKey] and Theme.ButtonOn or Color3.fromRGB(50, 50, 50)
        check.Text = Settings[settingKey] and "X" or ""
        print("[Eocqzin] " .. text .. " = " .. tostring(Settings[settingKey]))
    end)
end

local function CreateSlider(parent, yPos, labelText, settingKey, minVal, maxVal, decimals)
    decimals = decimals or 0
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 55)
    container.Position = UDim2.new(0, 5, 0, yPos)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 24)
    header.BackgroundTransparency = 1
    header.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = header
    
    local valDisplay = Instance.new("TextLabel")
    valDisplay.Size = UDim2.new(0, 50, 1, 0)
    valDisplay.Position = UDim2.new(1, -55, 0, 0)
    valDisplay.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    valDisplay.Text = tostring(Settings[settingKey])
    valDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    valDisplay.TextSize = 11
    valDisplay.Font = Enum.Font.GothamBold
    valDisplay.BorderSizePixel = 0
    valDisplay.Parent = header
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -12, 0, 8)
    sliderBg.Position = UDim2.new(0, 6, 0, 36)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    local initialRatio = (Settings[settingKey] - minVal) / (maxVal - minVal)
    initialRatio = math.clamp(initialRatio, 0, 1)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(initialRatio, 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 16, 0, 16)
    sliderBtn.Position = UDim2.new(initialRatio, -8, 0.5, -8)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBg
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = sliderBtn
    
    local dragging = false
    
    local function updateSlider(input)
        local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = minVal + (maxVal - minVal) * relX
        if decimals > 0 then
            local mult = 10 ^ decimals
            value = math.floor(value * mult) / mult
        else
            value = math.floor(value)
        end
        sliderFill.Size = UDim2.new(relX, 0, 1, 0)
        sliderBtn.Position = UDim2.new(relX, -8, 0.5, -8)
        valDisplay.Text = tostring(value)
        Settings[settingKey] = value
    end
    
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- PALETA DE CORES
local CHAMS_PRESETS = {
    {name = "Ciano",     color = Color3.fromRGB(0, 200, 255)},
    {name = "Verde",     color = Color3.fromRGB(0, 255, 100)},
    {name = "Rosa",      color = Color3.fromRGB(255, 0, 180)},
    {name = "Roxo",      color = Color3.fromRGB(180, 0, 255)},
    {name = "Vermelho",  color = Color3.fromRGB(255, 0, 0)},
    {name = "Laranja",   color = Color3.fromRGB(255, 120, 0)},
    {name = "Amarelo",   color = Color3.fromRGB(255, 220, 0)},
    {name = "Branco",    color = Color3.fromRGB(255, 255, 255)},
}

local function CreateColorPalette(parent, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 90)
    container.Position = UDim2.new(0, 5, 0, yPos)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 20)
    title.Position = UDim2.new(0, 5, 0, 2)
    title.BackgroundTransparency = 1
    title.Text = "Cor do Holograma"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 12
    title.Font = Enum.Font.GothamSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    local selectedIndicator = Instance.new("Frame")
    selectedIndicator.Size = UDim2.new(0, 20, 0, 20)
    selectedIndicator.Position = UDim2.new(1, -28, 0, 2)
    selectedIndicator.BackgroundColor3 = Settings.ChamsColor
    selectedIndicator.BorderSizePixel = 0
    selectedIndicator.Parent = container
    
    local siCorner = Instance.new("UICorner")
    siCorner.CornerRadius = UDim.new(1, 0)
    siCorner.Parent = selectedIndicator
    
    local siStroke = Instance.new("UIStroke")
    siStroke.Color = Color3.fromRGB(255, 255, 255)
    siStroke.Thickness = 1.5
    siStroke.Parent = selectedIndicator
    
    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, -10, 0, 60)
    grid.Position = UDim2.new(0, 5, 0, 25)
    grid.BackgroundTransparency = 1
    grid.Parent = container
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 32, 0, 32)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = grid
    
    for i, preset in ipairs(CHAMS_PRESETS) do
        local colorBtn = Instance.new("TextButton")
        colorBtn.BackgroundColor3 = preset.color
        colorBtn.Text = ""
        colorBtn.BorderSizePixel = 0
        colorBtn.LayoutOrder = i
        colorBtn.Parent = grid
        
        local cbCorner = Instance.new("UICorner")
        cbCorner.CornerRadius = UDim.new(1, 0)
        cbCorner.Parent = colorBtn
        
        local isSelected = (Settings.ChamsColor == preset.color)
        local cbStroke = Instance.new("UIStroke")
        cbStroke.Color = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
        cbStroke.Thickness = isSelected and 2 or 1
        cbStroke.Parent = colorBtn
        
        colorBtn.MouseButton1Click:Connect(function()
            Settings.ChamsColor = preset.color
            selectedIndicator.BackgroundColor3 = preset.color
            for _, child in ipairs(grid:GetChildren()) do
                if child:IsA("TextButton") then
                    local s = child:FindFirstChildOfClass("UIStroke")
                    if s then
                        if child.BackgroundColor3 == preset.color then
                            s.Color = Color3.fromRGB(255, 255, 255)
                            s.Thickness = 2
                        else
                            s.Color = Color3.fromRGB(60, 60, 60)
                            s.Thickness = 1
                        end
                    end
                end
            end
            print("[Eocqzin] Cor do Chams: " .. preset.name)
        end)
    end
end

-- ============================================
-- PREENCHER ABAS
-- ============================================
CreateToggle(tabContents["Aimbot"], "Ativar Aimbot", 5, "Aimbot")
CreateToggle(tabContents["Aimbot"], "Exibir Circulo do FOV", 35, "ShowFOV")
CreateSlider(tabContents["Aimbot"], 70, "FOV Size", "FOVRadius", 10, 1500, 0)

CreateToggle(tabContents["ESP"], "ESP Line (FF Style)", 5, "ESPLine")
CreateToggle(tabContents["ESP"], "ESP Box", 35, "ESPBox")
CreateToggle(tabContents["ESP"], "ESP Skeleton", 65, "ESPSkeleton")
CreateToggle(tabContents["ESP"], "ESP Name", 95, "ESPName")
CreateToggle(tabContents["ESP"], "ESP Health", 125, "ESPHealth")
CreateToggle(tabContents["ESP"], "ESP Distance", 155, "ESPDistance")
CreateToggle(tabContents["ESP"], "Team Check", 185, "TeamCheck")

CreateToggle(tabContents["Chams"], "Ativar Chams (Holograma)", 5, "ESPChams")
CreateToggle(tabContents["Chams"], "Contorno Preto (Outline)", 35, "ChamsOutline")
CreateSlider(tabContents["Chams"], 70, "Transparencia", "ChamsTransparency", 0, 0.95, 2)
CreateColorPalette(tabContents["Chams"], 130)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.ne
