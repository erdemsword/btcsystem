db_name = "bitcoin" 
host = "localhost" 
user = "root" 
password = "" 
  
database = dbConnect( "mysql", "dbname="..db_name..";host="..host, user, password ) 
if database then 
    outputDebugString ('basarili') 
else 
    outputDebugString ("basarisiz") 
end

function saveBitcoins () 
    local serial = getPlayerSerial(source)
	local bitcoin = getElementData(source, "bitcoin")
    local q =  dbQuery(database,"SELECT * FROM userbitcoins WHERE serial = ?", serial) 
    local poll, rows = dbPoll(q, -1) 
    if not (rows == 0) then 
      	dbExec ( database, "UPDATE userbitcoins SET userBitcoin = ? WHERE serial = ?", bitcoin, serial) 
    end
end

function loadBitcoins ()
    local serial = getPlayerSerial(source)
	local bitcoin = getElementData(source, "bitcoin")
    local q =  dbQuery(database,"SELECT * FROM userbitcoins WHERE serial = ?", serial) 
    local poll, rows = dbPoll(q, -1)
	if(rows == 0) then
        dbExec( database, "INSERT INTO userbitcoins ( userSerial , userBitcoin) VALUES ( ?, ?)", serial, bitcoin )
    end
    local result = dbQuery ( database ,"SELECT * FROM userbitcoins WHERE userSerial = ?", serial) 
    local poll, rows = dbPoll(result, -1) 
    if rows == 1 then 
        	setElementData ( source, "bitcoin", poll[1]["userBitcoin"] )
    end
end
addEventHandler ( "onPlayerLogin", getRootElement(), loadBitcoins ) 
addEventHandler ( "onPlayerQuit", getRootElement(), saveBitcoins ) 

 

function addBitcoinToServer(player, command, miktar)
	if not miktar then outputChatBox("[HATA]#ffffff hata!",player,255,100,100,true) return end
	local result = dbQuery ( database ,"SELECT * FROM serverbitcoins")
	local poll, rows = dbPoll(result, -1)
	if (rows>0) then
		local btc = poll[1]['totalBitcoin']
		dbExec ( database, "UPDATE serverbitcoins SET totalBitcoin = '"..btc.."'+'"..tostring(miktar).."'")
		outputChatBox("[BITCOIN]#ffffff Sunucuya #ffaacc"..tostring(miktar).."BTC #ffffffyüklendi!", root, 255, 100, 100, true)
	else
		dbExec( database, "INSERT INTO serverbitcoins (totalBitcoin) VALUES ('"..tostring(miktar).."')" )
	end
end
addCommandHandler("addbtc", addBitcoinToServer)
