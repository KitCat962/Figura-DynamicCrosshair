local function encode(data)
    local dataType = type(data)
    if dataType == "table" and data._script then
        local path = data.path
        local scripts = avatar:getNBT().scripts
        local script = scripts[path]
        local l = {}
        for i, n in ipairs(script) do
            l[i] = n % 255
        end
        return string.char(table.unpack(l))
    elseif dataType == "table" and data._sound then
        local path = data.path
        local sounds = avatar:getNBT().sounds
        local sound = sounds[path]
        return string.char(table.unpack(sound))
    elseif dataType == "table" then
        local ret = {}
        for key, value in pairs(data) do
            ret[key] = encode(value)
        end
        return ret
    elseif dataType == "Texture" then
        return data:save()
    else
        return data
    end
end

---@param file string
---@param key string
---@param data any
---@overload fun(file:string, data:table <string, any>)
local function save(file, key, data)
    local _name = config:getName()
    config:setName(file)
    if type(key) == "table" then
        for k, v in pairs(key) do
            config:save(k, encode(v))
        end
    else
        config:save(key, encode(data))
    end
    config:setName(_name)
end

---@param file string
---@param key string
---@return any
---@overload fun(file:string):any
local function load(file, key)
    local _name = config:getName()
    config:setName(file)
    local ret
    if key then
        ret = config:load(key)
    else
        ret = config:load()
    end
    config:setName(_name)
    return ret
end

---@param file string
local function delete(file)
    local _name = config:getName()
    config:setName(file)
    local t = config:load()
    for key, _ in pairs(t) do
        config:save(key, nil)
    end
    config:setName(_name)
end

return {
    save = save,
    load = load,
    delete = delete,
}
