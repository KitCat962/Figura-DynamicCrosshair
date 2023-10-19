local c = require("KattConfigManager")
c.delete("KattDynamicCrosshair")
c.save("KattDynamicCrosshair",{
    main = {_script = true, path = "KattDynamicCrosshairSrc"},
})