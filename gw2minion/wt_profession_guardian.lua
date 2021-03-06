-- Load routine only if player is a Guardian

-- The following values have to get set ALWAYS for ALL professions!!
wt_profession_guardian  =  inheritsFrom( nil )
wt_profession_guardian.professionID = 1 -- needs to be set
wt_profession_guardian.professionRoutineName = "Guardian"
wt_profession_guardian.professionRoutineVersion = "1.0"
wt_profession_guardian.switchweaponTmr = 0


------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Determine our weapons
function wt_profession_guardian.GetMainHandWeapon(MainHand)
	-- A bit stoopid but failsafe way to always get the correct weapons
	--d(Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1).skillID )
	if (MainHand ~= nil ) then		
		if (MainHand.skillID == 9159 ) then return ("Hammer")
		elseif (MainHand.skillID == 9137 ) then return ("Greatsword")
		elseif (MainHand.skillID == 9122 ) then return ("Staff")
		elseif (MainHand.skillID == 9105 ) then return ("Sword") 
		elseif (MainHand.skillID == 9109 ) then return ("Mace")
		elseif (MainHand.skillID == 9098 ) then return ("Scepter")		
		end
	end
	return "default"
end
-- Determine our weapon
function wt_profession_guardian.GetOffHandWeapon(OffHand)
--d(Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_4).contentID)
	if (OffHand ~= nil ) then
		if     (OffHand.skillID == 9124 ) then return ("Hammer") 
		elseif (OffHand.skillID == 9146 ) then return ("Greatsword")
		elseif (OffHand.skillID == 9265 ) then return ("Staff")
		elseif (OffHand.skillID == 9112 ) then return ("Focus")
		elseif (OffHand.skillID == 9104 or OffHand.skillID == 9089) then return ("Torch")
		elseif (OffHand.skillID == 15834 ) then return ("Shield")
		end
	end
	return "default"
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Randomly switch Weaponset
function wt_profession_guardian.SwitchWeapon()
	if (wt_profession_guardian.switchweaponTmr == 0 or wt_global_information.Now - wt_profession_guardian.switchweaponTmr > math.random(1500,4000)) then
		wt_profession_guardian.switchweaponTmr = wt_global_information.Now
		if ( gGuardSwapWeapons == "1" and Player:CanSwapWeaponSet() ) then
			Player:SwapWeaponSet()
			return true
		end
	end
	return false 
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Combat Default Attack 
wt_profession_guardian.c_attack_default = inheritsFrom(wt_cause)
wt_profession_guardian.e_attack_default = inheritsFrom(wt_effect)

function wt_profession_guardian.c_attack_default:evaluate()
	  return wt_core_state_combat.CurrentTarget ~= 0
end

