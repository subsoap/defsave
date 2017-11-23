-- this file store default data for your various files
-- if you don't want any defaults for a file don't include them
-- you don't have to set any defaults for all parts of a file
-- very useful in configs for setting default audio levels for example
-- nested tables are supported but you must manage the nested data

return {



config = {
	audio = { sfx = 0.5, music = 0.6},
	fullscreen = true,
	custom_cursor = true
},


profiles = {
	number_of_profiles = 0,
	current_profile = nil
},

player = {
	score = 0,

}


}