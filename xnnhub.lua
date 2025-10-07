--Xnn处女作
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local version = "v1.1" 
local versionColor = "#30ff6a" 

local Window = WindUI:CreateWindow({
    Title = "Xnn hub <font color='"..versionColor.."'>"..version.."</font>", 
    Icon = "star",
    Author = "作者:Xnn QQ群:805353054",
    Folder = "xnnhub",
    
    Size = UDim2.fromOffset(450, 390),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = true,

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

local Tab = Window:Tab({
    Title = "通用",
    Icon = "bird",
    Locked = false,
})  

local currentWalkSpeed = 16
local currentJumpPower = 50

Tab:Paragraph({
    Title = "===角色属性设置===",   
    })

Tab:Input({
    Title = "移动速度",
    Desc = "输入移动速度值",
    Placeholder = "16", 
    Callback = function(value)
        if value == "" then return end
        local speed = tonumber(value)
        if speed and speed >= 16 and speed <= 300 then
            currentWalkSpeed = speed
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speed
                    WindUI:Notify({
                        Title = "速度已设置",
                        Content = "移动速度: " .. speed,
                        Duration = 2
                    })
                end
            end
        else
            WindUI:Notify({
                Title = "输入错误",
                Content = "请输入16-300之间的数字",
                Duration = 3
            })
        end
    end
})

Tab:Input({
    Title = "跳跃高度",
    Desc = "输入跳跃高度值", 
    Placeholder = "50", 
    Callback = function(value)
        if value == "" then return end 
        local jump = tonumber(value)
        if jump and jump >= 50 and jump <= 300 then
            currentJumpPower = jump
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = jump
                    WindUI:Notify({
                        Title = "跳跃高度已设置",
                        Content = "跳跃高度: " .. jump,
                        Duration = 2
                    })
                end
            end
        else
            WindUI:Notify({
                Title = "输入错误",
                Content = "请输入50-300之间的数字",
                Duration = 3
            })
        end
    end
})

local antiKnockbackEnabled = false
local antiConn
local MAX_SPEED = 30

local function AntiKnockback(character)
    local hrp = character:WaitForChild("HumanoidRootPart")
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local vel = hrp.AssemblyLinearVelocity
        local horizontalSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude

        if horizontalSpeed > MAX_SPEED then
                  
            hrp.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
        end
    end)
    return conn
end

Tab:Toggle({
    Title = "防甩飞 (Anti-Knockback)",
    Desc = "开启后不会被脚本甩飞",
    Default = false,
    Callback = function(value)
        antiKnockbackEnabled = value

        if value then
            local player = game.Players.LocalPlayer
            if player.Character then
                antiConn = AntiKnockback(player.Character)
            end
            player.CharacterAdded:Connect(function(char)
                if antiConn then antiConn:Disconnect() end
                if antiKnockbackEnabled then
                    antiConn = AntiKnockback(char)
                end
            end)
            WindUI:Notify({
                Title = "防甩飞已开启",
                Content = "不会被脚本甩飞",
                Duration = 3
            })
        else
            if antiConn then
                antiConn:Disconnect()
                antiConn = nil
            end
            WindUI:Notify({
                Title = "防甩飞已关闭",
                Content = "会被脚本甩飞",
                Duration = 3
            })
        end
    end
})

Tab:Button({
    Title = "重置",
    Desc = "将速度和跳跃高度重置为默认值",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                currentWalkSpeed = 16
                currentJumpPower = 50
                WindUI:Notify({
                    Title = "重置成功",
                    Content = "速度和跳跃高度已重置为默认值",
                    Duration = 3
                })
            end
        end
    end,
})

local autoApply = false
Tab:Toggle({
    Title = "自动应用",
    Desc = "角色重生时自动应用当前设置",
    Default = false, 
    Callback = function(value)
        autoApply = value
        if value then
            local player = game.Players.LocalPlayer
            player.CharacterAdded:Connect(function(character)
                task.wait(0.5)
                local humanoid = character:WaitForChild("Humanoid")
                humanoid.WalkSpeed = currentWalkSpeed
                humanoid.JumpPower = currentJumpPower
            end)
            WindUI:Notify({
                Title = "自动应用已开启",
                Content = "角色重生时将自动应用设置",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "自动应用已关闭",
                Content = "角色重生时不会自动应用设置",
                Duration = 3
            })
        end
    end,
})

Tab:Button({
    Title = "飞行",
    Desc = "点击加载飞行脚本",
    Callback = function()
        local success, errorMsg = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tyyr4397-cmd/xnnhub/refs/heads/main/XNNFLY.txt"))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "加载成功", 
                Content = "飞行功能已启用",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "错误: " .. tostring(errorMsg),
                Duration = 5
            })
        end
    end
})

