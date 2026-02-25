-- [[ Ultimate Auto-Buy Seeds Hub ]] --
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ScrollFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- ตารางเก็บสถานะการเปิด/ปิด (Memory)
local settings = {
    ["WheatSeeds"] = false, ["CarrotSeeds"] = false, ["LettuceSeeds"] = false,
    ["CucumberSeeds"] = false, ["OnionSeeds"] = false, ["BeetrootSeeds"] = false,
    ["WatermelonSeeds"] = false, ["PumpkinSeeds"] = false, ["EggplantSeeds"] = false,
    ["KabochaSeeds"] = false, ["BellPepperSeeds"] = false, ["ChiliPepperSeeds"] = false,
    ["AntiAFK"] = true
}

-- ตั้งค่า UI หลัก
ScreenGui.Name = "UltimateSeedHub"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Size = UDim2.new(1, -30, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "SEED AUTO-BUY"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -28, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ส่วนของรายการปุ่ม (Scrolling)
ScrollFrame.Parent = MainFrame
ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 550) -- ปรับขนาดตามจำนวนปุ่ม
ScrollFrame.ScrollBarThickness = 4

UIListLayout.Parent = ScrollFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)

-- ฟังก์ชันสร้างปุ่มควบคุม
local function createButton(displayName, internalID)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = displayName .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = ScrollFrame

    btn.MouseButton1Click:Connect(function()
        settings[internalID] = not settings[internalID]
        btn.Text = displayName .. ": " .. (settings[internalID] and "ON" or "OFF")
        btn.BackgroundColor3 = settings[internalID] and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(50, 50, 50)
    end)
end

-- สร้างปุ่มตามรายการในรูปภาพ
createButton("Anti-AFK", "AntiAFK")
createButton("Wheat", "WheatSeeds")
createButton("Carrot", "CarrotSeeds")
createButton("Lettuce", "LettuceSeeds")
createButton("Cucumber", "CucumberSeeds")
createButton("Onion", "OnionSeeds")
createButton("Beetroot", "BeetrootSeeds")
createButton("Watermelon", "WatermelonSeeds")
createButton("Pumpkin", "PumpkinSeeds")
createButton("Eggplant", "EggplantSeeds")
createButton("Kabocha", "KabochaSeeds")
createButton("Bell Pepper", "BellPepperSeeds")
createButton("Chili Pepper", "ChiliPepperSeeds")

-- ระบบ Loop การซื้อ (ทำงานทุก 2 วินาที)
task.spawn(function()
    while task.wait(2) do
        if not ScreenGui.Parent then break end
        for itemID, isEnabled in pairs(settings) do
            if isEnabled and itemID ~= "AntiAFK" then
                game:GetService("ReplicatedStorage").Events.ItemPurchase:FireServer(itemID)
            end
        end
    end
end)

-- ระบบ Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if settings.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- ปุ่มลัดซ่อน UI (Right Control)
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
