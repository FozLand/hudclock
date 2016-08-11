-- Interval between clock updates (in os seconds).
local INTERVAL = 1

local player_hud = {}

core.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if player_hud[name] ~= nil then
		player:hud_remove(player_hud[name])
		player_hud[name] = nil
	end
	return true
end)

local function get_time ()
	local minutes = math.floor( core.get_timeofday()*24*60 )
	local m =  minutes % 60
	local h = (minutes/60) % 60
	return ("%02d:%02d"):format(h, m)
end

local function update_clock()
	local time = get_time()
	for _,p in ipairs( core.get_connected_players() ) do
		local name = p:get_player_name()
		if player_hud[name] then
			if not p:hud_change( player_hud[name], 'text', time ) then
				player_hud[name] = nil
			end
		else
			local h = p:hud_add({
				hud_elem_type = "text",
				position = {x=1, y=0},
				offset = {x=-48, y=32},
				text = time,
				number = 0xAAAA00,
			})
			player_hud[name] = h
		end
	end
	core.after(INTERVAL, update_clock)
end
core.after(INTERVAL, update_clock)
