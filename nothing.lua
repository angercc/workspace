
getgenv().predac = 0.037

readfile("idk.txt")
local Settings = {
    Aimlock = {
        AimPart = "LowerTorso",
        AimlockKey = "Q",
        Prediction = 0.143,

        FOVEnabled = false,
        FOVShow = false,
        FOVSize = 30,

        Enabled = false
    },
    SilentAim = {
        Key = "Q",
        AimAt = "LowerTorso",
        PredictionAmount = 0.139,

        FOVEnabled = true,
        FOVShow = false,
        FOVSize = 60,

        Enabled = false,
        KeyToLockOn = false
    },
    CFSpeed = {
        Speed = 2,
        
        Enabled = false,
        Toggled = false,

        Key = "Z"
    }
}
getgenv().AirshotFunccc = true
--// Variables (Service)

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")


--// Variables (regular)

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera
local GetGuiInset = GS.GetGuiInset

local AimlockState = false
local aimLocked
local lockVictim

--// Anti-Cheat

repeat wait() until LP.Character:FindFirstChild("FULLY_LOADED_CHAR");

for _,ac in pairs(LP.Character:GetChildren()) do
    if (ac:IsA("Script") and ac.Name ~= "Animate" and ac.Name ~= "Health") then
        ac:Destroy();
    end;
end;

LP.Character.ChildAdded:Connect(function(child)
    if (child:IsA("Script") and child.Name ~= "Animate" and ac.Name ~= "Health") then
        child:Destroy();
    end;
end);

--// CFrame Speed

local userInput = game:GetService('UserInputService')
local runService = game:GetService('RunService')

Mouse.KeyDown:connect(function(Key)
    local cfKey = Settings.CFSpeed.Key:lower()
    if (Key == cfKey) then
        if (Settings.CFSpeed.Toggled) then
            Settings.CFSpeed.Enabled = not Settings.CFSpeed.Enabled
            if (Settings.CFSpeed.Enabled == true) then
                repeat
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * Settings.CFSpeed.Speed
                    game:GetService("RunService").Stepped:wait()
                until Settings.CFSpeed.Enabled == false
            end
        end
    end
end)


--// FOV Circle
getgenv().colorrr2 = Color3.fromRGB(255,0,0)
local fov = Drawing.new("Circle")
fov.Filled = false
fov.Transparency = 1
fov.Thickness = 1
fov.Color = getgenv().colorrr2


--// Functions

function updateLock()
    if Settings.Aimlock.FOVEnabled == true and Settings.Aimlock.FOVShow == true then
        if fov then
            fov.Radius = Settings.Aimlock.FOVSize * 2
            fov.Visible = Settings.Aimlock.FOVShow
            fov.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GS).Y)
            fov.Color = getgenv().colorrr2
            

            return fov
        end
    else
        Settings.Aimlock.FOVShow = false
        fov.Visible = false
    end
end

function WTVP(arg)
    return Camera:WorldToViewportPoint(arg)
end

function WTSP(arg)
    return Camera.WorldToScreenPoint(Camera, arg)
end

function getClosest()
    local closestPlayer
    local shortestDistance = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        local notKO = v.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true
        local notGrabbed = v.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil
        
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild(Settings.Aimlock.AimPart) and notKO and notGrabbed then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            
            if (Settings.Aimlock.FOVEnabled) then
                if (fov.Radius > magnitude and magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            else
                if (magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

function sendNotification(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Headshot.me",
        Text = text,
        Duration = 5
    })
end
--// Checks if key is down

Mouse.KeyDown:Connect(function(k)
    local actualKey = Settings.Aimlock.AimlockKey:lower()
    if (k == actualKey) then
        if Settings.Aimlock.Enabled == true then
            aimLocked = not aimLocked
            if aimLocked then
                lockVictim = getClosest()
if getgenv().Notiq then
                
    sendNotification((lockVictim.Character.Humanoid.DisplayName))
end
            else
                if lockVictim ~= nil then
                    lockVictim = nil
if getgenv().Notiq then
                    sendNotification("No Target!")
end
                end
            end
        end
    end
end)

--// Loop update FOV and loop camera lock onto target

local localPlayer = game:GetService("Players").LocalPlayer
local currentCamera = game:GetService("Workspace").CurrentCamera
local guiService = game:GetService("GuiService")
local runService = game:GetService("RunService")
getgenv().colorrr = Color3.fromRGB(0,255,255)

local getGuiInset = guiService.GetGuiInset
local mouse = localPlayer:GetMouse()

local silentAimed = false
local silentVictim
local victimMan

local FOVCircle = Drawing.new("Circle")
FOVCircle.Filled = false
FOVCircle.Transparency = 0.3
FOVCircle.Thickness = 1.5
FOVCircle.Color = getgenv().colorrr
            FOVCircle.NumSides = 8

function updateFOV()
    if (FOVCircle) then
        if (Settings.SilentAim.FOVEnabled) then
            FOVCircle.Radius = Settings.SilentAim.FOVSize * 2
            FOVCircle.Visible = Settings.SilentAim.FOVShow
            FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + getGuiInset(guiService).Y)
            FOVCircle.Color = getgenv().colorrr
            FOVCircle.Filled = Settings.SilentAim.FOVFilled
            FOVCircle.NumSides = Settings.SilentAim.FOVSides
            return FOVCircle
        elseif (not Settings.SilentAim.FOVEnabled) then
            FOVCircle.Visible = false
        end
    end
end


function getClosestPlayerToCursor()
    local closestPlayer
    local shortestDistance = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild(Settings.SilentAim.AimAt) then
            local pos = currentCamera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
            



            if (Settings.SilentAim.FOVEnabled == true) then
                if (FOVCircle.Radius > magnitude and magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            else
                if (magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

Mouse.KeyDown:Connect(function(k)
    local actualKey = Settings.SilentAim.Key:lower()
    if (k == actualKey) then
        if (Settings.SilentAim.KeyToLockOn == false) then
            return
        end
        if (Settings.SilentAim.Enabled) then
            silentAimed = not silentAimed
                
            if silentAimed then
                silentVictim = getClosestPlayerToCursor()
                if getgenv().Notiu then
                sendNotification((silentVictim.Character.Humanoid.DisplayName))
                end
            elseif not silentAimed and silentVictim ~= nil then
                silentVictim = nil
if getgenv().Notiu then
                sendNotification('No Target!')
end
            end
        end
    end
end)

runService.RenderStepped:Connect(function()
    updateFOV()
    updateLock()
    victimMan = getClosestPlayerToCursor()
    if Settings.Aimlock.Enabled == true then
        if lockVictim ~= nil then
            Camera.CFrame = CFrame.new(Camera.CFrame.p, lockVictim.Character[Settings.Aimlock.AimPart].Position + lockVictim.Character[Settings.Aimlock.AimPart].Velocity*Settings.Aimlock.Prediction)
        end
    end
end)
if getgenv().nigger == true then
if silentVictim.Character.Humanoid.Jump == true and silentVictim.Character.Humanoid.FloorMaterial == Enum.Material.Air then
	Settings.SilentAim.PredictionAmount = "RightFoot"
else
	silentVictim.Character:WaitForChild("Humanoid").StateChanged:Connect(function(old,new)
		if new == Enum.HumanoidStateType.Freefall then
			Settings.SilentAim.PredictionAmount = "RightFoot"
		else
			Settings.SilentAim.PredictionAmount = "LowerTorso"
		end
	end)
end
end

game:GetService"RunService".RenderStepped:Connect(function()

    if getgenv().Sar == true and silentAimed then

    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local Value = tostring(ping)
    local pingValue = Value:split(" ")
    local PingNumber = pingValue[1]
    
    Settings.SilentAim.PredictionAmount
    = PingNumber / 1000 + getgenv().predac

    end
    end)

    
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}

    if Settings.SilentAim.Enabled and Settings.SilentAim.KeyToLockOn and silentAimed and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = silentVictim.Character[Settings.SilentAim.AimAt].Position+(silentVictim.Character[Settings.SilentAim.AimAt].Velocity*Settings.SilentAim.PredictionAmount)
        return old(unpack(args))
    elseif Settings.SilentAim.Enabled and not Settings.SilentAim.KeyToLockOn and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = victimMan.Character[Settings.SilentAim.AimAt].Position+(victimMan.Character[Settings.SilentAim.AimAt].Velocity*Settings.SilentAim.PredictionAmount)
        return old(unpack(args))
    end

    return old(...)
end)



	

local ezlib = {};

------------------------------------------------------------------------------
-- Stores the functions and variables essential for the UI to work.

local coreVars = {};	-- Stores essential vars
local coreFuncs = {};	-- Stores essential funcs
local coreGUIFuncs = {};	-- Stores functions that create the actual GUI

------------------------------------------------------------------------------
-- coreVars definitions

coreVars.navDebounce = true;
coreVars.usingSlider = false;
coreVars.elementX = 375
coreVars.sliderUsed = nil;

-- Used for keybind ui.
coreVars.awaitingInput = nil;	-- Stores the keybind that is requesting input from the user.
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if coreVars.awaitingInput then
		coreVars.awaitingInput.button.Text = input.KeyCode.Name;
		coreVars.awaitingInput = nil;
	end
end)
coreVars.colors = {
	Primary = Color3.fromRGB(24, 20, 44),
	Secondary = Color3.fromRGB(32, 28, 52),
	Tertiary = Color3.fromRGB(32, 28, 52),
	Quaternary = Color3.fromRGB(32, 28, 52)
};

if _G.EzHubTheme then

	local p = _G.EzHubTheme["Primary"];
	local s = _G.EzHubTheme["Secondary"];
	local t = _G.EzHubTheme["Tertiary"];
	local q = _G.EzHubTheme["Quaternary"];

	coreVars.colors = {
		Primary = Color3.fromRGB(p[1], p[2], p[3]),
		Secondary = Color3.fromRGB(s[1], s[2], s[3]),
		Tertiary = Color3.fromRGB(t[1], t[2], t[3]),
		Quaternary = Color3.fromRGB(q[1], q[2], q[3])
	}

end

------------------------------------------------------------------------------
-- Corefuncs definitions

coreFuncs.addInstance = function(instance, properties)
	if instance and type(properties) == "table" then
		local ins = Instance.new(tostring(instance));
		for i,v in pairs(properties or {}) do
			ins[i] = v;
		end
		return ins;
	else
		error("Invalid input for addInstance function.");
	end
end

