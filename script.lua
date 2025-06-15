setfpscap(30)
wait(15)
local __script__host = "http://110.164.146.123:7000"
local HttpService = game:GetService("HttpService")
local function Hop()
    local url = ""

    if game.PlaceId == 104715542330896 then
        url = __script__host .. "/servers"
    elseif game.PlaceId == 97556409405464 then
        url = __script__host .. "/serversv2"
    else
        warn("❌ ไม่รองรับ PlaceId นี้:", game.PlaceId)
        return
    end

    local ress = request({
        Url = url,
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    local dataa = HttpService:JSONDecode(ress.Body)
    if dataa then
        warn("✅ Job exists, hop")
        for ii, vv in pairs(dataa) do
            if ii == "id" then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, vv, game.Players.LocalPlayer)
            end
        end
    else
        warn("❌ Job not found, stay")
    end
end


local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:FindFirstChild("Modules")


-- local Updates = require(game:GetService("ReplicatedStorage").Modules.Game.GameInfo.Updates);
-- print(Updates.version)
-- if Updates.version == "1.2.10" then
--     Hop()
-- else
--     print("Version 1.2.11")
-- end

game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SplashScreenGui"):Destroy()
require(game:GetService("ReplicatedStorage").Modules.Game.UI.TransitionUI).conditional_enabled.set(false)
require(game:GetService("ReplicatedStorage").Modules.Game.SplashScreen).in_loading_screen.set(false)
wait(15)
-- click skip
local NetCore = require(game:GetService("ReplicatedStorage").Modules.Core.Net)
local Authenticate = debug.getupvalue(NetCore.get, 1)
local Send = function(...)
	Authenticate.event += 1;
	game:GetService("ReplicatedStorage").Remotes.Send:FireServer(Authenticate.event, ...)
end

local Get = function (...)
	Authenticate.func += 1;
	game:GetService("ReplicatedStorage").Remotes.Get:InvokeServer(Authenticate.func,...)
end
local a=require(game:GetService("ReplicatedStorage").Modules.Game.CharacterCreator.CharacterCreator)
local v8=require(game:GetService("ReplicatedStorage").Modules.Core.Char)
local v19 = require(game:GetService("ReplicatedStorage").Modules.Game.ResetCallback)
a.leaving_creator.set(true)
v8.enable_controls("character_creator")
Send("leave_character_creator")
v19.enable_reset_button()

wait(15)


local CONST1 = 1.1040895136738123
local CONST2 = 0.10408951367381225

local function level_to_xp(level)
    local expTerm = 2 ^ (level / 7)
    local xp = 0.125 * (level^2 - level + 600 * ((expTerm - CONST1) / CONST2))
    return math.floor(xp + 0.5)
end

local function xp_to_level(targetXP)
    local low, high = 0, 100
    while low <= high do
        local mid = math.floor((low + high) / 2)
        local midXP = level_to_xp(mid)
        if midXP <= targetXP then
            low = mid + 1
        else
            high = mid - 1
        end
    end
    return high
end
local DataCore = require(game:GetService("ReplicatedStorage").Modules.Core.Data)
local xp_total = DataCore.xp["total_level"]
local level_total = xp_total and xp_to_level(xp_total) or 0

local LocalPlayer = cloneref(game:GetService("Players").LocalPlayer)
local character = cloneref(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local playerGui = LocalPlayer:WaitForChild("PlayerGui")


-- UI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlackScreenUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.Position = UDim2.new(0, 0, 0, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BorderSizePixel = 0
blackFrame.Visible = true
blackFrame.Parent = screenGui

-- Player Name (Center)
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
nameLabel.Position = UDim2.new(0.25, 0, 0.42, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = LocalPlayer.Name
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.TextScaled = true
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.Parent = blackFrame

-- Status text (lower middle)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0.05, 0)
statusLabel.Position = UDim2.new(0, 0, 0.93, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "กำลังโหลด..."
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = blackFrame

-- Money text (bottom)
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, 0, 0.05, 0)
moneyLabel.Position = UDim2.new(0, 0, 0.85, 0)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "เงิน: กำลังโหลด..."
moneyLabel.TextColor3 = Color3.new(1, 1, 1)
moneyLabel.TextScaled = true
moneyLabel.Font = Enum.Font.SourceSans
moneyLabel.Parent = blackFrame


-- Xp text (bottom)
local xpLabel = Instance.new("TextLabel")
xpLabel.Size = UDim2.new(1, 0, 0.05, 0)
xpLabel.Position = UDim2.new(0, 0, 0.75, 0)
xpLabel.BackgroundTransparency = 1
xpLabel.Text = "XP: "
xpLabel.TextColor3 = Color3.new(1, 1, 1)
xpLabel.TextScaled = true
xpLabel.Font = Enum.Font.SourceSans
xpLabel.Parent = blackFrame

-- -- FPS Limiter
-- local fpsLimiter = true
-- RunService.RenderStepped:Connect(function()
-- 	if fpsLimiter and blackFrame.Visible then
-- 		wait(0.05) -- ประมาณ 20 FPS
-- 	end
-- end)

-- Toggle with Left Ctrl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.LeftControl then
		blackFrame.Visible = not blackFrame.Visible
	end
end)


-- Mobile: Add toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.3, 0, 0.06, 0)
toggleButton.Position = UDim2.new(0.5, 0, 0.02, 0) -- กลางบน
toggleButton.AnchorPoint = Vector2.new(0.5, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "Black Screen"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = screenGui
toggleButton.AutoButtonColor = true

toggleButton.MouseButton1Click:Connect(function()
	blackFrame.Visible = not blackFrame.Visible
end)



xpLabel.Text = "XP: ".. tostring(DataCore.xp["total_level"]) .. " Level: " .. tostring(xp_to_level(xp_total) or 0)

local function DeadEvent()
    local h=character:FindFirstChildOfClass("Humanoid")
    h:GetAttributeChangedSignal("IsDead"):Connect(function()
        if h:GetAttribute("IsDead") then
            warn("Player Dead")
            local time=game.Players.RespawnTime;
            repeat
                task.wait(1)
                time=time-1
            until time<=0
            -- Send("death_screen_request_respawn")
            Hop()
            -- task.wait(2)
            -- game:GetService("TeleportService"):Teleport(game.PlaceId,game:GetService("Players").LocalPlayer)
            DeadEvent()
        end
    end)
end
DeadEvent()


local PathfindingService = game:GetService("PathfindingService")
local plr = game.Players.LocalPlayer
local function line(from, to, color)
    local beam = Instance.new("Part")
    beam.Anchored = true
    beam.CanCollide = false
    beam.Size = Vector3.new(0.2, 0.2, (to - from).Magnitude)
    beam.CFrame = CFrame.new((from + to)/2, to)
    beam.Color = BrickColor.new(color).Color
    beam.Transparency = 0.5
    beam.Parent = DebugFolder
end

-- ฟังก์ชันเดินไปยังจุด
local function walkToTarget(targetPosition)
    local Char = plr.Character or plr.CharacterAdded:Wait()
    if not Char or not Char:FindFirstChild("HumanoidRootPart") or not Char:FindFirstChild("Humanoid") then
        warn("Character หรือ Humanoid ยังไม่พร้อม")
        return
    end

    local Humanoid = Char.Humanoid
    local pos = Char.HumanoidRootPart.Position

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = false,
        AgentCanClimb = false,
        AgentMaxSlope = 45,
    })

    path:ComputeAsync(pos, targetPosition)

    local Humanoidd = Char.Humanoid
    Humanoidd.WalkSpeed = 24


    if path.Status ~= Enum.PathStatus.Success then
        warn("Pathfinding ล้มเหลว: " .. tostring(path.Status))
        return
    end

    local waypoints = path:GetWaypoints()

    for i, v in ipairs(waypoints) do
        local targetPos = v.Position
        local humRoot = Char.HumanoidRootPart

        local distance = (targetPos - humRoot.Position).Magnitude

        -- ใช้ MoveTo เพื่อให้เดินไปยังจุด
        Humanoid:MoveTo(targetPos)
        
        local reached = false
        local event = Humanoid.MoveToFinished:Connect(function(success)
            reached = true
        end)

        -- รอจนกว่าจะถึง waypoint
        repeat task.wait() until reached
        event:Disconnect()

        -- ตรวจสอบระยะทางอีกครั้ง
        if (targetPos - humRoot.Position).Magnitude > 10 then
            warn("ไปไม่ถึงเป้าหมาย waypoint", i)
            break
        end

        -- แสดง Debug line
        if i < #waypoints then
            line(targetPos, waypoints[i + 1].Position, "Bright blue")
        end
    end
