-- TOolbox 
-- Many thanks to Etb for getting all the content ids!
tb = { }
tb.running = false
tb.visible = false
tb.lastrun = 0

function tb.ModuleInit() 

	if (Settings.GW2MINION.WvW_Loot == nil) then
		Settings.GW2MINION.WvW_Loot = "0"
	end
	if (Settings.GW2MINION.WvW_Speed == nil) then
		Settings.GW2MINION.WvW_Speed = "0"
	end
	
	GUI_NewWindow("ToolBox", 450, 100, 200, 300)	
	GUI_NewButton("ToolBox","UnpackAllBags","TB.unpack", "Utility")
	GUI_NewButton("ToolBox","SalvageAllItems","TB.salvage", "Utility")
	GUI_NewButton("ToolBox","SupplyRun","TB.supplyRun","Utility")

	GUI_NewCheckbox("ToolBox","AutoLoot WvW Bags","WvW_Loot","WvWvW")
	GUI_NewCheckbox("ToolBox","+33%Speed","WvW_Speed","WvWvW")
	
	GUI_NewButton("ToolBox","devmonitor","TB.eventmon","DevTools")
	GUI_NewButton("ToolBox","Minions,(Re)load Mesh","TB.reload","DevTools")
	GUI_NewField("ToolBox","Meshname:","greloadmesh", "DevTools");
	GUI_NewButton("ToolBox","PrintItemDataID","TB.printID","DevTools")
	GUI_NewField("ToolBox","ItemName:","tb_itemname","DevTools")

	GUI_NewButton("ToolBox","GetInteractableTarget","TB.getInteractableTarget","DevTools")
	GUI_NewButton("ToolBox","GetTarget","TB.getTarget","DevTools")
	GUI_NewButton("ToolBox","SetTarget","TB.setTarget","DevTools")
	GUI_NewButton("ToolBox","InteractTarget","TB.interactTarget","DevTools")
	GUI_NewField("ToolBox","Target: ","tb_target","DevTools")
	GUI_NewButton("ToolBox","GetConversationOptions","TB.getConversationOptions","DevTools")
	GUI_NewButton("ToolBox","SelectConversationOption","TB.selectConversationOption","DevTools")
	GUI_NewField("ToolBox","Option Number:","tb_option","DevTools")

	GUI_NewButton("ToolBox","PlayerPosition","TB.playerPosition","DevTools")
	GUI_NewButton("ToolBox","MoveTo","TB.moveTo","DevTools")
	GUI_NewButton("ToolBox","Teleport","TB.teleport","DevTools")
	GUI_NewField("ToolBox","X: ","tb_xPos","DevTools")
	GUI_NewField("ToolBox","Y: ","tb_yPos","DevTools")
	GUI_NewField("ToolBox","Z: ","tb_zPos","DevTools")
	GUI_FoldGroup("ToolBox","DevTools")
	GUI_WindowVisible("ToolBox",false)
	tb_itemname = ""
	tb_target = ""

	WvW_Loot = Settings.GW2MINION.WvW_Loot
	
end

function tb.ToggleMenu()
	if (tb.visible) then
		GUI_WindowVisible("ToolBox",false)	
		tb.visible = false
	else
		GUI_WindowVisible("ToolBox",true)	
		tb.visible = true
	end
end


function tb.OnUpdate( event, tickcount )		
	if (tickcount - tb.lastrun > 500) then
		tb.lastrun = tickcount	
		if (tb.running ) then
			if (wt_core_taskmanager.current_task ~= nil) then
				wt_core_taskmanager:DoTask()								
			else			
				tb.running = false				
			end	
		end
		if ( WvW_Loot == "1" ) then
			tb.CheckForWvWLoot()
		end
		if ( WvW_Speed == "1") then
			tb.CheckWvWSpeed()
		end
	end
end



