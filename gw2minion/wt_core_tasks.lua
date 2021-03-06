-- Blacklists for unsellable items and contested NPCs
wt_core_taskmanager.itemBlacklist = {}
-- npcBlacklist is for contested npcs
wt_core_taskmanager.npcBlacklist = {}
-- vendorBlacklist is for vendors who don't sell salvage kits/gathering tools
wt_core_taskmanager.vendorBlacklist = {}
-- eventBlacklist is for events that the bot could not complete
wt_core_taskmanager.eventBlacklist = {}
-- userEventBlacklist is for events that the user has manually blacklisted; these are peristent via settings
if ( Settings.GW2MINION.userEventBlacklist == nil) then
	Settings.GW2MINION.userEventBlacklist = {}
end
wt_core_taskmanager.userEventBlacklist = Settings.GW2MINION.userEventBlacklist
wt_core_taskmanager.waypointTimer = 0


-- Tasks that can be added to the taskmanager


--**********************************************************************************
-- DEFAULT TASKS ( Prio 0-999)
--**********************************************************************************

-- Explore Waypoint Task
function wt_core_taskmanager:addWaypointTask( waypoint )
	if ( waypoint ~= nil and waypoint.pos.x ~= 0 and waypoint.pos.y ~= 0 and waypoint.pos.z ~= 0 ) then 
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "WP"..tostring(math.floor(waypoint.pos.x))
		newtask.timestamp = wt_global_information.Now		
		newtask.name = "Explore Waypoint"
		newtask.priority = 650
		newtask.position = waypoint.pos
		newtask.done = false
		newtask.last_execution = 0
		newtask.throttle = 500

		function newtask:execute()
			local mypos = Player.pos
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
			if ( distance > 250 ) then
				--wt_debug("Walking towards new Waypoint ")	
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 200 )
					if ( gSMactive == "1" ) then
						SkillMgr.DoActionTmr = wt_global_information.Now 
						SkillMgr.DoAction()	
					end
					newtask.last_execution = wt_global_information.Now
				end
			else
				newtask.done = true
			end		
			newtask.name = "Explore Waypoint, dist: "..(math.floor(distance))
		end

		function newtask:isFinished()
			if ( newtask.done ) then 
				return true
			end
			return false
		end
		wt_core_taskmanager:addCustomtask( newtask )
	end
end

------------------------------------------------------------------
-- Explore Point Of Interest Task
function wt_core_taskmanager:addPOITask( poi )
	if ( poi ~= nil and poi.pos.x ~= 0 and poi.pos.y ~= 0 and poi.pos.z ~= 0 ) then 
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "PoI"..tostring(math.floor(poi.pos.x))
		newtask.timestamp = wt_global_information.Now				
		newtask.name = "Explore PointOfInterest"
		newtask.priority = 600
		newtask.position = poi.pos
		newtask.done = false
		newtask.last_execution = 0
		newtask.throttle = 500
		
		function newtask:execute()
			local mypos = Player.pos
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
			if ( distance > 220 ) then
				--wt_debug("Walking towards new PointOfInterest ")	
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 200 )
					if ( gSMactive == "1" ) then
						SkillMgr.DoActionTmr = wt_global_information.Now 
						SkillMgr.DoAction()	
					end
					newtask.last_execution = wt_global_information.Now
				end
			else
				newtask.done = true
			end
			newtask.name = "Explore PointOfInterest, dist: "..(math.floor(distance))
		end

		function newtask:isFinished()
			if ( newtask.done ) then
				return true
			end
			return false
		end	
		wt_core_taskmanager:addCustomtask( newtask )
	end
end