coreFuncs.roundify = function(element, radius)
	coreFuncs.addInstance("UICorner", {
		CornerRadius =  radius and UDim.new(0, radius) or UDim.new(0,4),
		Parent = element
	});
end

coreFuncs.isUsingSlider = function()
	return coreVars.usingSlider;
end

coreFuncs.dragifyLib = function(mainFrame)
	local dragging;
	local dragInput;
	local dragStart;
	local startPos;

	local function update(input)
		if coreFuncs.isUsingSlider() then return end
		Delta = input.Position - dragStart;
		Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y);
		game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(.15), {Position = Position}):Play();
	end

	mainFrame.InputBegan:Connect(function(input)
		if coreFuncs.isUsingSlider() then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true;
			dragStart = input.Position;
			startPos = mainFrame.Position;

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false;
				end
			end)
		end
	end)

	mainFrame.InputChanged:Connect(function(input)
		if coreFuncs.isUsingSlider() then return end
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			dragInput = input;
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input);
		end
	end)
end

-- Function for rotating instances. More info in main Ez Hub file
coreFuncs.rotateInstanceBy = function(instance, rotationAngle, delay, isCounterClockwise)
	for i = 1, rotationAngle / 40 do
		local tween = game:GetService("TweenService"):Create(instance, TweenInfo.new(delay or 0.03, Enum.EasingStyle.Linear), {Rotation = instance.Rotation + (isCounterClockwise and -40 or 40)});
		tween:Play();
		tween.Completed:Wait();
	end
end

-- Handles the navigation tab opening and closing
coreFuncs.handleNavLib = function(frame, nav, close, activeFrame)
	if coreVars.navDebounce then
		coreVars.navDebounce = false;

		coroutine.wrap(function()
			if frame.Position ~= UDim2.new(-0.5, 0, 0.108, 0) then
				frame:TweenPosition(UDim2.new(-0.5, 0, 0.108, 0),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true);	-- Hide
				if not activeFrame then return end
				activeFrame:TweenPosition(activeFrame.Position - UDim2.new(0,frame.Size.X.Offset + 20,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true);
			else
				frame:TweenPosition(UDim2.new(0, 0,0.108, 0),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true);		-- Show
				if not activeFrame then return end
				activeFrame:TweenPosition(activeFrame.Position + UDim2.new(0,frame.Size.X.Offset + 20,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true);
			end
		end)();

		if nav.Visible then

			coreFuncs.rotateInstanceBy(nav, 180);
			nav.Visible = false;
			close.Rotation = nav.Rotation;
			close.Visible = true;
			coreFuncs.rotateInstanceBy(close, 200);

		else

			coreFuncs.rotateInstanceBy(close, 180, nil, true);
			nav.Visible = true;
			nav.Rotation = close.Rotation;
			close.Visible = false;
			coreFuncs.rotateInstanceBy(nav, 200, nil, true);

		end

		coreVars.navDebounce = true;
	end
end

coreFuncs.applyFrameResizingLib = function(scrollingframe)
	local calc = scrollingframe:FindFirstChild("UIGridLayout") or scrollingframe:FindFirstChild("UIListLayout");
	local function update()
		pcall(function()
			local cS = calc.AbsoluteContentSize;
			scrollingframe.CanvasSize = UDim2.new(0,scrollingframe.Size.X,0,cS.Y + 30);
		end)
	end
	calc.Changed:Connect(update);
	update();
end

------------------------------------------------------------------------------
-- coreGUIFuncs definitions

coreGUIFuncs.newCreateGUI = function(name, pos, parent, colors)

	local screenGui = coreFuncs.addInstance("ScreenGui", {
		["Parent"] = parent,
		["Name"] = "EzLib"
	});

	local window = coreFuncs.addInstance("Frame", {
		["Position"] = pos,
		["Name"] = "MainFrame",
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["Size"] = UDim2.new(0, 410, 0, 278),
		["ClipsDescendants"] = true,
		["BorderSizePixel"] = 0,
		["BackgroundColor3"] = colors.Primary,
		["Parent"] = screenGui
	});

	coreFuncs.dragifyLib(window);
	coreFuncs.roundify(window);

	local topFrame = coreFuncs.addInstance("Frame", {
		["Name"] = "TopFrame",
		["BackgroundColor3"] = colors.Tertiary,
		["BorderSizePixel"] = 0,
		["Size"] = UDim2.new(1, 0, 0, 34),
		["ZIndex"] = 3,
		["Parent"] = window
	});

	coreFuncs.roundify(topFrame);

	coreFuncs.addInstance("Frame", {
		["Size"] = UDim2.new(1, 0, 0, 4),
		["AnchorPoint"] = Vector2.new(0, 1),
		["Position"] = UDim2.new(0, 0, 1, 0),
		["BackgroundColor3"] = colors.Tertiary,
		["ZIndex"] = 4,
		["BorderSizePixel"] = 0,
		["Parent"] = topFrame
	})

	coreFuncs.addInstance("TextLabel", {
		["Name"] = "UIName",
		["BackgroundTransparency"] = 1,
		["TextColor3"] = Color3.fromRGB(255,255,255),
		["AnchorPoint"] = Vector2.new(1,0.5),
		["Position"] = UDim2.new(1,-10,0.5,0),
		["Text"] = name,
		["Size"] = UDim2.new(0, 200, 0, 30),
		["TextWrapped"] = true,
		["ZIndex"] = 3,
		["TextXAlignment"] = Enum.TextXAlignment.Right,
		["Parent"] = topFrame
	});

	local closeNav = coreFuncs.addInstance("ImageButton", {
		["Name"] = "CloseNavButton",
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["BorderSizePixel"] = 0,
		["Position"] = UDim2.new(0.05, 0, 0.51, 0),
		["Size"] = UDim2.new(0, 20, 0, 20),
		["Visible"] = false,
		["ZIndex"] = 4,
		["Image"] = "http://www.roblox.com/asset/?id=5969992570",
		["Parent"] = topFrame
	});

	local openNav = coreFuncs.addInstance("ImageButton", {
		["Name"] = "NavButton",
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["BorderSizePixel"] = 0,
		["Position"] = UDim2.new(0.05, 0, 0.51, 0),
		["Size"] = UDim2.new(0, 28, 0, 28),
		["ZIndex"] = 4,
		["Image"] = "http://www.roblox.com/asset/?id=5942241281",
		["Parent"] = topFrame
	});

	local navFrame = coreFuncs.addInstance("ScrollingFrame", {
		["Name"] = "NavFrame",
		["Active"] = true,
		["BackgroundColor3"] = colors.Tertiary,
		["BorderSizePixel"] = 0,
		["Position"] = UDim2.new(-0.5, 0, 0.108000003, 0),
		["ScrollBarThickness"] = 0,
		["Size"] = UDim2.new(0, 130, 1, -34),
		["ZIndex"] = 2,
		["CanvasSize"] = UDim2.new(0, 0, 0, 0),
		["Parent"] = window
	});

	coreFuncs.addInstance("UIGridLayout", {
		["HorizontalAlignment"] = Enum.HorizontalAlignment.Center,
		["SortOrder"] = Enum.SortOrder.LayoutOrder,
		["CellPadding"] = UDim2.new(0, 5, 0, 7),
		["CellSize"] = UDim2.new(0, 95, 0, 25),
		["Parent"] = navFrame
	});

	coreFuncs.addInstance("UIPadding", {
		["PaddingBottom"] = UDim.new(0, 15),
		["PaddingTop"] = UDim.new(0, 20),
		["Parent"] = navFrame
	});

	coreFuncs.applyFrameResizingLib(navFrame);
	return ({["opennav"] = openNav, ["closenav"] = closeNav, ["navframe"] = navFrame, ["screengui"] = screenGui, ["window"] = window});

end

coreGUIFuncs.newTab = function(libInstance, name, colors)

	local button = coreFuncs.addInstance("TextButton", {
		["Text"] = tostring(name),
		["Name"] = tostring(name),
		["BorderSizePixel"] = 0,
		["BackgroundColor3"] = colors.Primary,
		["TextColor3"] = Color3.fromRGB(255,255,255),
		["ZIndex"] = 3,
		["Parent"] = libInstance.MainFrame.NavFrame
	});

	local blueLine = coreFuncs.addInstance("Frame", {
		["BackgroundColor3"] = colors.Quaternary,
		["Size"] = UDim2.new(0, 2, 1, 0),
		["ZIndex"] = 4,
		["Parent"] = button
	});

	coreFuncs.roundify(blueLine, 8);

	local window = coreFuncs.addInstance("ScrollingFrame", {
		["Name"] = tostring(name),
		["BorderSizePixel"] = 0,
		["BackgroundTransparency"] = 1,
		["AnchorPoint"] = Vector2.new(0.5,0.5),
		["Position"] = UDim2.new(0.5,0,2,0),
		["Size"] = UDim2.new(1, 0, 1, -34),
		["ScrollBarImageColor3"] = colors.Tertiary,
		["Parent"] = libInstance.MainFrame
	});

	coreFuncs.addInstance("UIListLayout", {
		["HorizontalAlignment"] = Enum.HorizontalAlignment.Center,
		["SortOrder"] = Enum.SortOrder.LayoutOrder,
		["Padding"] = UDim.new(0, 7),
		["Parent"] = window
	});

	coreFuncs.addInstance("UIPadding", {
		["PaddingBottom"] = UDim.new(0, 15),
		["PaddingTop"] = UDim.new(0, 10),
		["Parent"] = window
	});
	
	coreFuncs.applyFrameResizingLib(window);
	return ({["window"] = window, ["button"] = button});

end

coreGUIFuncs.newButton = function(tabWindow, name, colors)

	local button = coreFuncs.addInstance("TextButton", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = colors.Secondary,
		["BorderSizePixel"] = 0,
		["Size"] = UDim2.new(0, coreVars.elementX, 0, 35),
		["Font"] = Enum.Font.SourceSans,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["Text"] = name,
		["Parent"] = tabWindow
	});

	coreFuncs.roundify(button);
	return ({["button"] = button});

end

coreGUIFuncs.newCheckbox = function(tabWindow, name, state, colors)

	local frame = coreFuncs.addInstance("Frame", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = colors.Secondary,
		["BorderSizePixel"] = 0,
		["Size"] = UDim2.new(0, coreVars.elementX, 0, 35),
		["Parent"] = tabWindow
	});

	coreFuncs.roundify(frame);

	coreFuncs.addInstance("TextLabel", {
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0, 15, 0, 0),
		["Size"] = UDim2.new(0, 153, 0, 35),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = name,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextXAlignment"] = Enum.TextXAlignment.Left,
		["Parent"] = frame
	});

	local toggle = coreFuncs.addInstance("TextButton", {
		["AnchorPoint"] = Vector2.new(1, 0.5),
		["BackgroundColor3"] = Color3.fromRGB(149, 0, 0),
		["BorderSizePixel"] = 0,
		["Position"] = UDim2.new(1, -10, 0.5, 0),
		["Size"] = UDim2.new(0, 20, 0, 20),
		["AutoButtonColor"] = false,
		["Font"] = Enum.Font.SourceSans,
		["Text"] = "",
		["TextColor3"] = Color3.fromRGB(255, 0, 0),
		["TextSize"] = 14.000,
		["Parent"] = frame
	});

	coreFuncs.roundify(toggle);
	if state then
		toggle.BackgroundColor3 = Color3.fromRGB(0, 149, 74);
	end
	return ({["toggle"] = toggle, ["frame"] = frame});

