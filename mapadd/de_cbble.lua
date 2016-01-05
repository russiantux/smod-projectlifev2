--ORIGINAL SCRIPT BY SMOD AUTHOR http://accept.hopto.org/smod/
--MODIFICATION BY FITZROY_DOLL JANUARY 2007 http://www.amphibian.myzen.co.uk/home/

--These are Boolean values. 1 means yes, spawn these entities. 0 means no, do not spawn. TeamAlyx consists of Alyx and Barney plus a randomly chosen special teammate. Extras spawns extra zombies and combine weapons such as manhacks and mines. Turning Extras off makes the game easier and lightens the load on low spec systems.

local	TEAMALYX = 1
local	EXTRAS = 1

--CITIZENNUM can be up to 12 and includes the player (so number of allies is CITIZENUM - 1). COMBINENUM should equal number of Terrorist Spawn Points, in many cases 16.  ZOMBIENUM, TOOLSNUM and PROPSNUM are the number of zombies, combine weapons such as mines and prop physics. These numbers are limited only by your hardware. AMMONUM is the number of crates of resources including health, weapons and ammunition. Note that a value of zero for any of these numbers means spawn an unlimited amount, which will crash the game.

local	CITIZENNUM = HL2.RandomInt(3,5)
local	COMBINENUM = 16

local	ZOMBIENUM = HL2.RandomInt(2,5)
local	TOOLSNUM = HL2.RandomInt(2,5)
local	PROPSNUM = HL2.RandomInt(5,10)
local	AMMONUM = HL2.RandomInt(4,6)

-------DO NOT ALTER ANY VALUES BELOW THIS LINE-------

local	SQUADS = 8
local	CITIZENSPAWNPOINT = "info_player_counterterrorist"
local	COMBINESPAWNPOINT = "info_player_terrorist"

local	ZOMBIESPAWNPOINT = "info_npc_spawn_destination"
local	TOOLSPAWNPOINT = "info_npc_spawn_destination"

local	END_FLG = false

local	TIMER = 0

function Init()
end