wt_profession_guardian.e_attack_default.usesAbility = true
function wt_profession_guardian.e_attack_default:execute()	
	if (gSMactive == "0") then
	TID = wt_core_state_combat.CurrentTarget
	if ( TID ~= 0 ) then
		local T = CharacterList:Get(TID)
		if ( T ~= nil ) then		
			--wt_debug("attacking " .. wt_core_state_combat.CurrentTarget .. " Distance " .. T.distance)
			local TPos = T.pos
			Player:SetFacing(TPos.x, TPos.y, TPos.z)
			local s1 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
			local s2 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_2)
			local s3 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_3)
			local s4 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_4)
			local s5 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_5)
			local F1 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_13) --Virtue of Justice
			local F2 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_14) --Virtue of Resolve
			local F3 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_15) --Virtue of Courage
						
			-- Virtues
			if ( gGuardF1 == "1" and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_13) and F1~=nil and T.distance < 160) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_13)
					return
			end
			if ( gGuardF2 == "1" and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_14) and F2~=nil and Player.inCombat )  then
				local SK10 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_10)
				if (SK10 ~= nil and SK10.skillID == 9154 and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_10)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_14) return
				elseif (SK10 ~= nil and SK10.skillID ~= 9154 and Player.health.percent < math.random(20,50) ) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_14) return
				end
			end
			if ( gGuardF3 == "1" and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_15) and F3~=nil and Player.inCombat )  then
				local SK10 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_10)
				if (SK10 ~= nil and SK10.skillID == 9154 and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_10)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_15) return
				elseif (SK10 ~= nil and SK10.skillID ~= 9154 and Player.health.percent < math.random(20,50) ) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_15) return
				end
			end
			
			-- Skill 7,8,9,Elite
			if ( tonumber(gGuardSK7) ~= nil and tonumber(gGuardSK7) > 0 ) then
				local SK7 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_7)
				if ( SK7 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_7) and Player.health.percent < randomize(tonumber(gGuardSK7)) and (T.distance < SK7.maxRange or T.distance < 140 or SK7.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_7)
					return
				end
			end
			if ( tonumber(gGuardSK8) ~= nil and tonumber(gGuardSK8) > 0 ) then
				local SK8 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_8)
				if ( SK8 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_8) and Player.health.percent < randomize(tonumber(gGuardSK8)) and (T.distance < SK8.maxRange or T.distance < 140 or SK8.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_8)
					return
				end
			end
			if ( tonumber(gGuardSK9) ~= nil and tonumber(gGuardSK9) > 0 ) then
				local SK9 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_9)
				if ( SK9 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_9) and Player.health.percent < randomize(tonumber(gGuardSK9)) and (T.distance < SK9.maxRange or T.distance < 140 or SK9.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_9)
					return
				end
			end
			if ( tonumber(gGuardSK10) ~= nil and tonumber(gGuardSK10) > 0 ) then
				local SK10 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_10)
				if ( SK10 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_10) ) then
					if ( SK10.skillID == 9154 and Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_13) and Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_14) and Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_15)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_10)
						return 
					elseif ( SK10.skillID ~= 9154 and Player.health.percent < randomize(tonumber(gGuardSK10)) and (T.distance < SK10.maxRange or T.distance < 140 or SK10.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_10)
						return
					end
				end
			end
			
			
			
			-- Weapons
			local myMHWeap = wt_profession_guardian.GetMainHandWeapon(s1)
			local myOHWeap = wt_profession_guardian.GetOffHandWeapon(s4)
						
			if ( myOHWeap == "Hammer" ) then			
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < 170) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return
					end
				end
			end
			if ( myOHWeap == "Greatsword") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < 580 and T.distance > 140) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < 240) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return				
					end
				end	
			end				
			if ( myOHWeap == "Staff") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange and T.distance > 160) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and Player.health.percent < math.random(20,30) and T.distance < 1200) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return					
					end
				end
			end
			if ( myOHWeap == "Focus") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < 180 and Player.inCombat) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return					
					end
				end
			end				
			if ( myOHWeap == "Shield") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < 160) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return				
					end
				end
			end
			if ( myOHWeap == "Torch") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and (T.distance < s4.maxRange or T.distance < 200 )) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return					
					end
				end
			end
			------
			if ( myMHWeap == "Hammer" ) then			
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID) 
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_guardian.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end
			elseif ( myMHWeap == "Greatsword") then	
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_guardian.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end			
			elseif ( myMHWeap == "Staff") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < 260) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_guardian.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end	
			elseif ( myMHWeap == "Sword") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_guardian.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end						
			elseif ( myMHWeap == "Scepter") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange and T.movementstate == GW2.MOVEMENTSTATE.GroundMoving) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < 240 ) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_guardian.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end
			elseif ( myMHWeap == "Mace") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange and T.inCombat) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange ) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_guardian.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end
				
			
			else --DEFAULT ATTACK
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and (T.distance < s5.maxRange or s5.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and (T.distance < s4.maxRange or s4.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and (T.distance < s3.maxRange or s3.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and (T.distance < s2.maxRange or s2.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and (T.distance < s1.maxRange or s1.maxRange < 100)) then
						if (not wt_profession_guardian.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end
			end	
		end
	end
	end
end


-----------------------------------------------------------------------------------
-- Registration and setup of GUI and causes and effects to the different states for this profession
-----------------------------------------------------------------------------------
function wt_profession_guardian.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gGuardSwapWeapons" or k == "gGuardF1" or k == "gGuardF2" or k == "gGuardF3" or k == "gGuardSK7" or k == "gGuardSK8" or k == "gGuardSK9" or k == "gGuardSK10") then
			Settings.GW2MINION[tostring(k)] = v
		end
	end
end

function wt_profession_guardian:HandleInit() 	
	if ( Player.profession ~= nil and Player.profession == wt_profession_guardian.professionID) then
		wt_debug("Initalizing profession routine for Guardian")
		
		-- GUI Elements
		if ( Settings.GW2MINION.gGuardSwapWeapons == nil ) then
			Settings.GW2MINION.gGuardSwapWeapons = "1"
		end
		if ( Settings.GW2MINION.gGuardF1 == nil ) then
			Settings.GW2MINION.gGuardF1 = "75"
		end
		if ( Settings.GW2MINION.gGuardF2 == nil ) then
			Settings.GW2MINION.gGuardF2 = "75"
		end
		if ( Settings.GW2MINION.gGuardF3 == nil ) then
			Settings.GW2MINION.gGuardF3 = "50"
		end
		if ( Settings.GW2MINION.gGuardSK7 == nil ) then
			Settings.GW2MINION.gGuardSK7 = "80"
		end
		if ( Settings.GW2MINION.gGuardSK8 == nil ) then
			Settings.GW2MINION.gGuardSK8 = "80"
		end
		if ( Settings.GW2MINION.gGuardSK9 == nil ) then
			Settings.GW2MINION.gGuardSK9 = "80"
		end
		if ( Settings.GW2MINION.gGuardSK10 == nil ) then
			Settings.GW2MINION.gGuardSK10 = "75"
		end
		
		GUI_NewCheckbox(wt_global_information.MainWindow.Name,strings[gCurrentLanguage].autoSwapWeaponSets,"gGuardSwapWeapons",strings[gCurrentLanguage].guardianSettings);
		GUI_NewCheckbox(wt_global_information.MainWindow.Name,strings[gCurrentLanguage].autoF1,"gGuardF1",strings[gCurrentLanguage].guardianSettings);
		GUI_NewCheckbox(wt_global_information.MainWindow.Name,strings[gCurrentLanguage].autoF2,"gGuardF2",strings[gCurrentLanguage].guardianSettings);
		GUI_NewCheckbox(wt_global_information.MainWindow.Name,strings[gCurrentLanguage].autoF3,"gGuardF3",strings[gCurrentLanguage].guardianSettings);
		GUI_NewField(wt_global_information.MainWindow.Name,strings[gCurrentLanguage].skill7HP,"gGuardSK7",strings[gCurrentLanguage].guardianSettings);
		GUI_NewField(wt_global_information.MainWindow.Name,strings[gCurrentLanguage].skill8HP,"gGuardSK8",strings[gCurrentLanguage].guardianSettings);
		GUI_NewField(wt_global_information.MainWindow.Name,strings[gCurrentLanguage].skill9HP,"gGuardSK9",strings[gCurrentLanguage].guardianSettings);
		GUI_NewField(wt_global_information.MainWindow.Name,strings[gCurrentLanguage].eliteHP,"gGuardSK10",strings[gCurrentLanguage].guardianSettings);
		
		
		gGuardSwapWeapons = Settings.GW2MINION.gGuardSwapWeapons
		gGuardF1 = Settings.GW2MINION.gGuardF1
		gGuardF2 = Settings.GW2MINION.gGuardF2
		gGuardF3 = Settings.GW2MINION.gGuardF3
		gGuardSK7 = Settings.GW2MINION.gGuardSK7
		gGuardSK8 = Settings.GW2MINION.gGuardSK8
		gGuardSK9 = Settings.GW2MINION.gGuardSK9
		gGuardSK10 = Settings.GW2MINION.gGuardSK10
		
					
		-- Our C & E�s for Warrior combat:
		-- Default Causes & Effects that are already in the wt_core_state_combat for all classes:
		-- Death Check 				- Priority 10000   --> Can change state to wt_core_state_dead.lua
		-- Combat Over Check 		- Priority 500      --> Can change state to wt_core_state_idle.lua		
			
		local ke_Attack_default = wt_kelement:create("Attack",wt_profession_guardian.c_attack_default,wt_profession_guardian.e_attack_default, 45 )
		wt_core_state_combat:add(ke_Attack_default)
			

		-- We need to set the Currentprofession to our profession , so that other parts of the framework can use it.
		wt_global_information.Currentprofession = wt_profession_guardian
		wt_global_information.AttackRange = 120
	end
end

RegisterEventHandler("Module.Initalize",wt_profession_guardian.HandleInit)
RegisterEventHandler("GUI.Update",wt_profession_guardian.GUIVarUpdate)