end

coreGUIFuncs.newSlider = function(tabWindow, name, default, min, max, colors)
	
	default = math.floor(math.clamp(default, min, max) or min + 0.5)

	local frame = coreFuncs.addInstance("Frame", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = colors.Secondary,
		["BorderSizePixel"] = 0,
		["Size"] = UDim2.new(0, coreVars.elementX, 0, 62),
		["Parent"] = tabWindow
	});

	coreFuncs.roundify(frame);

	local sliderFrame = coreFuncs.addInstance("Frame", {
		["BackgroundColor3"] = colors.Primary,
		["Position"] = UDim2.new(0, 15, 0.677419364, 0),
		["Size"] = UDim2.new(1, -31, 0, 4),
		["Parent"] = frame
	});

	local indicator = coreFuncs.addInstance("Frame", {
		["Name"] = "Indicator",
		["AnchorPoint"] = Vector2.new(0, 0.5),
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["Position"] = UDim2.new(0, 0, 0.5, 0),
		["Size"] = UDim2.new(0, 12, 0, 12),
		["Parent"] = sliderFrame
	});

	local indicatorTrail = coreFuncs.addInstance("Frame", {
		["Name"] = "Indicator",
		["AnchorPoint"] = Vector2.new(0, 0.5),
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["Position"] = UDim2.new(0, 0, 0.5, 0),
		["Size"] = UDim2.new(0, 0, 1, 0),
		["BorderSizePixel"] = 0,
		["Parent"] = sliderFrame
	});

	coreFuncs.addInstance("TextLabel", {
		["Name"] = "Value",
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0, 15, 0, 0),
		["Size"] = UDim2.new(0, 153, 0, 35),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = name,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextXAlignment"] = Enum.TextXAlignment.Left,
		["Parent"] = frame
	});

	local valueDisplay = coreFuncs.addInstance("TextLabel", {
		["Name"] = "ValueDisplayer",
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["AnchorPoint"] = Vector2.new(1, 0);
		["Position"] = UDim2.new(1, -15, 0, 0),
		["Size"] = UDim2.new(0, 48, 0, 35),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = 0,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextWrapped"] = true,
		["TextXAlignment"] = Enum.TextXAlignment.Right,
		["Parent"] = frame
	});

	coreFuncs.roundify(indicator, 8);
	coreFuncs.roundify(indicatorTrail, 8);
	coreFuncs.roundify(sliderFrame, 8);

	valueDisplay.Text = default;
	indicator.Position = UDim2.new((default - min)/(max - min), 0, 0.5, 0);
	indicatorTrail.Size = UDim2.new((default - min)/(max - min), 0, 0.5, 0);
	return ({["indicator"] = indicator, ["indicatortrail"] = indicatorTrail, ["valuedisplay"] = valueDisplay, ["sliderframe"] = sliderFrame});

end

coreGUIFuncs.newKeybind = function(tabWindow, name, state, colors)

	local frame = coreFuncs.addInstance("Frame", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = colors.Secondary,
		["BorderSizePixel"] = 0,
		["Size"] = UDim2.new(0, coreVars.elementX, 0, 35),
		["Parent"] = tabWindow
	});

	local textLabel = coreFuncs.addInstance("TextLabel", {
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0, 15, 0, 0),
		["Size"] = UDim2.new(0, 153, 0, 35),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = name,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextXAlignment"] = Enum.TextXAlignment.Left,
		["Parent"] = frame
	});

	local button = coreFuncs.addInstance("TextButton", {
		["AnchorPoint"] = Vector2.new(1, 0.5),
		["BackgroundColor3"] = colors.Primary,
		["BorderSizePixel"] = 0,
		["Position"] = UDim2.new(1, -10, 0.5, 0),
		["Size"] = UDim2.new(0, 87, 0, 20),
		["AutoButtonColor"] = false,
		["Font"] = Enum.Font.SourceSans,
		["Text"] = state.Name,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["Parent"] = frame
	});

	return ({["textlabel"] = textLabel, ["button"] = button, ["frame"] = frame});

end

coreGUIFuncs.newDropdown = function(tabWindow, dropdownContainer, name, colors, mainGUI)

	local frame = coreFuncs.addInstance("Frame", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = colors.Secondary,
		["BorderSizePixel"] = 0,
		["Size"] = UDim2.new(0, coreVars.elementX, 0, 35),
		["Parent"] = tabWindow
	});

	coreFuncs.addInstance("TextLabel", {
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0, 15, 0, 0),
		["Size"] = UDim2.new(0, 153, 0, 35),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = name,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextWrapped"] = true,
		["TextXAlignment"] = Enum.TextXAlignment.Left,
		["Parent"] = frame
	});

	local toggle = coreFuncs.addInstance("TextButton", {
		["AnchorPoint"] = Vector2.new(1, 0.5),
		["BackgroundColor3"] = colors.Primary,
		["BorderSizePixel"] = 0,
		["Position"] = UDim2.new(1, -10, 0.5, 0),
		["Size"] = UDim2.new(0, 90, 0, 20),
		["AutoButtonColor"] = false,
		["Font"] = Enum.Font.SourceSans,
		["Text"] = name,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 12.000,
		["Parent"] = frame
	});

    coreFuncs.roundify(toggle);

	-------------------------------------
	-- Actual dropdown instance

	local mainFrame = coreFuncs.addInstance("Frame", {
		["Size"] = UDim2.new(0, 168, 0, 0),	-- Y is mainGUI.window.Size.Y.Offset when open
		["Position"] = UDim2.new(0.335396051, 0, 0.367346942, 0),
		["BorderSizePixel"] = 0,
		["Visible"] = false,
		["BackgroundColor3"] = colors.Primary,
		["ClipsDescendants"] = true;
		["Parent"] = dropdownContainer
	});

    coreFuncs.roundify(mainFrame);

	local topFrame = coreFuncs.addInstance("Frame", {
		["Name"] = "TopFrame",
		["BackgroundColor3"] = colors.Tertiary,
		["BorderSizePixel"] = 0,
		["Size"] = UDim2.new(1, 0, 0, 34),
		["ZIndex"] = 3,
		["Parent"] = mainFrame
	})

	coreFuncs.addInstance("TextLabel", {
		["Name"] = "UIName",
		["BackgroundTransparency"] = 1,
		["TextColor3"] = Color3.fromRGB(255,255,255),
		["AnchorPoint"] = Vector2.new(0.5,0.5),
		["Position"] = UDim2.new(0.5,0,0.5,0),
		["Text"] = name,
		["Size"] = UDim2.new(0, 200, 0, 30),
		["TextWrapped"] = true,
		["ZIndex"] = 3,
		["Parent"] = topFrame
	});

	coreFuncs.roundify(mainFrame, 4);

	local mainScrollingFrame = coreFuncs.addInstance("ScrollingFrame", {
		["Name"] = "MainScrollingFrame",
		["Parent"] = mainFrame,
		["Active"] = true,
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = colors.Primary,
		["BackgroundTransparency"] = 1.000,
		["BorderSizePixel"] = 0,
		["Position"] = UDim2.new(0.5, 0, 0.5, 20),
		["Size"] = UDim2.new(1, -10, 1, -50),
		["ScrollBarThickness"] = 0,
		["ScrollBarImageColor3"] = Color3.fromRGB(colors.Tertiary.R + 5, colors.Tertiary.G + 5, colors.Tertiary.B + 5),
		["VerticalScrollBarPosition"] = Enum.VerticalScrollBarPosition.Left,
	});

	coreFuncs.addInstance("UIPadding", {
		["Parent"] = mainScrollingFrame,
		["PaddingBottom"] = UDim.new(0, 10),
		["PaddingLeft"] = UDim.new(0, 5),
		["PaddingTop"] = UDim.new(0, 5)
	});

	coreFuncs.addInstance("UIListLayout", {
		["Parent"] = mainScrollingFrame,
		["HorizontalAlignment"] = Enum.HorizontalAlignment.Center,
		["SortOrder"] = Enum.SortOrder.LayoutOrder,
		["Padding"] = UDim.new(0, 4)
	});

	coreFuncs.applyFrameResizingLib(mainScrollingFrame);
	return ({["mainframe"] = mainFrame, ["mainscrollingframe"] = mainScrollingFrame, ["toggle"] = toggle, ["frame"] = frame});

end

coreGUIFuncs.newTextbox = function(tabWindow, name, state, colors)

	local frame = coreFuncs.addInstance("Frame", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = colors.Secondary,
		["BorderSizePixel"] = 0,
		["Size"] = UDim2.new(0, coreVars.elementX, 0, 35),
		["Parent"] = tabWindow
	});

	coreFuncs.roundify(frame);
	
	coreFuncs.addInstance("TextLabel", {
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0, 15, 0, 0),
		["Size"] = UDim2.new(0, 116, 0, 35),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = name or "",
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextXAlignment"] = Enum.TextXAlignment.Left,
		["Parent"] = frame
	});
	
	local textbox = coreFuncs.addInstance("TextBox", {
		["AnchorPoint"] = Vector2.new(1, 0.5),
		["BackgroundColor3"] = colors.Primary,
		["BorderSizePixel"] = 0,
		["Position"] = UDim2.new(1, -10, 0.5, 0),
		["Size"] = UDim2.new(0, 88, 0, 21),
		["Font"] = Enum.Font.SourceSans,
		["PlaceholderText"] = "Click to type...",
		["Text"] = state or "",
		["TextColor3"] = Color3.fromRGB(255,255,255),
		["TextSize"] = 12.000,
		["Parent"] = frame
	});
	
	coreFuncs.roundify(textbox);

	return ({["textbox"] = textbox, ["frame"] = frame});

