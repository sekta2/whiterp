if CLIENT then

	function GM:HUDPaint()
		local x = 50
		local y = 50
		draw.RoundedBox(50,x,y,50,50,Color(255,55,55,255))
	end

	function GM:OnPlayerChat( ply, text, teamChat, isDead )
		if text == "!addmoney" then
		net.Start("addmoney")
			net.WriteEntity(ply)
		net.SendToServer()
		end
	end

end