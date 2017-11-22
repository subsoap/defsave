# DefSave
A module to help you save / load config and player data in your Defold projects between sessions

## Installation
You can use DefSave in your own project by adding this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

	https://github.com/subsoap/defsave/archive/master.zip
  
Once added, you must require the main Lua module in scripts via

```
local defsave = require("defsave.defsave")
```