end

coreGUIFuncs.newDiv = function(tabWindow, colors)
	
	local spacebox = coreFuncs.addInstance("Frame", {
		["Name"] = "SpaceBox",
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0, 0, 0.10204082, 0),
		["Size"] = UDim2.new(1, 0, 0, 25),
		["Parent"] = tabWindow
	});

	local div = coreFuncs.addInstance("TextLabel", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = colors.Tertiary,
		["Position"] = UDim2.new(0.5, 0, 0.5, 0),
		["Size"] = UDim2.new(0, coreVars.elementX + 10, 0, 5),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = "",
		["TextColor3"] = Color3.fromRGB(0, 0, 0),
		["TextSize"] = 14.000,
		["Parent"] = spacebox
	});

	coreFuncs.roundify(div, 15);

	return ({["spacebox"] = spacebox});

end

coreGUIFuncs.newDesc = function(tabWindow, name)

	local spacebox = coreFuncs.addInstance("Frame", {
		["Name"] = "SpaceBox",
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0, 0, 0.10204082, 0),
		["Size"] = UDim2.new(1, 0, 0, 35),
		["Parent"] = tabWindow
	});

	coreFuncs.addInstance("TextLabel", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0.5, 5, 0.5, 0),
		["Size"] = UDim2.new(0, coreVars.elementX, 0, 31),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = name or "Description",
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextXAlignment"] = Enum.TextXAlignment.Left,
		["Parent"] = spacebox
	});

	return ({["spacebox"] = spacebox});

end

coreGUIFuncs.newTitle = function(tabWindow, name)
	
	local spacebox = coreFuncs.addInstance("Frame", {
		["Name"] = "SpaceBox",
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0, 0, 0.10204082, 0),
		["Size"] = UDim2.new(1, 0, 0, 23),
		["Parent"] = tabWindow
	});

	coreFuncs.addInstance("TextLabel", {
		["AnchorPoint"] = Vector2.new(0.5, 0.5),
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0.5, 5, 0.5, 0),
		["Size"] = UDim2.new(0, coreVars.elementX, 1, 0),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = name or "Title",
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 18.000,  
		["TextXAlignment"] = Enum.TextXAlignment.Left,
		["Parent"] = spacebox
	});

	return ({["spacebox"] = spacebox});

end

coreGUIFuncs.newNotifText = function(longText, text, parent, colors)

	local frame = coreFuncs.addInstance("Frame", {
		["Parent"] = parent,
		["AnchorPoint"] = Vector2.new(0, 1),
		["BackgroundColor3"] = colors.Primary,
		["Position"] = UDim2.new(0, -210, 1, -10),	-- Hidden position (when shown it should be 0, 10, 1, -10)
		["Size"] = UDim2.new(0, 200, 0, longText and 90 or 40)
	});
	
	coreFuncs.roundify(frame, 4);
	
	local textLabel = coreFuncs.addInstance("TextLabel", {
		["Parent"] = frame,
		["AnchorPoint"] = Vector2.new(0.5, 0),
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0.5, 0, 0, 0),
		["Size"] = UDim2.new(1, -20, 1, 0),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = text,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextWrapped"] = true
	});

	return ({["frame"] = frame, ["textlabel"] = textLabel});

end

coreGUIFuncs.newNotifButton = function(text, buttonLT, buttonRT, parent, colors)

	local frame = coreFuncs.addInstance("Frame", {
		["Parent"] = parent,
		["AnchorPoint"] = Vector2.new(0, 1),
		["BackgroundColor3"] = colors.Primary,
		["Position"] = UDim2.new(0, -210, 1, -10),	-- Hidden position (when shown it should be 0, 10, 1, -10)
		["Size"] = UDim2.new(0, 200, 0, 90)
	});
	
	coreFuncs.roundify(frame, 4);
	
	local textLabel = coreFuncs.addInstance("TextLabel", {
		["Parent"] = frame,
		["AnchorPoint"] = Vector2.new(0.5, 0),
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		["BackgroundTransparency"] = 1.000,
		["Position"] = UDim2.new(0.5, 0, 0, 8),
		["Size"] = UDim2.new(1, -20, 0, 45),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = text,
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000,
		["TextWrapped"] = true
	});

	local buttonL = coreFuncs.addInstance("TextButton", {
		["Name"] = "ButtonL",
		["Parent"] = frame,
		["AnchorPoint"] = Vector2.new(0, 0.5),
		["BackgroundColor3"] = colors.Secondary,
		["Position"] = UDim2.new(0, 10, 1, -25),
		["Size"] = UDim2.new(0.5, -13, 0.5, -20),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = buttonLT or "Yes",
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000
	});

	local buttonR = coreFuncs.addInstance("TextButton", {
		["Name"] = "ButtonL",
		["Parent"] = frame,
		["AnchorPoint"] = Vector2.new(1, 0.5),
		["BackgroundColor3"] = colors.Secondary,
		["Position"] = UDim2.new(1, -10, 1, -25),
		["Size"] = UDim2.new(0.5, -13, 0.5, -20),
		["Font"] = Enum.Font.SourceSans,
		["Text"] = buttonRT or "Yes",
		["TextColor3"] = Color3.fromRGB(255, 255, 255),
		["TextSize"] = 14.000
	});

	coreFuncs.roundify(buttonL);
	coreFuncs.roundify(buttonR);
	return ({["frame"] = frame, ["textlabel"] = textLabel, ["buttonl"] = buttonL, ["buttonr"] = buttonR});

end

------------------------------------------------------------------------------
-- "Template" like class for interactable elements (ex. button, slider, checkbox)

local interactableElements = {};
interactableElements.new = function()
	local self = {};

	-- Not sure why you would want to use this but I made it available
	self.changeCallback = function(callback)
		error("Pure Virtual Function");
	end

	-- Fires callback associated with the element
	self.fireCallback = function(...)
		error("Pure Virtual Function");
	end

	-- Changes text description of each element
	self.changeText = function(text)
		error("Pure Virtual Function");
	end

	-- NOTE: THE BELOW TWO FUNCTIONS MAY BE CONFUSING.
	-- YOU CAN REMEMBER IT THIS WAY. ANY API CALLS THAT REQUIRE
	-- YOU TO PASS IN AN ELEMENT, YOU WILL HAVE TO USE getMainInstance
	-- GETINSTANCE IS NOT USED FOR ANYTHING IN THE API. IT'S SIMPLY SOMETHING
	-- YOU CAN USE TO EDIT YOUR GUI EXTENSIVELY

	-- Returns the main instance that holds an array
	-- of locations of essential instances. No real use for this for the user
	self.getMainInstance = function()
		error("Pure Virtual Function");
	end

	-- Returns the most relevant parent instance in case you want to make any manual adjustments
	-- Make sure that you know what it is returning as it is different for each element
	-- Also make sure that you know how the hierarchy of the instance works before
	-- accessing any of its children
	self.getInstance = function()
		error("Pure Virtual Function");
	end

	-- I personally don't recommend using this function
	-- Avoid it as much as you can as it will cause errors if you
	-- attempt to call one of it's functions again later down your code
	-- treat it like how you would treat raw pointers in cpp as an example
	-- so if you do use it, be cautious with it.
	self.delete = function()
		error("Pure Virtual Function");
	end

	-----------------------------------------
	-- State related methods

	-- Returns state of a valid element
	-- does not work on buttons.
	self.getState = function() error("getState not defined for element") end;
	
	-- This method will not fire the callback function
	-- If you want to fire callback, checkbox.fireCallback() after
	-- changing state.
	self.setState = function() error("setState not defined for element") end;

	return self;
end

------------------------------------------------------------------------------
-- ezlib.enum

ezlib.enum = {
	notifType = {
		text = 0,
		longText = 1,
		buttons = 2
	},
	button = {
		left = 0,
		right = 1
	},
	theme = {
		default = {
			Primary = Color3.fromRGB(41, 53, 68),
			Secondary = Color3.fromRGB(35, 47, 62),
			Tertiary = Color3.fromRGB(28, 41, 56),
			Quaternary = Color3.fromRGB(18, 98, 159)
		}
	}
};

------------------------------------------------------------------------------
-- ezlib.create and newNotification Class

coreVars.activeNotification = nil;
coreVars.notificationHolder = Instance.new("ScreenGui", game.CoreGui);
ezlib.newNotif = function(notifType, text, buttonLT, buttonRT, buttonLC, buttonRC, theme)
	local notif = {};
	notif.notifType = notifType;
	local notifInstance;

	theme = theme or coreVars.colors;

	if notif.notifType == ezlib.enum.notifType.text then
		notifInstance = coreGUIFuncs.newNotifText(false, text, coreVars.notificationHolder, theme);
	elseif notif.notifType == ezlib.enum.notifType.longText then
		notifInstance = coreGUIFuncs.newNotifText(true, text, coreVars.notificationHolder, theme);
	elseif notif.notifType == ezlib.enum.notifType.buttons then
		notif.callbackL = buttonLC or function() end;
		notif.callbackR = buttonRC or function() end;
		notifInstance = coreGUIFuncs.newNotifButton(text, buttonLT, buttonRT, coreVars.notificationHolder, theme);
		notifInstance.buttonl.MouseButton1Click:Connect(function()
			notif.buttonLeftClicked:Fire();
			notif.buttonClicked:Fire();
			notif.fireCallback(ezlib.enum.button.left);
		end)
		notifInstance.buttonr.MouseButton1Click:Connect(function() 
			notif.buttonRightClicked:Fire();
			notif.buttonClicked:Fire();
			notif.fireCallback(ezlib.enum.button.right);
		end)
	else
		error("Invalid parameter for newNotification");
	end

	notif.fireCallback = function(button)
		if button == ezlib.enum.button.left then
			notif.callbackL();
		elseif button == ezlib.enum.button.right then
			notif.callbackR();
		end
	end

	notif.changeCallback = function(button, callback)
		if button == ezlib.enum.button.left then
			notif.buttonLC = callback;
		elseif button == ezlib.enum.button.right then
			notif.buttonRC = callback;
		end
	end

	notif.show = function()
		local continueFunc = false;

		if coreVars.activeNotification then
			coreVars.activeNotification.hide();
		end

		coreVars.activeNotification = notif;
		notifInstance.frame:TweenPosition(UDim2.new(0, 10, 1, -10), nil, nil, nil, true, function()
			continueFunc = true;
		end);
		repeat wait() until continueFunc;
		return notif;
	end

	notif.hide = function()
		local continueFunc = false;
		coreVars.activeNotification = nil;

		notifInstance.frame:TweenPosition(UDim2.new(0, -210, 1, -10), nil, nil, nil, true, function()
			continueFunc = true;
		end);
		repeat wait() until continueFunc;
		return notif;
	end

	local playDebounce = true;
	notif.play = function(delay)
		if not playDebounce then return false end
		playDebounce = false;

		notif.show();
		wait(delay or 5);
		notif.hide();

		playDebounce = true;
		return notif;	-- This is so that you can do something like ezlib.newNotif(...).play().delete();
	end

	-- play on seperate thread won't return instance after it finishes because
	-- of how threads work (common sense)
	-- To do the notif.play().delete() strategy, you can wrap
	-- notif.play().delete() in a seperate thread yourself instead of using the one below
	notif.playOnSeperateThread = function(delay)
		coroutine.wrap(function() notif.play(delay) end)();
	end

	-- I recommend that you just make a new notification container for every
	-- Notification that you require to make it more clean
	-- This function is only included to provide the user with more flexibility
	notif.changeText = function(text)
		notifInstance.textlabel.Text = text;
	end

	notif.delete = function()
		notifInstance.frame:Destroy();
	end

	-- Event handling for notif.buttonClicked - Only applies to ezlib.enum.notifType.buttons
	notif.buttonRightClicked = Instance.new("BindableEvent");
	notif.buttonLeftClicked = Instance.new("BindableEvent");
	notif.buttonClicked = Instance.new("BindableEvent");

	return notif;
