-- Disable drowning and apply constant health restoration for animals
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100) -- Check every 100 ms for responsiveness

        local playerPed = PlayerPedId() -- Get the player's Ped ID

        -- Check if the player's ped model is an animal (add your animal models here)
        if IsPedModel(playerPed, GetHashKey("a_c_rat")) or
           IsPedModel(playerPed, GetHashKey("a_c_shepherd")) or
           IsPedModel(playerPed, GetHashKey("a_c_retriever")) or
           IsPedModel(playerPed, GetHashKey("a_c_rottweiler")) then

            -- If the ped is in water and not in a vehicle
            if IsEntityInWater(playerPed) and not IsPedInAnyVehicle(playerPed, false) then

                -- Ensure the animal does not ragdoll in the water
                SetPedCanRagdoll(playerPed, false)

                -- Restore health to max to prevent drowning or damage
                local maxHealth = GetEntityMaxHealth(playerPed)
                if GetEntityHealth(playerPed) < maxHealth then
                    SetEntityHealth(playerPed, maxHealth)
                end

                -- Disable drowning damage entirely
                SetPedDiesInWater(playerPed, false)

                -- Get how submerged the ped is (0 = not submerged, 1 = fully submerged)
                local submergedLevel = GetEntitySubmergedLevel(playerPed)

                -- Get the current position and water height at that position
                local posX, posY, posZ = table.unpack(GetEntityCoords(playerPed))
                local isInWater, waterHeight = GetWaterHeight(posX, posY, posZ)

                -- Check water depth (distance between player position and water surface)
                local waterDepth = waterHeight - posZ

                -- If in shallow water, apply a stronger upward force to prevent sinking
                if submergedLevel > 0.25 then
                    if waterDepth <= 0.5 then  -- In shallow water (like pools)
                        -- Apply stronger upward force to ensure floating in shallow water
                        ApplyForceToEntity(playerPed, 1, 0.0, 0.0, 0.6, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    else  -- In deeper water (oceans), apply smoother, lower force
                        local force = math.min(0.4 * (submergedLevel - 0.25), 0.2)
                        ApplyForceToEntity(playerPed, 1, 0.0, 0.0, force, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    -- Cap the dog's height above the water surface to prevent rising too high
                    if posZ > waterHeight + 0.1 then
                        -- Apply a small downward force to prevent bouncing too high
                        ApplyForceToEntity(playerPed, 1, 0.0, 0.0, -0.1, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    -- Prevent sinking too far below the waves or water surface
                    if posZ < waterHeight - 0.1 then
                        -- Apply extra force if the animal is sinking too far
                        ApplyForceToEntity(playerPed, 1, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    -- Adjust the rotation slightly to tilt the head down and the butt up (small adjustment)
                    local currentRotation = GetEntityRotation(playerPed, 2)
                    SetEntityRotation(playerPed, currentRotation.x + 0.2, currentRotation.y, currentRotation.z, 2, true)
                end

                -- Optionally play a swim animation for animals with appropriate swimming animation this never worked some make them sink would be nice for a custom animation
                --[[if not IsEntityPlayingAnim(playerPed, "move_rat", "swim", 3) then
                    RequestAnimDict("move_rat")
                    while not HasAnimDictLoaded("move_rat") do
                        Citizen.Wait(100)
                    end
                    TaskPlayAnim(playerPed, "move_rat", "swim", 8.0, -8, -1, 1, 0, false, false, false)
                end]]
            else
                -- Re-enable ragdolling if not in water
                SetPedCanRagdoll(playerPed, true)
            end
        end
    end
end)
