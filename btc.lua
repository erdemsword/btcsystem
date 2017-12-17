db_name = "bitcoin" -- Veritabanı adı
host = "localhost" -- Hosting adı "localhost"
user = "root" -- Kullanıcı adı
password = "" -- Şifre
  
database = dbConnect( "mysql", "dbname="..db_name..";host="..host, user, password ) -- Veritabanına bağlanma

--Veritabanına bağlanma kontrolü--
if database then 
    outputDebugString ('basarili') 
else 
    outputDebugString ("basarisiz") 
end
--

--Oyuncu sunucudan çıkınca otomatik veritabanına kaydetme--
function saveBitcoins () 
    local serial = getPlayerSerial(source)
	local bitcoin = getElementData(source, "bitcoin")
    local q =  dbQuery(database,"SELECT * FROM userbitcoins WHERE serial = ?", serial) 
    local poll, rows = dbPoll(q, -1) 
    if not (rows == 0) then 
      	dbExec ( database, "UPDATE userbitcoins SET userBitcoin = ? WHERE serial = ?", bitcoin, serial) 
    end
end
addEventHandler ( "onPlayerQuit", getRootElement(), saveBitcoins ) 

--Oyuncu sunucuya girdiğinde otomatik BTC tanıma--
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
addEventHandler ( "onPlayerJoin", getRootElement(), loadBitcoins ) 
--

--Servera BTC yükleme sistemi--
function addBitcoinToServer(player, command, miktar)

	local result = dbQuery ( database ,"SELECT * FROM serverbitcoins")
	local poll, rows = dbPoll(result, -1)
	local btc = poll[1]["totalBitcoin"]
	if rows == 1 then
		dbExec ( database, "UPDATE serverbitcoins SET totalBitcoin = btc+tostring(miktar)")
		outputChatBox("[BITCOIN]#ffffff Sunucuya #ffaacc"..tostring(miktar).."BTC #ffffffüretildi!", root, 255, 100, 100, true)
	else
		dbExec( database, "INSERT INTO serverbitcoins ( totalBitcoin) VALUES ( ?)", tostring(miktar) )
	end
end
addCommandHandler("addbtc", addBitcoinToServer)
--

--Örnek geliştirilebilir BTC gönderme sistemi -- 
function giveBTCToPlayer(player, command, playerName, miktar)
	if not playerName then outputChatBox("[HATA] #ffffffOyuncu ismi girmelisin!", player, 255, 100, 100, true) return end
	local playername = findPlayerByName(playerName)
	setElementData(playername,"bitcoin" getElementData()
end
addCommandHandler("ceza", cezaVer)
--

--Oyuncu Bulma fonksiyonu--
function findPlayerByName (name)
	local player = getPlayerFromName(name)
	if player then return player end
	for i, player in ipairs(getElementsByType("player")) do
		if string.find(string.gsub(getPlayerName(player):lower(),"#%x%x%x%x%x%x", ""), name:lower(), 1, true) then
			return player
		end
	end
return false
end
--
