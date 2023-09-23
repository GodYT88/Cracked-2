local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GodYT88/Cracked-2/main/Visualise_UI_Library.lua"))()

local main = library.CreateMain()
local tab = main.CreateTab({ name = "Rage", icon = 14478582742 })
local category = tab.CreateCategory({ name = "rifles" })

category.CreateLabel({ name = "Something", side = "left" })

category.CreateButton({
    name = "kill all",
    side = "left",
    callback = function()
        -- Your callback function here
    end
})

category.CreateToggle({
    name = "auto-fire",
    side = "left",
    callback = function(state)
        -- Your callback function here
        print("Toggle state:", state)
    end
})

category.CreateSlider({
    name = "rw upgrade speed",
    side = "right",
    max = 100,
    min = 1,
    value = 10,
    callback = function(state)
        -- Your callback function here
        print("Slider value:", state)
    end
})

category.CreateDropdown({
    name = "#1 idiot",
    side = "right",
    objects = {"sirex", "seere", "office", "bananger", "neglect", "all"},
    choosed = "all",
    callback = function(state)
        -- Your callback function here
        print("Dropdown selection:", state)
    end
})

tab.CreateTheme({
    name = "Pastel Purple",
    color = Color3.fromRGB(202, 160, 255),
    callback = function(themeColors)
        -- Your callback function here (e.g., apply theme colors)
        print("Theme selected:", themeColors)
    end,
})

main.CreateThemes({
    themes = {
        ["Purple"] = Color3.fromRGB(87, 98, 255),
        -- Add more themes here
    }
})
