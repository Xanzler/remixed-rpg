--[[
    Created by mike.
    DateTime: 2024.05.31
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/commonClasses"

local mob = require "scripts/lib/mob"

questList = {
    {
        {
            prologue = { text = 'PlagueDoctorQuest_1_1_Prologue' },
            requirements = { item = { kind = "Carcass of Rat", quantity = 5 } },
            in_progress = { text = "PlagueDoctorQuest_1_1_InProgress" },
            reward = { kind = "RatArmor", quantity = 1 },
            epilogue = { text = "PlagueDoctorQuest_1_1_Epilogue" }
        },
        {
            prologue = { text = 'PlagueDoctorQuest_1_2_Prologue' },
            requirements = { item = { kind = "Carcass of Snail", quantity = 10 } },
            in_progress = { text = "PlagueDoctorQuest_1_2_InProgress" },
            reward = { kind = "Gold", quantity = 50 },
            epilogue = { text = "PlagueDoctorQuest_1_2_Epilogue" }
        }
    },
    {
        {
            prologue = { text = 'PlagueDoctorQuest_2_1_Prologue' },
            requirements = { item = { kind = "Moongrace.Seed", quantity = 2 } },
            in_progress = { text = "PlagueDoctorQuest_2_1_InProgress" },
            reward = { kind = "PotionOfMana", quantity = 1 },
            epilogue = { text = "PlagueDoctorQuest_2_1_Epilogue" }
        },
        {
            prologue = { text = 'PlagueDoctorQuest_2_2_Prologue' },
            requirements = { item = { kind = "Sungrass.Seed", quantity = 2 } },
            in_progress = { text = "PlagueDoctorQuest_2_2_InProgress" },
            reward = { kind = "PotionOfHealth", quantity = 1 },
            epilogue = { text = "PlagueDoctorQuest_2_2_Epilogue" }
        }
    },
    {
        {
            prologue = { text = 'PlagueDoctorQuest_3_1_Prologue' },
            requirements = { mob = { kind = "Bat", quantity = 1 } },
            in_progress = { text = "PlagueDoctorQuest_3_1_InProgress" },
            reward = { kind = "ScrollOfUpgrade", quantity = 1 },
            epilogue = { text = "PlagueDoctorQuest_3_1_Epilogue" }
        },
        {
            prologue = { text = 'PlagueDoctorQuest_3_2_Prologue' },
            requirements = { mob = { kind = "DeathKnight", quantity = 1 } },
            in_progress = { text = "PlagueDoctorQuest_3_2_InProgress" },
            reward = { kind = "PotionOfStrength", quantity = 1 },
            epilogue = { text = "PlagueDoctorQuest_3_2_Epilogue" }
        }
    },
    {
        {
            prologue = { text = 'PlagueDoctorQuest_4_1_Prologue' },
            requirements = { item = { kind = "Carcass of Warlock", quantity = 5 } },
            in_progress = { text = "PlagueDoctorQuest_4_1_InProgress" },
            reward = { kind = "PotionOfMight", quantity = 1 },
            epilogue = { text = "PlagueDoctorQuest_4_1_Epilogue" }
        },
        {
            prologue = { text = 'PlagueDoctorQuest_4_2_Prologue' },
            requirements = { item = { kind = "Carcass of KoboldIcemancer", quantity = 5 } },
            in_progress = { text = "PlagueDoctorQuest_4_2_InProgress" },
            reward = { kind = "PotionOfMight", quantity = 1 },
            epilogue = { text = "PlagueDoctorQuest_4_2_Epilogue" }
        }
    }
}

return mob.init({
    interact = function(self, chr)
        data = mob.restoreData(self)

        local questIndex = data["questIndex"]
        local questVariant = data["questVariant"]

        if data["questIndex"] > #questList then
            self:say("All quests complete!")
            return
        end

        if not data["questInProgress"] then
            questVariant = math.random(1, #questList[questIndex])

            RPD.showQuestWindow(self, questList[questIndex][questVariant].prologue.text)

            data["questInProgress"] = true
            data["questVariant"] = questVariant

            mob.storeData(self, data)
            return
        else
            local quest = questList[questIndex][questVariant]
            local requirements = quest.requirements

            if requirements.item then

                local itemDesc = requirements.item
                local wantedItem = chr:checkItem(itemDesc.kind)
                local wantedQty = itemDesc.quantity
                local actualQty = wantedItem:quantity()

                if actualQty >= wantedQty then
                    if wantedQty == actualQty then
                        wantedItem:removeItem()
                    else
                        wantedItem:quantity(actualQty - wantedQty)
                    end

                    RPD.showQuestWindow(self, quest.epilogue.text)

                    data["questInProgress"] = false
                    data["questIndex"] = questIndex + 1

                    local reward = RPD.item(quest.reward.kind, quest.reward.quantity)
                    chr:collectAnimated(reward)

                    mob.storeData(self, data)
                    return
                end

            elseif requirements.mob then
                local wantedMob = requirements.mob.kind
                local wantedQty = requirements.mob.quantity

                local pets = chr:getPets_l()

                local actualQty = 0

                for _, mob in pairs(pets) do
                    if mob.kind == wantedMob then
                        actualQty = actualQty + 1
                    end
                end

                if actualQty >= wantedQty then

                    for _, mob in pairs(pets) do
                        if mob.kind == wantedMob and wantedQty < 0 then
                            wantedQty = wantdQty - 1
                            mob:makePet(self)
                        end
                    end

                    RPD.showQuestWindow(self, quest.epilogue.text)
                    data["questInProgress"] = false
                    data["questIndex"] = questIndex + 1
                    mob.storeData(self, data)
                    return
                end

            else
                RPD.showQuestWindow(self, quest.in_progress.text)
                return
            end


        end

    end,
    spawn = function(self, level)
        level:setCompassTarget(self:getPos())
        data = mob.restoreData(self)
        data["questIndex"] = 1
        data["questInProgress"] = false
        mob.storeData(self, data)
    end
})