end

function walkTo(targetPosition)
    local Char = plr.Character
    local Humanoid = Char:WaitForChild("Humanoid")
    local HRP = Char:WaitForChild("HumanoidRootPart")

    Humanoid.WalkSpeed = 30

    Humanoid:MoveTo(targetPosition)

    -- รอ MoveTo เสร็จ หรือตรวจระยะเอง
    local connection
    local finished = false

    connection = Humanoid.MoveToFinished:Connect(function(reached)
        finished = true
        connection:Disconnect()
    end)

    -- fallback เผื่อ MoveToFinished ไม่ถูกเรียก
    while not finished and (targetPosition - HRP.Position).Magnitude > 2 do
        task.wait(0.1)
    end
end

-- ตำแหน่ง BoxPile
local boxPile = workspace.Map.Tiles.GasStationTile.Quick11.Interior.ShelfStockingJob:FindFirstChild("BoxPileForJob")
local boxPosition = boxPile and boxPile.WorldPivot.Position
local doorgas = workspace.Map.Tiles.GasStationTile.Quick11.Exterior.DoorSystem.DoorBase.CFrame.Position
local door = workspace.Map.Tiles.GasStationTile.Quick11.Interior.DoorSystem.Model.Part

local gasPumpModel = workspace.Map.Props.GasAdvertisingSign.Support.CFrame.Position
local Char = plr.Character
local HumanoidRootPart = Char.HumanoidRootPart
if gasPumpModel then 
    statusLabel.Text = "กำลังเดินไปที่ GasPump"
    walkToTarget(gasPumpModel)
    walkTo(doorgas)
    task.wait(1)
    print("เดินไปข้างหน้า 2 ก้าว")
    local direction = HumanoidRootPart.CFrame.LookVector  -- ทิศทางที่ตัวละครหันไป
    local newPosition = HumanoidRootPart.Position + direction * 10  -- ขยับ 2 ก้าว
    walkTo(newPosition)
    wait(3)
    walkToTarget(workspace.Map.Tiles.GasStationTile.Quick11.Interior.ShelfStockingJob.Shelves:GetChildren()[7].CFrame.Position)
    walkToTarget(Vector3.new(134.9644317626953, 255.46714782714844, 208.53805541992188))
    statusLabel.Text = "สมัครงาน..."
    Send("apply_for_job", workspace.Map.Tiles.GasStationTile.Quick11.Interior.Quick11Beacon)
