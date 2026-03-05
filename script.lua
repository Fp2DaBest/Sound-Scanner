local ps = cloneref(game:GetService("Players"))
local ms = cloneref(game:GetService("MarketplaceService"))

local on = true
local sc = false
local swept = false
local cnt = 0
local f = {}
local r = {}
local cn = {}

local opt = {
	{k="g", t="game tree", v=true},
	{k="n", t="nil instances", v=true},
	{k="m", t="modules", v=true},
	{k="c", t="garbage collector", v=false},
	{k="a", t="all instances", v=false},
}

local g = Instance.new("ScreenGui")
g.Name = string.char(math.random(97,122)) .. math.random(10000,99999)
g.ResetOnSpawn = false
g.Parent = gethui()

for _,x in pairs(gethui():GetChildren()) do
	if x ~= g and x:IsA("ScreenGui") and #x.Name > 4 and x.Name:sub(1,1):match("%l") then
		pcall(function() x:Destroy() end)
	end
end

local w = Instance.new("Frame")
w.Size = UDim2.new(0,300,0,420)
w.Position = UDim2.new(0.5,-150,0.5,-210)
w.BackgroundColor3 = Color3.fromRGB(20,20,20)
w.BorderColor3 = Color3.fromRGB(45,45,45)
w.BorderSizePixel = 1
w.Active = true
w.Draggable = true
w.Parent = g

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1,-24,0,24)
tl.Position = UDim2.new(0,6,0,0)
tl.BackgroundTransparency = 1
tl.Text = "sounds (0)"
tl.TextColor3 = Color3.fromRGB(170,170,170)
tl.TextSize = 12
tl.Font = Enum.Font.Code
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.Parent = w

local cb = Instance.new("TextButton")
cb.Size = UDim2.new(0,24,0,24)
cb.Position = UDim2.new(1,-24,0,0)
cb.BackgroundTransparency = 1
cb.Text = "x"
cb.TextColor3 = Color3.fromRGB(100,100,100)
cb.TextSize = 12
cb.Font = Enum.Font.Code
cb.Parent = w

local sp = Instance.new("Frame")
sp.Size = UDim2.new(1,0,0,1)
sp.Position = UDim2.new(0,0,0,24)
sp.BackgroundColor3 = Color3.fromRGB(45,45,45)
sp.BorderSizePixel = 0
sp.Parent = w

local sl = Instance.new("TextLabel")
sl.Size = UDim2.new(1,-8,0,14)
sl.Position = UDim2.new(0,6,0,28)
sl.BackgroundTransparency = 1
sl.Text = "sources"
sl.TextColor3 = Color3.fromRGB(90,90,90)
sl.TextSize = 9
sl.Font = Enum.Font.Code
sl.TextXAlignment = Enum.TextXAlignment.Left
sl.Parent = w

local yo = 43
for _, s in next, opt do
	local rf = Instance.new("Frame")
	rf.Size = UDim2.new(1,-8,0,16)
	rf.Position = UDim2.new(0,4,0,yo)
	rf.BackgroundTransparency = 1
	rf.Parent = w

	local tb = Instance.new("TextButton")
	tb.Size = UDim2.new(0,14,0,14)
	tb.Position = UDim2.new(0,2,0,1)
	tb.BackgroundColor3 = s.v and Color3.fromRGB(50,70,50) or Color3.fromRGB(30,30,30)
	tb.BorderColor3 = Color3.fromRGB(55,55,55)
	tb.BorderSizePixel = 1
	tb.Text = s.v and "x" or ""
	tb.TextColor3 = Color3.fromRGB(120,180,120)
	tb.TextSize = 10
	tb.Font = Enum.Font.Code
	tb.Parent = rf

	local lb = Instance.new("TextLabel")
	lb.Size = UDim2.new(1,-22,1,0)
	lb.Position = UDim2.new(0,20,0,0)
	lb.BackgroundTransparency = 1
	lb.Text = s.t
	lb.TextColor3 = Color3.fromRGB(130,130,130)
	lb.TextSize = 10
	lb.Font = Enum.Font.Code
	lb.TextXAlignment = Enum.TextXAlignment.Left
	lb.Parent = rf

	tb.MouseButton1Click:Connect(function()
		s.v = not s.v
		tb.Text = s.v and "x" or ""
		tb.BackgroundColor3 = s.v and Color3.fromRGB(50,70,50) or Color3.fromRGB(30,30,30)
		if s.v then swept = false end
	end)

	yo = yo + 18
end

local sp2 = Instance.new("Frame")
sp2.Size = UDim2.new(1,-8,0,1)
sp2.Position = UDim2.new(0,4,0,yo+2)
sp2.BackgroundColor3 = Color3.fromRGB(35,35,35)
sp2.BorderSizePixel = 0
sp2.Parent = w

