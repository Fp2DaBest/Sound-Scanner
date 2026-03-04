local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "s_" .. tostring(math.random(100000, 999999))
gui.ResetOnSpawn = false
gui.Parent = gethui()

for _, v in pairs(gethui():GetChildren()) do
    if v ~= gui and v:IsA("ScreenGui") and v.Name:sub(1,2) == "s_" then
        v:Destroy()
    end
end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 240, 0, 260)
main.Position = UDim2.new(0.5, -120, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderColor3 = Color3.fromRGB(45, 45, 45)
main.BorderSizePixel = 1
main.Active = true
main.Draggable = true
main.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 24)
title.BackgroundTransparency = 1
title.Text = "sounds"
title.TextColor3 = Color3.fromRGB(170, 170, 170)
title.TextSize = 12
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 6, 0, 0)
title.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -24, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "x"
closeBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.Code
closeBtn.Parent = main
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, 0, 0, 1)
sep.Position = UDim2.new(0, 0, 0, 24)
sep.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sep.BorderSizePixel = 0
sep.Parent = main

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -8, 0, 22)
scanBtn.Position = UDim2.new(0, 4, 0, 29)
scanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scanBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
scanBtn.BorderSizePixel = 1
scanBtn.Text = "scan"
scanBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
scanBtn.TextSize = 11
scanBtn.Font = Enum.Font.Code
scanBtn.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -8, 1, -58)
scroll.Position = UDim2.new(0, 4, 0, 55)
scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
scroll.BorderColor3 = Color3.fromRGB(40, 40, 40)
scroll.BorderSizePixel = 1
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 1)
layout.Parent = scroll

local scanning = false
local found = {}
local rows = {}

local function makeRow(numId, name)
    local url = "https://www.roblox.com/library/" .. numId

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    row.BorderSizePixel = 0
    row.Parent = scroll

    local dot = Instance.new("TextLabel")
    dot.Name = "status"
    dot.Size = UDim2.new(0, 10, 1, 0)
    dot.Position = UDim2.new(0, 2, 0, 0)
    dot.BackgroundTransparency = 1
    dot.Text = ">"
    dot.TextColor3 = Color3.fromRGB(80, 180, 80)
    dot.TextSize = 10
    dot.Font = Enum.Font.Code
    dot.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -52, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. " " .. numId
    label.TextColor3 = Color3.fromRGB(140, 140, 140)
    label.TextSize = 10
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = row

    local cpBtn = Instance.new("TextButton")
    cpBtn.Size = UDim2.new(0, 38, 0, 18)
    cpBtn.Position = UDim2.new(1, -42, 0.5, -9)
    cpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    cpBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
    cpBtn.BorderSizePixel = 1
    cpBtn.Text = "copy"
    cpBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    cpBtn.TextSize = 10
    cpBtn.Font = Enum.Font.Code
    cpBtn.Parent = row

    cpBtn.MouseButton1Click:Connect(function()
        setclipboard(url)
        cpBtn.Text = "ok"
        task.delay(0.8, function()
            if cpBtn.Parent then cpBtn.Text = "copy" end
        end)
    end)

    return row
end

local function collect()
    local batch = {}

    for _, obj in next, game:GetDescendants() do
        if typeof(obj) == "Instance" and obj:IsA("Sound") and obj.SoundId ~= "" then
            local sid = obj.SoundId
            if string.find(sid, "rbxassetid") then
                local num = sid:match("(%d+)")
                if num and not found[num] then
                    found[num] = {name = obj.Name, playing = obj.IsPlaying, obj = obj}
                    batch[#batch + 1] = num
                else if num and found[num] then
                    found[num].playing = obj.IsPlaying
                    found[num].obj = obj
                end end
            end
        end
    end

    pcall(function()
        for _, obj in next, getnilinstances() do
            if obj:IsA("Sound") and obj.SoundId ~= "" then
                local sid = obj.SoundId
                if string.find(sid, "rbxassetid") then
                    local num = sid:match("(%d+)")
                    if num and not found[num] then
                        found[num] = {name = obj.Name, playing = obj.IsPlaying, obj = obj}
                        batch[#batch + 1] = num
                    else if num and found[num] then
                        found[num].playing = obj.IsPlaying
                        found[num].obj = obj
                    end end
                end
            end
        end
    end)

    for _, num in next, batch do
        local data = found[num]
        rows[num] = makeRow(num, data.name)
    end

    for num, row in next, rows do
        local data = found[num]
        local dot = row:FindFirstChild("status")
        if dot then
            local isPlaying = false
            pcall(function()
                isPlaying = data.obj and data.obj.IsPlaying
            end)
            dot.Text = isPlaying and ">" or ""
        end
    end

    local count = 0
    for _ in next, found do count = count + 1 end
    title.Text = "sounds (" .. count .. ")"
end

scanBtn.MouseButton1Click:Connect(function()
    scanning = not scanning
    if scanning then
        scanBtn.Text = "stop"
        scanBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 25)
        scanBtn.BorderColor3 = Color3.fromRGB(70, 40, 40)
    else
        scanBtn.Text = "scan"
        scanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        scanBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

task.spawn(function()
    while gui.Parent do
        if scanning then
            collect()
        end
        task.wait(0.5)
    end
end)