function SpawnGordon(org, ang)

	local plr = HL2.GetPlayer()
	if plr ~= nil then
		HL2.SetEntityAbsOrigin(plr, org)
		HL2.SetEntityAbsAngles(plr, ang)
		local item = HL2.CreateEntity("item_suit", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_pistol", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_pistol_large", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_pistol_large", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_smg1", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_smg1_large", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_smg1_large", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_frag", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_frag", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_crowbar", org, ang)
		HL2.SpawnEntity(item)
	end	
end


--these are the citizen weapons. Good luck chaps!
local wep_name = {	"weapon_smg1", 
			"weapon_ak47",
			"weapon_grease",
			"weapon_kar98",
			"weapon_shotgun"
		}

function GetWeaponName()

	local rt = HL2.RandomInt(1, 5)
	
	return wep_name[rt]

end


--these are the combine weapons. Some are repeated to make them slightly more likely to occur. Sniper rifles should be uncommon in comparison to more traditional weapons.
local wep_name1 = {	"weapon_svd",
			"weapon_mp5",  
			"weapon_mp5",
			"weapon_ar2",
			"weapon_ar2",
			"weapon_smg1",
			"weapon_smg1",
			"weapon_shotgun",
			"weapon_shotgun"
		}

function GetWeaponName1()

	local rt = HL2.RandomInt(1, 9)
	
	return wep_name1[rt]

end

--these are the combine. Some are repeated to make them slightly more likely to occur. Cloaked and Ace Combine should be more rare than elites, soldiers and metropolice.
local npc_name = {	"npc_combine_ace",
			"npc_combine_e",
			"npc_combine_e",
			"npc_metropolice",
			"npc_metropolice",
			"npc_combine_s",
			"npc_combine_s",
			"npc_combine_c"
		}

function GetNPCName()

	local rt = HL2.RandomInt(1, 8)
	
	return npc_name[rt]

end

--these are the possible zombies. Along with the combine tools, they will infest areas between the combine and citizen spawn points.
local npc_name2 = {	"npc_zombie",
			"npc_headcrab",
			"npc_headcrab_fast",
			"npc_zombie_torso",
			"npc_fastzombie",
			"npc_headcrab_black",
			"npc_kheadcrab",
			"npc_poisonzombie",
			"npc_houndeye"
		}

function GetNPCName2()

	local rt = HL2.RandomInt(1, 9)
	
	return npc_name2[rt]

end

--these are the combine tools. Even though you will not get the gravity gun in this game, the hopper mine can be evaded by running quickly past as it bounces into the air. The rollermine can be destroyed with explosives. Throw a grenade then push the mine towards it using the smg1 or shotgun. If you’re lucky the mine will explode along with the grenade. 
local npc_name3 = {	"npc_manhack",
			"npc_rollermine",
			"combine_mine",
			"npc_kscanner"
		}

function GetNPCName3()

	local rt = HL2.RandomInt(1, 4)
	
	return npc_name3[rt]

end

--these are the props. These have been chosen on the basis of being large enough to block movement, create challenges or simply enhance visual interest, while still being breakable or moveable if necessary. 
local prop_name = {	"models/props_borealis/bluebarrel002.mdl",
			"models/props_c17/canister02a.mdl",
			"models/props_c17/canister_propane01a.mdl",
			"models/props_c17/FurnitureChair001a.mdl",
			"models/props_c17/furniturebathtub001a.mdl",
			"models/props_c17/Furnituredrawer001a.mdl",
 			"models/props_c17/Furnituredrawer002a.mdl",
			"models/props_c17/Furnituretable001a.mdl",
			"models/props_c17/Furnituretable002a.mdl",
			"models/props_c17/Furnituretable003a.mdl",
			"models/props_c17/oildrum001.mdl",
			"models/props_c17/oildrum001_explosive.mdl",
			"models/props_canal/boat001b.mdl",
			"models/props_canal/boat001a.mdl",
			"models/props_combine/breenglobe.mdl",
			"models/props_interiors/furniture_desk01a.mdl",
			"models/props_junk/bicycle01a.mdl",
			"models/props_junk/cardboard_box002a.mdl",
			"models/props_junk/gascan001a.mdl",
			"models/props_junk/metalgascan.mdl",
			"models/props_junk/terracotta01.mdl",
			"models/props_junk/trafficcone001a.mdl",
			"models/props_junk/watermelon01.mdl",
			"models/props_junk/wood_crate001a.mdl",
			"models/props_junk/wood_crate001a_damaged.mdl",
			"models/props_junk/wood_crate002a.mdl",
			"models/props_junk/wood_pallet001a.mdl",
			"models/props_lab/kennel_physics.mdl",
			"models/props_vehicles/carparts_door01a.mdl",
			"models/props_vehicles/carparts_tire01a.mdl",
			"models/props_wasteland/cafeteria_bench001a.mdl",
			"models/props_wasteland/cafeteria_table001a.mdl",
			"models/props_wasteland/barricade001a.mdl",
			"models/props_wasteland/laundry_basket001.mdl",
			"models/props_wasteland/laundry_cart002.mdl",
			"models/props_wasteland/prison_bedframe001a.mdl",
			"models/props_wasteland/prison_toilet01.mdl",
			"models/props/de_train/barrel.mdl",
			"models/props/de_inferno/chairantique.mdl",
			"models/props/de_inferno/picture3.mdl",
			"models/props/de_inferno/wine_barrel.mdl",
			"models/props/cs_assault/barrelwarning.mdl"
			}

function GetPROPName()

	local rt = HL2.RandomInt(1, 42)
	
	return prop_name[rt]

end

--these are the prop_physics. These do not have the lower cost multiplayer physics models, so must be spawned as prop_physics. Bonus points if you get the Breen bust.
local prop_name = {	"models/misc/kanban/bon.mdl",
			"models/misc/kanban/nozaki.mdl",
			"models/props_c17/doll01.mdl",
			"models/props_combine/breenbust.mdl",
			"models/props_junk/Propane_tank001a.mdl",
			"models/props/de_tides/vending_turtle.mdl",
			"models/Gibs/HGIBS.mdl",
			"models/misc/bowl_ball.mdl"
			}

function GetPROPName2()

	local rt = HL2.RandomInt(1, 8)
	
	return prop_name[rt]

end

--these are the corpses. 
local prop_name = {	"models/Humans/Charple01.mdl",
			"models/Humans/Charple02.mdl",
			"models/Humans/Charple03.mdl",
			"models/Humans/Charple04.mdl",
			"models/Humans/corpse1.mdl"
			}

function GetPROPName3()

	local rt = HL2.RandomInt(1, 5)
	
	return prop_name[rt]

end


--these are the possible crate contents. 
local crate_contents = {	"item_ammo_ar2_large",
			"item_ammo_pistol_large",
			"item_ammo_smg1_large",
			"item_healthkit",
			"item_healthvial",
			"item_battery",
			"item_box_buckshot",
			"weapon_frag"
		}

function GetCrateContents()

	local rt = HL2.RandomInt(1, 8)
	
	return crate_contents[rt]

end
--these are the special crate contents. 
local crate_contents = {	"item_ammo_ar2_altfire",
			"weapon_anm14",
			"item_ammo_smg1_grenade",			
			"food_sankaba",
			"food_cornedbeef",
			"weapon_crossbow",
			"weapon_357",
			"weapon_flaregun"			
		}

function GetCrateContents2()

	local rt = HL2.RandomInt(1, 8)
	
	return crate_contents[rt]

end

--create citizens
function SpawnCitizen(org, ang)
	
	local cit = HL2.CreateEntity("npc_citizen", org, ang)
	if( cit ~= nil ) then
		local rt = HL2.RandomInt(1,wep_name.getn)
		local sf = 1024 + 8 + 2		
		if HL2.RandomInt(1,4) == 1 then
			sf = sf + 131072		
		elseif HL2.RandomInt(1,4) == 1 then
			sf = sf + 524288
		end
		if HL2.RandomInt(1,5) == 1 then
			sf = sf + 65536 + 1048576
		end
		
		HL2.KeyValue(cit, "additionalequipment", GetWeaponName())
		HL2.KeyValue(cit, "ammosupply", "SMG1")
		HL2.KeyValue(cit, "ammoamount", "45")
		HL2.KeyValue(cit, "squadname", citizen)
		HL2.KeyValue(cit, "targetname", "citizen")
		HL2.KeyValue(cit, "spawnflags", sf)
		HL2.KeyValue(cit, "citizentype", HL2.RandomInt(1,3))
		HL2.KeyValue(cit, "runspeedmod", HL2.RandomFloat(0.8, 1.2))
		HL2.SpawnEntity(cit)
	end
 
end

--create combine
function SpawnCombine(org, ang, sqn)

	local npcname = GetNPCName()
	local cb = HL2.CreateEntity(npcname, org, ang)
	if( cb ~= nil ) then
		local rt = HL2.RandomInt(1,SQUADS)
		local sf = 1024 + 8
		if npcname == "npc_combine_s" then
			if HL2.RandomInt(0,1) == 0 then
				HL2.KeyValue(cb, "model", "models/combine_soldier_prisonguard.mdl")
			end
		end		
		if HL2.RandomInt(1,4) == 1 then
			sf = sf + 256
		end
		
		--	speed hacker
		if HL2.RandomInt(0,20) == 1 then
			HL2.KeyValue(cb, "runspeedmod", "2")
		else
			HL2.KeyValue(cb, "runspeedmod", HL2.RandomFloat(1.0,1.4))
		end
		--cops need hacks
		if npcname == "npc_metropolice" then
			if HL2.RandomInt(0,1) == 0 then
			HL2.KeyValue(cb, "manhacks", "1")
			end
		end
		HL2.KeyValue(cb, "spawnflags", sf)	
		HL2.KeyValue(cb, "additionalequipment", GetWeaponName1())
		HL2.KeyValue(cb, "NumGrenades", HL2.RandomInt(1,12))
		HL2.KeyValue(cb, "squadname", "combines" .. rt)
		HL2.KeyValue(cb, "targetname", sqn)
		HL2.SpawnEntity(cb)
	end

end

--create zombies
function SpawnZombie(org, VECTORZERO)

	local npcname2 = GetNPCName2()
	local zm = HL2.CreateEntity(npcname2, org, VECTORZERO)
	if( zm ~= nil ) then
		--	speed hacker. One day you will run into a speedhacked poison zombie.
		if HL2.RandomInt(0,20) == 1 then
			HL2.KeyValue(zm, "runspeedmod", "3")
					else
			HL2.KeyValue(zm, "runspeedmod", HL2.RandomFloat(1.0,1.4))
		end
		
		HL2.KeyValue(zm, "squadname", "zsquad")
		HL2.KeyValue(zm, "targetname", "zsquad")
		HL2.SpawnEntity(zm)
	end
end

--create combine tools
function SpawnTools(org, VECTORZERO)

	local npcname3 = GetNPCName3()
	local tl = HL2.CreateEntity(npcname3, org, VECTORZERO)
	if( tl ~= nil ) then
		if npcname3 == "combine_mine" then
			HL2.KeyValue(tl, "LockSilently", "1")
			HL2.KeyValue(tl, "ExplosionDamage", "150")
			HL2.KeyValue(tl, "ExplosionRadius", "125")
		end
		HL2.SpawnEntity(tl)
	end
end

--create props
function SpawnProps(org, ang)
	if HL2.RandomInt(1,10) == 1 then
	pp = HL2.CreateEntity("prop_physics", org, VECTORZERO)
		if pp ~= nil then
			HL2.KeyValue(pp, "model", GetPROPName2())
			HL2.KeyValue(pp, "skin", HL2.RandomInt(0,1))
			HL2.SpawnEntity(pp)
		end
else		
	if HL2.RandomInt(1,10) == 1 then
	pr = HL2.CreateEntity("prop_ragdoll", org, VECTORZERO)
		if pr ~= nil then
			HL2.KeyValue(pr, "model", GetPROPName3())
			HL2.SpawnEntity(pr)
		end	
	
else
	pm = HL2.CreateEntity("prop_physics_multiplayer", org, VECTORZERO)
		if pm ~= nil then
			HL2.KeyValue(pm, "model", GetPROPName())
			HL2.KeyValue(pm, "skin", HL2.RandomInt(0,1))
			HL2.SpawnEntity(pm)
		end
	end
	end
end

--create ammo
function SpawnAmmo(org, VECTORZERO)
	if HL2.RandomInt(1,10) == 1 then
	am2 = HL2.CreateEntity("item_item_crate", org, VECTORZERO)
		if am2 ~= nil then
			HL2.KeyValue(am2, "ItemClass", GetCrateContents2())
			HL2.KeyValue(am2, "ItemCount", HL2.RandomInt(1,3))
			HL2.SpawnEntity(am2)
		end
	else
	am = HL2.CreateEntity("item_item_crate", org, VECTORZERO)
		if am ~= nil then
			HL2.KeyValue(am, "ItemClass", GetCrateContents())
			HL2.KeyValue(am, "ItemCount", HL2.RandomInt(3,5))
			HL2.SpawnEntity(am)
		end
	end	
end

--end spawns

function CheckEnemy()

	local found = 0
	local sq

	for sq = 1, SQUADS, 1 do
	
		local ent = HL2.FindEntityByName(nil, "csquad" .. sq)
		while ent ~= nil do
			found = found + 1
			ent = HL2.FindEntityByName(ent, "csquad" .. sq)
		end
	end
	
	local ent2 = HL2.FindEntityByName(nil, "apc1")
	if ent2 ~= nil then found = found + 1
	end
	
	local ent3 = HL2.FindEntityByName(nil, "apc2")
	if ent3 ~= nil then found = found + 1
	end
	
	
	if found == 0 and END_FLG == false then

		HL2.CallMapaddLabel("clear")
		END_FLG = true
	elseif END_FLG == false then
		HL2.ShowHUDMessage("\n\n\n\n\n\n" .. found .. " Combine remaining")
	end 

end

function MoveTo(squad)

	local nodes = HL2.GetNodeCounts()
	local node = HL2.GetNodeData(HL2.RandomInt(0,nodes-1))
	if node ~= nil then
		local org = HL2.Vector(node.x, node.y, node.z)
		local targ = HL2.CreateEntity("info_target", org, VECTORZERO)
		if targ ~= nil then
			--print(squad , "move to ", HL2.VectorString(org))
			HL2.KeyValue(targ, "targetname", "mvtg" .. squad)
			HL2.SpawnEntity(targ)
		end 
		local gf = HL2.CreateEntity("ai_goal_follow", org, VECTORZERO)
		if( gf ~= nil ) then
			HL2.KeyValue(gf, "startactive", "1")
			HL2.KeyValue(gf, "actor", squad)
			HL2.KeyValue(gf, "formation", "1")
			HL2.KeyValue(gf, "searchtype", "0")
			HL2.KeyValue(gf, "goal", "mvtg" .. squad)
			HL2.KeyValue(gf, "MaximumState", "2")
			HL2.KeyValue(gf, "targetname", "mvgf" .. squad)
			HL2.SpawnEntity(gf)
		end
		local it = HL2.CreateEntity("instant_trig", org, VECTORZERO)
		if( it ~= nil ) then
			HL2.KeyValue(it, "radius", "300")
			HL2.KeyValue(it, "targetname", "mvit" .. squad)
			HL2.KeyValue(it, "touchname", squadname)
			HL2.KeyValue(it, "OnHitTrigger", "mvgf" .. squad .. ",kill,,0,-1")
			HL2.SpawnEntity(it)
		end
	end 

end

function SpawnTeamAlyx(ent)

--these are the weapons for Barney and the friendly combine.
local wep_name2 = {	"weapon_mp5",
			"weapon_ar2",
			"weapon_smg1",
			"weapon_AK47",
			"weapon_shotgun"
		}
function GetWeaponName2()
	local rt = HL2.RandomInt(1, 5)
	return wep_name2[rt]
end

--	alyx. 
	ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
	if ent ~= nil then
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		local npc = HL2.CreateEntity("npc_alyx", org, ang)
		if npc ~= nil then
			HL2.KeyValue(npc, "additionalequipment", "weapon_alyxgun")
			HL2.KeyValue(npc, "squadname", "teamalyx")
			HL2.KeyValue(npc, "targetname", "teamalyx")
			HL2.KeyValue(npc, "spawnflags", "1024")
			HL2.SpawnEntity(npc)
		end
	end

--	barney
	ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
	if ent ~= nil then
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		local npc = HL2.CreateEntity("npc_barney", org, ang)
		if npc ~= nil then
			HL2.KeyValue(npc, "additionalequipment", GetWeaponName2())
			HL2.KeyValue(npc, "squadname", "teamalyx")
			HL2.KeyValue(npc, "targetname", "teamalyx")
			HL2.KeyValue(npc, "spawnflags", "1024")
			HL2.SpawnEntity(npc)
		end
		end
	
-- special teammate
local npc_team = {	"npc_vortigaunt",
			"npc_um_citizen",
			"npc_f_combine"
		}
function GetNPC_Team()
	local rt = HL2.RandomInt(1, 3)
	return npc_team[rt]
end
	
	ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
	if ent ~= nil then
		local npc_team = GetNPC_Team()
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		local npc = HL2.CreateEntity(npc_team, org, ang)
		local sf = 1024 + 256
		if npc_team == "npc_f_combine" then
			HL2.KeyValue(npc, "additionalequipment", GetWeaponName2())
			sf = sf + 8
		end
		if npc_team == "npc_um_citizen" then
			HL2.KeyValue(npc, "additionalequipment", GetWeaponName2())
			sf = sf + 8
		end
		if npc_team == "npc_vortigaunt" then
			HL2.KeyValue(npc, "ArmorRechargeEnabled", "1")
		end
		if npc ~= nil then
			HL2.KeyValue(npc, "targetname", "teamalyx")
			HL2.KeyValue(npc, "squadname", "teamalyx")
			HL2.KeyValue(npc, "spawnflags", sf)
			HL2.SpawnEntity(npc)
		end
	end
	HL2.SetEntityRelationshipName2("teamalyx", "csquad*", DISPOSITION.D_HT, 1)
end


--create zombies
function SpawnExtras(ent)
	local cnt = ZOMBIENUM
	local ent = HL2.FindEntityByClass(nil, ZOMBIESPAWNPOINT)
	local sn = 1
	local sncnt = 1
	while ent ~= nil do
		
		local org = HL2.GetEntityAbsOrigin(ent)
		SpawnZombie(org, VECTORZERO)
		sncnt = sncnt + 1
		ent = HL2.FindEntityByClass(ent, ZOMBIESPAWNPOINT)

		cnt = cnt - 1
		if cnt == 0 then break end
		
	end
	
end

--create tools
function SpawnExtras2(ent)
	local cnt = TOOLSNUM
	local ent = HL2.FindEntityByClass(nil, TOOLSPAWNPOINT)
	local sn = 1
	local sncnt = 1
	while ent ~= nil do
		
		local org = HL2.GetEntityAbsOrigin(ent)
		SpawnTools(org, VECTORZERO)
		sncnt = sncnt + 1
		ent = HL2.FindEntityByClass(ent, TOOLSPAWNPOINT)

		cnt = cnt - 1
		if cnt == 0 then break end
		
	end
		

end

function MoveCombine()

	CheckEnemy()

	local sq

	for sq = 1, SQUADS, 1 do
	
		MoveTo("csquad" .. sq)
	
	end

	local it = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
	if( it ~= nil ) then
		HL2.KeyValue(it, "label", "cmovestop")	
		HL2.KeyValue(it, "timer", HL2.RandomInt(30,40))
		HL2.SpawnEntity(it)
	end

	if TEAMALYX == 1 then
		MoveTo("teamalyx")
		HL2.EntFire("followalyx", nil, "StartSchedule", 0, -1)
	end	
end		
		



function RoundInit()

--	****	spawn citizen. 

	local cnt = CITIZENNUM
	local firstspawn = 1

	local ent = HL2.FindEntityByClass(nil, CITIZENSPAWNPOINT)
	while ent ~= nil do
		
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)


		if firstspawn == 1 then
			SpawnGordon(org, ang)
		else
			SpawnCitizen(org, ang)
		end
		
		ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
		
		firstspawn = 0

		cnt = cnt - 1
		if cnt == 0 then break end
		
	end