function tb.UnpackBags()
	if (wt_core_taskmanager.current_task == nil) then
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "UNPACKBAG"
		newtask.name = "Opening Bags"
		newtask.timestamp = 0
		newtask.lifetime = 0
		newtask.priority = 15000
		newtask.done = false
		newtask.last_execution = 0
		newtask.throttle = 150
		newtask.deposited = false

		function newtask:execute()
			local opened = false
			if (ItemList.freeSlotCount > 1) then
				newtask.deposited = false
				local inv = ItemList("")	
				id,item = next(inv)
				while (id ~=nil and item ~= nil ) do
					local itemid = item.contentID   --Changed .dataID  to .contentID to avoid data changes, etb
					wt_debug("ID: "..tostring(itemid))          
					if (itemid == 234822 --Light Bag of Booty
					or itemid == 234204 --Light Supply Bag
					or itemid == 57104 --Hidden Hoards
					or itemid == 319074 --Ritual Sacks
					or itemid == 319100 --Bags of Pinched Goods
					or itemid == 342347 --Large Moldy Bags
					or itemid == 342357 --Heavy Moldy Bags
					or itemid == 287821 --Hidden Trove
					or itemid == 319084 --Tiny supply Bags
					or itemid == 235334 --Tiny Bag of Skritt Shinies
					or itemid == 234134 --Tiny Stolen Supplies Bags
					or itemid == 234200 --Small Supply Bags
					or itemid == 319102 --Bags of Filched Goods
					or itemid == 234165 --Tiny Bag of Trinkets
					or itemid == 102433 --Tiny Miner's Bags
					or itemid == 319068 --Tiny Ritual's Bags
					or itemid == 319070 --Small Ritual's Bags
					or itemid == 342335 --Medium Moldy Bags
					or itemid == 234252 --Bags of Theoretical Material
					or itemid == 234557 --Medium  Thorned Bags
					or itemid == 234157 --Large Stolen Supplies Bags
					or itemid == 319094 --Medium Supply Bags
					or itemid == 234830 --Medium Bag of Booty
					or itemid == 234181 --sacks of trinkets
					or itemid == 324308 --large icy bag
					or itemid == 190764 --large loot bag
					or itemid == 346228 --large treat bag
					or itemid == 319080 --large ritual bag
					or itemid == 175863 --large miner's bag
					or itemid == 234189 --large bag of trinkets
					or itemid == 319096 --large supply bag
					or itemid == 319082 --Heavy Ritual Bag
					or itemid == 342310 --Heavy Ice Bag
					or itemid == 190765 --Heavy Loot Bag
					or itemid == 346234 --Heavy Treat Bag
					or itemid == 319098 --Heavy Supply Bag
					or itemid == 234814 --Heavy Torned Bag
					or itemid == 200611 --Heavy Miner's Bag
					or itemid == 234192 --Heavy Bag Of Trinkets
					or itemid == 234224 --Heavy Bag Of Supplies
					or itemid == 234161 --Heavy Stolen Supplies Bag
					or itemid == 235362 --Heavy Bag Of Skritt Shinies
					or itemid == 314406 --Small Icy Bag
					or itemid == 190348 --Small Loot Bag
					or itemid == 342381 --Small Treat Bag
					or itemid == 342315 --Small Moldy Bag
					or itemid == 319086 --Small Supply Bag
					or itemid == 234490 --Small Thorned Bag
					or itemid == 102435 --Small Miner's Bag
					or itemid == 22224 --Small Bag Of Goods
					or itemid == 234820 --Small Bag Of Booty
					or itemid == 234169 --Small Bag Of Trinkets
					or itemid == 234200 --Small Bag Of Supplies
					or itemid == 234138 --Small Stolen Supplies Bag
					or itemid == 235338 --Small Bag Of Skritt Shinies
					) then --ADD MORE IDs HERE
						wt_debug( "Opening Bag..")
						opened = true
						
						item:Use()
					end
					id,item = next(inv,id)
				end
			else 
				if (not newtask.deposited) then
					Inventory:DepositCollectables()
					newtask.deposited = true
					opened = true
				end
			end
			
			if(not opened) then
				newtask.done = true
			end
		end
				
		function newtask:isFinished()
			if ( newtask.done ) then				
				wt_core_taskmanager.current_task = nil
				return true
			end
			return false
		end	
		
		wt_core_taskmanager.current_task = newtask
		tb.running = true
		wt_debug("Unpack Bag Task added..")
	else
		wt_core_taskmanager.current_task = nil
		tb.running = false
	end
end

