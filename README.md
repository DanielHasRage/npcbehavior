# NPC Behavior
This is a ModuleScript for ROBLOX I am currently working on developing.

This is still in its BETA phases.

# Use
To use this Module, you must first create a UniqueIdentification for an NPC, and then use that to reference the NPC later on in the script.

Secondly, you must create a node/s.

Thirdly, reference your pathing mode when you want the NPC to move! Simple as that!

# Example
```lua
local Module = require(game:GetService("ServerScriptService"):WaitForChild("NPCBehavior", 5))

local NPC1 = workspace.Dummy1
local Identifier1 = Module.CreateIdentifier(NPC1)
local Node1NPC1 = Module.CreateNode(Identifier1, Vector3.new(9.468, 2.929, -1.774))
local Node2NPC1 = Module.CreateNode(Identifier1, Vector3.new(9.468, 2.929, -35.834))
local Node3NPC1 = Module.CreateNode(Identifier1, Vector3.new(-10.94, 2.929, -35.834))

local NPC2 = workspace.Dummy2
local Identifier2 = Module.CreateIdentifier(NPC2)
local Node1NPC2 = Module.CreateNode(Identifier2, Vector3.new(9.468, 2.929, -1.774))
local Node2NPC2 = Module.CreateNode(Identifier2, Vector3.new(3.699, 2.929, -44.206))
local Node3NPC2 = Module.CreateNode(Identifier2, Vector3.new(24.107, 2.929, -44.206))

task.delay(5, function()
	Module.UnobstructedWalkToAllNodes(Identifier1)
end)

task.delay(7, function()
	Module.UnobstructedWalkToAllNodes(Identifier2)
end)
```
