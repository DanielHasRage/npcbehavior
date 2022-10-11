local NPCBHVR = {}

--[[

█ █▄░█ █▀▀ █▀█ █▀█ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
█ █░▀█ █▀░ █▄█ █▀▄ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█

You are permitted to use this module however you see fit.

Make sure that all of your NPC's are placed in the WORKSPACE!

Made by Dawave

NPCBHVR.CreateIdentifier(CharacterObject) -- This function returns a NumberValue instance, used when modifying a specific NPC's params
NPCBHVR.CreateNode(UniqueIdentification, NodePosition) -- This function returns a Vector3Value instance, used when moving the NPC to that position

NPCBHVR.UnobstructedWalkTo(UniqueIdentification, Node) -- This function implies that the character can move in a straight line to this node, without being obstructed
NPCBHVR.UnobstructedWalkTo(UniqueIdentification, Node) -- This function implies that the character can move to every created node without being obstructed

█ █ █
▄ ▄ ▄

Editing this module may result in script errors, and impede functionality, please refrain from doing so.

]]--

local Settings = script.Settings
local Warnings = Settings.Warnings
local Debug = Settings.Debug

function NPCBHVR.CreateIdentifier(CharacterObject)
	local UniqueIdentification = Instance.new("NumberValue", CharacterObject)
	UniqueIdentification.Name = "UniqueIdentification"
	UniqueIdentification.Value = math.floor(math.random(1,999999999))
	
	return UniqueIdentification
end

function NPCBHVR.CreateNode(UniqueIdentification, NodePosition)
	local EndProduct
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("UniqueIdentification") then
			if v:WaitForChild("UniqueIdentification", 5).Value == UniqueIdentification.Value then
				if #v:WaitForChild("UniqueIdentification", 5):GetChildren() <= 0 then
					local NodesFolder = Instance.new("Folder", v:WaitForChild("UniqueIdentification", 5)); NodesFolder.Name = "Nodes" 
					local NodeCount = Instance.new("NumberValue", NodesFolder); NodeCount.Name = "NodeCount"
					local Moving = Instance.new("BoolValue", v:WaitForChild("UniqueIdentification", 5)); Moving.Name = "Moving"
				end
				v:WaitForChild("UniqueIdentification", 5):WaitForChild("Nodes", 5):WaitForChild("NodeCount").Value += 1
				local NewNode = Instance.new("Vector3Value", v:WaitForChild("UniqueIdentification", 5):WaitForChild("Nodes", 5))
				NewNode.Name = "Node:" .. tostring(v:WaitForChild("UniqueIdentification", 5):WaitForChild("Nodes", 5):WaitForChild("NodeCount").Value)
				NewNode.Value = NodePosition
				EndProduct = NewNode
			else
				if Warnings.Value == true then warn("Critical Error (CreateNode): UniqueIdentification does not match") end
				warn(UniqueIdentification.Value); warn(v.UniqueIdentification.Value)
			end
		end
	end
	
	return EndProduct
end

--[[

█ █ █
▄ ▄ ▄

Past this point is NPC Movement, tampering with this could very well cause the script to throw errors and lose functionality, be cautious.

]]--

function NPCBHVR.UnobstructedWalkTo(UniqueIdentification, Node)
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("UniqueIdentification") then
			if v:WaitForChild("UniqueIdentification", 5).Value == UniqueIdentification.Value then
				if v:WaitForChild("UniqueIdentification", 5):WaitForChild("Moving", 5).Value == false then
					v:WaitForChild("UniqueIdentification", 5):WaitForChild("Moving", 5).Value = true
					if Debug.Value == true then
						if Warnings.Value == true then warn("Procedure (Settings): Debug is true, Nodes and Tracking will appear") end
						local NodeClone = Debug.Node:Clone()
						NodeClone.Parent = v
						NodeClone.Position = Node.Value
						
						local HRPAttachment = Instance.new("Attachment", v:WaitForChild("HumanoidRootPart", 5))
						local NodeCloneAttachment = NodeClone.Attachment
						local NodeCloneBeam = NodeClone.Attachment.Beam
						
						NodeCloneBeam.Attachment0 = HRPAttachment; NodeCloneBeam.Attachment1 = NodeCloneAttachment
						
						v:WaitForChild("Humanoid", 5):MoveTo(Node.Value)
						v:WaitForChild("Humanoid", 5).MoveToFinished:Wait()
						v:WaitForChild("UniqueIdentification", 5):WaitForChild("Moving", 5).Value = false
						
						game.Debris:AddItem(NodeClone, 0)
						game.Debris:AddItem(HRPAttachment, 1)
					else
						v:WaitForChild("Humanoid", 5):MoveTo(Node.Value)
						v:WaitForChild("Humanoid", 5).MoveToFinished:Wait()
						v:WaitForChild("UniqueIdentification", 5):WaitForChild("Moving", 5).Value = false
					end
				else
					if Warnings.Value == true then error("Error (UnobstructedWalkTo): NPC is already moving when you tried to throw another movement function") end
				end
			end
		end
	end
end

function NPCBHVR.UnobstructedWalkToAllNodes(UniqueIdentification)
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("UniqueIdentification") then
			if v:WaitForChild("UniqueIdentification", 5).Value == UniqueIdentification.Value then
				local Nodes = v:WaitForChild("UniqueIdentification", 5):WaitForChild("Nodes", 5):GetChildren()
				local ProperNodes = {}
				
				for i,v in pairs(Nodes) do
					if v.Name == "NodeCount" then
						if Warnings.Value == true then warn("Procedure (UnobstructedWalkToAllNodes): Ignoring the instance 'NodeCount'") end
					else
						local A = string.split(v.Name, ":")

						for ST1, ST2 in pairs(A) do
							local B = tonumber(ST2)
							if B ~= nil then
								ProperNodes[B] = v.Value
							end
						end
					end
				end
				
				for number, position in pairs(ProperNodes) do
					if Debug.Value == true then
						if Warnings.Value == true then warn("Procedure (Settings): Debug is true, Nodes and Tracking will appear") end
						local NodeClone = Debug.Node:Clone()
						NodeClone.Parent = v
						NodeClone.Position = position

						local HRPAttachment = Instance.new("Attachment", v:WaitForChild("HumanoidRootPart", 5))
						local NodeCloneAttachment = NodeClone.Attachment
						local NodeCloneBeam = NodeClone.Attachment.Beam

						NodeCloneBeam.Attachment0 = HRPAttachment; NodeCloneBeam.Attachment1 = NodeCloneAttachment

						v:WaitForChild("Humanoid", 5):MoveTo(position)
						v:WaitForChild("Humanoid", 5).MoveToFinished:Wait()

						game.Debris:AddItem(NodeClone, 0)
						game.Debris:AddItem(HRPAttachment, 1)
					else
						v:WaitForChild("Humanoid", 5):MoveTo(position)
						v:WaitForChild("Humanoid", 5).MoveToFinished:Wait()
					end
				end
			end
		end
	end
end

return NPCBHVR

-- Thanks for using my Module :D
