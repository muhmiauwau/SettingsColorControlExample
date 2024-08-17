






SettingsColorControlMixin = CreateFromMixins(SettingsControlMixin);

function SettingsColorControlMixin:OnLoad()
	SettingsControlMixin.OnLoad(self);
    

	self.Colorswatch = CreateFrame("Button", nil, self);
    self.Colorswatch:SetPoint("LEFT", self, "CENTER", -80, 0);
    self.Colorswatch:SetSize(20, 20);
    self.Colorswatch.Texture = self.Colorswatch:CreateTexture()
	self.Colorswatch.Texture:SetAllPoints()


    self.Colorswatch:SetScript("OnClick", function()
        local currentValue = self:GetSetting():GetValue()
		local options = {
			swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB();
                self:GetSetting():SetValue({r, g, b}) 
            end,
			cancelFunc = function()
                self.Colorswatch.Texture:SetColorTexture(currentValue[1],currentValue[2],currentValue[3])
            end,
			hasOpacity = false,
			r = currentValue[1],
			g = currentValue[2],
			b = currentValue[3],
		};
		
	    ColorPickerFrame:SetupColorPickerAndShow(options);
	end);


	self.Tooltip:SetScript("OnMouseUp", function()
		if self.Colorswatch:IsEnabled() then
			self.Colorswatch:Click();
		end
	end);
end

function SettingsColorControlMixin:Init(initializer)
	SettingsControlMixin.Init(self, initializer);
	 local setting = self:GetSetting();

    local currentValue = setting:GetValue()
    self.Colorswatch.Texture:SetColorTexture(currentValue[1], currentValue[2], currentValue[3])

end

function SettingsColorControlMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value);
    self.Colorswatch.Texture:SetColorTexture(value[1], value[2], value[3])
end

function SettingsColorControlMixin:Release()
	self.Colorswatch:Release();
	SettingsControlMixin.Release(self);
end




function Settings.CreateColor(category, setting, tooltip)
 
    local initializer = Settings.CreateControlInitializer("SettingsColorControlTemplate", setting, nil, tooltip);

    local layout = SettingsPanel:GetLayout(category);
	layout:AddInitializer(initializer);

    return initializer;
end














local addon = CreateFrame("Frame")
addon:RegisterEvent("PLAYER_LOGIN")
addon:SetScript("OnEvent", function()

    


    if SettingsColorControlExample == nil then 
        SettingsColorControlExample = {}
    end


    local category = Settings.RegisterVerticalLayoutCategory("Color Control Example")

    local function OnSettingChanged(setting, value)
        -- This callback will be invoked whenever a setting is modified.
        print("Setting changed:", setting:GetVariable())
        DevTools_Dump(value)
    end

    do 

        local name = "Test Color"
        local variable = "MyAddOn_Color"
        local variableKey = "color"
        local variableTbl = SettingsColorControlExample
        local defaultValue = {1, 1, 1}

        local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
        setting:SetValueChangedCallback(OnSettingChanged)

        local tooltip = "This is a tooltip for the checkbox."
        Settings.CreateColor(category, setting, tooltip)
    end


    Settings.RegisterAddOnCategory(category)


end)