local by = yo + 7
local bw = UDim2.new(1/3,-5,0,22)

local sb = Instance.new("TextButton")
sb.Size = bw
sb.Position = UDim2.new(0,4,0,by)
sb.BackgroundColor3 = Color3.fromRGB(30,30,30)
sb.BorderColor3 = Color3.fromRGB(50,50,50)
sb.BorderSizePixel = 1
sb.Text = "scan"
sb.TextColor3 = Color3.fromRGB(150,150,150)
sb.TextSize = 11
sb.Font = Enum.Font.Code
sb.Parent = w

local sv = Instance.new("TextButton")
sv.Size = bw
sv.Position = UDim2.new(1/3,2,0,by)
sv.BackgroundColor3 = Color3.fromRGB(30,30,30)
sv.BorderColor3 = Color3.fromRGB(50,50,50)
sv.BorderSizePixel = 1
sv.Text = "save"
sv.TextColor3 = Color3.fromRGB(150,150,150)
sv.TextSize = 11
sv.Font = Enum.Font.Code
sv.Parent = w

local cl = Instance.new("TextButton")
cl.Size = bw
cl.Position = UDim2.new(2/3,0,0,by)
cl.BackgroundColor3 = Color3.fromRGB(30,30,30)
cl.BorderColor3 = Color3.fromRGB(50,50,50)
cl.BorderSizePixel = 1
cl.Text = "clear"
cl.TextColor3 = Color3.fromRGB(150,150,150)
cl.TextSize = 11
cl.Font = Enum.Font.Code
cl.Parent = w

local sy = by + 26
local sf = Instance.new("ScrollingFrame")
sf.Size = UDim2.new(1,-8,1,-(sy+4))
sf.Position = UDim2.new(0,4,0,sy)
sf.BackgroundColor3 = Color3.fromRGB(15,15,15)
sf.BorderColor3 = Color3.fromRGB(40,40,40)
sf.BorderSizePixel = 1
sf.ScrollBarThickness = 3
sf.ScrollBarImageColor3 = Color3.fromRGB(60,60,60)
sf.CanvasSize = UDim2.new(0,0,0,0)
sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
sf.Parent = w

Instance.new("UIListLayout", sf).Padding = UDim.new(0,1)

local function mr(id, nm)
	local u = "https://create.roblox.com/store/asset/" .. id
	local e = Instance.new("Frame")
	e.Size = UDim2.new(1,0,0,28)
	e.BackgroundColor3 = Color3.fromRGB(20,20,20)
	e.BorderSizePixel = 0
	e.Parent = sf

	local d = Instance.new("TextLabel")
	d.Name = "d"
	d.Size = UDim2.new(0,10,1,0)
	d.Position = UDim2.new(0,2,0,0)
	d.BackgroundTransparency = 1
	d.Text = ">"
	d.TextColor3 = Color3.fromRGB(80,180,80)
	d.TextSize = 10
	d.Font = Enum.Font.Code
	d.Parent = e

	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1,-52,1,0)
	l.Position = UDim2.new(0,14,0,0)
	l.BackgroundTransparency = 1
	l.Text = nm .." ".. id
	l.TextColor3 = Color3.fromRGB(140,140,140)
	l.TextSize = 10
	l.Font = Enum.Font.Code
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextTruncate = Enum.TextTruncate.AtEnd
	l.Parent = e

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,38,0,18)
	b.Position = UDim2.new(1,-42,0.5,-9)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.BorderColor3 = Color3.fromRGB(50,50,50)
	b.BorderSizePixel = 1
	b.Text = "copy"
	b.TextColor3 = Color3.fromRGB(120,120,120)
	b.TextSize = 10
	b.Font = Enum.Font.Code
	b.Parent = e

	b.MouseButton1Click:Connect(function()
		setclipboard(u)
		b.Text = "ok"
		task.delay(0.8, function()
			if b.Parent then b.Text = "copy" end
		end)
	end)
	return e
end

local function ta(obj)
	if not on then return end
	if typeof(obj) ~= "Instance" then return end

	local s, sid
	s, sid = pcall(function() return obj.SoundId end)
	if not s or not sid or sid == "" then return end
	if not string.find(sid, "rbxassetid") then return end

	local num = sid:match("(%d+)")
	if not num or f[num] then return end

	local nm = "Unknown"
	pcall(function() nm = obj.Name end)

	f[num] = {n = nm, o = obj}
	r[num] = mr(num, nm)
	cnt = cnt + 1
	tl.Text = "sounds (" .. cnt .. ")"
end

local function chk(k)
	for _, x in next, opt do
		if x.k == k then return x.v end
	end
end

