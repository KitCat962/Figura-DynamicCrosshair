--================================================--
--   _  ___ _    ____      _    ___   __  ____    --
--  | |/ (_) |_ / ___|__ _| |_ / _ \ / /_|___ \   --
--  | ' /| | __| |   / _` | __| (_) | '_ \ __) |  --
--  | . \| | |_| |__| (_| | |_ \__, | (_) / __/   --
--  |_|\_\_|\__|\____\__,_|\__|  /_/ \___/_____|  --
--                                                --
--================================================--

--v4.0

local api = {
  enabled = true,
  model = models:newPart("Katt$DynamicCrosshair", "GUI"),
  vanilla = true,
  render = nil,
  blacklistedBlocks = {},
  blacklistedEntities = {
    ["minecraft:item"] = true,
    ["minecraft:potion"] = true,
    ["minecraft:area_effect_cloud"] = true,
    ["minecraft:experience_orb"] = true,
    ["minecraft:experience_bottle"] = true,
    ["minecraft:arrow"] = true,
    ["minecraft:spectral_arrow"] = true,
    ["minecraft:trident"] = true,
    ["minecraft:snowball"] = true,
    ["minecraft:egg"] = true,
    ["minecraft:ender_pearl"] = true,
    ["minecraft:eye_of_ender"] = true,
    ["minecraft:fireworks_rocket"] = true,
    ["minecraft:fishing_bobber"] = true,
    ["minecraft:lightning_bolt"] = true,
    ["minecraft:llama_spit"] = true,
    ["minecraft:evoker_fangs"] = true,
  },
}
function api.setCrosshairModel(model)
  if type(model) ~= "ModelPart" then api.vanilla = true end
  for _, child in ipairs(api.model:getChildren()) do
    api.model:removeChild(child)
  end
  api.model:addChild(model)
  api.vanilla = false
end

function api.setEnabled(bool)
  api.enabled = bool
  renderer:setRenderCrosshair(true)
end

function api.addBlacklistedBlock(blockID)
  api.blacklistedBlocks[blockID] = true
end

function api.removeBlacklistedBlock(blockID)
  api.blacklistedBlocks[blockID] = false
end

function api.addBlacklistedEntity(entityID)
  api.blacklistedEntities[entityID] = true
end

function api.removeBlacklistedEntity(entityID)
  api.blacklistedEntities[entityID] = false
end

local function validBlock(block, pos)
  if not block then return end
  if block:isAir() then return end
  if api.blacklistedBlocks[block.id] then return end
  return pos
end
local function validEntity(entity, pos)
  if not entity then return end
  if api.blacklistedEntities[entity:getType()] then return end
  return pos
end

local function calculateLookDir(rot)
  local pitch = math.rad(rot.x);
  local yaw = math.rad(-rot.y);
  local cYaw = math.cos(yaw);
  local sYaw = math.sin(yaw);
  local cPitch = math.cos(pitch);
  local sPitch = math.sin(pitch);
  return vec(sYaw * cPitch, -sPitch, cYaw * cPitch);
end

local _coords = vec(0, 0)
function events.RENDER(delta, context)
  if context == "FIGURA_GUI" or context == "MINECRAFT_GUI" then return end
  if not api.enabled then
    return
  end
  local playerEyePos = player:getPos(delta):add(0, player:getEyeHeight(), 0)
  local playerLookDir = calculateLookDir(player:getRot(delta))
  local playerReachPos = playerLookDir * host:getReachDistance() + playerEyePos
  local entity, entityPos = raycast:entity(
    playerEyePos,
    playerReachPos,
    function(entity) return entity:getUUID() ~= player:getUUID() end
  )
  local block, blockPos = raycast:block(
    playerEyePos,
    playerReachPos,
    "OUTLINE"
  )
  local targetPos =
      validEntity(entity, entityPos)
      or validBlock(block, blockPos)
      or playerReachPos

  local screenSpace = vectors.worldToScreenSpace(targetPos)

  local coords = screenSpace.xy:mul(client:getScaledWindowSize()):div(2, 2)
  coords:set(math.lerp(_coords, coords, 0.5))
  _coords:set(coords)

  if api.vanilla then
    renderer:setCrosshairOffset(coords)
    renderer:setRenderCrosshair(true)
    api.model:setVisible(true)
  else
    local modelCoords = (coords + client:getScaledWindowSize() / 2) * -1
    api.model:setPos(modelCoords.xy_)
        :setVisible(screenSpace.z >= 1)
        :setScale(3 / screenSpace.w)
    renderer:setRenderCrosshair(false)
  end

  if api.render then api.render(entity or block, coords, targetPos) end
end

return api