------------------------------------------------------------------
-- Fight at HeartQuest Task
function wt_core_taskmanager:addHeartQuestTask( quest )
	if not quest or quest == nil then
		return
	end
	local newtask = inheritsFrom( wt_task )
	newtask.UID = "HeartQuest"..tostring(math.floor(quest.pos.x))
	newtask.timestamp = wt_global_information.Now				
	newtask.name = "HeartQuest"
	--[[if (quest.type == 137) then -- currently active/nearby HeartQuest
		newtask.priority = 600
	else
		newtask.priority = 500
	end]]
	newtask.priority = 500
	newtask.spotreached = false
	newtask.startingTime = 0
	newtask.position = quest.pos
	newtask.maxduration = math.random(60000,600000)
	newtask.done = false
	newtask.last_execution = 0
	newtask.throttle = 500
	
	function newtask:canRun()			
		return true
	end
		
	function newtask:execute()
		if ( not newtask.spotreached ) then
			local me = Player
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, me.pos.x, me.pos.y, me.pos.z )
			if ( distance > 350 ) then
				--wt_debug("Walking towards FarmSpot Marker ")	
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					Player:MoveToRandomPointAroundCircle( newtask.position.x, newtask.position.y, newtask.position.z, 500 )
					if ( gSMactive == "1" ) then
						SkillMgr.DoActionTmr = wt_global_information.Now 
						SkillMgr.DoAction()	
					end
					newtask.last_execution = wt_global_information.Now
				end
			else
				newtask.spotreached = true
				newtask.startingTime = wt_global_information.Now
			end
			newtask.name = "HeartQuest: "..(math.floor(distance))
		else
			local me = Player
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, me.pos.x, me.pos.y, me.pos.z )
			if ( distance > 5000 ) then
				--wt_debug("Walking towards FarmSpot Marker ")	
				Player:MoveToRandomPointAroundCircle(  newtask.position.x, newtask.position.y, newtask.position.z, 1000 )
			else
				TargetList = ( CharacterList( "noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",onmesh,maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
				if ( TargetList ~= nil ) then 	
					nextTarget, E  = next( TargetList )
					if ( nextTarget ~= nil and wt_global_information.TargetBlacklist[nextTarget] == nil and (wt_global_information.Now - newtask.startingTime) < newtask.maxduration) then
						--wt_debug( "TaskManager: Begin Combat, Found target "..nextTarget )						
						wt_core_state_combat.setTarget( nextTarget )
						wt_core_controller.requestStateChange( wt_core_state_combat )
					else
						Player:StopMoving()
						newtask.done = true	
					end
				else
					Player:StopMoving()
					newtask.done = true
				end
			end
			newtask.name = "Do HeartQuest "..(math.floor((newtask.maxduration-(wt_global_information.Now - newtask.startingTime))/1000)).." sec"
		end		
	end

	function newtask:isFinished()
		if ( newtask.done ) then
			wt_core_taskmanager.Customtask_history[tostring(newtask.UID)] = wt_global_information.Now
			return true
		end
		return false
	end	
	wt_core_taskmanager:addCustomtask( newtask )
	
end

------------------------------------------------------------------
-- Fight at FarmSpot Task
function wt_core_taskmanager:addFarmSpotTask( marker )
	
	local newtask = inheritsFrom( wt_task )	
	newtask.UID = "FARM"..tostring(math.floor(marker.x))
	newtask.name = "FarmSpot "
	newtask.timestamp = wt_global_information.Now
	newtask.priority = 400
	newtask.spotreached = false
	newtask.startingTime = 0
	newtask.position = {}
	newtask.position.x = marker.x
	newtask.position.y = marker.y
	newtask.position.z = marker.z
	newtask.maxduration = math.random(60000,600000)
	newtask.done = false
	newtask.last_execution = 0
	newtask.throttle = 500
		
	function newtask:execute()
		if ( not newtask.spotreached ) then
			local me = Player
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, me.pos.x, me.pos.y, me.pos.z )
			if ( distance > 350 ) then
				--wt_debug("Walking towards FarmSpot Marker ")	
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 100 )
					if ( gSMactive == "1" ) then
						SkillMgr.DoActionTmr = wt_global_information.Now 
						SkillMgr.DoAction()	
					end
					newtask.last_execution = wt_global_information.Now
				end
			else
				newtask.spotreached = true
				newtask.startingTime = wt_global_information.Now
			end
			newtask.name = "FarmSpot: "..(math.floor(distance))
		else
			TargetList = ( CharacterList( "shortestpath,onmesh,noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
			if ( TargetList ~= nil ) then 	
				nextTarget, E  = next( TargetList )
				if ( nextTarget ~= nil and wt_global_information.TargetBlacklist[nextTarget] == nil and (wt_global_information.Now - newtask.startingTime) < newtask.maxduration) then
					--wt_debug( "TaskManager: Begin Combat, Found target "..nextTarget )					
					wt_core_state_combat.setTarget( nextTarget )
					wt_core_controller.requestStateChange( wt_core_state_combat )
				else
					Player:StopMoving()
					newtask.done = true
				end
			else
				Player:StopMoving()
				newtask.done = true
			end
			newtask.name = "Fight FarmSpot "..(math.floor((newtask.maxduration-(wt_global_information.Now - newtask.startingTime))/1000)).." sec"	
		end		
	end

	function newtask:isFinished()
		if ( newtask.done ) then 
			return true
		end
		return false
	end	
	wt_core_taskmanager:addCustomtask( newtask )
	
end

------------------------------------------------------------------
-- Fight at Random Point Task
function wt_core_taskmanager:addRandomFarmSpotTask( marker )
	
	local newtask = inheritsFrom( wt_task )	
	newtask.UID = "RANDOMPT"
	newtask.name = "Random FarmSpot "
	newtask.timestamp = wt_global_information.Now
	newtask.priority = 400
	newtask.spotreached = false
	newtask.startingTime = 0
	newtask.position = {}
	newtask.position.x = marker.x
	newtask.position.y = marker.y
	newtask.position.z = marker.z
	newtask.maxduration = math.random(60000,600000)
	newtask.done = false
	newtask.last_execution = 0
	newtask.throttle = 500
		
	function newtask:execute()
		if ( not newtask.spotreached ) then
			local me = Player
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, me.pos.x, me.pos.y, me.pos.z )
			if ( distance > 350 ) then
				--wt_debug("Walking towards FarmSpot Marker ")	
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 100 )
					if ( gSMactive == "1" ) then
						SkillMgr.DoActionTmr = wt_global_information.Now 
						SkillMgr.DoAction()	
					end
					newtask.last_execution = wt_global_information.Now
				end
			else
				newtask.spotreached = true
				newtask.startingTime = wt_global_information.Now
			end
			newtask.name = "Random FarmSpot: "..(math.floor(distance))
		else
			TargetList = ( CharacterList( "shortestpath,onmesh,noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
			if ( TargetList ~= nil ) then 	
				nextTarget, E  = next( TargetList )
				if ( nextTarget ~= nil and wt_global_information.TargetBlacklist[nextTarget] == nil and (wt_global_information.Now - newtask.startingTime) < newtask.maxduration) then
					--wt_debug( "TaskManager: Begin Combat, Found target "..nextTarget )					
					wt_core_state_combat.setTarget( nextTarget )
					wt_core_controller.requestStateChange( wt_core_state_combat )
				else
					Player:StopMoving()
					newtask.done = true
				end
			else
				Player:StopMoving()
				newtask.done = true
			end
			newtask.name = "Fight Random FarmSpot "..(math.floor((newtask.maxduration-(wt_global_information.Now - newtask.startingTime))/1000)).." sec"	
		end		
	end

	function newtask:isFinished()
		if ( newtask.done ) then 
			return true
		end
		return false
	end	
	wt_core_taskmanager:addCustomtask( newtask )
	
end

------------------------------------------------------------------
-- Explore Point Of Interest Task
function wt_core_taskmanager:addSkillChallengeTask( char )
	if not char or char == nil then
		return
	end
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "SkillCh"..tostring(char.agentID)
		newtask.timestamp = wt_global_information.Now				
		newtask.name = "SkillChallenge"
		newtask.priority = 600
		newtask.position = char.pos
		newtask.done = false
		newtask.last_execution = 0
		newtask.throttle = 500
		
		function newtask:execute()
			local mypos = Player.pos
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
			if ( distance > 100 ) then
				--wt_debug("Walking towards new PointOfInterest ")
				-- TODO: Update position
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 200 )
					if ( gSMactive == "1" ) then
						SkillMgr.DoActionTmr = wt_global_information.Now 
						SkillMgr.DoAction()	
					end
					newtask.last_execution = wt_global_information.Now
				end
			else
				-- TODO: Add chatshit
				newtask.done = true
			end
			newtask.name = "SkillChallenge: "..(math.floor(distance))
		end

		function newtask:isFinished()
			if ( newtask.done ) then
				return true
			end
			return false
		end	
		wt_core_taskmanager:addCustomtask( newtask )
end




------------------------------------------------------------------
-- Kill stuff nearby Task - NOTUSEDRIGHTNOW
function wt_core_taskmanager:addSearchAndKillTask(  )
	 
	local newtask = inheritsFrom( wt_task )
	newtask.name = "Search And Kill"
	newtask.priority = wt_task.priorities.normal
	newtask.startingTime = wt_global_information.Now
	newtask.maxduration = math.random(60000,600000)
	newtask.done = false
	
	function newtask:execute()
		TargetList = ( CharacterList( "shortestpath,onmesh,noCritter,attackable,alive,maxdistance=4000,maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
		if ( TargetList ~= nil ) then 	
			nextTarget, E  = next( TargetList )
			if ( nextTarget ~= nil and wt_global_information.TargetBlacklist[nextTarget] == nil and (wt_global_information.Now - newtask.startingTime) < newtask.maxduration) then
				--wt_debug( "TaskManager: Begin Combat, Found target "..nextTarget )				
				wt_core_state_combat.setTarget( nextTarget )
				wt_core_controller.requestStateChange( wt_core_state_combat )
			else
				Player:StopMoving()
				newtask.done = true
			end
		else
			Player:StopMoving()
			newtask.done = true
		end
		newtask.name = "Search And Kill "..(math.floor((newtask.maxduration-(wt_global_information.Now - newtask.startingTime))/1000)).." sec"
	end

	function newtask:isFinished()
		if ( newtask.done ) then 
			return true
		end
		return false
	end	
	wt_core_taskmanager:addCustomtask( newtask )
	
end




--**********************************************************************************
-- PRIORITY TASKS ( Prio 1000-9999)
--**********************************************************************************

-- Kill Enemy Character Task - P:3000-3500
function wt_core_taskmanager:addKillTask( ID, character, Prio )
	if not character or character == nil then
		return
	end
	local newtask = inheritsFrom( wt_task )
	newtask.UID = "KILL"..tostring(ID)
	newtask.timestamp = wt_global_information.Now
	newtask.lifetime = 20000
	newtask.name = "Attacking "..tostring(character.name)
	newtask.priority = tonumber(Prio)
	newtask.position = character.pos
	newtask.done = false
	newtask.ID = ID			
	function newtask:execute()				
		local ntarget = CharacterList:Get(tonumber(newtask.ID))
		if ( ntarget ~= nil and ntarget.distance < 4000 and ntarget.alive and ntarget.onmesh and (ntarget.attitude == 1 or ntarget.attitude == 2 ) and wt_global_information.TargetBlacklist[tonumber(newtask.ID)] == nil) then
			--wt_debug(newtask.name)
			if (tonumber(newtask.ID) ~= nil) then
				if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then
					MultiBotSend( "5;"..tostring(newtask.ID),"gw2minion" ) -- Set FocusTarget for Minions
				end
				wt_core_state_combat.setTarget( tonumber(newtask.ID) )
				wt_core_controller.requestStateChange( wt_core_state_combat )
				return
			end				
			newtask.done = true
		else
			newtask.done = true
		end		
	end
			
	function newtask:isFinished()
		if ( newtask.done ) then 
			return true
		end
		return false
	end
	
	wt_core_taskmanager:addCustomtask( newtask )
end

-- Kill Enemy Gadget Task - P:3000-3500
function wt_core_taskmanager:addKillGadgetTask( ID, gadget, Prio )
	if not gadget or gadget == nil then
		return
	end
	local newtask = inheritsFrom( wt_task )
	newtask.UID = "KILL"..tostring(ID)
	newtask.timestamp = wt_global_information.Now
	newtask.lifetime = 20000
	newtask.name = "Attacking Gadget"
	newtask.priority = tonumber(Prio)
	newtask.position = gadget.pos
	newtask.done = false
	newtask.ID = ID			
	function newtask:execute()				
		local ntarget = GadgetList:Get(tonumber(newtask.ID))
		if ( ntarget ~= nil and ntarget.los and ntarget.distance < 4000 and ntarget.alive and (ntarget.attitude == 1 or ntarget.attitude == 2) and ntarget.onmesh and wt_global_information.TargetBlacklist[tonumber(newtask.ID)] == nil) then
			--wt_debug((newtask.name))
			if (tonumber(newtask.ID) ~= nil) then
				if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then
					MultiBotSend( "7;"..tostring(newtask.ID),"gw2minion" ) -- Set FocusTarget for Minions
				end
				wt_core_state_gcombat.setTarget( tonumber(newtask.ID) )
				wt_debug("GOING TO KILL THAT GADGET")
				wt_core_controller.requestStateChange( wt_core_state_gcombat )
				return
			end				
			newtask.done = true
		else
			newtask.done = true
		end		
	end
			
	function newtask:isFinished()
		if ( newtask.done ) then 
			return true
		end
		return false
	end
	
	wt_core_taskmanager:addCustomtask( newtask )
end

function wt_core_taskmanager:addGotoPosTask( pos, prio )
	if (NavigationManager:IsOnMesh(pos)) then
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "GOTOPOS"
		newtask.timestamp = wt_global_information.Now
		newtask.name = "GotoPos"
		newtask.ID = ID
		newtask.priority = prio
		newtask.spotreached = false
		newtask.startingTime = 0
		newtask.position = pos
		newtask.maxduration = 300000 --max 5 min
		newtask.done = false
		newtask.last_execution = 0
		newtask.throttle = 500
		newtask.randomdist = math.random(130,700)
		newtask.usedWP = false

		function newtask:execute()
			mypos = Player.pos
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
			 -- TELEPORT TO NEAREST WAYPOINT
			if ( gUseWaypoints == "1" and wt_core_helpers:OkayToWaypoint() and not newtask.usedWP) then
				if ( distance > 6500 ) then
					local wp = wt_core_helpers:GetWaypoint(newtask.position, distance)
					if (wp ~= nil) then
						wt_core_helpers:TimedWaypoint(wp.contentID)
						newtask.usedWP = true
						return
					end
				end
			end
			if ( distance > 150 ) then
				-- MAKE SURE ALL MINIONS ARE NEARBY
				if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then
					local party = Player:GetPartyMembers()
					if (TableSize(party) > 0) then
						local index, player  = next( party )
						while ( index ~= nil and player ~= nil ) do			
							if (player.distance > 1500 and player.onmesh) then
								MultiBotSend( "100;"..tostring(Player.characterID),"gw2minion" ) -- Minions follow Leader									
								break
							end
							index, player  = next( party,index )
						end		
					end						
				end
				-- HEAL if being attacked
				if (Player.health.percent < wt_core_state_combat.RestHealthLimit and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_6)) then
					--wt_debug("e_heal_action")
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_6)
					return					
				end
				Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 75 )
				if ( gSMactive == "1" ) then
					SkillMgr.DoActionTmr = wt_global_information.Now 
					SkillMgr.DoAction()	
				end
				newtask.name = "GotoPos: "..(math.floor(distance))
			elseif ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
				newtask.last_execution = wt_global_information.Now
				
				--MAKE SURE ALL MINIONS ARE NEARBY WHEN IN GROUP
				if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then	
					local party = Player:GetPartyMembers()
					local canvendor = true							
					if (TableSize(party) > 0) then
						local i,p = next (party)
						while (i~= nil and p~= nil) do
							if (p.distance > 1500) then
								canvendor = false
								break
							end
							i,p = next(party,i)
						end
					end
					if (not canvendor) then
						wt_debug("Waiting for our whole party to get to me....")
						MultiBotSend( "100;"..tostring(Player.characterID),"gw2minion" ) -- Minions follow Leader
						newtask.name = "Waiting..."
						return
					else
						newtask.done = true
					end
				else
					newtask.done = true
				end
			end
		end

		function newtask:isFinished()
			if ( newtask.done ) then
				return true
			end
			return false
		end
		wt_core_taskmanager:addCustomtask( newtask )
	end
