-- [[ Ultimate Seed Hub with Auto-Save System ]] --
local HttpService = game:GetService("HttpService")
local FileName = "SeedHub_Settings.json"

-- 1. ระบบจัดการข้อมูล (Save/Load)
local settings = {
    WheatSeeds = false, CarrotSeeds = false, LettuceSeeds = false,
    CucumberSeeds = false, OnionSeeds = false, BeetrootSeeds = false,
    WatermelonSeeds = false, PumpkinSeeds = false, EggplantSeeds = false,
    KabochaSeeds = false, BellPepperSeeds = false, ChiliPepperSeeds = false,
    AntiAFK = true
}

local function SaveData()
    if writefile then
        writefile(FileName, HttpService:JSONEncode(settings))
    end
end

local function LoadData()
    if isfile and isfile(FileName) then
        local data = HttpService:JSONDecode(readfile(FileName))
        for k, v in pairs(data) do
            settings[k] = v
        end
    end
end

LoadData() -- โหลดค่าที่เคยบันทึกไว้ทันทีที่รัน

-- 2. สร้าง UI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ScrollFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "PersistentSeedHub"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Size = UDim2.new(1, -30, 0, 40)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "AUTO-BUY (SAVED)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 7)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

ScrollFrame.Parent = MainFrame
ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollFrame.Size = UDim2.new(1, -10, 1, -55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollFrame.ScrollBarThickness = 3

UIListLayout.Parent = ScrollFrame
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 3. ฟังก์ชันสร้างปุ่มที่จำค่าได้
local function createButton(displayName, internalID)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 38)
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = ScrollFrame

    -- อัปเดตสีตามค่าที่โหลดมา
    local function updateVisual()
        btn.Text = displayName .. ": " .. (settings[internalID] and "ON" or "OFF")
        btn.BackgroundColor3 = settings[internalID] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 60)
    end
    
    updateVisual()

    btn.MouseButton1Click:Connect(function()
        settings[internalID] = not settings[internalID]
        updateVisual()
        SaveData() -- บันทึกค่าลงไฟล์ทุกครั้งที่มีการเปลี่ยน
    end)
end

-- สร้างปุ่มตามลำดับภาพ
createButton("🛡️ Anti-AFK", "AntiAFK")
createButton("🌾 Wheat", "WheatSeeds")
createButton("🥕 Carrot", "CarrotSeeds")
createButton("🥬 Lettuce", "LettuceSeeds")
createButton("🥒 Cucumber", "CucumberSeeds")
createButton("🧅 Onion", "OnionSeeds")
createButton("🔴 Beetroot", "BeetrootSeeds")
createButton("🍉 Watermelon", "WatermelonSeeds")
createButton("🎃 Pumpkin", "PumpkinSeeds")
createButton("🍆 Eggplant", "EggplantSeeds")
createButton("🎃 Kabocha", "KabochaSeeds")
createButton("🫑 Bell Pepper", "BellPepperSeeds")
createButton("🌶️ Chili Pepper", "ChiliPepperSeeds")

-- 4. ระบบ Loop การซื้อ (Logic)
task.spawn(function()
    while task.wait(2) do
        if not ScreenGui.Parent then break end
        for itemID, isEnabled in pairs(settings) do
            if isEnabled and itemID ~= "AntiAFK" then
                -- ส่งคำสั่งซื้อไปยัง Server
                game:GetService("ReplicatedStorage").Events.ItemPurchase:FireServer(itemID)
            end
        end
    end
end)

-- 5. ระบบ Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if settings.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- ซ่อน UI ด้วย Right Control
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