end

local function updateMoney()
    local money_now = DataCore.money.bank + DataCore.money.hand
	moneyLabel.Text = "เงิน: " .. tostring(money_now)
end


do -- anti afk
    local vu = cloneref(game:GetService("VirtualUser"))
    game:GetService("Players").LocalPlayer.Idled:Connect(function() 
        local cam=workspace.CurrentCamera
        vu:Button2Down(Vector2.new(0,0),cam.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),cam.CFrame)
    end)
end

-- function sendRequest(money_hand, money_bank, xp_total, level_total)
--     local res = request({
--         Url = __script__host .. "/addbotxp",
--         Method = "POST",
--         Headers = {
--             ["Content-Type"] = "application/json"
--         },
--         Body = HttpService:JSONEncode({
--             username_bot = LocalPlayer.Name,
--             money_hand = money_hand or 0,
--             money_bank = money_bank or 0,
--             xp = xp_total or 0,
--             xp_totel = level_total or 0,
--             status = 1
--         })
--     })
--     warn(res.Body)
-- end
function sendRequest(money_hand, money_bank, xp_total, level_total)
    task.spawn(function()
        local res = request({
            Url = __script__host .. "/addbotxp",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                username_bot = LocalPlayer.Name,
                money_hand = money_hand or 0,
                money_bank = money_bank or 0,
                xp = xp_total or 0,
                xp_totel = level_total or 0,
                status = 1
            })
        })
        warn(res.Body)
    end)
end


local v9 = require(ReplicatedStorage.Modules.Game.Jobs.JobData);
local Skills = require(ReplicatedStorage.Modules.Game.Skills.SkillsList);
local DataCore = require(game.ReplicatedStorage.Modules.Core.Data);
local shelf_length = v9.job_info.shelf_stocker.stock_shelf_length;

local function checkspeed(v21)
    local v22 = 1;
    local l_shelf_stocker_0 = Skills.list.shelf_stocker;
    local v24 = nil;
    v24 = v21 == "extra_box" and "extra_box" or v21 .. "_percentage_increase";
    for _, v26 in l_shelf_stocker_0 do
        if v26.reward_info and v26.reward_info[v24] and Skills.has_skill(DataCore, "shelf_stocker", v26.name) then
            v22 = v22 + v26.reward_info[v24] / 100;
        end;
    end;
    return v22;