end

-- Force Follow Leader - P:3750
function wt_core_taskmanager:addFollowTask( ID, prio )

    local character = CharacterList:Get(tonumber(ID))
    if ( character ~= nil ) then

        local newtask = inheritsFrom( wt_task )
        newtask.UID = "FOLLOW"
        newtask.timestamp = wt_global_information.Now
        newtask.name = "Follow"
        newtask.ID = ID
        newtask.priority = prio
        newtask.spotreached = false
        newtask.startingTime = 0
        newtask.position = character.pos
        newtask.maxduration = 300000 --max 5 min
        newtask.done = false
        newtask.last_execution = 0
        newtask.throttle = 500
        newtask.randomdist = math.random(130,700)
		newtask.usedWP = false

        function newtask:execute()
            local Char = CharacterList:Get(tonumber(newtask.ID))
            if ( Char ~= nil ) then
                newtask.position = Char.pos
                if ( not newtask.spotreached ) then
                    if ( Char.distance > 5000 ) then
                        if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
                            -- TELEPORT TO NEAREST WAYPOINT
                            if ( (gUseWaypoints == "1" or gUseWaypointsEvents == "1") and wt_core_helpers:OkayToWaypoint() and not newtask.usedWP) then
								local wp = wt_core_helpers:GetWaypoint(newtask.position, Char.distance)
								if (wp ~= nil) then
									wt_core_helpers:TimedWaypoint(wp.contentID)
									newtask.usedWP = true
									newtask.last_execution = wt_global_information.Now
								end
							end
                        end
					end
                    if ( Char.distance > newtask.randomdist) then
                        if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
                            Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 120 )
							if ( gSMactive == "1" ) then
								SkillMgr.DoActionTmr = wt_global_information.Now 
								SkillMgr.DoAction()	
							end
							newtask.last_execution = wt_global_information.Now
                        end
                    else
                        newtask.spotreached = true
                        newtask.startingTime = wt_global_information.Now
                    end
                    newtask.name = "Follow: "..(math.floor(Char.distance))
                else
                    newtask.done = true
                end
            end
        end

        function newtask:isFinished()
            if ( newtask.done ) then
                return true
            end
            return false
        end
        wt_core_taskmanager:addCustomtask( newtask )
    end
end


