local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local BellBtn = Instance.new("TextButton")
local ChiliBtn = Instance.new("TextButton")
local UIListLayout = Instance.new("UIListLayout")

-- ตัวแปรสถานะ
local buyBell = false
local buyChili = false

-- ตั้งค่าหน้าจอหลัก
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "AutoBuySystem"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -80)
MainFrame.Size = UDim2.new(0, 160, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- ลากได้

-- หัวข้อ (Title)
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Seed Auto-Buy"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มกากบาท (Close/Destroy)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

-- จัดปุ่มกด (Layout)
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Parent = MainFrame
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(0, 0, 0, 40)
ButtonContainer.Size = UDim2.new(1, 0, 1, -40)

UIListLayout.Parent = ButtonContainer
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)

-- ฟังก์ชันสร้างปุ่ม Toggle
local function createBtn(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Parent = ButtonContainer
    return btn
end

BellBtn = createBtn("Bell Pepper")
ChiliBtn = createBtn("Chili Pepper")

-- ลอจิกการซื้อ (Loops)
task.spawn(function()
    while true do
        if not ScreenGui.Parent then break end -- หยุดลูปถ้า UI โดนลบ
        if buyBell then
            game:GetService("ReplicatedStorage").Events.ItemPurchase:FireServer("BellPepperSeeds")
        end
        task.wait(2)
    end
end)

task.spawn(function()
    while true do
        if not ScreenGui.Parent then break end
        if buyChili then
            game:GetService("ReplicatedStorage").Events.ItemPurchase:FireServer("ChiliPepperSeeds")
        end
        task.wait(2)
    end
end)

-- ปุ่มคลิกเหตุการณ์
BellBtn.MouseButton1Click:Connect(function()
    buyBell = not buyBell
    BellBtn.Text = "Bell: " .. (buyBell and "ON" or "OFF")
    BellBtn.BackgroundColor3 = buyBell and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 60)
end)

ChiliBtn.MouseButton1Click:Connect(function()
    buyChili = not buyChili
    ChiliBtn.Text = "Chili: " .. (buyChili and "ON" or "OFF")
    ChiliBtn.BackgroundColor3 = buyChili and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 60)
end)

-- ปุ่มปิดลบทิ้งถาวร
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ปุ่มลัดซ่อน/แสดง (RightControl)
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
