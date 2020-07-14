MenuPool = NativeUI.CreatePool()
MainMenu = NativeUI.CreateMenu("AniMenu", "Main Menu")
MenuPool:Add(MainMenu)

function SendNotification(text)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentString(text)
    EndTextCommandThefeedPostTicker(true, true)
end

function ControlMenu(Menu)
    MenuPool:MouseControlsEnabled (false)
    MenuPool:MouseEdgeEnabled (false)
    MenuPool:ControlDisablingEnabled(false)

    local StopAnim = NativeUI.CreateItem("Stop Animation", "")
    Menu:AddItem(StopAnim)
    Menu.OnItemSelect = function(Sender, Item, Index)
        if Item == StopAnim then
            ClearPedTasksImmediately(PlayerPedId())
        end
    end
end

function AnimationMenu(Menu)
    local AnimList = MenuPool:AddSubMenu(Menu, "Animation List", "List of all animations")
    for AnimIndex = 1, #Animation do
        local Anim = NativeUI.CreateItem(Animation[AnimIndex][2], Animation[AnimIndex][1])
        AnimList.SubMenu:AddItem(Anim)
        AnimList.SubMenu.OnItemSelect = function(Sender, Item, Index)
            if Index == Index then
                local PlayerPed = PlayerPedId()
                RequestAnimDict(Animation[Index][1])
                local Time = 0
                while not HasAnimDictLoaded(Animation[Index][1]) and Time <= 50 do 
                    Citizen.Wait(100)
                    Time = Time + 1
                end

                if Time >= 50 then
                    SendNotification("~r~~h~ERROR ~h~~w~: The animation dictionnary took too long to load.")
                else
                    TaskPlayAnim(PlayerPed, Animation[Index][1], Animation[Index][2], 8.0, 1.0, -1, 1)
                    RemoveAnimDict(Animation[Index][1])
                end
            end
        end
    end
end

AnimationMenu(MainMenu)
ControlMenu(MainMenu)
MenuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        MenuPool:ProcessMenus()
        if IsControlJustPressed(1, 166) then
            MainMenu:Visible(not MainMenu:Visible())
        end
    end
end)