-- Go To Repair Task - P:4500
function wt_core_taskmanager:addRepairTask(priority,vendor)
	if (vendor == nil) then
		vendor = wt_core_helpers:GetClosestRepairVendor(999999)
	end
	if ( vendor ) then		
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "REPAIR"
		newtask.timestamp = wt_global_information.Now
		newtask.name = "Goto Repair"
		newtask.priority = tonumber(priority)
		newtask.position = vendor.pos
		newtask.done = false
		newtask.vendor = vendor
		newtask.throttle = 500
		newtask.last_execution = 0
		newtask.repaired = false
		newtask.usedWP = false
		newtask.clearedVendor = false
		newtask.sendMessage = gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1
			
		function newtask:execute()	
			local mypos = Player.pos
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
			if (distance > 150) then
				wt_core_taskmanager:addGotoPosTask(newtask.position, 5250)
			else
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					newtask.last_execution = wt_global_information.Now
					--MAKE SURE ALL MINIONS ARE NEARBY WHEN IN GROUP
					if (newtask.sendMessage) then	
						wt_debug("Telling Minions to repair")
						MultiBotSend( "16;0","gw2minion" )
						newtask.name = "Repairing"
						newtask.sendMessage = false
					end
					
					if (gEnableRepair == "0" or not NeedRepair()) then
						newtask.done = true
						return
					end
					
					-- grab the vendor again in case the pointer has become invalid
					local vendor = wt_core_helpers:GetClosestRepairVendor(999999)
					if ( vendor ~= nil and vendor.distance < 150 and vendor.characterID ~= nil and vendor.characterID ~= 0) then						
						-- TARGET VENDOR
						local nearestID = Player:GetInteractableTarget()
						if ( vendor.characterID ~= nil and vendor.characterID ~= 0 and nearestID ~= nil and vendor.characterID ~= nearestID ) then
							if ( Player:GetTarget() ~= vendor.characterID) then				
								Player:SetTarget(vendor.characterID)
								return
							end
						end
						-- INTERACT WITH VENDOR
						if ( not Player:IsConversationOpen() and newtask.repaired == false ) then
							wt_debug( "Repair: Opening Vendor.. " )
							Player:Interact( vendor.characterID )
							return		
						end
						-- CHAT WITH VENDOR
						wt_debug( "Repair: Chatting with Vendor..." )
						if ( Player:IsConversationOpen() and newtask.repaired == false) then
							local options = Player:GetConversationOptions()
							nextOption, entry  = next( options )
							local found = false
							while ( nextOption ~= nil ) do
								if( entry == GW2.CONVERSATIONOPTIONS.Repair ) then
									Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Repair )
									newtask.repaired = true
									found = true
									break
								elseif( entry == GW2.CONVERSATIONOPTIONS.Continue ) then
									Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Continue )
									found = true
									break
								elseif( entry == GW2.CONVERSATIONOPTIONS.Return ) then
									Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Return )
									wt_core_state_repair.repaired = true
									found = true
									break
								end
								nextOption, entry  = next( options, nextOption )
							end
							if ( not found ) then
								wt_core_taskmanager.npcBlacklist[vendor.characterID] = os.time()
								newtask.done = true
								wt_debug( "Repair: can't handle repairvendor, please report back to the developers" )
							end
						end							
						-- DONE LOL
						if (newtask.repaired) then
							newtask.done = true
						end							
					else
						-- Reget closest Vendor
						wt_debug("Vendor changed, trying to get new NPC..")
						local vendor = wt_core_helpers:GetClosestRepairVendor(999999)
						if (vendor ~= nil) then
							newtask.position = vendor.pos
							newtask.vendor = vendor
						else
							newtask.done = true
						end
					end
				end
			end
		end
		
		function newtask:isFinished()
			if ( newtask.done ) then
                if (Player:IsConversationOpen()) then
                    Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Close )
                end
				return true
			end
			return false
		end
			
		wt_core_taskmanager:addCustomtask( newtask )
	end
end


