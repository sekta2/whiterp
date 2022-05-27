if SERVER then

	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")

	include("shared.lua")

	WhiteRP = {}

	util.AddNetworkString("addmoney")

	function WhiteRP.CreateDir(dirname)
		if !file.Exists(dirname,"DATA") then
			file.CreateDir(dirname)
		end
	end


	function WhiteRP.checkJson(ply)
		WhiteRP.CreateDir("wrp_plydata")
		if !file.Exists("wrp_plydata/" .. ply:SteamID64() .. ".json","DATA") then
			local plydata = {
				money = 100
			}
			local json = util.TableToJSON(plydata)
			file.Write("wrp_plydata/" .. ply:SteamID64() .. ".json",json)
		end
	end

	function WhiteRP.plyLoadData(ply)
		WhiteRP.checkJson(ply)
		local json = file.Read(ply:SteamID64() .. ".json", "DATA")
		local tableply = util.JSONToTable( json )
		for k,v in pairs(tableply) do
			ply:SetNWInt(k,v)
		end
	end

	function WhiteRP.plySaveData(ply)
		WhiteRP.checkJson(ply)
		local json = file.Read(ply:SteamID64() .. ".json", "DATA")
		local tableply = util.JSONToTable( json )
		local newtableply = {}
		for k,v in pairs(tableply) do
			local v2=ply:GetNWInt(k)
			table.Add(newtableply, {k = v2})
		end
		local newjson = util.TableToJSON(newtableply)
		file.Write("wrp_plydata/" .. ply:SteamID64() .. ".json",newjson)
	end

	function WhiteRP.getMoney(ply)
		WhiteRP.checkJson(ply)
		return ply:GetNWInt("money",100)
	end

	function WhiteRP.setMoney(ply,count)
		WhiteRP.checkJson(ply)
		ply:SetNWInt("money",count)
	end

	function WhiteRP.addMoney(ply,count)
		WhiteRP.checkJson(ply)
		local money = WhiteRP.getMoney(ply)
		money = money + count
		WhiteRP.setMoney(ply,money)
	end

	function GM:PlayerConnect(name, ip)

		print("Player "..name.." is connecting!")

	end


	function GM:PlayerInitialSpawn(ply)

		print("Player "..ply:Name().." Has spawned")
		WhiteRP.checkJson(ply)
		WhiteRP.plyLoadData(ply)

	end

	net.Receive("addmoney",function()
		local ply = net.ReadEntity()
		local money = WhiteRP.getMoney(ply)
		WhiteRP.addMoney(ply,100)
		WhiteRP.plySaveData(ply)
	end)

end