--	*****	spawn team alyx
	
	if TEAMALYX == 1 then
		SpawnTeamAlyx(ent)
	end
	

--	*****	spawn combine

	cnt = COMBINENUM
	ent = HL2.FindEntityByClass(nil, COMBINESPAWNPOINT)
	local sn = 1
	local sncnt = 1
	local sqn = COMBINENUM / SQUADS
	while ent ~= nil do
		
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		
		local squadname = "csquad" .. sn
		SpawnCombine(org, ang, squadname)
		sncnt = sncnt + 1
		if sncnt > sqn then 
			sncnt = 1
			sn = sn + 1
		end
		
		ent = HL2.FindEntityByClass(ent, COMBINESPAWNPOINT)

		cnt = cnt - 1
		if cnt == 0 then break end
		
	end

--create ammo
	cnt = AMMONUM
	local sn = 1
	local sncnt = 1
	while cnt ~= nil do
		local nodes = HL2.GetNodeCounts()
		local node = HL2.GetNodeData(HL2.RandomInt(0,nodes-1))
		if node ~= nil then
		local org = HL2.Vector(node.x, node.y + 16, node.z + 5)
		
		SpawnAmmo(org, VECTORZERO)
		sncnt = sncnt + 1

		cnt = cnt - 1
		if cnt == 0 then break end
		end
	end

--create props 
	cnt = PROPSNUM
	local sn = 1
	local sncnt = 1
	while cnt ~= nil do
		local nodes = HL2.GetNodeCounts()
		local node = HL2.GetNodeData(HL2.RandomInt(0,nodes-1))
		if node ~= nil then
		local org = HL2.Vector(node.x, node.y + 16, node.z + 5)

		
		SpawnProps(org, VECTORZERO)
		sncnt = sncnt + 1
		
		cnt = cnt - 1
		if cnt == 0 then break end
		
		end
	end	
	
	if EXTRAS == 1 then
		SpawnExtras(ent)
		SpawnExtras2(ent)
	end
end
