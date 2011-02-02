
texture_cache = {}

-- loads file into a texture cache and reuses them if needed
function load(file)
    if texture_cache[file] == nil then
        texture_cache[file] = love.graphics.newImage(file)
    end
    return texture_cache[file]
end
