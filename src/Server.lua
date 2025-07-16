-- Constructor --
local SCP = {}
SCP.__index = SCP

function SCP._new()
	local self = setmetatable({}, SCP)
	
	self._Services = {}
	
	return self
end

--====================--
--== Public methods ==--
--====================--

function SCP:AddService(module_script: ModuleScript)
	assert(module_script.ClassName == "ModuleScript", module_script.Name .. " is not a ModuleScript")
	assert(not self._Services[module_script.Name], "More than one " .. module_script.Name .. " has been included")

	self._Services[module_script.Name] = require(module_script)

	if self._Services[module_script.Name].Init then
		self._Services[module_script.Name]:Init()
	end
end

function SCP:AddServices(path: Instance)
	assert(typeof(path) == "Instance", "path is not an Instance")

	for index, module_script in next, path:GetChildren() do
		self:AddService(module_script)
	end
end

function SCP:Start()
	for index, service in next, self._Services do
		if not service.Start then continue end

		service:Start()
	end
end

function SCP:GetService(service_name)
	return self._Services[service_name]
end

--=====================--
--== Private methods ==--
--=====================--

return SCP._new()