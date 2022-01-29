-- Profile is meant to be used in games with multi-profiles possible
-- Such as PC games with shared computers where each person wants to play their own profile

local defsave = require("defsave.defsave")
local uuid = require("defsave.uuid")
local json = require("defsave.json")

local M = {}

M.defsave_filename = "profile"
M.defsave_key = "profile"
M.verbose = false
M.template_data = {}
M.template_data_filename = nil
M.profiles = {}
M.enable_obfuscation = false -- if true then all data saved and loaded will be XOR obfuscated
M.obfuscation_key = "profile" -- pick a unique obfuscation key, the longer the key for obfuscation the better

-- xor key based obfuscation
local function obfuscate(input, key)
	if M.enable_obfuscation == false then return input end
	key = key or M.obfuscation_key
	local output = ""
	local key_iterator = 1

	local input_length = #input
	local key_length = #key

	for i=1, input_length do
		local character = string.byte(input:sub(i,i))
		if key_iterator >= key_length + 1 then key_iterator = 1 end -- cycle
		local key_byte = string.byte(key:sub(key_iterator,key_iterator))
		output = output .. string.char(bit.bxor( character , key_byte))

		key_iterator = key_iterator + 1

	end
	return output
end

local function decompress(buffer)
	if type(buffer) == "table" then return buffer end
	if buffer == nil then return {} end
	buffer = zlib.inflate(buffer)
	buffer = obfuscate(buffer, M.obfuscation_key)
	buffer = json.decode(buffer)
	return buffer
end

local function compress(buffer)
	buffer = json.encode(buffer)
	buffer = obfuscate(buffer, M.obfuscation_key)
	buffer = zlib.deflate(buffer)
	return buffer
end

function M.set_defsave_filename(filename)
	assert(type(filename) == "string", "Profile: set_defsave_filename must pass a string")
	M.defsave_filename = filename
end

-- loads profile data via DefSave
function M.load()
	defsave.load(M.defsave_filename)
end

-- gets a list of ids of profiles
function M.get_profiles()
	local profiles = {}
	for k,v in pairs(M.profiles) do
		table.insert(profiles, k)
	end
	return profiles
end

-- gets the profile marked as active, returns nil if no active profile is found
function M.get_active_profile()
	for k,v in pairs(M.profiles) do
		if v.__active == true then
			return k
		end
	end
	return nil
end

local function set_active_profile_to_inactive()
	for k,v in pairs(M.profiles) do
		if v.__active == true then
			v.__active = false
			return true
		end
	end
end

-- replaces active profile with marked id
function M.set_active_profile(profile)
	assert(M.profile_exists(profile), "Profile: set_active_profile - profile does not exist " .. tostring(profile))
	if M.verbose == true then print("Profile: New active profile " .. tostring(profile)) end
	set_active_profile_to_inactive()
	M.profiles[profile].__active = true
end



-- deletes a profile based on its id
function M.delete_profile(profile)
	M.profiles[profile] = nil
end

-- create unique profile ID
function M.create_unique_profile_id()
	local uuid_value = uuid.generate_UUID_version_4()
	while M.profiles[uuid_value] ~= nil do
		uuid_value = uuid.generate_UUID_version_4()
	end
	return "profile-" .. uuid_value
end

function M.profile_exists(profile)
	if M.profiles[profile] == nil then
		return false
	else
		return true
	end
end

function M.is_profile_active(profile)
	assert(M.profile_exists(profile), "Profile: is_profile_active - profile does not exist " .. tostring(profile))
	if M.profiles[profile].__active == true then
		return true
	else
		return false
	end
end

-- creates a profile with optional template data used
function M.create_profile(profile, template_data, extra_data)
	if M.verbose == true then print("Profile: create_profile - " .. tostring(profile)) end
	profile = profile or M.create_unique_profile_id()
	assert(M.profile_exists(profile) == false, "Profile: You cannot create duplicate profiles with the same ID")
	M.profiles[profile] = {}
	M.profiles[profile].id = profile
	M.update_profile(profile, M.template_data[template_data])
	M.update_profile(profile, extra_data)
	return profile
end

-- sets a value within the profile id
function M.set_value(profile, key, value)
	assert(M.profiles[profile] ~= nil, "Profile: set_value - the profile " .. tostring(profile) .. " does not exist.")
	M.profiles[profile][key] = value
end

-- returns a value of a profile id
function M.get_value(profile, key)
	assert(M.profiles[profile] ~= nil, "Profile: get_value - the profile " .. tostring(profile) .. " does not exist.")
	return M.profiles[profile][key]
end

-- replaces all values within data into the profile
function M.update_profile(profile, data)
	if M.verbose == true then print("Profile: update_profile") end
	if data == nil then return end
	if next(data) == nil then return end
	for k,v in pairs(data) do
		M.profiles[profile][k] = v
	end
end

-- clears a profile and resets it to template data
function M.reset_profile(profile, template_data)
	if M.verbose == true then print("Profile: Resetting profile " .. tostring(profile)) end
	M.profiles[profile] = {}
	M.update_profile(profile, template_data)
end

function M.update_defsave()
	defsave.set(M.defsave_filename, M.defsave_key, compress(M.profiles))
end

function M.save()
	if M.verbose == true then print("Profile: Saving") end
	M.update_defsave()
	defsave.save_all()
end

function M.final()
	M.save()
end

function M.init()
	if M.verbose == true then print("Profile: Initilized") end
	if M.template_data_filename ~= nil then
		M.template_data = assert(loadstring(sys.load_resource(M.template_data_filename)))()
	end
	if not defsave.is_loaded(M.defsave_filename) then
		defsave.load(M.defsave_filename)
	end
	M.profiles = decompress(defsave.get(M.defsave_filename, M.defsave_key))
end

function M.update()
end

return M
