local plrs = game:GetService("Players")
local mkt = game:GetService("MarketplaceService")
local lp = plrs.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "s_" .. tostring(math.random(100000,999999))
gui.ResetOnSpawn = false
gui.Parent = gethui()

for _,v in pairs(gethui():GetChildren()) do
	if v ~= gui and v:IsA("ScreenGui") and v.Name:sub(1,2) == "s_" then v:Destroy() end
end

local main = Instance.new("Frame")
main.Size = UDim2.new(0,300,0,340)
main.Position = UDim2.new(0.5,-150,0.5,-170)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderColor3 = Color3.fromRGB(45,45,45)
main.BorderSizePixel = 1
main.Active = true
main.Draggable = true
main.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-24,0,24)
title.Position = UDim2.new(0,6,0,0)
title.BackgroundTransparency = 1
title.Text = "sounds"
title.TextColor3 = Color3.fromRGB(170,170,170)
title.TextSize = 12
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,24,0,24)
closeBtn.Position = UDim2.new(1,-24,0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "x"
closeBtn.TextColor3 = Color3.fromRGB(100,100,100)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.Code
closeBtn.Parent = main
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1,0,0,1)
sep.Position = UDim2.new(0,0,0,24)
sep.BackgroundColor3 = Color3.fromRGB(45,45,45)
sep.BorderSizePixel = 0
sep.Parent = main

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.5,-6,0,22)
scanBtn.Position = UDim2.new(0,4,0,29)
scanBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
scanBtn.BorderColor3 = Color3.fromRGB(50,50,50)
scanBtn.BorderSizePixel = 1
scanBtn.Text = "scan"
scanBtn.TextColor3 = Color3.fromRGB(150,150,150)
scanBtn.TextSize = 11
scanBtn.Font = Enum.Font.Code
scanBtn.Parent = main

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.5,-6,0,22)
saveBtn.Position = UDim2.new(0.5,2,0,29)
saveBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
saveBtn.BorderColor3 = Color3.fromRGB(50,50,50)
saveBtn.BorderSizePixel = 1
saveBtn.Text = "save"
saveBtn.TextColor3 = Color3.fromRGB(150,150,150)
saveBtn.TextSize = 11
saveBtn.Font = Enum.Font.Code
saveBtn.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-8,1,-58)
scroll.Position = UDim2.new(0,4,0,55)
scroll.BackgroundColor3 = Color3.fromRGB(15,15,15)
scroll.BorderColor3 = Color3.fromRGB(40,40,40)
scroll.BorderSizePixel = 1
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(60,60,60)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

Instance.new("UIListLayout", scroll).Padding = UDim.new(0,1)

local scanning = false
local found = {}
local rows = {}

local function makeRow(id, name)
	local url = "https://create.roblox.com/store/asset/" .. id
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1,0,0,28)
	row.BackgroundColor3 = Color3.fromRGB(20,20,20)
	row.BorderSizePixel = 0
	row.Parent = scroll

	local dot = Instance.new("TextLabel")
	dot.Name = "status"
	dot.Size = UDim2.new(0,10,1,0)
	dot.Position = UDim2.new(0,2,0,0)
	dot.BackgroundTransparency = 1
	dot.Text = ">"
	dot.TextColor3 = Color3.fromRGB(80,180,80)
	dot.TextSize = 10
	dot.Font = Enum.Font.Code
	dot.Parent = row

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,-52,1,0)
	lbl.Position = UDim2.new(0,14,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text = name .. " " .. id
	lbl.TextColor3 = Color3.fromRGB(140,140,140)
	lbl.TextSize = 10
	lbl.Font = Enum.Font.Code
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.Parent = row

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,38,0,18)
	btn.Position = UDim2.new(1,-42,0.5,-9)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.BorderColor3 = Color3.fromRGB(50,50,50)
	btn.BorderSizePixel = 1
	btn.Text = "copy"
	btn.TextColor3 = Color3.fromRGB(120,120,120)
	btn.TextSize = 10
	btn.Font = Enum.Font.Code
	btn.Parent = row

	btn.MouseButton1Click:Connect(function()
		setclipboard(url)
		btn.Text = "ok"
		task.delay(0.8, function()
			if btn.Parent then btn.Text = "copy" end
		end)
	end)
	return row
end

local function tryAdd(obj)
	if not (typeof(obj) == "Instance" and obj:IsA("Sound")) then return end
	local sid = obj.SoundId
	if sid == "" or not string.find(sid, "rbxassetid") then return end
	local num = sid:match("(%d+)")
	if not num then return end

	if found[num] then
		found[num].obj = obj
		found[num].playing = obj.IsPlaying
		return
	end

	found[num] = { name = obj.Name, playing = obj.IsPlaying, obj = obj }
	rows[num] = makeRow(num, obj.Name)
end

local function collect()
	for _, obj in next, game:GetDescendants() do
		tryAdd(obj)
	end

	pcall(function()
		for _, obj in next, getnilinstances() do
			tryAdd(obj)
		end
	end)

	pcall(function()
		for _, mod in next, getloadedmodules() do
			if mod:IsA("ModuleScript") then
				for _, child in next, mod:GetDescendants() do
					tryAdd(child)
				end
			end
		end
	end)

	pcall(function()
		for _, obj in next, getinstances() do
			tryAdd(obj)
		end
	end)

	pcall(function()
		local gc = getgc(true)
		for i = 1, #gc do
			if typeof(gc[i]) == "Instance" and gc[i]:IsA("Sound") then
				tryAdd(gc[i])
			end
		end
	end)

	for num, row in next, rows do
		local data = found[num]
		local dot = row:FindFirstChild("status")
		if not dot then continue end
		local ok, playing = pcall(function() return data.obj and data.obj.IsPlaying end)
		dot.Text = (ok and playing) and ">" or ""
	end

	local c = 0
	for _ in next, found do c += 1 end
	title.Text = "sounds (" .. c .. ")"
end

saveBtn.MouseButton1Click:Connect(function()
	local lines = {}
	for num, data in next, found do
		lines[#lines+1] = data.name .. " | https://create.roblox.com/store/asset/" .. num
	end
	if #lines == 0 then
		saveBtn.Text = "empty"
		task.delay(0.8, function() if saveBtn.Parent then saveBtn.Text = "save" end end)
		return
	end
	local ok = pcall(function()
		local gn = mkt:GetProductInfo(game.PlaceId).Name
		gn = gn:gsub("[^%w%s%-_]",""):gsub("%s+","_")
		makefolder("SoundScanner")
		writefile("SoundScanner/" .. gn .. ".txt", table.concat(lines, "\n"))
	end)
	saveBtn.Text = ok and "saved" or "error"
	task.delay(1, function() if saveBtn.Parent then saveBtn.Text = "save" end end)
end)

scanBtn.MouseButton1Click:Connect(function()
	scanning = not scanning
	if scanning then
		scanBtn.Text = "stop"
		scanBtn.BackgroundColor3 = Color3.fromRGB(40,25,25)
		scanBtn.BorderColor3 = Color3.fromRGB(70,40,40)
	else
		scanBtn.Text = "scan"
		scanBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
		scanBtn.BorderColor3 = Color3.fromRGB(50,50,50)
	end
end)

task.spawn(function()
	while gui.Parent do
		if scanning then collect() end
		task.wait(0.5)
	end
end)
