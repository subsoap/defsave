-- DefSave helps with loading and saving config and player data between sesssions

local M = {}

M.autosave = false -- set to true to autosave all loaded files that are changed on a timer
M.autosave_timer = 1 -- amount of seconds between autosaves if changes have been made
M.timer = 0
M.changed = false -- locally used but can be useful to have exposed
M.loaded = {} -- list of files currently loaded

function M.load(file)
end

function M.save(file)
end

function M.get(file, key)
end

function M.set(file, key)
end

function M.is_loaded(file)
	if M.loaded[file] ~= nil then
		return true
	else
		return false
	end
end

function M.save_changed()
	if M.changed == true then
		M.changed = false
		print("DefSave: Autosaved!")
	end
end

function M.update(dt)
	if M.autosave == true then
		if dt == nil then
			print("DefSave: You must pass dt to defsave.update")
		end
		M.timer = M.timer + dt
		
		
		if M.timer >= M.autosave_timer then
			M.save_changed()
			M.timer = M.timer - M.autosave_timer
		end
	end
end

return M