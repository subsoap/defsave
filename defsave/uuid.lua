--- Generates UUIDs in version 4 format (randomly) only right now
-- random seed is set once on module init

M = {}

local function randomseed(seed)
	local bitsize = 32
	local lua_version = tonumber(_VERSION:match("%d%.*%d*"))
	seed = math.floor(math.abs(seed))
	if seed >= (2^bitsize) then
		-- avoid overflow causing 1 or 0 as seed = repeated seeds
		seed = seed - math.floor(seed / 2^bitsize) * (2^bitsize)
	end
	if lua_version < 5.2 then
		-- 5.1 (incorrect) signed int
		math.randomseed(seed - 2^(bitsize-1))
	else
		-- 5.2 (correct) unsigned int
		math.randomseed(seed)
	end
	return seed
end

local function set_random_seed()
	randomseed(os.time()*10000)
end

function M.generate_UUID_version_4()
	local UUID_template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return string.gsub(UUID_template, '[xy]', function (c)
		local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
		local UUID, _ = string.format('%x', v)
		return UUID
	end)
end

set_random_seed()

--print(M.generate_UUID_version_4())
--UUID, _ = M.generate_UUID_version_4()
--print(UUID)

return M