end

ezlib.create = function(name, parent, pos, theme, gameID, deleteOldGUI)
	local create = {};

	-- Format parameters so no errors occcur.
	name = name or "Ez Hub";
	parent = parent or game.CoreGui;
	pos = pos or UDim2.new(0.5, 0, 0.5, 0);
	theme = theme or coreVars.colors;	-- themes. For coloring the gui differently
	if deleteOldGUI == nil then deleteOldGUI = true; end
	if deleteOldGUI then
		for i,v in pairs(game.CoreGui:GetChildren()) do
			if v.Name == "EzLib" then v:Destroy(); end
			if v.Name == "dropdownContainer" then v:Destroy(); end
		end
		for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
			if v.Name == "EzLib" then v:Destroy(); end
			if v.Name == "dropdownContainer" then v:Destroy(); end
		end
	end

	if gameID and gameID ~= game.PlaceId then
		local continueAnyway;
		local notif = ezlib.newNotif(ezlib.enum.notifType.buttons, "Incompatible game for GUI. Continue anyway?", "Yes", "No",
			function() continueAnyway = true; end,
			function() continueAnyway = false; end);

		notif.show();
		notif.buttonClicked.Event:Wait();
		notif.hide();

		if not continueAnyway then return end
	end
	
	-- Storing states of the GUI
	local tabs = {};	-- tab container. Holds all tab objects
	local activeTab;	-- keeps track of the tab that is open
	getgenv().togglegui = Enum.KeyCode.RightShift;	-- the keybind that toggles the gui
	local dropdownContainer = Instance.new("ScreenGui", game.CoreGui);
	dropdownContainer.Name = "dropdownContainer";
	local activeDropdown;
	local dropdownDebounce = true;

	-- Create main GUI and handle events
	local mainGUI = coreGUIFuncs.newCreateGUI(name, pos, parent, theme);
	if _G.EzHubExclusives and type(_G.EzHubExclusives) == "table" then
		table.insert(_G.EzHubExclusives, mainGUI.screengui);
	end

	mainGUI.opennav.MouseButton1Click:Connect(function() coreFuncs.handleNavLib(mainGUI.navframe, mainGUI.opennav, mainGUI.closenav, activeTab) end)
	mainGUI.closenav.MouseButton1Click:Connect(function() coreFuncs.handleNavLib(mainGUI.navframe, mainGUI.opennav, mainGUI.closenav, activeTab) end)

	-- For toggling
	game:GetService("UserInputService").InputBegan:Connect(function(input, gameprocess)
		if input.KeyCode == getgenv().togglegui and (not gameprocess) then
			mainGUI.screengui.Enabled = not mainGUI.screengui.Enabled;
		end
	end)

	-- Creates new tab
	create.newTab = function(name)
		local tab = {};
		tab.name = name;

		local tabInstance = coreGUIFuncs.newTab(mainGUI.screengui, name, theme);
		table.insert(tabs, 1, tab)
		tabInstance.button.MouseButton1Click:Connect(function()
			create.openTab(tab);
		end)

		tab.newButton = function(name, callback)
			local button = interactableElements.new();
			button.callback = callback;

			local buttonInstance = coreGUIFuncs.newButton(tabInstance.window, name, theme);
			buttonInstance.button.MouseButton1Click:Connect(function() button.fireCallback() end);

			button.changeCallback = function(callback)
				button.callback = callback;
			end

			button.fireCallback = function(...)
				button.callback(...);
			end
			
			button.changeText = function(text)
				button.button.Text = text or "Button";
			end

			button.getMainInstance = function()
				return buttonInstance;
			end

			button.getInstance = function()
				return buttonInstance.button;
			end

			button.delete = function()
				button.getInstance():Destroy();
			end

			return button;
		end

		tab.newSlider = function(name, state, min, max, callback)
			local slider = interactableElements.new();
			slider.min = min;
			slider.max = max;
			slider.callback = callback;
			slider.state = state;

			local sliderInstance = coreGUIFuncs.newSlider(tabInstance.window, name, state, min, max, theme);
			sliderInstance.indicator.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					coreVars.usingSlider = true;
					coreVars.sliderUsed = sliderInstance;
				end
			end)
			sliderInstance.indicator.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					coreVars.usingSlider = false;
					coreVars.sliderUsed = nil;
				end
			end)
		
			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and coreVars.sliderUsed == sliderInstance then
					local pos = UDim2.new(math.clamp((input.Position.X - sliderInstance.sliderframe.AbsolutePosition.X) / sliderInstance.sliderframe.AbsoluteSize.X, 0, 1), 0, 0.5, 0);
					sliderInstance.indicator:TweenPosition(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true);
					sliderInstance.indicatortrail:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true);
					slider.state = math.floor(((pos.X.Scale * max) / max) * (max - min) + min);
					sliderInstance.valuedisplay.Text = tostring(slider.state);
					coroutine.wrap(function()
						pcall(function()
							slider.fireCallback(slider.state);
						end)
					end)();
				end
			end)

			slider.changeCallback = function(callback)
				slider.callback = callback;
			end
			
			slider.fireCallback = function(...)
				slider.callback(...);
			end

			slider.changeText = function(text)
				sliderInstance.sliderframe.Parent.TextLabel = text;
			end

			slider.getMainInstance = function()
				return sliderInstance;
			end

			slider.getInstance = function()
				return sliderInstance.sliderframe.Parent;
			end

			slider.delete = function()
				slider.getInstance():Destroy();
			end

			-----------------------------------------
			-- State related methods

			slider.getState = function()
				return slider.state;
			end

			slider.setState = function(state)
				slider.state = state;
				sliderInstance.indicator.Position = UDim2.new((state - min)/(max - min), 0, 0.5, 0);
				sliderInstance.indicatortrail.Size = UDim2.new((state - min)/(max - min), 0, 0.5, 0);
			end

			return slider;
		end

		tab.newCheckbox = function(name, state, callback)
			local checkbox = interactableElements.new();
			checkbox.callback = callback;
			checkbox.state = state;

			local checkboxInstance = coreGUIFuncs.newCheckbox(tabInstance.window, name, state, theme);
			checkboxInstance.toggle.MouseButton1Click:Connect(function()
				checkbox.setState(not checkbox.state);
				checkbox.fireCallback(checkbox.state);
			end)

			checkbox.changeCallback = function(callback)
				checkbox.callback = callback;
			end

			checkbox.fireCallback = function(...)
				checkbox.callback(...);
			end

			checkbox.changeText = function(text)
				checkboxInstance.frame.TextLabel.Text = text;
			end

			checkbox.getMainInstance = function()
				return checkboxInstance;
			end

			checkbox.getInstance = function()
				return checkboxInstance.frame;
			end

			checkbox.delete = function()
				checkbox.getInstance():Destroy();
			end

			-----------------------------------------
			-- State related methods

			checkbox.getState = function()
				return checkbox.state;
			end

			checkbox.setState = function(state)
				if state then
					game:GetService("TweenService"):Create(checkboxInstance.toggle, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(0, 149, 74)}):Play();
				else
					game:GetService("TweenService"):Create(checkboxInstance.toggle, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(149, 0, 0)}):Play();
				end
				checkbox.state = state;
			end

			return checkbox;
		end

		tab.newDropdown = function(name, state, data, callback, closeAfterButtonPress)
			-- This section checks to see if data is an array or a vector (dictionary)
			-- If it is a vec, it will count the i-th value only
			local isVector = function(data)
				local i = 0;
				for _,v in pairs(data) do
					i = i + 1;
					if data[i] == nil then return true end
				end
				return false;
			end

			local dropdown = interactableElements.new();
			dropdown.callback = callback;

			-- Makes sure that data is always a regular array.
			-- A vector will mess things up
			dropdown.data = isVector(data) and
			(function()
				local t = {};
				for i,v in pairs(data) do
					table.insert(t, 1, i);
				end
				return t;
			end)() or data;

			dropdown.state = state;
			dropdown.isOpen = false;

			if closeAfterButtonPress == nil then closeAfterButtonPress = true end

			local dropdownInstance = coreGUIFuncs.newDropdown(tabInstance.window, dropdownContainer, name, theme, mainGUI);
			dropdownInstance.toggle.Text = dropdown.state;

			-- For a nice effect when the dropdown opens and closes
			local function handleDropdownTransparency(transparencyLevel)
				for i,v in pairs(dropdown.getMainInstance().mainframe:GetChildren()) do
					if v:IsA("GuiObject") then 
						game:GetService("TweenService"):Create(v, TweenInfo.new(0.25), {BackgroundTransparency = transparencyLevel}):Play();
						if pcall(function() local _ = v.Text end) then
							game:GetService("TweenService"):Create(v, TweenInfo.new(0.25), {TextTransparency = transparencyLevel}):Play();
						end
					end
				end
			end

			-- Only clears out the gui elements.
			-- Does not actually clear out the dropdown.data
			local function clearData()
				for i,v in pairs(dropdownInstance.mainscrollingframe:GetChildren()) do
					if v:IsA("TextButton") then
						v:Destroy();
					end
				end
			end
			
			-- Same with this function. Does not overwrite dropdown.data
			-- Only takes care of GUI elements
			local function updateData()
				clearData();
				for _,v in pairs(dropdown.data) do
					local btn = coreFuncs.addInstance("TextButton", {
						["Parent"] = dropdownInstance.mainscrollingframe,
						["BackgroundColor3"] = theme.Secondary,
						["BorderSizePixel"] = 0,
						["Size"] = UDim2.new(1, -20, 0, 30),
						["Font"] = Enum.Font.SourceSans,
						["TextColor3"] = Color3.fromRGB(255, 255, 255),
						["Text"] = tostring(v),
						["TextSize"] = 14.000
					})
					btn.MouseButton1Click:Connect(function()
						dropdown.changeState(btn.Text);
						dropdown.fireCallback(btn.Text);
						if closeAfterButtonPress then dropdown.hideDropdown() end;
					end)
				end
			end
			updateData();
			
			dropdownInstance.toggle.MouseButton1Click:Connect(function()
				
				if not dropdownDebounce then return end
				dropdownDebounce = false;

				if dropdown.isOpen then
					dropdown.hideDropdown();
				else
					dropdown.showDropdown();
				end

				dropdownDebounce = true;

			end)
				

			dropdown.showDropdown = function()

				-- Close all other open dropdows
				if activeDropdown and activeDropdown ~= dropdown then
					activeDropdown.hideDropdown();
				end

				dropdown.getMainInstance().mainframe.Visible = true;
				-- Add a connection that will be update the position of the drop down menu so that it is
				-- next to main panel at all times
				dropdown.movementConnection = game:GetService("RunService").RenderStepped:Connect(function()
					local position = mainGUI.window.Position + UDim2.new(0, (mainGUI.window.Size.X.Offset / 2) + 5, 0, -(mainGUI.window.Size.Y.Offset / 2));
					dropdownInstance.mainframe.Position = position;
				end)

				-- Animation that opens the dropdown
				handleDropdownTransparency(1);
				local tweenDone = false;
				dropdown.getMainInstance().mainframe:TweenSize(UDim2.new(0, 168, 0, mainGUI.window.Size.Y.Offset), nil, Enum.EasingStyle.Linear, 0.5, true, function()
			        tweenDone = true;
				end);
				repeat wait() until tweenDone;
				handleDropdownTransparency(0);

				dropdown.isOpen = true;
				activeDropdown = dropdown;
			
			end

			dropdown.hideDropdown = function()

				handleDropdownTransparency(1);
				local tweenDone = false;
				dropdown.getMainInstance().mainframe:TweenSize(UDim2.new(0, 168, 0, 0), nil, Enum.EasingStyle.Linear, 0.5, true, function()
					tweenDone = true;
				end);
				repeat wait() until tweenDone;

				dropdown.getMainInstance().mainframe.Visible = false;
				if dropdown.movementConnection then dropdown.movementConnection:Disconnect(); end
				dropdown.isOpen = false;

				if activeDropdown == dropdown then
					activeDropdown = nil;
				end

			end

			dropdown.changeCallback = function(callback)
				dropdown.callback = callback;
			end

			dropdown.fireCallback = function(...)
				dropdown.callback(...);
			end

			dropdown.changeText = function(text)
				dropdownInstance.mainframe.Name.Text = text;
			end

			dropdown.changeData = function(data)
				dropdown.data = isVector(data) and
				(function()
					local t = {};
					for i,v in pairs(data) do
						table.insert(t, 1, i);
					end
					return t;
				end)() or data;
				updateData();
			end

			dropdown.getData = function()
				return dropdown.data;
			end

			dropdown.changeState = function(state)
				dropdown.state = state;
				dropdownInstance.toggle.Text = dropdown.state;
			end

			dropdown.getState = function()
				return dropdown.state;
			end

			dropdown.getMainInstance = function()
				return dropdownInstance;
			end

			dropdown.getInstance = function()
				return ({dropdownInstance.frame, dropdownInstance.mainframe});
			end

			dropdown.delete = function()
				dropdown.getInstance()[1]:Destroy();
				dropdown.getInstance()[2]:Destroy();
			end

			return dropdown;
		end

		tab.newTextbox = function(name, state, callback)
			local textbox = interactableElements.new();
			textbox.callback = callback;
			textbox.state = state;

			local textboxInstance = coreGUIFuncs.newTextbox(tabInstance.window, name, state, theme);
			textboxInstance.textbox:GetPropertyChangedSignal("Text"):Connect(function()
				textbox.state = textboxInstance.textbox.Text;
				textbox.fireCallback(textboxInstance.textbox.Text);
			end)

			textbox.changeCallback = function(callback)
				textbox.callback = callback;
			end

			textbox.fireCallback = function(...)
				textbox.callback(...);
			end

			textbox.changeText = function(text)
				textboxInstance.textbox.Text = text;
			end

			textbox.getMainInstance = function()
				return textboxInstance;
			end

			textbox.getInstance = function()
				return textboxInstance.frame;
			end

			textbox.delete = function()
				textbox.getInstance():Destroy();
			end
			
			-----------------------------------------
			-- State related methods

			textbox.getState = function()
				return textbox.state;
			end

			textbox.setState = function(text)
				textbox.changeText(text);
			end

			return textbox;
		end

		tab.newKeybind = function(name, state, callback)
			local keybind = interactableElements.new();
			keybind.callback = callback;
			keybind.state = state or Enum.KeyCode.A;		

			local keybindInstance = coreGUIFuncs.newKeybind(tabInstance.window, name, state, theme);
			local keybindDebounce = true;
			keybindInstance.button.MouseButton1Click:Connect(function()
				if not keybindDebounce then return end
				keybindDebounce = false;
				coreVars.awaitingInput = keybindInstance;
				keybindInstance.button.Text = "Press key";
				repeat wait() until not coreVars.awaitingInput and keybindInstance.button.Text ~= "Press Key";
				keybind.state = Enum.KeyCode[keybindInstance.button.Text];
				keybind.fireCallback(keybind.state);
				keybindDebounce = true;
			end)

			keybind.changeCallback = function(callback)
				keybind.callback = callback;
			end

			keybind.fireCallback = function(...)
				keybind.callback(...);
			end

			keybind.changeText = function(text)
				keybindInstance.textlabel.Text = text;
			end

			keybind.getMainInstance = function()
				return keybindInstance;
			end

			keybind.getInstance = function()
				return keybindInstance.frame;
			end

			keybind.delete = function()
				keybind.getInstance():Destroy();
			end

			-----------------------------------------
			-- State related methods

			keybind.getState = function()
				return keybind.state;
			end

			keybind.setState = function(state)
				keybindInstance.button.Text = state.Name;
			end

			return keybind;
		end

		tab.newTitle = function(name)
			local title = {};

			local titleInstance = coreGUIFuncs.newTitle(tabInstance.window, name);
			
			title.changeText = function(text)
				titleInstance.spacebox.TextLabel.Text = text;
			end

			title.getMainInstance = function()
				return titleInstance;
			end

			title.getInstance = function()
				return titleInstance.spacebox;
			end

			title.delete = function()
				title.getInstance():Destroy();
			end

			return title;
		end

		tab.newDiv = function()
			local div = {};

			local divInstance = coreGUIFuncs.newDiv(tabInstance.window, theme);

			div.getMainInstance = function()
				return divInstance;
			end

			div.getInstance = function()
				return divInstance.spacebox;
			end

			div.delete = function()
				div.getInstance():Destroy();
			end

			return div;
		end

		tab.newDesc = function(name)
			local desc = {};

			local descInstance = coreGUIFuncs.newDesc(tabInstance.window, name);
			
			desc.changeText = function(text)
				descInstance.spacebox.TextLabel.Text = text;
			end

			desc.getMainInstance = function()
				return descInstance;
			end

			desc.getInstance = function()
				return descInstance.spacebox;
			end

			desc.delete = function()
				desc.getInstance():Destroy();
			end

			return desc;
		end

		tab.getMainInstance = function()
			return tabInstance;
		end

		tab.getInstance = function()
			return tabInstance.window;
		end

		tab.delete = function()
			tab.getInstance():Destroy();
			tab.getMainInstance().button:Destroy();
		end

		return tab;
	end

	-- gets tab based on name
	create.getTab = function(tabName)
		for i,v in pairs(tabs) do
			if v.name == tabName then
				return v;
			end
		end
	end

	-- opens specific tab. Use create.getTab to get the tab instance if you havn't saved it in a local var
	local openTabDebounce = true;
	create.openTab = function(tabInstance)
		tabInstance = tabInstance.getMainInstance();
		if not openTabDebounce then return end
		openTabDebounce = false;

		-- Checks if current window is not the same as what the requested open tab is
		-- If so, it will continue. If not, it will just close the nav bar as the 
		-- requested tab is already open
		if activeTab ~= tabInstance.window or not activeTab then 
			-- Closing of unwanted tabs
			if activeTab then
				activeTab:TweenPosition(activeTab.Position + UDim2.new(2,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true);
				wait(.3);
				activeTab.Position = UDim2.new(0.5,0,2,0);
			end

			-- Opening of desired tab
			tabInstance.window.Position = UDim2.new(0.5,0,2,0);
			tabInstance.window:TweenPosition(UDim2.new(0.5,0,0.5,17), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true);
		end

		-- Close nav frame if its open so that the user can navigate on the tab
		if mainGUI.navframe.Position ~= UDim2.new(-0.5, 0, 0.108, 0) then
			coreFuncs.handleNavLib(mainGUI.navframe, mainGUI.opennav, mainGUI.closenav, activeTab);
		end

		activeTab = tabInstance.window;
		openTabDebounce = true;
	end

	-- Changes keybind to toggle gui
	create.changeKeybind = function(keyCode)
		if keyCode:IsA("InputObject") then
			keybind = keyCode;
		end
	end

	-- Closes the entire instance - (deletes all entities)
	create.close = function()
		mainGUI.screengui:Destroy();
	end

	create.getMainInstance = function()
		return mainGUI;
	end

	create.getInstance = function()
		return mainGUI.screengui;
	end

	create.delete = function()
		create.getInstance():Destroy();
	end

	return create;
end








local mainGUI = ezlib.create("Headshot.me");
local tab = mainGUI.newTab("Home");
local Aimbot = mainGUI.newTab("Aimbot");
local tab2 = mainGUI.newTab("Silent FOV");
local ESP = mainGUI.newTab("ESP");
local Shop = mainGUI.newTab("Shop");
local nig = mainGUI.newTab("Extras");



gv = false
game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameprocess)
	    if (inputObject.KeyCode == getgenv().keyylol) and (not gameprocess) and gv == false and bitches == true then
	        gv = true
	        			game.Players.LocalPlayer.Character.Humanoid.Name = "Humz"
			game.Players.LocalPlayer.Character.Humz.WalkSpeed = getgenv().speed
			game.Players.LocalPlayer.Character.Humz.JumpPower = 50
	    else
	        	    if (inputObject.KeyCode == getgenv().keyylol) and (not gameprocess) and gv == true and bitches == true then