-- Go To Vendor Task - P:5000
function wt_core_taskmanager:addVendorTask(priority, vendor)
	if (vendor == nil) then
		vendor = wt_core_helpers:GetClosestSellVendor(999999)
	end
	if ( vendor ) then		
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "VENDORSELL"
		newtask.timestamp = wt_global_information.Now
		newtask.name = "GoTo Vendor"
		newtask.priority = tonumber(priority)
		newtask.position = vendor.pos
		newtask.done = false
		newtask.vendor = vendor
		newtask.throttle = 500
		newtask.last_execution = 0
		newtask.junksold = false
		newtask.itemSlotID = nil
		newtask.itemStackcount = nil
		newtask.firstSell = true
		newtask.usedWP = false
		newtask.clearedVendor = false
		newtask.sendMessage = gMinionEnabled == "1" and MultiBotIsConnected() and Player:GetRole() == 1
		
		function newtask:execute()
			-- have to clear vendor target to reset buy/sell data
			local mypos = Player.pos
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
			if (distance > 150) then
				wt_core_taskmanager:addGotoPosTask(newtask.position, 5250)
			else
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					newtask.last_execution = wt_global_information.Now
					--MAKE SURE ALL MINIONS ARE NEARBY WHEN IN GROUP
					if (newtask.sendMessage) then
						wt_debug("Telling Minions to vendor")
						MultiBotSend( "11;0","gw2minion" )
						newtask.name = "Vendoring(Sell)"
						newtask.sendMessage = false
					end						
					
					local vendor = wt_core_helpers:GetClosestSellVendor(999999)
					if ( vendor ~= nil and vendor.distance < 150 and vendor.characterID ~= nil and vendor.characterID ~= 0) then													
						-- TARGET VENDOR
						local nearestID = Player:GetInteractableTarget()
						if ( vendor.characterID ~= nil and vendor.characterID ~= 0 and nearestID ~= nil and vendor.characterID ~= nearestID ) then 
							if ( Player:GetTarget() ~= vendor.characterID) then				
								Player:SetTarget(vendor.characterID)
								return
							end
						end
						-- INTERACT WITH VENDOR
						if ( not Inventory:IsVendorOpened() and  not Player:IsConversationOpen() ) then
							wt_debug( "Vendoring: Opening Vendor.. " )
							Player:Interact( vendor.characterID )
							return
						end
						-- CHAT WITH VENDOR
						if ( not Inventory:IsVendorOpened() and Player:IsConversationOpen() and not newtask.junksold ) then
							wt_debug( "Vendoring: Chatting with Vendor.." )							
							local options = Player:GetConversationOptions()
							nextOption, entry  = next( options )
							local found = false
							while ( nextOption ~= nil ) do
								if( entry == GW2.CONVERSATIONOPTIONS.Shop ) then
									Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Shop )
									found = true
									break
								elseif( entry == GW2.CONVERSATIONOPTIONS.KarmaShop ) then
									Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.KarmaShop )
									found = true
									break
								elseif( entry == 23 ) then
									Player:SelectConversationOption( 23 )
									found = true
									break
								end
								nextOption, entry  = next( options, nextOption )
							end
							if ( not found ) then
								nextOption, entry  = next( options )
								while ( nextOption ~=nil ) do
									if( entry == GW2.CONVERSATIONOPTIONS.Continue ) then
										Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Continue )
										found = true
										break
									elseif( entry == GW2.CONVERSATIONOPTIONS.Story ) then
										Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Story )
										found = true
										break
									end
									nextOption, entry  = next( options, nextOption )
								end
							end
							if ( not found ) then
								wt_core_taskmanager.npcBlacklist[vendor.characterID] = os.time()
								newtask.done = true
								wt_debug( "Vendoring: can't handle vendor, please report back to the developers" )
							end
							return
						end
						-- SELL ITEMS
						if (Inventory:IsVendorOpened() and not newtask.junksold) then
							if(newtask.itemSlotID ~= nil) then
								-- for some reason after first loop through sell conditional the ItemList is not updated properly
								-- use this conditional to avoid accidentally blacklisting a legit item
								if (newtask.firstSell) then
									newtask.firstSell = false
								else
									local item = ItemList:Get(newtask.itemSlotID)
									if (item ~= nil) then
										if (item.stackcount == newtask.itemStackcount) then
											--item did not sell, add it to blacklist
											wt_debug("Blacklisting item dataID: "..tostring(item.dataID))
											if (wt_core_taskmanager.itemBlacklist[item.dataID] == nil) then
												wt_core_taskmanager.itemBlacklist[item.dataID] = 0
											else
												wt_core_taskmanager.itemBlacklist[item.dataID] = wt_core_taskmanager.itemBlacklist[item.dataID] + 1
											end
										end
									end
								end
							end
							
							wt_debug( "Vendoring: Selling Items.. ")
							local sold = false			
							if ( gVendor_Weapons == "1") then
							local tmpR = tonumber(gMaxItemSellRarity)	
								-- Sell Weapons	
								while ( tmpR > 0 and sold == false) do
									local sweapons = ItemList("itemtype=18,notsoulbound,rarity="..tmpR)	
									local id,item = next(sweapons)
									if (id ~=nil and item ~= nil) then
										local blacklistCount = wt_core_taskmanager.itemBlacklist[item.dataID]
										if(blacklistCount == nil or blacklistCount < 3) then
											newtask.itemSlotID = id
											newtask.itemStackcount = item.stackcount
											wt_debug( "Vendoring: Selling Weapon... ")
											item:Sell()
											sold = true
										end
									end
									tmpR = tmpR - 1
								end
							end
							
							if ( gVendor_Armor == "1") then
							local tmpR = tonumber(gMaxItemSellRarity)	
								-- Sell Armor
								if ( not sold ) then
									while ( tmpR > 0 and sold == false) do
										local sarmor = ItemList("itemtype=0,notsoulbound,rarity="..tmpR)					
										local id,item = next(sarmor)
										if (id ~=nil and item ~= nil) then
											local blacklistCount = wt_core_taskmanager.itemBlacklist[item.dataID]
											if(blacklistCount == nil or blacklistCount < 3) then
												newtask.itemSlotID = id
												newtask.itemStackcount = item.stackcount										
												wt_debug( "Vendoring: Selling Armor... ")
												item:Sell()
												sold = true
											end
										end
										tmpR = tmpR - 1
									end		
								end	
							end
							
							if ( gVendor_Trinkets == "1") then
							local tmpR = tonumber(gMaxItemSellRarity)	
								-- Sell Trinkets
								if ( not sold ) then
									while ( tmpR > 0 and sold == false) do
										local strinket = ItemList("itemtype=15,notsoulbound,rarity="..tmpR)					
										local id,item = next(strinket)
										if (id ~=nil and item ~= nil) then
											local blacklistCount = wt_core_taskmanager.itemBlacklist[item.dataID]
											if(blacklistCount == nil or blacklistCount < 3) then
												newtask.itemSlotID = id
												newtask.itemStackcount = item.stackcount											
												wt_debug( "Vendoring: Selling Trinkets... ")
												item:Sell()
												sold = true
											end
										end
										tmpR = tmpR - 1
									end		
								end		
							end
							
							if ( gVendor_UpgradeComps == "1") then
							local tmpR = tonumber(gMaxItemSellRarity)	
								-- Sell Upgrade Components
								if ( not sold ) then
									while ( tmpR > 0 and sold == false) do
										local supgrade = ItemList("itemtype=17,notsoulbound,rarity="..tmpR)					
										local id,item = next(supgrade)
										if (id ~=nil and item ~= nil) then
											local blacklistCount = wt_core_taskmanager.itemBlacklist[item.dataID]
											if(blacklistCount == nil or blacklistCount < 3) then
												newtask.itemSlotID = id
												newtask.itemStackcount = item.stackcount											
												wt_debug( "Vendoring: Selling Upgrade Components... ")
												item:Sell()
												sold = true
											end
										end
										tmpR = tmpR - 1
									end		
								end		
							end
							
							if ( gVendor_CraftingMats == "1") then
							local tmpR = tonumber(gMaxItemSellRarity)	
								-- Sell Crafting Mats
								if ( not sold ) then
									while ( tmpR > 0 and sold == false) do
										local scraftmats = ItemList("itemtype=5,notsoulbound,rarity="..tmpR)				
										local id,item = next(scraftmats)
										if (id ~=nil and item ~= nil) then
											local blacklistCount = wt_core_taskmanager.itemBlacklist[item.dataID]
											if(blacklistCount == nil or blacklistCount < 3) then
												newtask.itemSlotID = id
												newtask.itemStackcount = item.stackcount											
												wt_debug( "Vendoring: Selling Crafting Mats... ")
												item:Sell()
												sold = true
											end
										end
										tmpR = tmpR - 1
									end		
								end		
							end
							
							if ( gVendor_Trophies == "1") then
							local tmpR = tonumber(gMaxItemSellRarity)	
								-- Sell Trophies
								if ( not sold ) then
									while ( tmpR > 0 and sold == false) do
										local strophies = ItemList("itemtype=16,notsoulbound,rarity="..tmpR)					
										local id,item = next(strophies)
										if (id ~=nil and item ~= nil) then
											local blacklistCount = wt_core_taskmanager.itemBlacklist[item.dataID]
											if(blacklistCount == nil or blacklistCount < 3) then
												newtask.itemSlotID = id
												newtask.itemStackcount = item.stackcount										
												wt_debug( "Vendoring: Selling Trophies... ")
												item:Sell()
												sold = true
											end
										end
										tmpR = tmpR - 1
									end		
								end		
							end
							
							-- Sell Junk
							if ( not sold ) then
								wt_debug( "Vendoring: Selling Junk..." )
								Inventory:SellJunk()
								newtask.junksold = true
							end
							
							newtask.throttle = math.random(500,1500)
						end
						-- DONE LOL
						if (newtask.junksold) then
							newtask.done = true
						end							
					else
						-- Reget closest Vendor
						wt_debug("Vendor changed, trying to get new NPC..")
						local vendor = wt_core_helpers:GetClosestSellVendor(999999)
						if (vendor ~= nil) then
							newtask.position = vendor.pos
							newtask.vendor = vendor
						else
							newtask.done = true
						end
					end
				end
			end
		end
		
		function newtask:isFinished()
			if ( newtask.done ) then
				if (Player:IsConversationOpen()) then
                    Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Close )
                end
				return true
			end
			return false
		end
		
		wt_core_taskmanager:addCustomtask( newtask )
	end
end