end;
local v38 = math.floor((shelf_length / checkspeed("speed")) * 10 + 0.5) / 10


local function isInGasStationTile(player)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end

    local hrp = character.HumanoidRootPart
    local gasStationTile = workspace.Map.Tiles.GasStationTile.Quick11.Interior:FindFirstChild("ShelfStockingJob")
    if not gasStationTile or not gasStationTile:IsA("Model") then
        return false
    end

    -- ได้ CFrame และ Size ของ bounding box ของ Model
    local cframe, size = gasStationTile:GetBoundingBox()

    -- คำนวณตำแหน่งมุมล่างซ้ายและบนขวา (bounding box)
    local minBound = cframe.Position - (size / 2)
    local maxBound = cframe.Position + (size / 2)

    local pos = hrp.Position
    return (
        pos.X >= minBound.X and pos.X <= maxBound.X and
        pos.Y >= minBound.Y and pos.Y <= maxBound.Y and
        pos.Z >= minBound.Z and pos.Z <= maxBound.Z
    )
end

local failedAttempts = 0
local failedSendBox = 0
while true do
    print("xp_total", xp_total)
    print("level_total", level_total)
    xpLabel.Text = "XP: ".. tostring(DataCore.xp["total_level"]) .. " Level: " .. tostring(xp_to_level(DataCore.xp["total_level"]) or 0)

    -- walkToTarget(workspace.Map.Tiles.GasStationTile.Quick11.Interior.ShelfStockingJob.Shelves:GetChildren()[7].CFrame.Position)
    walkToTarget(Vector3.new(134.9644317626953, 255.46714782714844, 208.53805541992188))
    statusLabel.Text = "รับกล่อง..."
    fireproximityprompt(workspace.Map.Tiles.GasStationTile.Quick11.Interior.ShelfStockingJob.NormalBox.ProximityPrompt)
    if isInGasStationTile(plr) then
        print("Player is in the Gas Station Tile!")
    else
        -- print("Player is outside the Gas Station Tile.")
        Hop()
        break
    end
    print("check send")
    task.wait(0.5)
    local stopp = true
    while stopp do
        -- walkToTarget(workspace.Map.Tiles.GasStationTile.Quick11.Interior.ShelfStockingJob.Shelves:GetChildren()[7].CFrame.Position)

        -- อัปเดต shelfTargets ใหม่ทุกครั้งในลูป
        local shelfTargets = {}

        for _, shelf in ipairs(workspace.Map.Tiles.GasStationTile.Quick11.Interior.ShelfStockingJob.Shelves:GetChildren()) do
            local attachment = shelf:FindFirstChild("Attachment")
            if attachment then
                table.insert(shelfTargets, shelf.Position)
            end
        end

        -- print("จำนวน shelf ที่พบ:", #shelfTargets)

        if failedSendBox >= 8 then
            Hop()
            -- game:GetService("TeleportService"):Teleport(game.PlaceId,game:GetService("Players").LocalPlayer)
        end

        -- ถ้ามี shelfTargets ให้ไปส่งของ
        if #shelfTargets > 0 then
            failedSendBox += 1
            for i, shelfPos in ipairs(shelfTargets) do
                statusLabel.Text = "ส่งกล่อง..."
                -- print("กำลังไปยัง shelf ที่", i, shelfPos)
                walkToTarget(shelfPos)
                -- task.wait(10)
                task.wait(v38)
                -- print("ส่งของเรียบร้อย")
                failedAttempts = 0
            end
        else
            failedAttempts += 1
            -- print("ไม่มี shelf ให้ส่งแล้ว หยุดลูป")

            walkToTarget(workspace.Map.Tiles.GasStationTile.Quick11.Interior.ATM.Area.Position)
            if DataCore.money.hand > 0 then
                Get("transfer_funds", "hand", "bank", DataCore.money.hand)
                updateMoney()
            end
            if failedAttempts >= 2 then
                Hop()
            end
            stopp = false
            break
        end
    end
    failedSendBox = 0

    sendRequest(DataCore.money.hand,DataCore.money.bank,DataCore.xp["total_level"],xp_total and xp_to_level(DataCore.xp["total_level"]) or 0)
end