gv = false
			game.Players.LocalPlayer.Character.Humz.WalkSpeed = 16
			game.Players.LocalPlayer.Character.Humz.JumpPower = 50
			game.Players.LocalPlayer.Character.Humz.Name = "Humanoid"	
			end end
	end)

    if bitches == false then
        game.Players.LocalPlayer.Character.Humz.WalkSpeed = 16
        game.Players.LocalPlayer.Character.Humz.JumpPower = 50
        game.Players.LocalPlayer.Character.Humz.Name = "Humanoid"	
        getgenv().speed = 16
    end


    hf = false
    game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameprocess)
            if (inputObject.KeyCode == getgenv().esp) and (not gameprocess) and hf == false and bed == true then
                hf = true


                espConfig.enabled = true

        elseif (inputObject.KeyCode == getgenv().esp) and (not gameprocess) and hf == true and bed == true then
            hf = false
            espConfig.enabled = false

        end
    
    end)


 






Aimbot.newTitle("Aimbot");
Aimbot.newDiv();

Aimbot.newCheckbox("Enable", false, function(t)
    getgenv().Amt = not getgenv().Amt
end
)
Aimbot.newKeybind("Keybind", Enum.KeyCode.Q, function(state)
    getgenv().aimlockkeyy = state
end)



Aimbot.newTitle("Settings");
Aimbot.newDiv();
Aimbot.newCheckbox("Notifications", false, function(t)
    getgenv().Noti = t
end
)
Aimbot.newTextbox("Prediction", "Numbers", function(state)
    Pv = state
end)
Aimbot.newTextbox("Radius", "Numbers", function(state)
    Ar = state
end)
Aimbot.newDropdown("Body Parts", "Select", {
	"Head",
	"HumanoidRootPart",
	"UpperTorso",
	"LowerTorso",
	}, function(objective)
        getgenv().Ap = objective
        getgenv().Oamp = objective
    
	end)