function tb.AutoSalvage()	
	if (wt_core_taskmanager.current_task == nil) then	
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "AUTOSALVAGE"
		newtask.timestamp = 0
		newtask.lifetime = 0
		newtask.name = "Salvage All Items"
		newtask.priority = 15000
		newtask.done = false
		newtask.last_execution = 0
		newtask.throttle = 150
		newtask.deposited = false
		newtask.lastitemID = 0
		newtask.lastitemstacksize = 0
		newtask.ignorelist = {}
		
		function newtask:execute()
			local taskran = false
			if (ItemList.freeSlotCount > 1) then
				newtask.deposited = false
				local inventory = ItemList("")
				local salvageItems = {}
				local salvageTools = {}
				id , item = next(inventory)
				while ( id ~= nil ) do
					if ( item ~= nil and not item.soulbound and item.rarity < 4 and ( item.itemtype == GW2.ITEMTYPE.Armor or item.itemtype == GW2.ITEMTYPE.Weapon or item.itemtype == GW2.ITEMTYPE.Trophy ) and not table.contains(newtask.ignorelist, item.dataID)) then						
						table.insert(salvageItems,item)
					elseif ( item.itemtype == GW2.ITEMTYPE.SalvageTool ) then
						table.insert(salvageTools,item)
					end
					id, item  = next(inventory,id)
				end				
				if ( TableSize(salvageItems) > 0 and TableSize(salvageTools) >0 ) then
					id , item = next(salvageItems)
					tid , tool = next(salvageTools)
					if ( id ~= nil and item ~= nil and tid ~=nil and tool ~= nil ) then
						if ( Player:GetCurrentlyCastedSpell() == 17 ) then
							wt_debug("Salvaging item " .. (item.name) .. " with " .. (tool.name))
							tool:Use(item)
							taskran = true
							if (newtask.lastitemID == 0 or newtask.lastitemID ~= item.dataID or (newtask.lastitemID == item.dataID and item.stackcount < newtask.lastitemstacksize)) then
								newtask.lastitemID = item.dataID
								newtask.lastitemstacksize = item.stackcount
							else
								wt_debug("Cannot Salvage item: "..(item.name).." ignoring it")
								table.insert(newtask.ignorelist,item.dataID)
							end
						end
					end
				end
			else 
				if (not newtask.deposited) then
					Inventory:DepositCollectables()
					newtask.deposited = true
					taskran = true
				end
			end
			
			if(not taskran) then
				newtask.done = true
			end
		end
				
		function newtask:isFinished()
			if ( newtask.done ) then
				wt_core_taskmanager.current_task = nil
				return true
			end
			return false
		end	
		wt_debug("Salvaging Task Added..")
		wt_core_taskmanager.current_task = newtask
		tb.running = true
	else
		wt_core_taskmanager.current_task = nil
		tb.running = false
	end
end

function tb.DoSupplyRun()	
	if (wt_core_taskmanager.current_task == nil) then
		wt_core_taskmanager:addVendorTask(15000, nil)
		tb.running = true		
		wt_debug("Doing Supply Run")
		if (TableSize(wt_core_taskmanager.Customtask_list) == 1) then
			i,wt_core_taskmanager.current_task = next(wt_core_taskmanager.Customtask_list)
			wt_core_taskmanager.Customtask_list = {}
		end
	else
		wt_core_taskmanager.current_task = nil
		tb.running = false
		wt_debug("Stopping Supply Run")
	end	
	--wt_core_taskmanager:addRepairTask(15000)
end

function tb.MinionsloadMesh()
	wt_debug("Telling Minions to (re)load mesh: "..tostring(greloadmesh))
	if (greloadmesh ~= nil and greloadmesh ~= "" and gMinionEnabled == "1" and MultiBotIsConnected( )) then
		MultiBotSend( "50;"..greloadmesh,"gw2minion" )
	end
end

-- <3 Urguwno
function tb.CheckForWvWLoot()
    loot = (GadgetList("maxdistance=180"))
    if (loot ~= nil ) then
        id,gadgettableentry = next(loot, nil)
        while id do
            if (id ~= nil) and (id ~= 0) then
                if (gadgettableentry ~= nil) and (gadgettableentry ~= 0) then
                    if (gadgettableentry.gatherable ~= true) and (gadgettableentry.type == 3) then
                        if (CharacterList:Get(id) == nil) then							
                            Player:Use(id)
							--Player:Interact(id)
							--Player:PressF()
                            return
                        end
                    end
                end
            end
        id,gadgettableentry = next(loot, id)
        end
    end
end

