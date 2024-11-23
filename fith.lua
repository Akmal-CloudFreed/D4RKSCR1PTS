-- fisch autofarm script :) - cloudfreed on discord

repeat wait() until game:IsLoaded() and game:GetService("Players")

local playerCFrame = CFrame.new(-2705.95801, 165.624969, 1754.67444, 0.49963665, 3.57410901e-09, -0.866235077, 1.84048758e-08, 1, 1.47417945e-08, 0.866235077, -2.33084894e-08, 0.49963665)
local playerPosition = Vector3.new(-2705.95801, 165.624969, 1754.67444)
local bobberCFrame = CFrame.new(-2694.83032, 160.074951, 1748.82397, 1, -1.50031894e-06, 5.89414639e-13, 1.50031894e-06, 1, -8.95301582e-07, 7.53823328e-13, 8.95301582e-07, 1)
local bobberPositioning = Vector3.new(-2694.83032, 160.074951, 1748.82397)

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerBackpack = player:WaitForChild("Backpack")

local isNewScriptLoaded = false
local running = false
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local bodyPosition = Instance.new("BodyPosition")
bodyPosition.MaxForce = Vector3.new(0, 0, 0)

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(0, 0, 0)

local bobberPosition = Instance.new("BodyPosition")
bobberPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bobberPosition.Position = bobberPositioning

local detectNewLoad = Instance.new("TextLabel")
detectNewLoad.Name = "bisch_akmal"

local madeByLabel = Instance.new("TextLabel")
madeByLabel.Parent = screenGui
madeByLabel.Size = UDim2.new(0, 200, 0, 30)
madeByLabel.Position = UDim2.new(1, -210, 0.5, -85) -- Credits above status
madeByLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
madeByLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
madeByLabel.TextScaled = true
madeByLabel.Text = "Made by Akmal"

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = screenGui
statusLabel.Size = UDim2.new(0, 200, 0, 50)
statusLabel.Position = UDim2.new(1, -210, 0.5, -25) -- Status label
statusLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Text = "Script is OFF"

local toggleMessage = Instance.new("TextLabel")
toggleMessage.Parent = screenGui
toggleMessage.Size = UDim2.new(0, 200, 0, 30)
toggleMessage.Position = UDim2.new(1, -210, 0.5, 30)
toggleMessage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleMessage.TextScaled = true
toggleMessage.Text = "Press P to toggle" -- For dumbfucks

local function stopOldLoad()
    local textLabel = player:FindFirstChild("bisch_akmal")
    if textLabel then textLabel:destroy() end
    detectNewLoad.Parent = player
end

local function oxygen()
    local character = player.Character
    if not character then return end

    local client = character:FindFirstChild("client")
    if not client then return end

    local oxygen = client:FindFirstChild("oxygen")
    if not oxygen then return end

    oxygen:destroy()
end

local function findChildWithRod(parent)
    if not parent then return nil end

    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Instance") and child.Name:lower():find('rod') then
            return child
        end
    end
    return nil
end

local function equipRod()
    local rod = findChildWithRod(playerBackpack)
    if rod then
        local Humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        Humanoid:EquipTool(rod)
        wait(3)
    end
end

local function castRod()
    local remote = player.Character and player.Character:FindFirstChildOfClass("Tool") and player.Character:FindFirstChildOfClass("Tool").events.cast
    if remote then
        remote:FireServer(1)
    else
        print("this bullshit game doesnt have the remote... FUCK!")
    end
end

local function startTracking(playerbar)
    if not playerbar then return end

    playerbar:GetPropertyChangedSignal('Position'):Wait()
    ReplicatedStorage.events.reelfinished:FireServer(100, true)
end

local function remote()
    if not running then return end

    equipRod()
    castRod()
end

local function shake(button)
    if not button then return end

    button.Position = UDim2.new(0.5, 0, 0.5, 0)
    wait(0.05)

    local pos = button.AbsolutePosition
    local size = button.AbsoluteSize

    if button.Visible == true then
        VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, player, 0)
        VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, player, 0)
    end
end

local function toggleAnchor()
    local character = player.Character
    if not character then return end

    local HumanoidRootPart = character.HumanoidRootPart
    if not HumanoidRootPart then return end

    bodyPosition.Position = playerPosition--HumanoidRootPart.Position
    bodyPosition.Parent = HumanoidRootPart

    bodyGyro.CFrame = playerCFrame--HumanoidRootPart.CFrame
    bodyGyro.Parent = HumanoidRootPart

    if running then
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    else
        bodyPosition.MaxForce = Vector3.new(0, 0, 0)
        bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    end
