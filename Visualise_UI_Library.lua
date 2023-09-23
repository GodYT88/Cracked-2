local lp = game:GetService("Players").LocalPlayer;
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local mouse = lp:GetMouse()
local hs = game:GetService("HttpService")

local http_request = fluxus and fluxus.request or request

if game:GetService("CoreGui"):FindFirstChild("visualise") then game:GetService("CoreGui"):FindFirstChild("visualise"):Destroy() end
if game:GetService("CoreGui"):FindFirstChild("visualise") then return end

local library = {}

local l_o = 0;

function library.CreateMain()
	local loops = {}

	local visualise = Instance.new("ScreenGui")
	visualise.Name = "visualise"
	visualise.Parent = (game:GetService("CoreGui") or gethui())
	visualise.ResetOnSpawn = false
	visualise.ZIndexBehavior = Enum.ZIndexBehavior.Global
	
	uis.InputBegan:Connect(function(input, process)
		if input.KeyCode == Enum.KeyCode.Insert and not process then
			visualise.Enabled = not visualise.Enabled
		end
	end)

	local main = game:GetObjects("rbxassetid://14483616780")[1]
	main.Parent = visualise
	main.ImageLabel:Destroy()
	
	local icon = game:GetObjects("rbxassetid://14774115318")[1]
	icon.Parent = main
	
	--require(13699518434):BlurFrame(main)

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function Lerp(a, b, m)
		return a + (b - a) * m
	end;

	local lastMousePos
	local lastGoalPos
	local DRAG_SPEED = 14;
	local function Update(dt)
		if not (startPos) then return end;
		if not (dragging) and (lastGoalPos) then
			main.Position = UDim2.new(startPos.X.Scale, Lerp(main.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(main.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
			return 
		end;

		local delta = (lastMousePos - uis:GetMouseLocation())
		local xGoal = (startPos.X.Offset - delta.X);
		local yGoal = (startPos.Y.Offset - delta.Y);
		lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
		main.Position = UDim2.new(startPos.X.Scale, Lerp(main.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(main.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
	end;

	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			lastMousePos = uis:GetMouseLocation()

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	loops["drag"] = rs.Heartbeat:Connect(Update)

	local SectionsFolder = Instance.new("Folder", main.Main)
	SectionsFolder.Name = "SectionsFolder"

	--require(13699518434):BlurFrame(dragger)

	local tabUtil = {}

	function tabUtil.CreateTab(args)
		args.name = args.name or "Tab"
		args.icon = args.icon or 0

		local tab = game:GetObjects("rbxassetid://14483817764")[1]
		tab.Parent = main.Main.Tabs
		tab.TextLabel.Text = args.name
		tab.ImageLabel.Image = "rbxassetid://"..args.icon
		tab.AutoButtonColor = false
		
		tab.line.Name = "ColorToChange"
		tab.ColorToChange.BackgroundColor3 = Color3.fromRGB(202, 160, 255)

		local Categorys = game:GetObjects("rbxassetid://14483883409")[1]
		Categorys.Parent = main.Main
		Categorys.Visible = false
		Categorys.UIListLayout.Padding = UDim.new(0, 5)
		Categorys.UIListLayout.FillDirection = Enum.FillDirection.Horizontal

		tab.MouseButton1Click:Connect(function()
			for _,v in pairs(main.Main.Tabs:GetChildren()) do
				if v.Name == "tab" then
					ts:Create(v.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageColor3 = Color3.fromRGB(63,63,63)}):Play()
					ts:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
					ts:Create(v.TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(63,63,63)}):Play()
					ts:Create(v.ColorToChange, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0,2, 0,0), Position = UDim2.new(0.96,0, 0.45,0)}):Play()
				end
			end
			for _,v in pairs(SectionsFolder:GetChildren()) do
				if v:IsA("GuiObject") then
					v.Visible = false
				end
			end
			for _,v in pairs(main.Main:GetChildren()) do
				if v.Name == "Categorys" then
					v.Visible = false
				end
			end
			ts:Create(tab.ColorToChange, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0,2, 0,20), Position = UDim2.new(0.96,0, 0.15,0)}):Play()
			ts:Create(tab, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.5}):Play()
			ts:Create(tab.TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			ts:Create(tab.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
			Categorys.Visible = true
		end)

		local special = {}

		function special.CreateCategory(args)
			args.name = args.name or "category"

			local category = game:GetObjects("rbxassetid://14483927878")[1]
			category.Parent = Categorys
			category.TextLabel.Text = args.name
			category.TextLabel.AnchorPoint = Vector2.new(0.5,0.5)
			category.TextLabel.Position = UDim2.new(0.5,0, 0.5,0)
			category.line.AnchorPoint = Vector2.new(0.5,0)
			category.line.Position = UDim2.new(0.5,0, 0.951,0)
			
			category.line.Name = "ColorToChange"
			category.ColorToChange.BackgroundColor3 = Color3.fromRGB(202, 160, 255)

			local categorySize = game:GetService("TextService"):GetTextSize(category.TextLabel.Text, category.TextLabel.TextScaled, Enum.Font.Gotham, Vector2.new(1000000, 1000000))
			local lenght = (categorySize.Magnitude * 4)

			category.Size = UDim2.new(0, category.Size.X.Offset + lenght, 0,31)
			category.TextLabel.Size = UDim2.new(0, category.TextLabel.Size.X.Offset + lenght, 0,16)
			category.ColorToChange.Size = UDim2.new(0, category.ColorToChange.Size.X.Offset + lenght, 0,2)

			local LSection = game:GetObjects("rbxassetid://14483632704")[1]
			LSection.Parent = SectionsFolder
			LSection.Visible = false
			local RSection = game:GetObjects("rbxassetid://14673936263")[1]
			RSection.Parent = SectionsFolder
			RSection.Visible = false

			local oldLine = category.ColorToChange.Size
			category.ColorToChange.Size = UDim2.new(0,0, 0,2)
			category.BackgroundTransparency = 1

			category.MouseButton1Click:Connect(function()
				for _,v in pairs(SectionsFolder:GetChildren()) do
					if v:IsA("GuiObject") then
						v.Visible = false
					end
				end
				for _,v in pairs(Categorys:GetChildren()) do
					if v.Name == "category" then
						ts:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
						ts:Create(v.ColorToChange, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0,0, 0,2)}):Play()
					end
				end

				LSection.Visible = true
				RSection.Visible = true
				ts:Create(category, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.5}):Play()
				ts:Create(category.ColorToChange, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = oldLine}):Play()
			end)

			local modules = {}
			function modules.CreateLabel(args)
				args.name = args.name or "Label"
				args.side = args.side or "left"
				
				local label = game:GetObjects("rbxassetid://14728648816")[1]
				label.Parent = args.side == "left" and LSection or RSection
				label.Text = args.name
				label.LayoutOrder = l_o
				l_o += 1;
			end
			function modules.CreateButton(args)
				args.name = args.name or "Button"
				args.callback = args.callback or function() end
				args.side = args.side or "left"

				local button = game:GetObjects("rbxassetid://14484174621")[1]
				button.Parent = args.side == "left" and LSection or RSection
				button.TextLabel.Text = args.name
				button.LayoutOrder = l_o
				l_o += 1;

				button.MouseButton1Click:Connect(function()
					args.callback()
				end)
			end
			function modules.CreateToggle(args)
				args.name = args.name or "Toggle";
				args.callback = args.callback or function() end
				args.side = args.side or "left"
				args.enabled = args.enabled or false

				local toggle = game:GetObjects("rbxassetid://14484258247")[1]
				toggle.Parent = args.side == "left" and LSection or RSection
				toggle.TextLabel.Text = args.name;
				toggle.bar.BackgroundColor3 = args.enabled and Color3.fromRGB(48, 48, 48) or Color3.fromRGB(21, 21, 21)
				toggle.bar.circle.Position = args.enabled and UDim2.new(0.8,0, 0.5,0) or UDim2.new(0.2,0, 0.5,0)
				toggle.LayoutOrder = l_o
				l_o += 1;

				args.callback(args.enabled)
				local enabled = args.enabled

				toggle.MouseButton1Click:Connect(function()
					enabled = not enabled
					args.callback(enabled)

					if enabled then
						ts:Create(toggle.bar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(48, 48, 48)}):Play()
						ts:Create(toggle.bar.circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.8,0, 0.5,0)}):Play()
					else
						ts:Create(toggle.bar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(21, 21, 21)}):Play()
						ts:Create(toggle.bar.circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.2,0, 0.5,0)}):Play()
					end
				end)
			end
			function modules.CreateSlider(args)
				args.name = args.name or "Slider";
				args.callback = args.callback or function() end
				args.side = args.side or "left";
				
				args.max = args.max or 100;
				args.min = args.min or 20;
				args.value = args.value or (args.max - args.min)
				
				local slider = game:GetObjects("rbxassetid://14773898725")[1]
				slider.Parent = args.side == "left" and LSection or RSection
				slider.TextLabel.Text = args.name;
				slider.number.Text = tostring(args.value)
				slider.LayoutOrder = l_o
				
				local inner = slider.bar.inner
				
				l_o += 1;

				local conStart
				local conEnded

				slider.bar.hitbox.MouseButton1Down:Connect(function()
					local mousePos = uis:GetMouseLocation().X;
					local sliderSize = slider.bar.hitbox.AbsoluteSize.X;
					local sliderPos = slider.bar.hitbox.AbsolutePosition.X;
					local per = math.clamp((mousePos - sliderPos), 0, 195);
					inner.Size = UDim2.new(0, per, 0, 6);

					local v = (mousePos - sliderPos) / sliderSize
					local p = (v / 0.01 + 0.5) * 0.01
					local circlePos = math.clamp(p, 0, 1);
					slider.bar.circle.Position = UDim2.new(circlePos - 0.03, 0, 0.5, 0);

					local return_value = (((args.max - args.min) / 195) * inner.AbsoluteSize.X) + args.min;
					local a = math.floor(return_value);
					local c = string.len(a) + 2;

					args.callback(tonumber(string.sub(return_value, 1, c)));
					slider.number.Text = tostring(string.sub(return_value, 1, c));

					conStart = mouse.Move:Connect(function()
						local mousePos = uis:GetMouseLocation().X;
						local sliderSize = slider.bar.hitbox.AbsoluteSize.X;
						local sliderPos = slider.bar.hitbox.AbsolutePosition.X;
						local per = math.clamp((mousePos - sliderPos), 0, 195);
						inner.Size = UDim2.new(0, per, 0, 6);

						return_value = (((args.max - args.min) / 195) * inner.AbsoluteSize.X) + args.min;
						a = math.floor(return_value);
						c = string.len(a) + 2;

						v = (mousePos - sliderPos) / sliderSize
						p = (v / 0.01 + 0.5) * 0.01
						circlePos = math.clamp(p, 0, 1);
						slider.bar.circle.Position = UDim2.new(circlePos - 0.03, 0, 0.5, 0);

						args.callback(tonumber(string.sub(return_value, 1, c)));
						slider.number.Text = tostring(string.sub(return_value, 1, c));
					end)
					conEnded = uis.InputEnded:Connect(function(Mouse)
						if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
							conStart:Disconnect();
							conEnded:Disconnect();
						end
					end)
				end)
			end
			function modules.CreateDropdown(args)
				local listSize = 0
				local padding = 5
				
				args.name = args.name or "Dropdown"
				args.objects = args.objects or {"object"}
				args.choosed = args.choosed or args.objects[1]
				args.side = args.side or "left"
				args.callback = args.callback or function() end
				
				local dropdown = game:GetObjects("rbxassetid://14673211874")[1]
				dropdown.Parent = args.side == "left" and LSection or RSection
				dropdown.TextLabel.Text = args.name;
				dropdown.select.Text = args.choosed;
				dropdown.LayoutOrder = l_o
				
				local DropdownList = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIListLayout = Instance.new("UIListLayout")
				local UIPadding = Instance.new("UIPadding")

				DropdownList.Name = "DropdownList"
				DropdownList.Parent = args.side == "left" and LSection or RSection
				DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				DropdownList.BackgroundTransparency = 1
				DropdownList.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownList.BorderSizePixel = 0
				DropdownList.ClipsDescendants = true
				DropdownList.LayoutOrder = 4
				DropdownList.Size = UDim2.new(0, 213, 0, -5)
				DropdownList.LayoutOrder = l_o;

				UICorner.CornerRadius = UDim.new(0, 5)
				UICorner.Parent = DropdownList

				UIListLayout.Parent = DropdownList
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 5)

				UIPadding.Parent = DropdownList
				UIPadding.PaddingTop = UDim.new(0, 5)
				
				local openListSystem = coroutine.create(function()
					local opened = false;

					dropdown.MouseButton1Click:Connect(function()
						opened = not opened;

						ts:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
							Size = UDim2.new(0, 213, 0, opened and listSize or -5),
							Transparency = opened and 0.5 or 1
						}):Play()
						ts:Create(dropdown.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Rotation = opened and 180 or 0}):Play()
					end)
				end)

				coroutine.resume(openListSystem)
				
				for _,v in pairs(args.objects) do
					listSize += 30 - padding;
					
					local Object = Instance.new("TextButton")
					local UICorner_2 = Instance.new("UICorner")
					local TextLabel = Instance.new("TextLabel")
					
					Object.Name = "Object"
					Object.Parent = DropdownList
					Object.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
					Object.BackgroundTransparency = 1.000
					Object.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Object.BorderSizePixel = 0
					Object.Position = UDim2.new(0.0399061032, 0, 0, 0)
					Object.Size = UDim2.new(0, 196, 0, 20)
					Object.AutoButtonColor = false
					Object.Text = ""
					Object.TextColor3 = Color3.fromRGB(0, 0, 0)
					Object.TextSize = 14.000

					UICorner_2.CornerRadius = UDim.new(0, 5)
					UICorner_2.Parent = Object

					TextLabel.Parent = Object
					TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.BackgroundTransparency = 1.000
					TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					TextLabel.BorderSizePixel = 0
					TextLabel.Position = UDim2.new(0.0177771114, 0, 0.122283936, 0)
					TextLabel.Size = UDim2.new(0, 196, 0, 14)
					TextLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					TextLabel.Text = v
					TextLabel.TextColor3 = Color3.fromRGB(143, 143, 143)
					TextLabel.TextScaled = true
					TextLabel.TextSize = 14.000
					TextLabel.TextWrapped = true
					TextLabel.TextXAlignment = Enum.TextXAlignment.Left
					
					Object.MouseButton1Click:Connect(function()
						args.callback(v)
						dropdown.select.Text = v;
						
						for _,v in pairs(DropdownList:GetChildren()) do
							if v.Name == "Object" then
								ts:Create(v, TweenInfo.new(0.3), {Transparency = 1}):Play()
							end
						end
						
						ts:Create(Object, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
					end)
				end
				
				l_o += 1;
			end
			function modules.CreateTheme(args)
				args.name = args.name or "Theme"
				
				args.color = args.color or Color3.fromRGB(255,255,255)
				args.color2 = args.color2 or Color3.fromRGB(95, 95, 95)
				
				args.callback = args.callback or function() end
				args.side = args.side or "left"
				
				local themeButton = game:GetObjects("rbxassetid://14760887340")[1]
				themeButton.TextLabel.Text = args.name
				--themeButton.gradient.BackgroundColor3 = args.color
				--themeButton.gradient.Glow.BackgroundColor3 = args.color
				themeButton.Parent = args.side == "left" and LSection or RSection
				themeButton.LayoutOrder = l_o
				themeButton.gradient.UIGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, args.color),
					ColorSequenceKeypoint.new(1, args.color2)
				})
				themeButton.gradient.Glow.UIGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, args.color),
					ColorSequenceKeypoint.new(1, args.color2)
				})
				l_o += 1;
				
				themeButton.MouseButton1Click:Connect(function()
					args.callback({args.color, args.color2})
					
					for _,v in pairs(visualise:GetDescendants()) do
						if v.Name == "ColorToChange" then
							if v:IsA("Frame") then
								v.BackgroundColor3 = args.color
							elseif v:IsA("ImageLabel") then
								v.ImageColor3 = args.color
							end
						elseif v.Name == "GradientToChange" then
							v.Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, args.color),
								ColorSequenceKeypoint.new(1, args.color2)
							})
						end
					end
				end)
			end
			
			return modules
		end

		return special
	end
	function tabUtil.CreateThemes(args)
		args.themes = args.themes or {}

		local themesTab = tabUtil.CreateTab({name = "Themes"})
		local themesCategory = themesTab.CreateCategory({name = "client"})

		for i,v in pairs(args.themes) do
			print(unpack(args.themes))
			themesCategory.CreateTheme({name = i, color = v, callback = function(c)
				print(c)
			end,})
		end
	end
	return tabUtil
end
return library

--[[
local main = library.CreateMain()
local tab = main.CreateTab({name = "Rage", icon = 14478582742})
local category = tab.CreateCategory({name = "rifles"})
category.CreateLabel({name = "Something", side = "left"})
category.CreateButton({name = "kill all", side = "left", callback = function()
	print("killed all")
end,})
category.CreateToggle({name = "auto-fire", side = "left", callback = function(state)
	print(state)
end,})
category.CreateLabel({name = "Something2", side = "right"})
category.CreateSlider({name = "rw upgrade speed", side = "right", max = 100, min = 1, value = 10, callback = function(state)
	print(state)
end,})
category.CreateDropdown({name = "#1 idiot", side = "right", objects = {"sirex", "seere", "office", "bananger", "neglect", "all"}, choosed = "all", callback = function(state)
	print(state)
end,})
tab.CreateTheme({name = "Pastel Purple", color = Color3.fromRGB(202, 160, 255), callback = function(state)
    ColorTheme = state
end,})

main.CreateThemes({themes = {
	["Purple"] = Color3.fromRGB(87, 98, 255)
}})]]