tab.newTitle("Home");
tab.newDiv();
tab.newDesc("Thank you for choosing Headshot.me! This hub is still in development");
tab.newButton("Join Discord", function()   syn.request({
    Url = "http://127.0.0.1:6463/rpc?v=1",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json",
        ["Origin"] = "https://discord.com"
    },
    Body = game:GetService("HttpService"):JSONEncode({
        cmd = "INVITE_BROWSER",
        args = {
            code = "anger"
        },
        nonce = game:GetService("HttpService"):GenerateGUID(false)
    }),
 })
end);

tab.newKeybind("Toggle UI", Enum.KeyCode.RightShift, function(state)
	getgenv().togglegui = state
end)
tab.newDiv();







tab2.newTitle("Silent FOV");
tab2.newDiv();
tab2.newCheckbox("Enable", false, function(state)
    Settings.SilentAim.Enabled = state
   
    
             end)

             
tab2.newKeybind("Keybind", Enum.KeyCode.B, function(arg)
    Settings.SilentAim.Key = arg

end)


tab2.newTitle("Customize");
tab2.newDiv();
tab2.newCheckbox("Notification", false, function(State)
    getgenv().Notiu = State
end)
tab2.newCheckbox("Auto Prediction", false, function(state)
    getgenv().sar = state
 end)
tab2.newCheckbox("Keybind Lock On", false, function(state)
    Settings.SilentAim.KeyToLockOn = state
 end)
tab2.newCheckbox("FOV Circle", false, function(state)
    Settings.SilentAim.FOVShow = state

end)
tab2.newCheckbox("FOV Filled", false, function(arg)
    Settings.SilentAim.FOVFilled = arg
end)
tab2.newSlider("FOV Size", 60, 0, 300, function(arg)
    Settings.SilentAim.FOVSize = tonumber(arg)
end)


tab2.newSlider("FOV Sides", 8, 3, 50, function(Text)
    Settings.SilentAim.FOVSides = tonumber(Text)
end)
tab2.newCheckbox("Visible Check", false, function(state)
    Settings.SilentAim.VisibleCheck = state

end)

tab2.newTextbox("Prediction",0.149, function(Text)
    Settings.SilentAim.PredictionAmount = tonumber(arg)
end)

tab2.newDropdown("Body Parts", "Select", {
	"Head",
	"HumanoidRootPart",
	"UpperTorso",
	"LowerTorso",
	}, function(arg)
        Settings.SilentAim.AimAt = tostring(arg)
	end)
	ESP.newTitle("ESP");
    ESP.newDiv();
	ESP.newButton("ESP", function()
		loadstring(game:HttpGet("https://pastebin.com/raw/PJ15g5zu"))()
	   end)
    ESP.newTitle("Settings");
    ESP.newDiv();

    
    ESP.newCheckbox("Enable", false, function(t)
        if t then
            espConfig.enabled = true
            bed = true
        else
            espConfig.enabled = false
            bed = false
        end
    end
    )
    ESP.newKeybind("Keybind", Enum.KeyCode.P, function(state)
        getgenv().esp = state
    end)
    ESP.newTitle("Customize");
    ESP.newDiv();

    ESP.newCheckbox("Tracer", false, function(t)
        espConfig.tracer = t
    end)

    ESP.newCheckbox("Head", false, function(t)
        espConfig.headdot = t
    end)
    ESP.newCheckbox("Tag", false, function(t)
        espConfig.tag = t
    end)
    ESP.newCheckbox("Rainbow", false, function(t)
       espConfig.rainbowcolor = t
    end)

    getgenv().keyylol = Enum.KeyCode.N
    getgenv().antilockkk = Enum.KeyCode.M
    getgenv().lower = Enum.KeyCode.V
    getgenv().fake = Enum.KeyCode.X
getgenv().speed = 16
getgenv().Ml = 2.5
getgenv().SBS = 0

    nig.newTitle("Miscellaneous");
    nig.newDiv();
    nig.newCheckbox("Enable WalkSpeed", false, function(t)
        bitches = t
     end)
     nig.newKeybind("Keybind", Enum.KeyCode.N, function(state)
        getgenv().keyylol = state
    end)
    nig.newSlider("Amount", 16, 0, 750, function(Text)
        getgenv().speed = Text
    end)
    nig.newTitle("CFrame Speed");
    nig.newDiv();
    nig.newCheckbox("Enable CFrame", false, function(t)
        antilock = t
     end)
     nig.newKeybind("Keybind", Enum.KeyCode.M, function(state)
        getgenv().antilockkk = state
    end)
    nig.newSlider("Amount", 2.5,1,15, function(state)
        getgenv().Ml = state
    end)
    nig.newTitle("Spin Bot");
    nig.newDiv();


	
	





    nig.newCheckbox("Enable Spin Bot", false, function(t)

    function getRoot(char)
        local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('UpperTorso')
        return rootPart
    end

    if t == true then
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "Spinning"
        Spin.Parent = getRoot(game.Players.LocalPlayer.Character)
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0,getgenv().SBS,0)
    else
        for i,v in pairs(getRoot(game.Players.LocalPlayer.Character):GetChildren()) do
            if v.Name == "Spinning" then
                v:Destroy()
            end
        end
    end
end)



game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameprocess)

    if (inputObject.KeyCode == getgenv().lower) and (not gameprocess) and niggu == true then
                Clicking = not Clicking
                if Clicking == true then
                    repeat
                        mouse1click()
                        wait(0.001)
                    until Clicking == false
                end
            end
        end)

nig.newSlider("Amount", 0, 0, 50, function(Text)
    getgenv().SBS = Text
end)

nig.newTitle("Auto Clicker");
    nig.newDiv();

    nig.newCheckbox("Enable Auto Clicker", false, function(t)
niggu = t
       
    end)
    nig.newKeybind("Keybind", Enum.KeyCode.V, function(state)
        getgenv().lower = state
    end)
  
    nig.newTitle("Fake Macro");
    nig.newDiv();

    nig.newCheckbox("Enable Fake Macro", false, function(t)
       macroolol = t
       
    end)
    nig.newKeybind("Keybind", Enum.KeyCode.X, function(state)
        getgenv().fake = state
    end)
  
    nig.newTitle("Camera");
    nig.newDiv();
    nig.newSlider("FOV", 70, 0, 120, function(Text)
        workspace.Camera.FieldOfView = Text
    end)