end

local function gotoAnchoredLocation()
    if not running then return end

    local character = player.Character
    if not character then return end

    local HumanoidRootPart = character.HumanoidRootPart
    if not HumanoidRootPart then return end

    HumanoidRootPart.CFrame = bodyGyro.CFrame
end

local function updateStatusLabel()
    if running then
        statusLabel.Text = "Script is ON"
        statusLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green :)
        remote()
    else
        statusLabel.Text = "Script is OFF"
        statusLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red >:)
    end
end

local function toggleRunning()
    if isNewScriptLoaded == true then return end
    running = not running

    if running then
        print("Script resumed...")
    else
        print("Script stopped...")
    end
    toggleAnchor()
    updateStatusLabel()
end

stopOldLoad()

local UserInputServiceConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        toggleRunning()
    end
end)

local playerGuiAddedConnection = playerGui.DescendantAdded:Connect(function(descendant)
    if running and descendant.Name == "playerbar" and descendant.Parent.Name == "bar" then
        startTracking(descendant)
    else if running and descendant.Name == "button" and descendant.Parent.Name == "safezone" then
        shake(descendant)
    end
    end
end)

local playerGuiRemovedConnection = playerGui.DescendantRemoving:Connect(function(descendant)
    if descendant.Name == "playerbar" and descendant.Parent.Name == "bar" then
        wait(0.05)
        remote()
    end
end)

local bobberCreatedConnection = player.Character.DescendantAdded:Connect(function(descendant)
    if running and descendant.Name == "RopeConstraint" and descendant.Parent.Name == "bobber" then
        local bobber = descendant.Parent
        descendant.WinchForce = 0
        bobberPosition.Parent = bobber
    else if running and descendant.Name == "Beam" and descendant.Parent.Name == "bob" then
        descendant:Destroy()
    end
    end
end)

local detectNewLoadConnection

local function cleanup()
    print('cleaning old script...')

    isNewScriptLoaded = true
    running = false
    updateStatusLabel()
    bodyGyro:destroy()
    bodyPosition:destroy()

    UserInputServiceConnection:Disconnect()
    playerGuiAddedConnection:Disconnect()
    playerGuiRemovedConnection:Disconnect()
    bobberCreatedConnection:Disconnect()
    detectNewLoadConnection:Disconnect()
    script:Destroy()
end

detectNewLoadConnection = detectNewLoad.AncestryChanged:Connect(function(descendant, parent)
    if descendant.Name == "bisch_akmal" and not parent then
        cleanup()
    end
end)

local intro = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("TextLabel")
local UIST = Instance.new("UIStroke")
intro.Parent = game:GetService("CoreGui")
Frame.Parent = intro
Frame.BorderColor3 = Color3.new(255,0,0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.new(1, 0, 0, 100)
Frame.Position = UDim2.new(0, 0, -0.4, 0)
ImageLabel.Parent = Frame
ImageLabel.BorderColor3 = Color3.fromRGB(255,0,0)
ImageLabel.TextColor3 = Color3.fromRGB(255, 0, 50)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0, 0, 0, 0)
ImageLabel.Size = UDim2.new(1, 0, 1, 0)
ImageLabel.Text = "░█████╗░██╗░░░░░░█████╗░██╗░░░██╗██████╗░███████╗██████╗░███████╗███████╗██████╗░\n██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗\n██║░░╚═╝██║░░░░░██║░░██║██║░░░██║██║░░██║█████╗░░██████╔╝█████╗░░█████╗░░██║░░██║\n██║░░██╗██║░░░░░██║░░██║██║░░░██║██║░░██║██╔══╝░░██╔══██╗██╔══╝░░██╔══╝░░██║░░██║\n╚█████╔╝███████╗╚█████╔╝╚██████╔╝██████╔╝██║░░░░░██║░░██║███████╗███████╗██████╔╝\n░╚════╝░╚══════╝░╚════╝░░╚═════╝░╚═════╝░╚═╝░░░░░╚═╝░░╚═╝╚══════╝╚══════╝╚═════╝░"
UIST.Parent = ImageLabel
Frame:TweenPosition(UDim2.new(0, 0, 0.2, 0), "Out", "Elastic", 3)
wait(3.01)
Frame:TweenPosition(UDim2.new(0, 0, 1.5, 0), "Out", "Elastic", 5)
wait(5.01)
intro:Destroy()

player.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

while wait(1) do
    if isNewScriptLoaded then break end

    gotoAnchoredLocation()
    oxygen()
    remote()
end
