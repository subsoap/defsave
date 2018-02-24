local defsave = require("defsave.defsave")

local M = {}

M.defsave_filename = "profile"
M.template_data = {}

-- gets a list of ids of profiles
function M.get_profiles()
end

-- gets the profile marked as active, returns false if no active profile is found
function M.get_active_profile()
end

-- replaces active profile with marked id
function M.set_active_profile(profile)
end

-- deletes a profile based on its id
function M.delete_profile(profile)
end

-- creates a profile with optional template data used
function M.create_profile(profile, template_data)
end

-- sets a value within the profile id
function M.set_value(profile, key, value)
end

-- returns a value of a profile id
function M.get_value(profile, key)
end

-- replaces all values within data into the profile
function M.update_profile(profile, data)
end

-- clears a profile and resets it to template data
function M.reset_profile(profile, template_data) 
end

function M.final()
end

function M.init()
end

function M.update()
end

return M