nig.newTitle("Accessories");
    nig.newDiv();

    nig.newButton("Headless", function()
        game.Players.LocalPlayer.Character.Head.Transparency = 1
        for i,v in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
        if (v:IsA("Decal")) then
        v:Destroy()
        end
        end
        end)
        
       
        nig.newButton("Right Korblox", function()
			
            local ply = game.Players.LocalPlayer
            local chr = ply.Character
            chr.RightLowerLeg.MeshId = "902942093"
            chr.RightLowerLeg.Transparency = "1"
            chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
            chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
            chr.RightFoot.MeshId = "902942089"
            chr.RightFoot.Transparency = "1"
		wait(.4)
		loadstring(game:HttpGet("https://avarixcommunity.com/scripts/autoButton"))()
        end)

    local runService = game:service('RunService')

    game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameprocess)

	    if (inputObject.KeyCode == getgenv().antilockkk) and (not gameprocess) and antilock == true then
            Enabled = not Enabled
            if Enabled == true then
                repeat
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * getgenv().Ml
                    runService.Stepped:wait()
                until Enabled == false
            end
        end
    end)


	Shop.newTitle("Shop");
	Shop.newDiv();
    
	Shop.newButton("Revolver", function()
       
        _G.savedhumanoidpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-868.005005, -35.549202, -529.420044, -1, 0, 0, 0, 1, 0, 0, 0, -1)
        wait(.2)
        fireclickdetector(game:GetService("Workspace").Ignored.Shop["[Revolver] - $1300"].ClickDetector)
        wait()
        fireclickdetector(game:GetService("Workspace").Ignored.Shop["[Revolver] - $1300"].ClickDetector)
        wait(.2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.savedhumanoidpos)


	end)
	Shop.newButton("Revolver Ammo", function(t)
		local amount=nigga
		for i=1,amount do
        _G.savedhumanoidpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-876.60498, -35.5436897, -529.419983, -1, 0, 0, 0, 1, 0, 0, 0, -1)
        wait(.2)
        fireclickdetector(game:GetService("Workspace").Ignored.Shop["12 [Revolver Ammo] - $75"].ClickDetector)
        wait()
        fireclickdetector(game:GetService("Workspace").Ignored.Shop["12 [Revolver Ammo] - $75"].ClickDetector)
        wait(.2)
		fireclickdetector(game:GetService("Workspace").Ignored.Shop["12 [Revolver Ammo] - $75"].ClickDetector)
        wait(.2)
		fireclickdetector(game:GetService("Workspace").Ignored.Shop["12 [Revolver Ammo] - $75"].ClickDetector)
        wait(.2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.savedhumanoidpos)
		end

	
	end)
	Shop.newTextbox("Amount", "Numbers", function(t)
		
		nigga = t
	end)

	
	Shop.newTitle("Double-Barrel");
	Shop.newDiv();
    
	Shop.newButton("Double-Barrel", function()
       
        _G.savedhumanoidpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-868.924438, -35.5491982, -523.849976, -1, 0, 0, 0, 1, 0, 0, 0, -1)
        wait(.2)
        fireclickdetector(game:GetService("Workspace").Ignored.Shop["[Double-Barrel SG] - $1400"].ClickDetector)
        wait()
        fireclickdetector(game:GetService("Workspace").Ignored.Shop["[Double-Barrel SG] - $1400"].ClickDetector)
        wait(.2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.savedhumanoidpos)


	end)
	Shop.newButton("Double-Barrel Ammo", function(t)
		local amount=fw
		for i=1,amount do
        _G.savedhumanoidpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-875.524902, -35.5449677, -523.849976, -1, 0, 0, 0, 1, 0, 0, 0, -1)
        wait(.3)
        fireclickdetector(game:GetService("Workspace").Ignored.Shop["18 [Double-Barrel SG Ammo] - $60"].ClickDetector)
        wait()
        fireclickdetector(game:GetService("Workspace").Ignored.Shop["18 [Double-Barrel SG Ammo] - $60"].ClickDetector)
        wait(.3)

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.savedhumanoidpos)
		end

	
	end)
	Shop.newTextbox("Amount", "Numbers", function(t)
		
		fw = t
	end)


	

    game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameprocess)

        local Player = game:GetService("Players").LocalPlayer
    local Wallet = Player.Backpack:FindFirstChild("Wallet")

    local UniversalAnimation = Instance.new("Animation")

    function stopTracks()
        for _, v in next, game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks() do
            if (v.Animation.AnimationId:match("rbxassetid")) then
                v:Stop()
            end
        end
    end

    function loadAnimation(id)
        if UniversalAnimation.AnimationId == id then
            stopTracks()
            UniversalAnimation.AnimationId = "1"
        else
            UniversalAnimation.AnimationId = id
            local animationTrack = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(UniversalAnimation)
            animationTrack:Play()
        end
    end

    if (inputObject.KeyCode == getgenv().fake) and (not gameprocess) and macroolol == true then
        Fake = not Fake
        if Fake == true then
                stopTracks()
                loadAnimation("rbxassetid://3189777795")
                wait(1.5)
                Wallet.Parent = Player.Character
                wait(0.15)
                Player.Character:FindFirstChild("Wallet").Parent = Player.Backpack
                wait(0.05)
                repeat game:GetService("RunService").Heartbeat:wait()
                    keypress(0x49)
                    game:GetService("RunService").Heartbeat:wait()
                    keypress(0x4F)
                    game:GetService("RunService").Heartbeat:wait()
                    keyrelease(0x49)
                    game:GetService("RunService").Heartbeat:wait()
                    keyrelease(0x4F)
                    game:GetService("RunService").Heartbeat:wait()
                until Fake == false
            end
        end
    end)




	--// TEXTBOX

	getgenv().Ap = "UpperTorso" -- For R15 Games: {UpperTorso, LowerTorso, HumanoidRootPart, Head} | For R6 Games: {Head, Torso, HumanoidRootPart}
	getgenv().Ar = 30 -- How far away from someones character you want to lock on at
	getgenv().Tp = true 
	getgenv().Fp = true
	getgenv().Pv = 6
	getgenv().Tc = false -- Check if Target is on your Team (True means it wont lock onto your teamates, false is vice versa) (Set it to false if there are no teams)
	getgenv().Pm = true -- Predicts if they are moving in fast velocity (like jumping) so the aimbot will go a bit faster to match their speed 
	getgenv().Oamp = "LowerTorso"
	getgenv().Cij = true
	getgenv().Apo = true
	
	for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Script") and v.Name ~= "Health" and v.Name ~= "Sound" and v:FindFirstChild("LocalScript") then
			v:Destroy()
		end
	end
	game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
		repeat
			wait()
		until game.Players.LocalPlayer.Character
		char.ChildAdded:Connect(function(child)
			if child:IsA("Script") then 
				wait(0.1)
				if child:FindFirstChild("LocalScript") then
					child.LocalScript:FireServer()
				end
			end
		end)
	end)
	
	repeat wait() until game:IsLoaded()
	
		getgenv().Amt = false
	
		local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
		local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
		local MousePressed, CanNotify = false, false;
		local AimlockTarget;
		local OldPre;
	
		getgenv().cIA = true
	
		getgenv().WorldToViewportPoint = function(P)
			return Camera:WorldToViewportPoint(P)
		end
	
		getgenv().WorldToScreenPoint = function(P)
			return Camera.WorldToScreenPoint(Camera, P)
		end
	
		getgenv().GetObscuringObjects = function(T)
			if T and T:FindFirstChild(getgenv().Ap) and Client and Client.Character:FindFirstChild("Head") then 
				local RayPos = workspace:FindPartOnRay(RNew(
					T[getgenv().Ap].Position, Client.Character.Head.Position)
				)
				if RayPos then return RayPos:IsDescendantOf(T) end
			end
		end
	
		getgenv().GetNearestTarget = function()
			-- Credits to whoever made this, i didnt make it, and my own mouse2plr function kinda sucks
			local players = {}
			local PLAYER_HOLD  = {}
			local DISTANCES = {}
			for i, v in pairs(Players:GetPlayers()) do
				if v ~= Client then
					table.insert(players, v)
				end
			end
			for i, v in pairs(players) do
				if v.Character ~= nil then
					local AIM = v.Character:FindFirstChild("Head")
					if getgenv().Tc == true and v.Team ~= Client.Team then
						local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
						local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
						local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
						local DIFF = math.floor((POS - AIM.Position).magnitude)
						PLAYER_HOLD[v.Name .. i] = {}
						PLAYER_HOLD[v.Name .. i].dist= DISTANCE
						PLAYER_HOLD[v.Name .. i].plr = v
						PLAYER_HOLD[v.Name .. i].diff = DIFF
						table.insert(DISTANCES, DIFF)
					elseif getgenv().Tc == false and v.Team == Client.Team then 
						local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
						local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
						local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
						local DIFF = math.floor((POS - AIM.Position).magnitude)
						PLAYER_HOLD[v.Name .. i] = {}
						PLAYER_HOLD[v.Name .. i].dist= DISTANCE
						PLAYER_HOLD[v.Name .. i].plr = v
						PLAYER_HOLD[v.Name .. i].diff = DIFF
						table.insert(DISTANCES, DIFF)
					end
				end
			end
			
			if unpack(DISTANCES) == nil then
				return nil
			end
			
			local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
			if L_DISTANCE > getgenv().Ar then
				return nil
			end
			
			for i, v in pairs(PLAYER_HOLD) do
				if v.diff == L_DISTANCE then
					return v.plr
				end
			end
			return nil
		end
	
		game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameprocess)
			if not (Uis:GetFocusedTextBox()) then 
				if (inputObject.KeyCode == getgenv().aimlockkeyy) and (not gameprocess) and AimlockTarget == nil then
					pcall(function()
						if MousePressed ~= true then MousePressed = true end 
						local Target;Target = GetNearestTarget()
						if Target ~= nil then 
							AimlockTarget = Target
							if getgenv().Notif then
					
								sendNotification((Target.Character.Humanoid.DisplayName))
							end
						end
					end)
				elseif (inputObject.KeyCode == getgenv().aimlockkeyy) and (not gameprocess) and AimlockTarget ~= nil then
					if AimlockTarget ~= nil then AimlockTarget = nil end
					if MousePressed ~= false then 
						MousePressed = false 
						if getgenv().Notif then
						sendNotification("No Target!")
						end

					end
				end
			end
		end)
		RService.RenderStepped:Connect(function()
			local AimPartOld = getgenv().Oamp
			if getgenv().Tp == true and getgenv().Fp == true then 
				if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
					CanNotify = true 
				else 
					CanNotify = false 
				end
			elseif getgenv().Tp == true and getgenv().Fp == false then 
				if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
					CanNotify = true 
				else 
					CanNotify = false 
				end
			elseif getgenv().Tp == false and getgenv().Fp == true then 
				if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
					CanNotify = true 
				else 
					CanNotify = false 
				end
			end
			if getgenv().Amt == true and MousePressed == true then 
				if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(getgenv().Ap) then 
					if getgenv().Fp == true then
						if CanNotify == true then
							if getgenv().Pm == true then 
								Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().Ap].Position + AimlockTarget.Character[getgenv().Ap].Velocity/Pv)
							elseif getgenv().Pm == false then 
								Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().Ap].Position)
							end
						end
					elseif getgenv().Tp == true then 
						if CanNotify == true then
							if getgenv().Pm == true then 
								Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().Ap].Position + AimlockTarget.Character[getgenv().Ap].Velocity/Pv)
							elseif getgenv().Pm == false then 
								Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().Ap].Position)
							end
						end 
					end
				end
			end
			if getgenv().Cij == true then
				if AimlockTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air and AimlockTarget.Character.Humanoid.Jump == true then
					getgenv().Ap = "RightLowerLeg"
				else
					getgenv().Ap = AimPartOld
				end
			end
			
	
		end)
	
		

    
mainGUI.openTab(tab);


