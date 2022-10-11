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

local Settings = script.Settings -- Getting the settings folder and recognizing its descendants
local Warnings = Settings.Warnings
local Debug = Settings.Debug

function NPCBHVR.CreateIdentifier(CharacterObject)
	local UniqueIdentification = Instance.new("NumberValue", CharacterObject) -- Create the NumberValue instance to reference later for nodes and movement
	UniqueIdentification.Name = "UniqueIdentification"
	UniqueIdentification.Value = math.floor(math.random(1,999999999)) -- Assigning it a unique value
	
	return UniqueIdentification -- Returning this value to be used later down the line
end

function NPCBHVR.CreateNode(UniqueIdentification, NodePosition)
	local EndProduct -- This value will be turned into a node to be returned
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("UniqueIdentification") then -- Checking if the Character has a UniqueIdentifiers, meaning it is a registered NPC
			if v:WaitForChild("UniqueIdentification", 5).Value == UniqueIdentification.Value then -- If so, check if it is the NPC you are referencing through ARG 2
				if #v:WaitForChild("UniqueIdentification", 5):GetChildren() <= 0 then -- Check if anything exists in the UniqueIdentification Instance, if not then
					local NodesFolder = Instance.new("Folder", v:WaitForChild("UniqueIdentification", 5)); NodesFolder.Name = "Nodes"  -- Create node storage
					local NodeCount = Instance.new("NumberValue", NodesFolder); NodeCount.Name = "NodeCount" -- Count the nodes to assign them in order later on
					local Moving = Instance.new("BoolValue", v:WaitForChild("UniqueIdentification", 5)); Moving.Name = "Moving" -- Determine whether the character is already moving
				end
				v:WaitForChild("UniqueIdentification", 5):WaitForChild("Nodes", 5):WaitForChild("NodeCount").Value += 1 -- Progress in the amount of nodes when making a new node
				local NewNode = Instance.new("Vector3Value", v:WaitForChild("UniqueIdentification", 5):WaitForChild("Nodes", 5)) -- Create the new node and assign its parent
				NewNode.Name = "Node:" .. tostring(v:WaitForChild("UniqueIdentification", 5):WaitForChild("Nodes", 5):WaitForChild("NodeCount").Value) -- Assign the node a name that can be easily split later on for table storage
				NewNode.Value = NodePosition -- Give the nodes position in ARG 2 over to the Vector3 value
				EndProduct = NewNode -- Make end product and newnode one and the same
			else
				if Warnings.Value == true then warn("Critical Error (CreateNode): UniqueIdentification does not match") end
				warn(UniqueIdentification.Value); warn(v.UniqueIdentification.Value)
			end
		end
	end
	
	return EndProduct -- Return the EndProduct AKA the new node for reference later on
end

--[[

█ █ █
▄ ▄ ▄

Past this point is NPC Movement, tampering with this could very well cause the script to throw errors and lose functionality, be cautious.

]]--

function NPCBHVR.UnobstructedWalkTo(UniqueIdentification, Node) -- Here a node is passed through for a single node movement
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("UniqueIdentification") then
			if v:WaitForChild("UniqueIdentification", 5).Value == UniqueIdentification.Value then
				if v:WaitForChild("UniqueIdentification", 5):WaitForChild("Moving", 5).Value == false then -- Check to see if the NPC is currently moving, if not, proceed, else warn the user at line 103
					v:WaitForChild("UniqueIdentification", 5):WaitForChild("Moving", 5).Value = true
					if Debug.Value == true then -- Debug makes it to where nodes are visible when the NPC is moving, and shows their pathing as well, when disabled the script still functions normally
						if Warnings.Value == true then warn("Procedure (Settings): Debug is true, Nodes and Tracking will appear") end -- Warn them that DEBUG is on in-case of them not wanting it on
						local NodeClone = Debug.Node:Clone() -- Cloning the Nodes debug part
						NodeClone.Parent = v
						NodeClone.Position = Node.Value -- Moving it to the node that is passed through
						
						local HRPAttachment = Instance.new("Attachment", v:WaitForChild("HumanoidRootPart", 5)) -- Attaching beam to the HRP and Node to show pathing
						local NodeCloneAttachment = NodeClone.Attachment
						local NodeCloneBeam = NodeClone.Attachment.Beam
						
						NodeCloneBeam.Attachment0 = HRPAttachment; NodeCloneBeam.Attachment1 = NodeCloneAttachment -- Attaching beam to the HRP and Node to show pathing
						
						v:WaitForChild("Humanoid", 5):MoveTo(Node.Value) -- Moving the NPC to the nodes position
						v:WaitForChild("Humanoid", 5).MoveToFinished:Wait() -- Waiting for the NPC to arrive
						v:WaitForChild("UniqueIdentification", 5):WaitForChild("Moving", 5).Value = false -- Reverting them back to being still in the moving value
						
						game.Debris:AddItem(NodeClone, 0) -- removing node
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

function NPCBHVR.UnobstructedWalkToAllNodes(UniqueIdentification) -- Here a UniqueIdentification is passed through to have the NPC move through all nodes in the order they were added
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("UniqueIdentification") then
			if v:WaitForChild("UniqueIdentification", 5).Value == UniqueIdentification.Value then
				local Nodes = v:WaitForChild("UniqueIdentification", 5):WaitForChild("Nodes", 5):GetChildren() -- Array of nodes
				local ProperNodes = {} -- Table of nodes in number order
				
				for i,v in pairs(Nodes) do
					if v.Name == "NodeCount" then -- Ignoring the NodeCount instance and warning that I did so
						if Warnings.Value == true then warn("Procedure (UnobstructedWalkToAllNodes): Ignoring the instance 'NodeCount'") end
					else
						local A = string.split(v.Name, ":") -- Splitting the name of the nodes to get the number value

						for ST1, ST2 in pairs(A) do -- indexing this array to access the number
							local B = tonumber(ST2) -- Converting the numberstring into a normal number
							if B ~= nil then -- Making sure that it isn't nil before passing it onto the array
								ProperNodes[B] = v.Value -- Adding the node to the array
							end
						end
					end
				end
				
				for number, position in pairs(ProperNodes) do -- Cycling through the array and moving to the nodes using the same method as the previous function
					if Debug.Value == true then -- again, debug is toggleable
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