function tb.CheckWvWSpeed()
    -- ooc = 294
	-- ooc + 33% = 391
	-- ic = 210
	-- ic + 33% = 279
	if ( Player.inCombat ) then		
		Player:SetSpeed(279)
	else 		
		Player:SetSpeed(391)
	end
end

-- STUFF
function tb.GetInteractableTarget()
	local t = Player:GetInteractableTarget()
	if t ~= 0 then
		local char = CharacterList:Get(t)
		tb_target = tostring(t)
		GUI_RefreshWindow()
		d("Interactable Target: "..(char.name).." "..tostring(t))
	else
		d("No Interactable Target")
	end
end

function tb.GetTarget()
	local t = Player:GetTarget()
	if t ~= 0 then
		local char = CharacterList:Get(t)
		tb_target = tostring(t)
		GUI_RefreshWindow()
		d("Current Target: "..(char.name).." "..tostring(t))
	else
		d("No Current Target")
	end
end

function tb.SetTarget()
	local t = Player:SetTarget(tonumber(tb_target))
	if t == true then
		local char = CharacterList:Get(tb_target)
		d("Target Set: "..(char.name).. " "..tostring(tb_target))
	elseif t == false then
		d("Target Set Error")
	else
		d("t = nil")
	end
end

function tb.InteractTarget()
	local t = Player:Interact(tonumber(tb_target))
	local char = CharacterList:Get(tb_target)
	if t == true and char ~= nil then
		d("Interact with: "..(char.name).." "..tb_target.." successful")
	elseif t == false and char ~= nil then
		d("Interact with: "..(char.name).." "..tb_target.." failed")
	else
		d("No target selected or could not get target")
	end
end

function tb.GetConversationOptions()
	local t = Player:GetConversationOptions()
	if t ~= nil then
		for key, option in pairs(t) do
			d("Option Index (For Selection): "..tostring(key)..", Option Number (GW2.Enum): "..tostring(option))
		end
	else
		d("No conversation options")
	end
end

function tb.SelectConversationOption()
	local t = nil
	t = Player:SelectConversationOptionByIndex(tonumber(tb_option))
	if t ~=  false then
		d("Conversation option "..tb_option.." selected")
	else
		d("Could not select conversation option")
	end
end

function tb.PlayerPosition()
	d(Player.pos)
	tb_xPos = tostring(Player.pos.x)
	tb_yPos = tostring(Player.pos.y)
	tb_zPos = tostring(Player.pos.z)
	GUI_RefreshWindow()
end

function tb.MoveTo()
	wt_debug("Moving to target..")
	Player:MoveTo(tonumber(tb_xPos),tonumber(tb_yPos),tonumber(tb_zPos))
end

function tb.Teleport()
	Player:Teleport(tonumber(tb_xPos),tonumber(tb_yPos),tonumber(tb_zPos))
end

function tb.PrintDataID()
	for id, item in pairs(ItemList("")) do
		if((item.name) == tb_itemname) then
			d(tostring(id))
			d(item.name..": "..tostring(item.dataID))
		end
	end
end




RegisterEventHandler("TB.printID", tb.PrintDataID)
RegisterEventHandler("TB.toggle", tb.ToggleMenu)
RegisterEventHandler("TB.unpack", tb.UnpackBags)
RegisterEventHandler("TB.salvage", tb.AutoSalvage)
RegisterEventHandler("TB.reload", tb.MinionsloadMesh)
RegisterEventHandler("TB.eventmon", devmonitor.ToggleMenu)
RegisterEventHandler("TB.supplyRun", tb.DoSupplyRun)
RegisterEventHandler("TB.getInteractableTarget", tb.GetInteractableTarget)
RegisterEventHandler("TB.getTarget", tb.GetTarget)
RegisterEventHandler("TB.setTarget", tb.SetTarget)
RegisterEventHandler("TB.interactTarget", tb.InteractTarget)
RegisterEventHandler("TB.getConversationOptions", tb.GetConversationOptions)
RegisterEventHandler("TB.selectConversationOption", tb.SelectConversationOption)
RegisterEventHandler("TB.playerPosition",tb.PlayerPosition)
RegisterEventHandler("TB.moveTo", tb.MoveTo)
RegisterEventHandler("TB.teleport", tb.Teleport)
RegisterEventHandler("Gameloop.Update",tb.OnUpdate)
RegisterEventHandler("Module.Initalize",tb.ModuleInit)
