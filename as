--http spying is a sad thing to do. It just shows you want to steal others work and use it in your own without credits like every paster. Even if you have this silent aim its Noss (thx papi)


_G.Distance = 190000343
 _G.Prediction =  (  .18  )

    _G.FOV =  600
    
    _G.AimKey =    "p"  
    
  
    _G.mysilentaimtogglesmh = false
    local SilentAim = false 
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Players = game:GetService("Players")
    local Mouse = LocalPlayer:GetMouse()
    local Camera = game:GetService("Workspace").CurrentCamera
    hookmetamethod = hookmetamethod
    Drawing = Drawing
    
    local FOV_CIRCLE = Drawing.new("Circle")
    _G.Circle = FOV_CIRCLE
    FOV_CIRCLE.Visible = false
    FOV_CIRCLE.Filled = false
    FOV_CIRCLE.Thickness = 1
    FOV_CIRCLE.Transparency = 1
    FOV_CIRCLE.Color = Color3.new(0, 1, 0)
    FOV_CIRCLE.Radius = 600
    FOV_CIRCLE.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    Options = {
        Torso = "HumanoidRootPart";
        Head = "Head";
    }
    
    local function MoveFovCircle()
        pcall(function()
            local DoIt = true
            spawn(function()
                while DoIt do task.wait()
                    FOV_CIRCLE.Position = Vector2.new(Mouse.X, (Mouse.Y + 36))
                end
            end)
        end)
    end coroutine.wrap(MoveFovCircle)()
    
    Mouse.KeyDown:Connect(function(KeyPressed)
        if KeyPressed == (_G.AimKey:lower()) then
            if SilentAim == false then
                game:GetService("StarterGui"):SetCore("SendNotification",{     

Title = "Silent Aim",     

Text = "Off",

Duration = 3

})
                SilentAim = true
            elseif SilentAim == true then
                
                game:GetService("StarterGui"):SetCore("SendNotification",{     

Title = "Silent Aim",     

Text = "On",

Duration = 3

})
                SilentAim = false
            end
        end
    end)
    
    local oldIndex = nil 
    oldIndex = hookmetamethod(game, "__index", function(self, Index)
        if self == Mouse and (Index == "Hit") then 
            local Distance = _G.Distance
            local Targete = nil
            if SilentAim and _G.mysilentaimtogglesmh == true then
                
                for _, v in pairs(Players:GetPlayers()) do 
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
                        local Enemy = v.Character	
                        local CastingFrom = CFrame.new(Camera.CFrame.Position, Enemy[Options.Torso].CFrame.Position) * CFrame.new(0, 0, -4)
                        local RayCast = Ray.new(CastingFrom.Position, CastingFrom.LookVector * 9000)
                        local World, ToSpace = workspace:FindPartOnRayWithIgnoreList(RayCast, {LocalPlayer.Character:FindFirstChild("Head")})
                        local RootWorld = (Enemy[Options.Torso].CFrame.Position - ToSpace).magnitude
                        if RootWorld < 4 then
                            local RootPartPosition, Visible = Camera:WorldToScreenPoint(Enemy[Options.Torso].Position)
                            if Visible then
                                local Real_Magnitude = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(RootPartPosition.X, RootPartPosition.Y)).Magnitude
                                if Real_Magnitude < Distance and Real_Magnitude < FOV_CIRCLE.Radius then
                                    Distance = Real_Magnitude
                                    Targete = Enemy
                                end
                            end
                        end
                    end
                end
            end
            
            if Targete ~= nil and Targete[Options.Torso] and Targete:FindFirstChild("Humanoid").Health > 0 then
                if SilentAim  == true then 
                    local ShootThis = Targete[Options.Torso] -- or Options.Head
                    local Predicted_Position = ShootThis.CFrame + (ShootThis.Velocity * _G.Prediction + Vector3.new(0,0.5,0)) --  (-1) = Less blatant
                    return ((Index == "Hit" and Predicted_Position))
                end
            end
            
        end
        return oldIndex(self, Index)
    end)