local noclipConnection = nil
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Tab:Toggle({
    Title = "穿墙模式",
    Desc = "开启后可以穿过墙壁和障碍物",
    Default = false,
    Callback = function(value)
        if value then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            WindUI:Notify({
                Title = "穿墙模式",
                Content = "已启用 - 可以穿过墙壁",
                Duration = 3
            })
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            WindUI:Notify({
                Title = "穿墙模式",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

local jumpConnection = nil
local UserInputService = game:GetService("UserInputService")

Tab:Toggle({
    Title = "无限跳跃",
    Desc = "开启后无限跳跃",
    Default = false,
    Callback = function(value)
        if value then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            WindUI:Notify({
                Title = "无限跳跃",
                Content = "已启用 - 按空格键跳跃",
                Duration = 3
            })
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
            WindUI:Notify({
                Title = "无限跳跃",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

local Tab2 = Window:Tab({
    Title = "MM2",
    Icon = "box",
    Locked = false,
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Colors = {
    Innocent = Color3.fromRGB(0, 255, 0),   
    Murderer = Color3.fromRGB(255, 0, 0),   
    Sheriff  = Color3.fromRGB(0, 0, 255),   
}

local ESPBoxes = {}
local ESPEnabled = false
local ESPConnection

local function GetPlayerRole(player)
    if not player.Character then return nil end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end

    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("knife") then return "Murderer" end
            if name:find("gun") then return "Sheriff" end
        end
    end

    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("knife") then return "Murderer" end
            if name:find("gun") then return "Sheriff" end
        end
    end

    return "Innocent"
end

local function CreateESPBox(player)
    local drawing = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Role = Drawing.new("Text"),
        Player = player
    }

    drawing.Box.Thickness = 2
    drawing.Box.Filled = false
    drawing.Box.ZIndex = 1

    drawing.Name.Size = 16
    drawing.Name.Center = true
    drawing.Name.Outline = true
    drawing.Name.ZIndex = 2

    drawing.Role.Size = 16
    drawing.Role.Center = true
    drawing.Role.Outline = true
    drawing.Role.ZIndex = 2

    ESPBoxes[player] = drawing
end

local function RemoveESP(player)
    if ESPBoxes[player] then
        for _, obj in pairs(ESPBoxes[player]) do
            if obj and obj.Remove then obj:Remove() end
        end
        ESPBoxes[player] = nil
    end
end

local function UpdateESP()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for player, drawing in pairs(ESPBoxes) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local role = GetPlayerRole(player)

            if humanoidRootPart and humanoid and role and Colors[role] then
                local pos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    local distance = (hrp.Position - humanoidRootPart.Position).Magnitude
                    local scale = math.max(20, 1000 / distance)

                    drawing.Box.Visible = true
                    drawing.Box.Size = Vector2.new(scale, scale * 2)
                    drawing.Box.Position = Vector2.new(pos.X - scale/2, pos.Y - scale)
                    drawing.Box.Color = Colors[role]

                    drawing.Name.Visible = true
                    drawing.Name.Position = Vector2.new(pos.X, pos.Y - scale - 20)
                    drawing.Name.Text = player.Name
                    drawing.Name.Color = Colors[role]

                    drawing.Role.Visible = true
                    drawing.Role.Position = Vector2.new(pos.X, pos.Y - scale - 40)
                    drawing.Role.Text = role
                    drawing.Role.Color = Colors[role]
                else
                    drawing.Box.Visible = false
                    drawing.Name.Visible = false
                    drawing.Role.Visible = false
                end
            else
                drawing.Box.Visible = false
                drawing.Name.Visible = false
                drawing.Role.Visible = false
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then CreateESPBox(player) end
end)
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

Tab2:Toggle({
    Title = "身份高亮ESP",
    Desc = "显示MM2玩家身份 (绿色=无辜者 红色=杀手 蓝色=警长)",
    Default = false,
    Callback = function(value)
        ESPEnabled = value
        if value then
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not ESPBoxes[player] then
                    CreateESPBox(player)
                end
            end
                        
            ESPConnection = RunService.RenderStepped:Connect(UpdateESP)
            WindUI:Notify({
                Title = "ESP",
                Content = "身份高亮已启用",
                Duration = 3
            })
        else            
            if ESPConnection then ESPConnection:Disconnect() ESPConnection = nil end
            for player, _ in pairs(ESPBoxes) do
                RemoveESP(player)
            end
            WindUI:Notify({
                Title = "ESP",
                Content = "身份高亮已禁用",
                Duration = 3
            })
        end
    end
})

Tab2:Paragraph({
    Title = "===杀手===",
    })

Tab2:Button({
    Title = "杀死全部",
    Callback = function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Knife") then
            WindUI:Notify({
                Title = "提示",
                Content = "你不是凶手，无法使用！",
                Duration = 3
            })
            return
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                char:PivotTo(plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
                task.wait(0.1)
            end
        end
    end
})

local autoKillEnabled = false
Tab2:Toggle({
    Title = "自动杀人",
    Default = false,
    Callback = function(state)
        autoKillEnabled = state
        if autoKillEnabled then
            WindUI:Notify({ Title = "自动杀人", Content = "已启用", Duration = 3 })
            task.spawn(function()
                while autoKillEnabled and task.wait(0.5) do
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Knife") then
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                if dist < 20 then
                                    char:PivotTo(plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
                                end
                            end
                        end
                    else
                        autoKillEnabled = false
                        WindUI:Notify({ Title = "自动杀人", Content = "已禁用", Duration = 3 })
                        break
                    end
                end
            end)
        else
            WindUI:Notify({ Title = "自动杀人", Content = "已禁用", Duration = 3 })
        end
    end
})

local reachEnabled = false
Tab2:Toggle({
    Title = "攻击范围扩展",
    Default = false,
    Callback = function(state)
        reachEnabled = state

        if reachEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(30, 30, 30)
                    end
                end
            end
            WindUI:Notify({
                Title = "攻击范围扩展",
                Content = "已启用 (hitbox 30)",
                Duration = 3
            })
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(2, 2, 1)
                    end
                end
            end
            WindUI:Notify({
                Title = "攻击范围扩展",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

Tab2:Paragraph({
    Title = "===警长和无辜者===",
    })

local sheriffAimEnabled = false
Tab2:Toggle({
    Title = "警长自动瞄准",
    Default = false,
    Callback = function(state)
        sheriffAimEnabled = state
        if sheriffAimEnabled then
            WindUI:Notify({ Title = "警长自动瞄准", Content = "已启用", Duration = 3 })
            task.spawn(function()
                while sheriffAimEnabled and task.wait(0.1) do
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Gun") then
                        local target, closest = nil, math.huge
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
                                local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                if dist < closest then
                                    closest = dist
                                    target = plr
                                end
                            end
                        end
                        if target and target.Character then
                            char:PivotTo(CFrame.lookAt(
                                char.HumanoidRootPart.Position,
                                target.Character.HumanoidRootPart.Position
                            ))
                        end
                    else
                        sheriffAimEnabled = false
                        WindUI:Notify({ Title = "警长自动瞄准", Content = "已禁用", Duration = 3 })
                        break
                    end
                end
            end)
        else
            WindUI:Notify({ Title = "警长自动瞄准", Content = "已禁用", Duration = 3 })
        end
    end
})

Tab2:Button({
    Title = "自动捡枪",
    Callback = function()
        local gun = workspace:FindFirstChild("GunDrop")
        if gun then
            LocalPlayer.Character:PivotTo(gun.CFrame + Vector3.new(0, 0, 2))
        else
            WindUI:Notify({
                Title = "提示",
                Content = "地图上没有掉落的枪！",
                Duration = 3
            })
        end
    end
})

Tab2:Paragraph({
    Title = "===其他===",
    })

local hitboxEnabled = false
Tab2:Toggle({
    Title = "扩大碰撞箱",
    Default = false,
    Callback = function(state)
        hitboxEnabled = state
        if hitboxEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then root.Size = Vector3.new(10, 10, 10) end
                end
            end
            WindUI:Notify({ Title = "扩大碰撞箱", Content = "已启用", Duration = 3 })
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then root.Size = Vector3.new(2, 2, 1) end
                end
            end
            WindUI:Notify({ Title = "扩大碰撞箱", Content = "已禁用", Duration = 3 })
        end
    end
})

Tab2:Paragraph({ Title = "=== 玩家传送 ===" })

Tab2:Button({
    Name = "传送到凶手",
    Callback = function()
        local murderer = getPlayerByTool("Knife")
        if murderer then teleportToPlayer(murderer) end
    end
})

Tab2:Button({
    Name = "传送到警长",
    Callback = function()
        local sheriff = getPlayerByTool("Gun")
        if sheriff then teleportToPlayer(sheriff) end
    end
})

Tab2:Button({
    Name = "传送到无辜者",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                if not plr.Character:FindFirstChild("Knife") and not plr.Character:FindFirstChild("Gun") then
                    teleportToPlayer(plr)
                    break
                end
            end
        end
    end
})

Tab2:Button({
    Name = "随机传送玩家",
    Callback = function()
        local valid = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(valid, plr)
            end
        end
        if #valid > 0 then
            teleportToPlayer(valid[math.random(1, #valid)])
        end
    end
})

Tab2:Button({
    Name = "传送到最高玩家",
    Callback = function()
        local highestPlayer = nil
        local highestY = -math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local y = plr.Character.HumanoidRootPart.Position.Y
                if y > highestY then
                    highestY = y
                    highestPlayer = plr
                end
            end
        end
        if highestPlayer then teleportToPlayer(highestPlayer) end
    end
})

Tab2:Paragraph({ Title = "=== 地图传送 ===" })

Tab2:Button({
    Name = "传送到大厅",
    Callback = function()
        local lobby = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("Spawn") or workspace:FindFirstChild("MainSpawn")
        if lobby then teleportTo(lobby) end
    end
})

Tab2:Button({
    Name = "传送到掉落枪",
    Callback = function()
        local gun = workspace:FindFirstChild("GunDrop")
        if gun then teleportTo(gun) end
    end
})

Tab2:Button({
    Name = "传送到地图中心",
    Callback = function()
        local map = workspace:FindFirstChild("Map")
        if map then
            local center = map:GetBoundingBox()
            LocalPlayer.Character:PivotTo(center + Vector3.new(0, 10, 0))
        else
            LocalPlayer.Character:PivotTo(CFrame.new(0, 50, 0))
        end
    end
})

Tab2:Button({
    Name = "传送到隐藏点",
    Callback = function()
        local hiddenSpots = {
            Vector3.new(0, 100, 0),
            Vector3.new(100, 50, 100),
            Vector3.new(-100, 50, -100),
            Vector3.new(0, 200, 0),
        }
        local randomSpot = hiddenSpots[math.random(1, #hiddenSpots)]
        LocalPlayer.Character:PivotTo(CFrame.new(randomSpot))
    end
})

Tab2:Button({
    Name = "传送前方50 stud",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            root.CFrame = root.CFrame + root.CFrame.LookVector * 50
        end
    end
})

Tab2:Button({
    Name = "传送上方50 stud",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            root.CFrame = root.CFrame + Vector3.new(0, 50, 0)
        end
    end
})

Tab2:Paragraph({ Title = "=== 位置保存 ===" })

local savedPositions = {}

Tab2:Button({
    Name = "保存当前位置",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local posName = "Position_" .. #savedPositions + 1
            savedPositions[posName] = LocalPlayer.Character.HumanoidRootPart.CFrame
            WindUI:Notify({ Title = "位置保存", Content = "已保存: " .. posName, Duration = 3 })
        end
    end
})

Tab2:Button({
    Name = "传送到上次保存位置",
    Callback = function()
        local posNames = {}
        for name, _ in pairs(savedPositions) do table.insert(posNames, name) end
        if #posNames > 0 then
            local lastPos = savedPositions[posNames[#posNames]]
            LocalPlayer.Character:PivotTo(lastPos)
        end
    end
})

local Tab3 = Window:Tab({
    Title = "忍者传奇",
    Icon = "box",
    Locked = false,
})

Tab3:Paragraph({
    Title = "===自动===",
    })

Tab3:Toggle({
    Title = "自动出售",
    Default = false,
    Callback = function(state)
        getgenv().autosell = state
        if state then            
            task.spawn(function()
                while getgenv().autosell do
                    local player = game:GetService("Players").LocalPlayer
                    if player and player:FindFirstChild("ninjaEvent") then
                        player.ninjaEvent:FireServer("sell")
                    end
                    task.wait(0.5)
                end
            end)            
            WindUI:Notify({
                Title = "自动出售",
                Content = "已启用",
                Duration = 3
            })
        else            
            WindUI:Notify({
                Title = "自动出售",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

Tab3:Toggle({
    Title = "自动挥刀",
    Default = false,
    Callback = function(state)
        getgenv().autoswing = state
        if state then
            task.spawn(function()
                while getgenv().autoswing do
                    local player = game:GetService("Players").LocalPlayer
                    if player and player:FindFirstChild("ninjaEvent") then
                        player.ninjaEvent:FireServer("swingKatana")
                    end
                    task.wait(0.3)
                end
            end)
            WindUI:Notify({
                Title = "自动挥刀",
                Content = "已启用",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "自动挥刀",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

Tab3:Toggle({
    Title = "自动买武器",
    Default = false,
    Callback = function(state)
        getgenv().autobuy = state
        if state then
            task.spawn(function()
                while getgenv().autobuy do
                    local player = game:GetService("Players").LocalPlayer
                    if player and player:FindFirstChild("ninjaEvent") then
                        player.ninjaEvent:FireServer("buyAllSwords", "Ground")
                    end
                    task.wait(1)
                end
            end)
            WindUI:Notify({
                Title = "自动买武器",
                Content = "已启用",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "自动买武器",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

Tab3:Toggle({
    Title = "自动买腰带",
    Default = false,
    Callback = function(state)
        getgenv().autobelt = state
        if state then
            task.spawn(function()
                while getgenv().autobelt do
                    local player = game:GetService("Players").LocalPlayer
                    if player and player:FindFirstChild("ninjaEvent") then
                        player.ninjaEvent:FireServer("buyAllBelts", "Ground")
                    end
                    task.wait(1)
                end
            end)
            WindUI:Notify({
                Title = "自动买腰带",
                Content = "已启用",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "自动买腰带",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

Tab3:Toggle({
    Title = "自动买技能",
    Default = false,
    Callback = function(state)
        getgenv().autobuySkills = state
        if state then
            task.spawn(function()
                while getgenv().autobuySkills do
                    local player = game:GetService("Players").LocalPlayer
                    if player and player:FindFirstChild("ninjaEvent") then
                        player.ninjaEvent:FireServer("buyAllSkills", "Ground")
                    end
                    task.wait(1)
                end
            end)
            WindUI:Notify({
                Title = "自动买技能",
                Content = "已启用",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "自动买技能",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

Tab3:Toggle({
    Title = "自动买手里剑",
    Default = false,
    Callback = function(state)
        getgenv().autobuyShuriken = state
        if state then
            task.spawn(function()
                while getgenv().autobuyShuriken do
                    local player = game:GetService("Players").LocalPlayer
                    if player and player:FindFirstChild("ninjaEvent") then
                        player.ninjaEvent:FireServer("buyAllShurikens", "Ground")
                    end
                    task.wait(1)
                end
            end)
            WindUI:Notify({
                Title = "自动买手里剑",
                Content = "已启用",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "自动买手里剑",
                Content = "已禁用",
                Duration = 3
            })
        end
    end
})

Tab3:Paragraph({
    Title = "===宠物水晶===",
})

local SelectedCrystal
local crystals = game:GetService("Workspace").mapCrystalsFolder:GetChildren()
local crystalNames = {}

for _, crystal in ipairs(crystals) do
    table.insert(crystalNames, crystal.Name)
end

Tab3:AddDropdown({
    Name = "选择水晶",
    Options = crystalNames,
    Callback = function(crystalName)
        SelectedCrystal = crystalName
    end
})

Tab3:AddButton({
    Name = "打开选定水晶",
    Callback = function()
        if SelectedCrystal then
            local event = game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote")
            task.spawn(function()
                local success, err = pcall(function()
                    event:InvokeServer("openCrystal", SelectedCrystal)
                end)
                if success then
                    WindUI:Notify({
                        Title = "水晶",
                        Content = SelectedCrystal.." 已打开",
                        Duration = 3
                    })
                else
                    WindUI:Notify({
                        Title = "错误",
                        Content = "打开水晶失败: "..tostring(err),
                        Duration = 3
                    })
                end
            end)
        else
            WindUI:Notify({
                Title = "错误",
                Content = "请先选择一个水晶！",
                Duration = 3
            })
        end
    end
})

Tab3:Paragraph({
    Title = "===传送===",
})

local islands = {
    "魔法岛屿", "星界岛屿", "神秘岛屿", "太空岛屿",
    "苔原岛屿", "永恒岛屿", "沙暴", "雷暴",
    "古代地狱岛屿", "午夜暗影岛屿", "神话灵魂岛屿",
    "冬季仙境岛屿", "黄金大师岛屿", "龙之传说岛屿",
    "赛博传奇岛屿", "天空风暴岛屿", "混沌传奇岛屿",
    "灵魂融合岛屿", "黑暗元素岛屿", "内心平静岛屿",
    "炽热漩涡岛屿"
}

local SelectedIsland

Tab3:AddDropdown({
    Name = "选择岛屿",
    Options = islands,
    Callback = function(islandName)
        SelectedIsland = islandName
    end
})

Tab3:AddButton({
    Name = "传送到选中岛屿",
    Callback = function()
        if SelectedIsland then
            local part = game:GetService("Workspace").islandUnlockParts:FindFirstChild(SelectedIsland)
            local player = game.Players.LocalPlayer
            if part and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = part.CFrame
                WindUI:Notify({
                    Title = "传送",
                    Content = "已传送到："..SelectedIsland,
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "未找到该岛屿！",
                    Duration = 3
                })
            end
        else
            WindUI:Notify({
                Title = "错误",
                Content = "请先选择一个岛屿！",
                Duration = 3
            })
        end
    end
})

Tab3:Paragraph({
    Title = "===杂项===",
})

Tab3:AddButton({
    Name = "解锁所有岛屿",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        for _, part in pairs(game:GetService("Workspace").islandUnlockParts:GetChildren()) do
            firetouchinterest(char:WaitForChild("HumanoidRootPart"), part, 0)
            firetouchinterest(char:WaitForChild("HumanoidRootPart"), part, 1)
        end
        WindUI:Notify({
            Title = "解锁所有岛屿",
            Content = "已解锁！",
            Duration = 3
        })
    end
})

Tab3:AddButton({
    Name = "解锁所有元素",
    Callback = function()
        for _, element in pairs(game:GetService("ReplicatedStorage").Elements:GetChildren()) do
            game:GetService("ReplicatedStorage").rEvents.elementMasteryEvent:FireServer(element)
        end
        WindUI:Notify({
            Title = "解锁所有元素",
            Content = "已解锁！",
            Duration = 3
        })
    end
})

Tab3:AddButton({
    Name = "无限二段跳",
    Callback = function()
        game.Players.LocalPlayer.multiJumpCount.Value = 999999999
        WindUI:Notify({
            Title = "无限二段跳",
            Content = "已启用",
            Duration = 3
        })
    end
})

WindUI:Notify({
    Title = "Xnn Hub 加载成功",
    Content = "版本 " .. version .. " 已就绪",
    Duration = 5
})

print("Xnn Hub " .. version .. " 加载完成！")

do
    local Players = game:GetService("Players")
    local VirtualUser = game:GetService("VirtualUser")
    local LocalPlayer = Players.LocalPlayer

    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    WindUI:Notify({
        Title = "防挂机已启用",
        Content = "Anti-AFK 已自动开启",
        Duration = 4
    })

    print("Anti-AFK 已加载完成")
end