-- totalStacks is NOT the amount to buy, it is the amount that the bot should have in inventory
-- when the buy task is completed
function wt_core_taskmanager:addVendorBuyTask(priority, wt_core_itemType, totalStacks, quality, vendor)
	if (vendor == nil) then
		vendor = wt_core_helpers:GetClosestBuyVendor(999999)
	end
	if ( vendor ) then		
		local newtask = inheritsFrom( wt_task )
		newtask.UID = "VENDORBUY"..tostring(wt_core_itemType)
		newtask.timestamp = wt_global_information.Now
		newtask.name = "GoTo Vendor"
		newtask.priority = tonumber(priority)
		newtask.position = vendor.pos
		newtask.done = false
		newtask.vendor = vendor
		newtask.throttle = 500
		newtask.last_execution = 0
		newtask.priority = tonumber(priority)
		newtask.totalStacks = tonumber(totalStacks)
		newtask.wt_core_itemType = tonumber(wt_core_itemType)
		newtask.quality = quality
		newtask.usedWP = false
		newtask.clearedVendor = false
		newtask.sendMessage = gMinionEnabled == "1" and MultiBotIsConnected() and Player:GetRole() == 1
		
		function newtask:execute()
			-- have to clear vendor target to reset buy/sell data
			local mypos = Player.pos
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
			if (distance > 150) then
				wt_core_taskmanager:addGotoPosTask(newtask.position, 5250)
			elseif ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
				newtask.last_execution = wt_global_information.Now
				--MAKE SURE ALL MINIONS ARE NEARBY WHEN IN GROUP
				if (newtask.sendMessage) then
					wt_debug("Telling Minions to vendor")
					MultiBotSend( "13;0","gw2minion" )
					newtask.name = "Vendoring(Buy)"
					newtask.sendMessage = false
				end						
				
				local vendor = wt_core_helpers:GetClosestBuyVendor(999999)
				if ( vendor ~= nil and vendor.distance < 150 and vendor.characterID ~= nil and vendor.characterID ~= 0) then										
					-- TARGET VENDOR
					local nearestID = Player:GetInteractableTarget()
					if ( vendor.characterID ~= nil and vendor.characterID ~= 0 and nearestID ~= nil and vendor.characterID ~= nearestID ) then 
						if ( Player:GetTarget() ~= vendor.characterID) then	
							if ( CharacterList:Get(vendor.characterID) ~= nil ) then
								Player:SetTarget(vendor.characterID)
								return
							else
								d("Something really odd happened, ...")
								newtask.vendor = nil
								return
							end
						end
					end
					-- INTERACT WITH VENDOR
					if ( not Inventory:IsVendorOpened() and  not Player:IsConversationOpen() ) then
						wt_debug( "Vendoring: Opening Vendor.. " )
						Player:Interact( vendor.characterID )
						return
					end
					-- CHAT WITH VENDOR
					if ( not Inventory:IsVendorOpened() and Player:IsConversationOpen() ) then
						wt_debug( "Vendoring: Chatting with Vendor.." )							
						local options = Player:GetConversationOptions()
						nextOption, entry  = next( options )
						local found = false
						while ( nextOption ~= nil ) do
							if( entry == GW2.CONVERSATIONOPTIONS.Shop ) then
								Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Shop )
								found = true
								break
							elseif( entry == GW2.CONVERSATIONOPTIONS.KarmaShop ) then
								Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.KarmaShop )
								found = true
								break
							elseif( entry == 23 ) then
								Player:SelectConversationOption( 23 )
								found = true
								break
							end
							nextOption, entry  = next( options, nextOption )
						end
						if ( not found ) then
							nextOption, entry  = next( options )
							while ( nextOption ~=nil ) do
								if( entry == GW2.CONVERSATIONOPTIONS.Continue ) then
									Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Continue )
									found = true
									break
								elseif( entry == GW2.CONVERSATIONOPTIONS.Story ) then
									Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Story )
									found = true
									break
								end
								nextOption, entry  = next( options, nextOption )
							end
						end
						if ( not found ) then
							wt_core_taskmanager.npcBlacklist[vendor.characterID] = os.time()
							newtask.done = true
							wt_debug( "Vendoring: can't handle vendor, please report back to the developers" )
						end
						return
					end
					-- BUY ITEMS
					if (Inventory:IsVendorOpened()) then
						-- Check current stock
						local myStacks = wt_core_items:GetItemStock(newtask.wt_core_itemType)
						if (myStacks ~= nil and myStacks < newtask.totalStacks and (ItemList.freeSlotCount > (newtask.totalStacks - myStacks))) then
							-- Buy Items
							wt_debug(tostring(myStacks).." stacks found in inventory. Buying "..tostring(newtask.totalStacks - myStacks).." stacks")
							
							-- attempt to buy specified quality first
							local itemContentIDs = wt_core_items.contentIDs[newtask.wt_core_itemType]
							local vendorItems = VendorItemList("contentID="..itemContentIDs[tonumber(newtask.quality)])
							if (vendorItems ~= nil ) then
								local id,item=next(vendorItems)
								if (id ~= nil) then
									item:Buy()
								else
									-- if buy best available is selected for itemtype do that
									if 	(newtask.wt_core_itemType == wt_core_items.skit and gBuyBestSalvageKit == "1") or 
										(newtask.wt_core_itemType ~= wt_core_items.skit and gBuyBestGatheringTool == "1") then
										local vendorList = VendorItemList("")
										local item = wt_core_items:GetBestQualityItem(vendorList,newtask.wt_core_itemType)
										if (item ~= nil) then
											item:Buy()
										else
											wt_debug("Vendor doesn't have salvage kits/gtools....blacklisting")
											wt_core_taskmanager.vendorBlacklist[vendor.characterID] = true
											-- tell minions to blacklist vendor
											if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then	
												MultiBotSend( "18;"..tonumber(vendor.characterID),"gw2minion" )
											-- tell leader to blacklist vendor
											elseif (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() ~= 1) then
												MultiBotSend( "17;"..tonumber(vendor.characterID),"gw2minion" )
											end
											newtask.done = true
										end
									else
										wt_debug("Vendor doesn't have requested quality salvage kits/gtools....blacklisting")
										wt_core_taskmanager.vendorBlacklist[vendor.characterID] = true
										-- tell minions to blacklist vendor
										if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then	
											MultiBotSend( "18;"..tonumber(vendor.characterID),"gw2minion" )
										-- tell leader to blacklist vendor
										elseif (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() ~= 1) then
											MultiBotSend( "17;"..tonumber(vendor.characterID),"gw2minion" )
										end
										newtask.done = true
									end
								end
							end
						else
							newtask.done = true
						end
							
						newtask.throttle = math.random(500,1500)
					end
					-- DONE LOL
					if (newtask.itemsPurchased) then
						newtask.done = true
					end
				else
					-- Reget closest Vendor
					wt_debug("Vendor changed, trying to get new NPC..")
					local vendor = wt_core_helpers:GetClosestBuyVendor(999999)
					if (vendor ~= nil) then
						newtask.position = vendor.pos
						newtask.vendor = vendor
					else
						newtask.done = true
					end
				end
			end
		end
		
		function newtask:isFinished()
			if ( newtask.done ) then 
                if (Player:IsConversationOpen()) then
                    Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Close )
                end
				return true
			end
			return false
		end
		
		wt_debug("Buy Items Task Added..")
		wt_core_taskmanager:addCustomtask(newtask)
	end
end


