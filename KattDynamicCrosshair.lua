if not host:isHost() then return end
local _config = config:getName()
local kdc = config:setName("KattDynamicCrosshair"):load("main")
if not kdc then error("Could not find KattDynamicCrosshair soure file in ConfigAPI") end
config:setName(_config)
return load(kdc)(
--models.Crosshair
)
