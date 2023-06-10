-- USED
bot = Plutonium:GetBot()
function getBot()
    if bot.m_bot.State == "Connected" then
        Status = "online"
    elseif bot.m_bot.State ==  "Account is banned" then
        Status = "banned"
    elseif bot.m_bot.State == "Connecting" then
        Status = "login fail"
    else
        Status = "offline"
    end
    return {
        world = bot.World.Name,
        name = bot.m_bot.TankInfo.TankIDName,
        x = bot.NetAvatar.Pos.X,
        y = bot.NetAvatar.Pos.Y,
        level = bot.NetAvatar.Level,
        status = Status,
        gems = bot.NetAvatar.Inventory.Gems,
        slot = bot.NetAvatar.Inventory.BackPackSize,
    }
end

function findItem(id)
    if id == 112 then
        return bot.NetAvatar.Inventory.Gems
    end
    item = bot:FindItem(id)
    if item == nil then
        return 0
    else
        return item.Count
    end
end

function say(od)
    bot:SendPacket(2, 'action|input\n|text|'..od)
end

function findPath(x,y)
    bot:FindPathAsync(x,y)
end

function move(p_x,p_y)
    local x = math.floor(bot.NetAvatar.Pos.X/32) + p_x
    local y = math.floor(bot.NetAvatar.Pos.Y/32) + p_y
    bot:FindPathAsync(x,y)
    Plutonium:Sleep(bot:GetCooldown())
end

function punch(p_x,p_y)
    local x = math.floor(bot.NetAvatar.Pos.X/32) + p_x
    local y = math.floor(bot.NetAvatar.Pos.Y/32) + p_y
    bot:PunchTile(x, y)
end

function place(id,p_x,p_y)
    local x = math.floor(bot.NetAvatar.Pos.X/32) + p_x
    local y = math.floor(bot.NetAvatar.Pos.Y/32) + p_y
    bot:PlaceTile(x, y, id)
end

function sleep(ms)
    Plutonium:Sleep(ms)
end

function drop(iditem,count)
    if count ~= nil then
        bot:Drop(iditem, count)
    else
        bot:Drop(iditem)
    end
end

function trash(iditem, count)
    if count ~= nil then
        bot:Trash(iditem, count)
    else
        bot:Trash(iditem)
    end
end

function collect(range, id)
    if id == nil then
        bot:Collect(range*32)
    else
        bot:Collect(range*32, id)
    end
end

function connect()
    bot:Connect()
end

function disconnect()
    bot:Disconnect()
end

function getTile(tilex,tiley)
    tilefg = 0
    tilebg = 0
    tileflags = 0
    tileready = false
    tilefg = bot:GetTile(tilex, tiley).Foreground
    tilebg = bot:GetTile(tilex, tiley).Background
    tileflags = bot:GetTile(tilex, tiley).Flags
    tileready = bot:GetTile(tilex, tiley).SeedData:IsReady()
    return {
        fg = tilefg,
        bg = tilebg,
        flags = tileflags,
        ready = tileready,
    }
end

function getTiles()
    local tiles = {}
    local bot = Plutonium:GetBot()
    for j = 0, bot.World.Height - 1 do
        for i = 0, bot.World.Width - 1 do
            table.insert(tiles, { x = i, y = j, fg = getTile(i,j).fg ,flags =  getTile(i,j).flags ,bg =  getTile(i,j).bg ,ready = getTile(i,j).ready})
        end
    end
    return tiles
end

function warp(Dunia, Kunci)
    if Kunci then
        bot:Warp(Dunia.."|"..Kunci)
    else
        bot:Warp(Dunia)
    end
end

function sendPacket(type, text)
    Plutonium:SendPacket(type, text)
end

function store_pack(namepack)
    Plutonium:SendPacket(2,"action|buy\nitem|"..namepack)
end

function UpSlot()
    Plutonium:SendPacket(2,"action|buy\nitem|upgrade_backpack")
end

-- EXAMPLE
-- getBot().world		 	| cek world bot 		| return string value
-- getBot().name		 	| cek name bot 		    | return string value
-- getBot().y		 		| cek cordinate y bot 	| return number value
-- getBot().x		 		| cek cordinate x bot 	| return number value
-- getBot().level		 	| cek level bot 		| return number value
-- getBot().gems			| cek gems bot 		    | return number value
-- getBot().status	 		| cek status bot		| return string "online" or "offline" or "banned" or "login fail"
-- findItem(id)		 		| cek count item in bot | return number value
-- say("hellow world")		| typing in world
-- findPath(x,y)		 	| teleport in cordinate
-- move(x,y)		 		| move in from coordinate to cordinate target
-- punch(x,y)		 		| bot punch 
-- place(id,x,y)		 	| bot place
-- sleep(millisecond)	 	| delay
-- collect(range)		 	| collect item
-- connect()		 		| conenct bot
-- disconnect()		 		| disconenct bot
-- getTile(x,y).fg	 		| cek block in coordinate 	    | return number value
-- getTile(x,y).bg	 		| cek background in coordinate  | return number value
-- getTile(x,y).flags	 	| cek flag in coordinate 	    | return number value
-- for _, tile in pairs(getTiles()) do 
--  say(tile.x)		 		| cek scan coordinates x 	    | return number value
--  say(tile.y)		 		| cek scan coordinates y	    | return number value
--  say(tile.fg)		 	| cek scan block			    | return number value
--  say(tile.bg)		 	| cek scan background		    | return number value
--  say(tile.flags)	 		| cek scan flag			        | return number value
--  say(tile.ready)	 		| cek scan tree ready or no	    | return number value
-- end
-- store_pack("world_lock") | buy pack
-- upbagpack()				| buy bagpack
-- warp(delay,world,iddoor) | warping at onther world use iddoor
-- warp(delay,world)		| warping at onther world 

-- EXAMPLE FUNC
-- function harvest(id)
--     for _,tile in pairs(getTiles()) do
--         if tile.fg == id and tile.ready then
--             findPath(tile.x,tile.y)
--             sleep(30)
--             punch(0,0)
--             sleep(180)
--         end
--    end
-- end
-- harvest(3)