local function dosweep()
	local i = 0

	if chk("g") and sc then
		local d = game:GetDescendants()
		for j = 1, #d do
			if not sc then return end
			if typeof(d[j]) == "Instance" then
				local ok, is = pcall(d[j].IsA, d[j], "Sound")
				if ok and is then ta(d[j]) end
			end
			i = i + 1
			if i % 300 == 0 then task.wait() end
		end
		d = nil
		task.wait()
	end

	if chk("n") and sc then
		pcall(function()
			local ni = getnilinstances()
			for j = 1, #ni do
				if not sc then return end
				pcall(function()
					if ni[j]:IsA("Sound") then ta(ni[j]) end
				end)
				i = i + 1
				if i % 300 == 0 then task.wait() end
			end
		end)
		task.wait()
	end

	if chk("m") and sc then
		pcall(function()
			local md = getloadedmodules()
			for j = 1, #md do
				if not sc then return end
				pcall(function()
					if md[j]:IsA("ModuleScript") then
						local ch = md[j]:GetDescendants()
						for x = 1, #ch do
							if not sc then return end
							pcall(function()
								if ch[x]:IsA("Sound") then ta(ch[x]) end
							end)
							i = i + 1
							if i % 300 == 0 then task.wait() end
						end
					end
				end)
			end
		end)
		task.wait()
	end

	if chk("a") and sc then
		pcall(function()
			local al = getinstances()
			for j = 1, #al do
				if not sc then return end
				pcall(function()
					if al[j]:IsA("Sound") then ta(al[j]) end
				end)
				i = i + 1
				if i % 300 == 0 then task.wait() end
			end
			al = nil
		end)
		task.wait()
	end

	if chk("c") and sc then
		pcall(function()
			local gc = getgc(true)
			for j = 1, #gc do
				if not sc then return end
				if typeof(gc[j]) == "Instance" then
					pcall(function()
						if gc[j]:IsA("Sound") then ta(gc[j]) end
					end)
				end
				i = i + 1
				if i % 600 == 0 then task.wait() end
			end
			gc = nil
		end)
	end

	if sc then swept = true end
end

local function upd()
	local i = 0
	for k, row in next, r do
		if not sc then break end
		local dt = row:FindFirstChild("d")
		if dt then
			local ok, p = pcall(function() return f[k].o and f[k].o.IsPlaying end)
			dt.Text = (ok and p) and ">" or ""
		end
		i = i + 1
		if i % 120 == 0 then task.wait() end
	end
end

local onc
onc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	if not on then return onc(self, ...) end
	if not checkcaller() then
		local m = getnamecallmethod()
		if m == "Play" and typeof(self) == "Instance" then
			pcall(function()
				if self:IsA("Sound") then task.defer(ta, self) end
			end)
		end
	end
	return onc(self, ...)
end))

cn[#cn+1] = game.DescendantAdded:Connect(function(obj)
	if not on then return end
	pcall(function()
		if obj:IsA("Sound") then task.defer(ta, obj) end
	end)
end)

cb.MouseButton1Click:Connect(function()
	on = false
	sc = false
	for _, c in next, cn do
		pcall(function() c:Disconnect() end)
	end
	g:Destroy()
end)

cl.MouseButton1Click:Connect(function()
	for _, row in next, r do
		pcall(function() row:Destroy() end)
	end
	f = {}
	r = {}
	cnt = 0
	swept = false
	tl.Text = "sounds (0)"
end)

sv.MouseButton1Click:Connect(function()
	if cnt == 0 then
		sv.Text = "empty"
		task.delay(0.8, function() if sv.Parent then sv.Text = "save" end end)
		return
	end
	local ln = {}
	for num, data in next, f do
		ln[#ln+1] = data.n .. " | https://create.roblox.com/store/asset/" .. num
	end
	table.sort(ln)
	local ok = pcall(function()
		local gn = ms:GetProductInfo(game.PlaceId).Name
		gn = gn:gsub("[^%w%s%-_]",""):gsub("%s+","_")
		makefolder("SoundScanner")
		writefile("SoundScanner/" .. gn .. ".txt", table.concat(ln, "\n"))
	end)
	sv.Text = ok and "saved" or "error"
	task.delay(1, function() if sv.Parent then sv.Text = "save" end end)
end)

sb.MouseButton1Click:Connect(function()
	sc = not sc
	if sc then
		sb.Text = "stop"
		sb.BackgroundColor3 = Color3.fromRGB(40,25,25)
		sb.BorderColor3 = Color3.fromRGB(70,40,40)
		print("Scanning for sounds....")
		if not swept then
			task.spawn(dosweep)
		end
	else
		print("Stopped scanning. Found " .. cnt .. " sounds.")
		sb.Text = "scan"
		sb.BackgroundColor3 = Color3.fromRGB(30,30,30)
		sb.BorderColor3 = Color3.fromRGB(50,50,50)
	end
end)

task.spawn(function()
	while on and g.Parent do
		if sc then upd() end
		task.wait(2.5)
	end
end)
