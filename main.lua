-- ⚠️ HARUS DIJALANKAN DI LOCALSCRIPT
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- === CONFIG ===
local Identifier = "nyxhub"
local function GetHWID()
    return LocalPlayer.UserId
end

-- === VALIDASI KEY ===
local function ValidateKey(key)
    local hwid = GetHWID()
    local url = "https://pandadevelopment.net/v2_validation?key=" .. HttpService:UrlEncode(tostring(key))
        .. "&service=" .. HttpService:UrlEncode(tostring(Identifier))
        .. "&hwid=" .. HttpService:UrlEncode(tostring(hwid))

    local success, response = pcall(function()
        return HttpService:RequestAsync({ Url = url, Method = "GET" })
    end)

    if not success or not response or not response.Success then
        return false, "Network error"
    end

    local ok, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not ok then
        return false, "Invalid response"
    end

    if data and data.V2_Authentication == "success" then
        return true, "Success"
    else
        return false, data.reason or "Invalid key or HWID"
    end
end

-- === LINK GET KEY ===
local function GetKeyLink()
    return "https://pandadevelopment.net/getkey?service=" .. HttpService:UrlEncode(Identifier)
        .. "&hwid=" .. HttpService:UrlEncode(tostring(GetHWID()))
end

-- === BUAT GUI NYX ===
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

-- Background gelap transparan
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 0.7
bg.BackgroundColor3 = Color3.fromRGB(10, 8, 20) -- Malam pekat
bg.Parent = gui

-- Panel utama
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 360, 0, 260)
panel.Position = UDim2.new(0.5, -180, 0.5, -130)
panel.BackgroundColor3 = Color3.fromRGB(20, 18, 35) -- Ungu gelap
panel.BorderColor3 = Color3.fromRGB(90, 70, 140)
panel.BorderSizePixel = 2
panel.ClipsDescendants = true
panel.Parent = gui

-- Efek "glow" lembut (border dalam)
local glow = Instance.new("UICorner")
glow.CornerRadius = UDim.new(0, 12)
glow.Parent = panel

-- Judul
local title = Instance.new("TextLabel")
title.Text = "☾ NYX HUB ☽"
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(220, 200, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 15)
title.Parent = panel

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Text = "Enter your key to unlock the abyss"
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.TextColor3 = Color3.fromRGB(160, 140, 200)
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.Parent = panel

-- Input Key
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.85, 0, 0, 36)
keyBox.Position = UDim2.new(0.075, 0, 0, 85)
keyBox.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
keyBox.TextColor3 = Color3.fromRGB(240, 230, 255)
keyBox.PlaceholderText = "••••••••••••••••"
keyBox.PlaceholderColor3 = Color3.fromRGB(120, 110, 140)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 15
keyBox.ClearTextOnFocus = false
keyBox.Parent = panel

local keyGlow = Instance.new("UIStroke")
keyGlow.Color = Color3.fromRGB(100, 80, 160)
keyGlow.Thickness = 1.5
keyGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
keyGlow.Parent = keyBox

-- Status label
local status = Instance.new("TextLabel")
status.Text = ""
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0, 130)
status.TextColor3 = Color3.fromRGB(255, 100, 100)
status.Parent = panel

-- === TOMBOL ===
local btnSubmit = Instance.new("TextButton")
btnSubmit.Size = UDim2.new(0.26, 0, 0, 32)
btnSubmit.Position = UDim2.new(0.05, 0, 0, 165)
btnSubmit.Text = "✅ SUBMIT"
btnSubmit.Font = Enum.Font.GothamBold
btnSubmit.TextSize = 14
btnSubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSubmit.BackgroundColor3 = Color3.fromRGB(80, 60, 140)
btnSubmit.Parent = panel

local btnGetKey = Instance.new("TextButton")
btnGetKey.Size = UDim2.new(0.26, 0, 0, 32)
btnGetKey.Position = UDim2.new(0.37, 0, 0, 165)
btnGetKey.Text = "🔑 GET KEY"
btnGetKey.Font = Enum.Font.GothamBold
btnGetKey.TextSize = 14
btnGetKey.TextColor3 = Color3.fromRGB(255, 255, 255)
btnGetKey.BackgroundColor3 = Color3.fromRGB(100, 70, 160)
btnGetKey.Parent = panel

local btnExit = Instance.new("TextButton")
btnExit.Size = UDim2.new(0.26, 0, 0, 32)
btnExit.Position = UDim2.new(0.69, 0, 0, 165)
btnExit.Text = "❌ EXIT"
btnExit.Font = Enum.Font.GothamBold
btnExit.TextSize = 14
btnExit.TextColor3 = Color3.fromRGB(255, 255, 255)
btnExit.BackgroundColor3 = Color3.fromRGB(140, 60, 80)
btnExit.Parent = panel

-- Hover effect sederhana (opsional, bisa dihapus jika terlalu berat)
for _, btn in ipairs({btnSubmit, btnGetKey, btnExit}) do
    local originalColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(
            math.min(255, originalColor.R * 255 + 30),
            math.min(255, originalColor.G * 255 + 30),
            math.min(255, originalColor.B * 255 + 30)
        ) / 255
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = originalColor
    end)
end

-- === FUNGSI TOMBOL ===
btnExit.MouseButton1Click:Connect(function()
    pcall(function() gui:Destroy() end)
end)

btnGetKey.MouseButton1Click:Connect(function()
    local link = GetKeyLink()
    if setclipboard then
        setclipboard(link)
        status.TextColor3 = Color3.fromRGB(120, 220, 180)
        status.Text = "✓ Link copied to clipboard!"
        wait(2)
        status.Text = ""
    end
    -- Opsional: buka browser (tidak semua executor support)
    if syn and syn.open_url then
        syn.open_url(link)
    elseif flux_open_url then
        flux_open_url(link)
    end
end)

btnSubmit.MouseButton1Click:Connect(function()
    local function trim(s)
        return s:match("^%s*(.-)%s*$")
    end
    
    local key = trim(keyBox.Text)
    if key == "" then
        status.TextColor3 = Color3.fromRGB(255, 120, 120)
        status.Text = "• Key cannot be empty"
        return
    end

    btnSubmit.Text = "⋯ VERIFYING"
    btnSubmit.BackgroundColor3 = Color3.fromRGB(70, 50, 100)
    btnSubmit.Active = false

    spawn(function()
        local ok, msg = ValidateKey(key)
        if ok then
            status.TextColor3 = Color3.fromRGB(120, 220, 180)
            status.Text = "✓ Authenticated. Loading NYX..."
            wait(0.8)

            -- HAPUS GUI
            pcall(function() gui:Destroy() end)

            -- LOAD MAIN SCRIPT
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/0db59331d859fe6f"))()
            end)

            if not success then
                warn("NYX HUB Load Error:", err)
            end
        else
            status.TextColor3 = Color3.fromRGB(255, 120, 120)
            status.Text = "✗ " .. tostring(msg)
            btnSubmit.Text = "✅ SUBMIT"
            btnSubmit.BackgroundColor3 = Color3.fromRGB(80, 60, 140)
            btnSubmit.Active = true
        end
    end)
end)
