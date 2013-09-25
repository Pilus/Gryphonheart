if GHMMenuCreator == nil then
  local miscApi = GHI_MiscAPI().GetAPI();
  local loc = GHI_Loc()
  
  local t = {
    {
      {
        
        {
          type = "Button",
          text = "Button",
          align = "l",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Button",
                    text = "Button",
                    align = "c",
                    label = "button",
                    tooltip = "Button",
                    ignoreTheme = false,
                    compact = false,
                    xOff = 0,
                    yOff = 0,
                    OnClick = function(self)
                    -- Code Here
                    end,
                    
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
          
        },
        {
          type = "Button",
          text = "Text",
          align = "r",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Text",
                    text = "Text",
                    align = "c",
                    label = "text",
                    fontSize = 11,
                    width = 100,
                    xOff = 0,
                    yOff = 0,                    
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
          
        },
      },
      {
        {
          type = "Button",
          text = "Edit Box",
          align = "l",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Editbox",
                    text = "Editbox",
                    align = "c",
                    label = "editbox",
                    texture = "Tooltip",
                    tooltip = "Editbox",
                    width = 200,
                    xOff = 0,
                    yOff = 0,
                    OnTextChanged = function(self, userInput)
                        -- Code Here
                    end,                   
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
          
        },
        {
          type = "Button",
          text = "Edit Field",
          align = "r",
          OnClick = function() 
            local objCode = [[
                {
                    type = "EditField",
                    text = "Edit Field",
                    align = "c",
                    label = "editfield",
                    texture = "Tooltip",
                    tooltip = "Edit Field",
                    width = 200,
                    height = 200,
                    xOff = 0,
                    yOff = 0,
                    OnTextChanged = function(self, userInput)
                        -- Code Here
                    end,                   
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
        },
      },
      {
        {
          type = "Button",
          text = "Check Box",
          align = "l",
          OnClick = function() 
            local objCode = [[
                {
                    type = "CheckBox",
                    text = "CheckBox",
                    align = "c",
                    label = "checkbox",
                    tooltip = "Check Box",
                    xOff = 0,
                    yOff = 0,
                    OnClick = function(self)
                    -- Code Here
                    end,
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
          
        },
        {
          type = "Button",
          text = "Radio Set",
          align = "r",
          OnClick = function() 
            local objCode = [[
                {
                    type = "RadioButtonSet",
                    text = "RadioButtonSet",
                    align = "c",
                    label = "radiobutton",
                    tooltip = "RadioButtonSet",
                    retunrIndex = true,
                    xOff = 0,
                    yOff = 0,
                    OnSelect = function()
                    -- Code Here
                    end,
                    dataFunc = function() end,
                    data = {
                        "One",
                        "Two",
                    },                
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
        },
      },
      {
        {
          type = "Button",
          text = "Color",
          align = "l",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Color",
                    text = "Color",
                    align = "c",
                    label = "color",
                    tooltip = "Color",
                    xOff = 0,
                    yOff = 0,
                    scale = 1,
                    returnIndexTable = false,
                    onColorSelect = function()
                    end,
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
          
        },
        {
          type = "Button",
          text = "Time",
          align = "r",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Time",
                    text = "Time",
                    align = "c",
                    label = "time",
                    tooltip = "Time",
                    xOff = 0,
                    yOff = 0,
                    width = 100,
                    values = {1,2,3},
                    startText = 0,
                    OnTextChanged = function(self,userInput)
                        -- Code Here
                    end,
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
        },
      },
      {
        {
          type = "Button",
          text = "Slider",
          align = "l",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Slider",
                    text = "Slider",
                    align = "c",
                    label = "slider",
                    tooltip = "Slider",
                    xOff = 0,
                    yOff = 0,
                    width = 100,
                    isStackSlider = nil,
                    isTimeSlider = nil,
                    isSlotSlider = nil,
                    values = {1,2,3},
                    OnValueChanged = function(self,userInput)
                        -- Code Here
                    end,
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
          
        },
        {
          type = "Button",
          text = "Code Field",
          align = "r",
          OnClick = function() 
            local objCode = [[
                {
                    type = "CodeField",
                    text = "Code Field",
                    align = "c",
                    label = "codefield",
                    texture = "Tooltip",
                    tooltip = "Code Field",
                    width = 200,
                    height = 200,
                    xOff = 0,
                    yOff = 0,
                    toolbarButtons = {
                        {
                            texture = "INTERFACE\\ICONS\\Ability_Rogue_Sprint",
                            tooltip = "Toolbar Button",
                            func = function()
                                -- Code Here
                            end,
                        },
                    },                   
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
        },
      },
      {
        {
          type = "Button",
          text = "Icon",
          align = "l",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Icon",
                    text = "Icon",
                    align = "c",
                    framealign = "r",
                    label = "icon",
                    tooltip = "Icon",
                    xOff = 0,
                    yOff = 0,
                    OnChanged = function(self)
                    -- Code Here
                    end,
                    
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
          
        },
        {
          type = "Button",
          text = "Image",
          align = "r",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Image",
                    text = "Image",
                    align = "c",
                    label = "image",
                    xOff = 0,
                    yOff = 0,                    
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,
        },
      },
      {
        {
          type = "Button",
          text = "Position",
          align = "r",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Position",
                    text = "Position",
                    align = "c",
                    label = "position",
                    xOff = 0,
                    yOff = 0,                   
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,          
        },
        {
          type = "Button",
          text = "Sound",
          align = "l",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Sound",
                    text = "Sound",
                    align = "c",
                    label = "sound",
                    xOff = 0,
                    yOff = 0,                   
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,       
        },
      },
      {
        {
          type = "Button",
          text = "H Bar",
          align = "l",
          OnClick = function() 
            local objCode = [[
                {
                    type = "HBar",
                    align = "c",
                    label = "hbar",
                    width = 100,
                    xOff = 0,
                    yOff = 0,                   
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,       
          
        },
        {
          type = "Button",
          text = "Dummy",
          align = "r",
          OnClick = function() 
            local objCode = [[
                {
                    type = "Dummy",
                    align = "c",
                    label = "dummy",
                    width = 100,
                    height = 100,
                    xOff = 0,
                    yOff = 0,                   
                },
            ]]  
            local oldCode = GHMMenuCreator.GetLabel("code")
            GHMMenuCreator.ForceLabel("code", oldCode..objCode)
          end,       
        },
      },
      {
        {
          type = "CodeField",
          label = "code",
          width = 200,
          height = 300,
          toolbarButtons = {
            {
              texture = "INTERFACE\\ICONS\\Ability_Rogue_Sprint",
              tooltip = "Clear",
              func = function()
                GHMMenuCreator.ForceLabel("code","")
              end,
            },
          },
        },
      },
      
    },
    
    background = "Interface\\FrameGeneral\\UI-Background-Rock",
    title = "GHM Objects",
    name = "GHMMenuCreator",
    theme = "BlankTheme",
    width = 200,
    height = 600,
    useWindow = true,
  }
  
  GHMMenuCreator = GHM_NewFrame("GHMMenuCreator",t);
  
  GHMMenuCreator:Show()
else
  GHMMenuCreator:Show()
end