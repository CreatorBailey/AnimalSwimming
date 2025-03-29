local QBCore = exports['qb-core']:GetCoreObject()

local function IsPlayerAnimal()
    local ped = PlayerPedId()
    return GetPedType(ped) == 28
end

local function HandleAnimalSwim()
    local ped = PlayerPedId()
    print("^6Debug^7: ^3Animal Swim ^2module ^4loaded")

    CreateThread(function()
        while true do
            Wait(200)

            if not IsPlayerAnimal() then break end

            SetPedDiesInWater(ped, false)
            SetPedDiesInstantlyInWater(ped, false)

            if IsEntityInWater(ped) and not IsPedInAnyVehicle(ped, false) then
                SetPedCanRagdoll(ped, false)

                local maxHealth = GetEntityMaxHealth(ped)
                if GetEntityHealth(ped) < maxHealth then
                    SetEntityHealth(ped, maxHealth)
                end

                local submergedLevel = GetEntitySubmergedLevel(ped)
                local pedCoords = GetEntityCoords(ped)
                local _, waterHeight = GetWaterHeight(pedCoords.x, pedCoords.y, pedCoords.z)
                local waterDepth = waterHeight - pedCoords.z

                if submergedLevel > 0.25 then
                    if waterDepth <= 0.5 then
                        ApplyForceToEntity(ped, 1, 0.0, 0.0, 0.6, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    else
                        local force = math.min(0.4 * (submergedLevel - 0.25), 0.2)
                        ApplyForceToEntity(ped, 1, 0.0, 0.0, force, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    if pedCoords.z > waterHeight + 0.1 then
                        ApplyForceToEntity(ped, 1, 0.0, 0.0, -0.1, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    if pedCoords.z < waterHeight - 0.1 then
                        ApplyForceToEntity(ped, 1, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    local currentRotation = GetEntityRotation(ped, 2)
                    SetEntityRotation(ped, currentRotation.x + 0.2, currentRotation.y, currentRotation.z, 2, true)
                end
            else
                SetPedCanRagdoll(ped, true)
            end
        end
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    print("^6Debug^7: ^2Loading ^3Animal Swim ^2module^7...")
    Wait(3000)

    if IsPlayerAnimal() then
        HandleAnimalSwim()
    else
        print("^6Debug^7: ^2Player is ^1not ^2animal^7, ^2stopping ^3Animal Swim ^2module^7...")
    end
end)
