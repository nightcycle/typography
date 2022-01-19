local runService = game:GetService("RunService")
if runService:IsServer() then return end
local packages = script.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))

local viewportSizeY = fusion.State(420)

if not runService:IsEdit() then
	local camera = game.Workspace.CurrentCamera
	viewportSizeY:set(camera.ViewportSize.Y)
	local viewportSizeChangeSignal = camera:GetPropertyChangedSignal("ViewportSize")
	viewportSizeChangeSignal:Connect(function()
		viewportSizeY:set(camera.ViewportSize.Y)
	end)
end

local maxVertResolution = 1200
local minVertResolution = 300

local constructor = {}

function constructor.new(fontState, minSizeState, maxSizeState)
	if typeof(fontState) == "Enum" then fontState = fusion.State(fontState) end
	if type(minSizeState) == "number" then minSizeState = fusion.State(minSizeState) end
	if type(maxSizeState) == "number" then maxSizeState = fusion.State(maxSizeState) end
	local _TextSize = fusion.Computed(function()
		local viewportSizeY = viewportSizeY:get()

		local vertResolution = math.clamp(viewportSizeY, minVertResolution, maxVertResolution)
		local alpha = vertResolution/(maxVertResolution-minVertResolution)

		local min = minSizeState:get()
		local max = maxSizeState:get()

		return math.round(alpha*(max-min) + min)
	end)
	local _Padding = fusion.Computed(function()
		return UDim.new(0, math.floor(_TextSize:get()*0.5))
	end)
	local _Font = fontState
	return fusion.Computed(function()
		return {
			Font = _Font:get(),
			Padding = _Padding:get(),
			TextSize = _TextSize:get(),
		}
	end)
end


return constructor