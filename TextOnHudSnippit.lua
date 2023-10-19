local dynamicCrosshair = require((...):gsub("(.)$", "%1.") .. "KattDynamicCrosshair")

local hudTextTask = dynamicCrosshair.model:newText("DynamicCrosshairHudText"):shadow(true)
local hudMainHandItemTask = dynamicCrosshair.model:newItem("DynamicCrosshairHudMainHand"):pos(-16, 32)
    :displayMode("GUI")
local hudOffHandItemTask = dynamicCrosshair.model:newItem("DynamicCrosshairHudOffhand"):pos(-32, 32)
    :displayMode("GUI")
local hudBootsItemTask = dynamicCrosshair.model:newItem("DynamicCrosshairHudBoots"):pos(-64, 16)
    :displayMode("GUI")
local hudLeggingsItemTask = dynamicCrosshair.model:newItem("DynamicCrosshairHudLeggings"):pos(-48, 16)
    :displayMode("GUI")
local hudChestplateItemTask = dynamicCrosshair.model:newItem("DynamicCrosshairHudChestplate"):pos(
  -32, 16):displayMode("GUI")
local hudHelmetItemTask = dynamicCrosshair.model:newItem("DynamicCrosshairHudHelmet"):pos(-16, 16)
    :displayMode("GUI")
function dynamicCrosshair.render(pos, target, screenCoords)
  hudMainHandItemTask:visible(false)
  hudOffHandItemTask:visible(false)
  hudBootsItemTask:visible(false)
  hudLeggingsItemTask:visible(false)
  hudChestplateItemTask:visible(false)
  hudHelmetItemTask:visible(false)
  hudTextTask:visible(false)
  if not target then return end
  hudTextTask:visible(true)
  local scl = 1
  if type(target) == "BlockState" then
    local str = string.format("%s\n%s\n\n",
      target.id,
      tostring(target:getPos()))
    if target.properties then
      for key, value in pairs(target.properties) do
        str = string.format("%s%s: %s\n", str, key,
          type(value) == "table" and printTable(value, 5, true):gsub(string.char(9), "  ") or
          tostring(value))
      end
    end
    if player:isSneaking() and target:hasBlockEntity() then
      for key, value in pairs(target:getEntityData()) do
        str = string.format("%s%s: %s\n", str, key,
          type(value) == "table" and printTable(value, 5, true):gsub(string.char(9), "  ") or
          tostring(value))
      end
    end
    hudTextTask:text(str)
        :pos(-10, (client.getTextHeight(str) / 2) * scl)
        :scale(scl)
  elseif type(target) == "LivingEntityAPI" or type(target) == "PlayerAPI" then
    local str = string.format("%s (%s)\n%e/%e\n%s\n%s\n%s\n\n",
      target:getName(), target:getType(),
      math.floor(target:getHealth() * 100) / 100, target:getMaxHealth(),
      target:getDimensionName(),
      tostring(target:getPos():scale(100):floor():scale(1 / 100)),
      tostring(target:getRot()))
    if player:isSneaking() then
      for key, value in pairs(target:getNbt()) do
        str = string.format("%s%s: %s\n", str, key,
          type(value) == "table" and printTable(value, 5, true):gsub(string.char(9), "  ") or
          tostring(value))
      end
      scl = 0.5
    end
    hudMainHandItemTask:item(target:getItem(1)):visible(true)
        :pos(-16, (client.getTextHeight(str) / 2 * scl) + 32)
    hudOffHandItemTask:item(target:getItem(2)):visible(true)
        :pos(-32, (client.getTextHeight(str) / 2 * scl) + 32)
    hudBootsItemTask:item(target:getItem(3)):visible(true)
        :pos(-64, (client.getTextHeight(str) / 2 * scl) + 16)
    hudLeggingsItemTask:item(target:getItem(4)):visible(true)
        :pos(-48, (client.getTextHeight(str) / 2 * scl) + 16)
    hudChestplateItemTask:item(target:getItem(5)):visible(true)
        :pos(-32, (client.getTextHeight(str) / 2 * scl) + 16)
    hudHelmetItemTask:item(target:getItem(6)):visible(true)
        :pos(-16, (client.getTextHeight(str) / 2 * scl) + 16)
    hudTextTask:text(str)
        :pos(-10, (client.getTextHeight(str) / 2) * scl)
        :scale(scl)
  elseif type(target) == "EntityAPI" then
    local str = string.format("%s (%s)\n%s\n%s\n%s\n\n",
      target:getName(), target:getType(),
      target:getDimensionName(),
      tostring(target:getPos():scale(100):floor():scale(1 / 100)),
      tostring(target:getRot()))
    if player:isSneaking() then
      for key, value in pairs(target:getNbt()) do
        str = string.format("%s%s: %s\n", str, key,
          type(value) == "table" and printTable(value, 5, true):gsub(string.char(9), "  ") or
          tostring(value))
      end
      scl = 0.5
    end
    hudTextTask:text(str)
        :pos(-10, (client.getTextHeight(str) / 2) * scl)
        :scale(scl)
  end
end