-- Do Event Task - P:4000
function wt_core_taskmanager:addEventTask( ID, event, prio )
	if not event or event == nil then
		return
	end
	local newtask = inheritsFrom( wt_task )
	newtask.UID = "Event"..tostring(event.eventID)
	newtask.timestamp = wt_global_information.Now				
	newtask.name = "Event"	
	newtask.priority = prio
	newtask.eventID = event.eventID	
	newtask.spotreached = false
	newtask.startingTime = 0
	newtask.eventType = nil
	newtask.position = event.pos
	newtask.maxduration = math.random(20000,50000)
	newtask.done = false
	newtask.last_execution = 0
	newtask.throttle = 500
	newtask.needUpdate = false
	newtask.needPause = false
	newtask.pausestartingTime = 0
	newtask.pausemaxduration = math.random(10000,30000)
	newtask.EventComponents = {}
	newtask.waiting = false
	newtask.finishTimer = nil
	newtask.usedWP = false
	
	function newtask:execute()

		local MMList = {}
		local myevent = nil
		
		-- run a timer so that we only do each event for 5 minutes
		-- this should be enough time to tag events that last longer
		if (newtask.finishTimer == nil) then
			newtask.finishTimer = os.time()
		elseif (os.difftime(os.time(), newtask.finishTimer) > tonumber(gEventTimeout)) then
			-- blacklist event for 10 minutes in case it's broken
			wt_debug("Blacklisting event "..newtask.eventID)
			wt_core_taskmanager.eventBlacklist[newtask.eventID] = os.time()
			newtask.done = true
			return
		end

		if (newtask.eventType == nil) then
			MMList = MapMarkerList("isevent,eventID="..tonumber(newtask.eventID)..",onmesh")
		else
			MMList = MapMarkerList("isevent,eventID="..tonumber(newtask.eventID)..",type="..tonumber(newtask.eventType)..",onmesh")
		end
		
		if ( MMList ~= nil ) then
			local index, event = next(MMList)			
			myevent = event
			
			-- Enlist all Event components	
			if (TableSize(newtask.EventComponents) == 0) then
				wt_debug("Enlist all Event components	")
				while (index ~= nil and event ~= nil) do
					local epos = event.pos
					newtask.EventComponents[tonumber(event.type)] = { x=epos.x , y=epos.y, z=epos.z }
					index, event = next(MMList,index)
				end
			end
			
			
			-- Cycle through all Eventcomponents to find out if it is an escort mission
			if (newtask.eventType == nil) then
				index, event = next(MMList)	
				while (index ~= nil and event ~= nil) do					
					if (newtask.EventComponents[tonumber(event.type)] ~= nil) then
						-- Check if the coords changed, aka escord/moving event
						local apos = event.pos
						local bpos = newtask.EventComponents[tonumber(event.type)]
						--wt_debug("A: "..tostring(apos.x).." "..tostring(apos.y).." "..tostring(apos.z))
						--wt_debug("B: "..tostring(bpos.x).." "..tostring(bpos.y).." "..tostring(bpos.z))
						local distance =  Distance3D( apos.x, apos.y, apos.z, bpos.x, bpos.y, bpos.z )
						if (distance > 500) then
							-- We found a moving event, assuming it is a escord mission/guy
							wt_debug("Moving Event Found! "..tostring(event.type).." "..tostring(event.eventID))
							newtask.eventType = event.type
							
							myevent = event
							break
						end
					end
					
					index, event = next(MMList,index)
				end
			end
			
			
			if ( myevent ~= nil and myevent.pos ~= nil) then
				newtask.position = myevent.pos
				if ( not newtask.spotreached ) then
					 -- TELEPORT TO NEAREST WAYPOINT
					if ( gUseWaypointsEvents == "1" and wt_core_helpers:OkayToWaypoint() and not newtask.usedWP) then
						if ( myevent.distance > 6500 ) then
							local wp = wt_core_helpers:GetWaypoint(newtask.position, myevent.distance)
							if (wp ~= nil) then
								wt_core_helpers:TimedWaypoint(wp.contentID)
								newtask.usedWP = true
								if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then	
									MultiBotSend( "100;"..tonumber(Player.characterID),"gw2minion" ) -- Minions follow Leader
								end
							end
						end
					end
					if ( myevent.distance > 1000 ) then
						if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
							if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then	
								local party = Player:GetPartyMembers()
								if (party ~= nil ) then
									local index, player  = next( party )
									while ( index ~= nil and player ~= nil ) do			
										if (player.distance > 600 and player.onmesh) then
											MultiBotSend( "100;"..tonumber(Player.characterID),"gw2minion" ) -- Minions follow Leader
											break
										end
										index, player  = next( party,index )
									end		
								end						
							end
							Player:MoveToRandomPointAroundCircle( newtask.position.x, newtask.position.y, newtask.position.z, 500 )
							if ( gSMactive == "1" ) then
								SkillMgr.DoActionTmr = wt_global_information.Now 
								SkillMgr.DoAction()	
							end
							newtask.last_execution = wt_global_information.Now
						end
					else
						newtask.spotreached = true
						newtask.startingTime = wt_global_information.Now
					end
					newtask.name = "Event: "..(math.floor(myevent.distance))
				else
					if ( newtask.needPause and (wt_global_information.Now - newtask.pausestartingTime) < newtask.pausemaxduration) then
						if (newtask.waiting == false) then
							newtask.waiting = true
							newtask.waitingTime = os.time()
						else
							if (os.difftime(os.time(), newtask.waitingTime) > 60) then
								-- blacklist this event forever, bot can't complete it
								wt_core_taskmanager.eventBlacklist[newtask.eventID] = -1
								newtask.done = true
								return
							end
						end
						
						newtask.name = "Event: Waiting.."
						-- Search for nearby enemies
						local Elist = ( CharacterList( "nearest,attackable,alive,incombat,noCritter,onmesh,maxdistance=2500" ) )
						if ( TableSize( Elist ) > 0 ) then
							nextTarget, E  = next( Elist )
							if ( nextTarget ~= nil and E ~= nil and wt_global_information.TargetBlacklist[nextTarget] == nil) then
								newtask.waiting = false
								if (E.distance > 500) then
									local Epos = E.pos
									Player:MoveToRandomPointAroundCircle( Epos.x, Epos.y, Epos.z, 500 )
									return
								else									
									wt_core_state_combat.setTarget( nextTarget )
									wt_core_controller.requestStateChange( wt_core_state_combat )
									return
								end
							end
						end
						--[[local npcList = CharacterList("nearest,npc,dead,maxdistance=2500,friendly,onmesh")
						if ( TableSize( npcList ) > 0 ) then
							local nextTarget, E  = next( npcList )
							if ( nextTarget ~= nil and E ~= nil ) then
								if ( E.distance > 110 ) then
									local TPOS = E.pos
									Player:MoveTo( TPOS.x, TPOS.y, TPOS.z , 25 )
								elseif( E.distance <= 110 ) then
									Player:StopMoving()
									local npcID = Player:GetInteractableTarget()
									if (npcID ~= 0) then
										newtask.waiting = false
										if( Player:GetCurrentlyCastedSpell() == 17 ) then
											Player:Interact(npcID)
											wt_debug("Reviving NPC: "..(E.name))
											return
										end
									end
								end
							end
						end]]
						if (Player.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving and newtask.eventType ~= nil) then
							if ( myevent.distance > 500 ) then	
								Player:MoveToRandomPointAroundCircle(  newtask.position.x, newtask.position.y, newtask.position.z, 750 )
							end
						end
					else
						if ((wt_global_information.Now - newtask.startingTime) < newtask.maxduration) then
						
							if ( myevent.distance > 3000 ) then	
								Player:MoveToRandomPointAroundCircle(  newtask.position.x, newtask.position.y, newtask.position.z, 750 )
							else
								TargetList = ( CharacterList( "attackable,nearest,alive,maxdistance=2500,onmesh") )
								if ( TargetList ~= nil ) then 	
									local nextTarget, E  = next( TargetList )									
									if ( nextTarget ~= nil and wt_global_information.TargetBlacklist ~= nil and wt_global_information.TargetBlacklist[nextTarget] == nil) then
										wt_core_state_combat.setTarget( nextTarget )
										wt_core_controller.requestStateChange( wt_core_state_combat )																
									else
										TargetList = GadgetList( "attackable,alive,los,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceFar )
										if ( TargetList ~= nil ) then 	
											local nextTarget, E  = next( TargetList )
											if ( nextTarget ~= nil and wt_global_information.TargetBlacklist ~= nil and wt_global_information.TargetBlacklist[nextTarget] == nil) then
												wt_core_state_gcombat.setTarget( nextTarget )
												wt_core_controller.requestStateChange( wt_core_state_gcombat )
												return
											end
										end
										newtask.needPause = true
										newtask.pausestartingTime = wt_global_information.Now										
									end								
								else
									newtask.needPause = true
									newtask.pausestartingTime = wt_global_information.Now
								end
							end
							newtask.name = "Do Event "..(math.floor((newtask.maxduration-(wt_global_information.Now - newtask.startingTime))/1000)).." sec"
						else
							newtask.needUpdate = true
						end
					end
				end
			else
				newtask.needUpdate = true
			end
		else
			newtask.needUpdate = true
		end
		
			
		if (newtask.needUpdate) then
			local event = MapMarkerList("isevent,eventID="..tonumber(newtask.eventID)..",onmesh")
			if event then
				local i,e = next(event)
				if i and e then
					newtask.needUpdate = false
					newtask.position = event.pos
					newtask.startingTime = wt_global_information.Now
					return
				end
			end
			-- Chain Event check
			if (newtask.needUpdate) then
				local event = MapMarkerList("isevent,eventID=" .. tonumber(newtask.eventID+1)..",onmesh")
				if event then
					local i,e = next(event)
					if i and e then
						wt_core_taskmanager:addEventTask( i, e , 4000)						
					end
				end
			end
			newtask.done = true
		end
	end

	function newtask:isFinished()
		if ( newtask.done ) then 
			wt_core_taskmanager.Customtask_history[tostring(newtask.UID)] = wt_global_information.Now
			return true
		end
		return false
	end

	wt_core_taskmanager:addCustomtask( newtask )	
end


function wt_core_taskmanager:addQuarzBasketTask( marker , prio)
	if not marker or marker == nil then
		return
	end
	local newtask = inheritsFrom( wt_task )
	newtask.UID = "Quartzbasket"..tostring(math.floor(marker.pos.x))
	newtask.timestamp = wt_global_information.Now				
	newtask.name = "Quartzbasket"
	newtask.agentID = marker.agentID
	newtask.priority = prio
	newtask.spotreached = false
	newtask.startingTime = 0
	newtask.position = marker.pos
	newtask.maxduration = math.random(50000,60000)
	newtask.done = false
	newtask.last_execution = 0
	newtask.throttle = 500
	newtask.mapchecklast_execution = 0
	newtask.mapmarkerthrottle = 2000
	
	function newtask:canRun()			
		return true
	end
		
	function newtask:execute()
		if ( not newtask.spotreached ) then			
			local me = Player
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, me.pos.x, me.pos.y, me.pos.z )
			if ( distance > 120 ) then
				if ( (wt_global_information.Now - newtask.mapchecklast_execution) > newtask.mapmarkerthrottle ) then
					newtask.mapchecklast_execution = wt_global_information.Now
					local event = MapMarkerList("worldmarkertype=20,agentID="..newtask.agentID)
					if event ~= nil then
						local i,e = next(event)
						if not i or not e then
							d("Quartzbasket is gone...")
							Player:StopMoving()
							newtask.done = true		
						end
					else
						d("Quartzbasket is gone...")
						Player:StopMoving()
						newtask.done = true
					end
				end	
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 75 )
					if ( gSMactive == "1" ) then
						SkillMgr.DoActionTmr = wt_global_information.Now 
						SkillMgr.DoAction()	
					end
					newtask.last_execution = wt_global_information.Now
				end
			else
				if ( Player:GetInteractableTarget() == newtask.agentID ) then
					d("Grabbing Basket")
					Player:Use(newtask.agentID)
					newtask.spotreached = true
					newtask.startingTime = wt_global_information.Now
					newtask.last_execution = wt_global_information.Now
					newtask.throttle = 2000
				end
			end
			newtask.name = "Quartzbasket: "..(math.floor(distance))
		else
			newtask.done = true	
		end		
	end

	function newtask:isFinished()
		if ( newtask.done ) then			
			return true
		end
		return false
	end	
	wt_core_taskmanager:addCustomtask( newtask )
