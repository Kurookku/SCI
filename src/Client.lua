-- Constructor --
local SCI = {}
SCI.__index = SCI

function SCI._new()
	local self = setmetatable({}, SCI)
	
	self._Controllers = {}
	
	return self
end

--====================--
--== Public methods ==--
--====================--

function SCI:AddController(module_script: ModuleScript)
	assert(module_script.ClassName == "ModuleScript", module_script.Name .. " is not a ModuleScript")
	assert(not self._Controllers[module_script.Name], "More than one " .. module_script.Name .. " has been included")

	self._Controllers[module_script.Name] = require(module_script)

	if self._Controllers[module_script.Name].Init then
		self._Controllers[module_script.Name]:Init()
	end
end

function SCI:AddControllers(path: Instance)
	assert(typeof(path) == "Instance", "path is not an Instance")

	for index, module_script in next, path:GetChildren() do
		self:AddController(module_script)
	end
end

function SCI:Start()
	for index, singleton in next, self._Controllers do
		if not singleton.Start then continue end

		singleton:Start()
	end
end

function SCI:GetController(controller_name)
	return self._Controllers[controller_name]
end

--=====================--
--== Private methods ==--
--=====================--

return SCI._new()