end


-- Pause task stops the bot for random tick count with EmergencyTask priority
function wt_core_taskmanager:addPauseTask(low, high)     
	local newtask = inheritsFrom( wt_task )
	newtask.name = "PauseBot"
	newtask.priority = 10001
	newtask.done = false
	newtask.last_execution = 0
	newtask.throttle = 250
	newtask.pauseTime = math.random(low, high)
	newtask.startTime = wt_global_information.Now
   
	function newtask:execute()
		if (wt_global_information.Now - newtask.startTime > newtask.pauseTime) then 
			newtask.done = true
		end
	end
   
	function newtask:isFinished()
			if ( newtask.done ) then
				return true
			end
			return false
	end    
	wt_debug("Pausing "..newtask.pauseTime.." milliseconds")
	wt_core_taskmanager:addCustomtask( newtask )
end







-- blacklist whatever the current event id is and write to settings
function wt_core_taskmanager:BlacklistCurrentEvent()
	if (wt_core_taskmanager.current_task ~= nil) then
		if (string.find(wt_core_taskmanager.current_task.name, "Event") ~= nil) then
			local event = wt_core_taskmanager.current_task
			wt_core_taskmanager:BlacklistEvent(event.eventID)
			
			-- tell group to blacklist event
			if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1) then	
				MultiBotSend( "23;"..tonumber(event.eventID),"gw2minion" )
			-- tell leader to blacklist event
			elseif (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() ~= 1) then
				MultiBotSend( "22;"..tonumber(event.eventID),"gw2minion" )
			end
			
		end
	end
end

-- blacklist the specified event and write to settings
function wt_core_taskmanager:BlacklistEvent(eventID)
	if (wt_core_taskmanager.current_task ~= nil) then
		if (string.find(wt_core_taskmanager.current_task.name, "Event") ~= nil) then
			local event = wt_core_taskmanager.current_task
			if (eventID == event.eventID) then
				event.done = true
			end
		end
	end
	wt_debug("Blacklisting event "..eventID.." due to user request")
	
	-- write out blacklist to settings
	wt_core_taskmanager.userEventBlacklist = Settings.GW2MINION.userEventBlacklist
	if (wt_core_taskmanager.userEventBlacklist[eventID] == nil) then
		wt_core_taskmanager.userEventBlacklist[eventID] = true
		Settings.GW2MINION.userEventBlacklist = wt_core_taskmanager.userEventBlacklist
		Settings.GW2MINION.version = 1.0
	end
end

function wt_core_taskmanager:CleanBlacklist()
	-- clear npcBlacklist
	for npcID, listTime in pairs(wt_core_taskmanager.npcBlacklist) do
		if (npcID ~= nil and listTime ~= nil) then
			--clear out npcs that have been blacklisted longer than 5 mins
			if (os.difftime(os.time(), listTime) > 300) then
				wt_core_taskmanager.npcBlacklist[npcID] = nil
			end
		end
	end
	
	-- clear eventBlacklist
	for eventID, listTime in pairs(wt_core_taskmanager.eventBlacklist) do
		if (eventID ~= nil and listTime ~= nil) then
			if (listTime ~= -1) then
				--clear out npcs that have been blacklisted longer than 10 mins
				if (os.difftime(os.time(), listTime) > 600) then
					wt_core_taskmanager.eventBlacklist[eventID] = nil
				end
			end
		end
	end
end

RegisterEventHandler("wt_core_taskmanager.blacklistCurrentEvent", wt_core_taskmanager.BlacklistCurrentEvent)