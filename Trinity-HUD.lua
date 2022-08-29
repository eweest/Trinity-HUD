-- -- ABOUT SCRIPT
script_name("Trinity HUD")
script_version("1.1")
script_authors("eweest")
script_description("29.08.2022")
script_url("https://vk.com/gtatrinitymods")

local SCRIPT = thisScript()
local SCRIPT_NAME = string.gsub(SCRIPT.name, "%s", "-")

---- ASSETS [START]

-- SCREEN RESOLUTION
local sX, sY = getScreenResolution()
local pX, pY = sX/1920, sY/1080

local loadTexture = {}
local loadWeaponTexture = {}

-- LIB
local sampev = require("lib.samp.events")
local memory = require("memory")
local weapons = require("game.weapons")

-- FONTS
local FONT_SCRIPT = "PFDinDisplayPro-Medium"
local FONTS = {
	["hud-22"] = renderCreateFont(FONT_SCRIPT, 22, 0),
	["hud-18"] = renderCreateFont(FONT_SCRIPT, 18, 0),
	["hud-16"] = renderCreateFont(FONT_SCRIPT, 16, 0),
	["hud-14"] = renderCreateFont(FONT_SCRIPT, 14, 0),
	["hud-12"] = renderCreateFont(FONT_SCRIPT, 12, 0),
	["hud-10"] = renderCreateFont(FONT_SCRIPT, 10, 0),
}

-- CHAT
local CMD_SCRIPT = "/hud"
local CHAT_MSG = {
	["TAG"] = "Trinity Mods",
	["done"] = {color = "0xFFCC00", colorText = "FFFFFF", sound_id = 1083},
	["warning"] = {color = "0xFF9832", colorText = "9E9E9E", sound_id = 1085},
	["error"] = {color = "0xFF3232", colorText = "9E9E9E", sound_id = 1055},
	["trinity"] = {color = "0x75C225", colorText = "FFFFFF", sound_id = 0},
}
-- TRINITY SERVERS
local TRINITYGTA_IP = {
	["RPG"] = "185.169.134.83",
	["RP1"] = "185.169.134.84",
	["RP2"] = "185.169.134.85"
}

-- PATHS
local DIRECT = getWorkingDirectory()
local MAIN_PATH = DIRECT .. "\\config\\Trinity GTA Mods\\"
local FOLDER_PATH = SCRIPT.name .. "\\"
-- local MODULES_PATH = "modules\\"
local CONFIG_PATH = "config\\"
local TEXTURES_PATH = "textures\\"
local WEAPON_PATH = "weapon\\"
local SETTINGS_PATH = SCRIPT.name .."-settings.json"

-- MODULE
local TABLE_TDW = {
	["EAT"] = -1,
	["WATER"] = -1,
	["HYGIENE"] = -1,
	["INV"] = -1,
	["GREEN_ZONE"] = -1,
	["CHIP"] = -1,
	["TIME"] = -1,
	["DATE"] = -1,
	["OTHER"] = {}
}

-- TEXTURES
local TEXTURES = {  -- NAME, URL
	["hud-bg"] = {"hud-bg.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-bg.png"},
	["hud-bg-head"] = {"hud-bg-head.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-bg-head.png"},
	["hud-bg-time"] = {"hud-bg-time.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-bg-time.png"},
	["hud-bg-weapon"] = {"hud-bg-weapon.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-bg-weapon.png"},
	-- ICONS
	["hud-health"] = {"hud-health.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-health.png"},
	["hud-armor"] = {"hud-armor.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-armor.png"},
	["hud-oxygen"] = {"hud-oxygen.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-oxygen.png"},
	["hud-eat"] = {"hud-eat.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-eat.png"},
	["hud-water"] = {"hud-water.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-water.png"},
	["hud-hygiene"] = {"hud-hygiene.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-hygiene.png"},
	["hud-ammo"] = {"hud-ammo.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-ammo.png"},
	["hud-money"] = {"hud-money.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-money.png"},
	["hud-online"] = {"hud-online.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-online.png"},
	["hud-id"] = {"hud-id.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-id.png"},
	["hud-time"] = {"hud-time.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/hud-time.png"},
	["green-zone"] = {"green-zone.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/green-zone.png"},
	-- MATERIALS
	["round"] = {"round.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/round.png"},
}

local TEXTURES_WEAPON = { -- ID, URL
	["0"] = {"0.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/0.png"},
	["1"] = {"1.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/1.png"},
	["2"] = {"2.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/2.png"},
	["3"] = {"3.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/3.png"},
	["4"] = {"4.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/4.png"},
	["5"] = {"5.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/5.png"},
	["6"] = {"6.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/6.png"},
	["7"] = {"7.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/7.png"},
	["8"] = {"8.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/8.png"},
	["9"] = {"9.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/9.png"},
	["10"] = {"10.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/10.png"},
	["11"] = {"11.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/11.png"},
	["12"] = {"12.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/12.png"},
	["13"] = {"13.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/13.png"},
	["14"] = {"14.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/14.png"},
	["15"] = {"15.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/15.png"},
	["16"] = {"16.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/16.png"},
	["17"] = {"17.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/17.png"},
	["18"] = {"18.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/18.png"},
	["22"] = {"22.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/22.png"},
	["23"] = {"23.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/23.png"},
	["24"] = {"24.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/24.png"},
	["25"] = {"25.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/25.png"},
	["26"] = {"26.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/26.png"},
	["27"] = {"27.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/27.png"},
	["28"] = {"28.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/28.png"},
	["29"] = {"29.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/29.png"},
	["30"] = {"30.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/30.png"},
	["31"] = {"31.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/31.png"},
	["32"] = {"32.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/32.png"},
	["33"] = {"33.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/33.png"},
	["34"] = {"34.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/34.png"},
	["35"] = {"35.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/35.png"},
	["36"] = {"36.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/36.png"},
	["37"] = {"37.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/37.png"},
	["38"] = {"38.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/38.png"},
	["39"] = {"39.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/39.png"},
	["40"] = {"40.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/40.png"},
	["41"] = {"41.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/41.png"},
	["42"] = {"42.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/42.png"},
	["43"] = {"43.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/43.png"},
	["44"] = {"44.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/44.png"},
	["45"] = {"45.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/45.png"},
	["46"] = {"46.png", "https://github.com/eweest/Trinity-HUD/raw/main/assets/textures/weapon/46.png"}
}

-- GIT-HUB PATH
local UPDATE_JSON_PATH = "https://raw.githubusercontent.com/eweest/" .. SCRIPT_NAME .. "/main/assets/update.json"
local UPDATE_FILE_PATH = "https://raw.githubusercontent.com/eweest/" .. SCRIPT_NAME .. "/main/" .. SCRIPT_NAME .. ".lua"

-- CONFIG "settings.json"
local SETTINGS = {
	["RPG"] = {
		["VIEW"] = true,
		["VIEW_CHAT"] = false,
		["VIEW_TIME"] = true,
	},
	["RP1"] = {
		["VIEW"] = true,
		["VIEW_CHAT"] = false,
		["VIEW_TIME"] = true,
	},
	["RP2"] = {
		["VIEW"] = true,
		["VIEW_CHAT"] = false,
		["VIEW_TIME"] = true,
	},
	["AUTOUPDATE"] = false
}


-- CHECK FOLDERS DIRECTORY
for _, FOLDER in ipairs({CONFIG_PATH, TEXTURES_PATH, TEXTURES_PATH .. WEAPON_PATH}) do
	if not doesDirectoryExist(MAIN_PATH .. FOLDER_PATH .. FOLDER) then
		createDirectory(MAIN_PATH .. FOLDER_PATH .. FOLDER) -- SCRIPT MAIN FOLDER
		print(string.format("������� ����� {00FF00}%s{CCCCCC} ���� ������� �������.", FOLDER))
	else
		print(string.format("������� ����� {FFFFFF}%s{CCCCCC} ������������.", FOLDER))
	end
end
print(string.format("����� �������� ��������� �� ����: {FFFFFF}%s{CCCCCC}", MAIN_PATH .. FOLDER_PATH))

for _, NAME_URL in pairs(TEXTURES_WEAPON) do
	if not doesFileExist(MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. WEAPON_PATH .. NAME_URL[1]) then
		downloadUrlToFile(NAME_URL[2], MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. WEAPON_PATH .. NAME_URL[1])
		print(string.format("���� �� ����: {FFFFFF}%s{32FF32}%s{CCCCCC} ������� c�����.", MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. WEAPON_PATH, NAME_URL[1]))
	end
end

for _, NAME_URL in pairs(TEXTURES) do
	if not doesFileExist(MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. NAME_URL[1]) then
		downloadUrlToFile(NAME_URL[2], MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. NAME_URL[1])
		print(string.format("���� �� ����: {FFFFFF}%s{32FF32}%s{CCCCCC} ������� c�����.", MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH, NAME_URL[1]))
	end
end


-- SETTINGS PATH (JSON)
if not doesFileExist(MAIN_PATH .. FOLDER_PATH .. CONFIG_PATH .. SETTINGS_PATH) then 
	local settingFile = io.open(MAIN_PATH .. FOLDER_PATH .. CONFIG_PATH .. SETTINGS_PATH, "w") 
	settingFile:write(encodeJson(SETTINGS))  
	io.close(settingFile)

	print(string.format("���� �������� {00FF00}%s{CCCCCC} ������� ������.", SETTINGS_PATH))
end

if doesFileExist(MAIN_PATH .. FOLDER_PATH .. CONFIG_PATH .. SETTINGS_PATH) then
	local settingFile = io.open(MAIN_PATH .. FOLDER_PATH .. CONFIG_PATH .. SETTINGS_PATH, "r") 
	if settingFile then 
		DB = decodeJson(settingFile:read("*a")) 
		io.close(settingFile)
	end 
	print(string.format("���� �������� {FFFFFF}%s{CCCCCC} ������� ��������.", SETTINGS_PATH))
end
---- ASSETS [END]

-- <FUNCTION> MAIN [START]
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	-- CHECK UPDATE
	if DB["AUTOUPDATE"] then
		DB["AUTOUPDATE"] = true
		autoupdate(UPDATE_JSON_PATH, CHAT_MSG["TAG"], UPDATE_FILE_PATH)
	else
		print("�������������� ���������.")
	end
	-- TRINITY SERVERS
	local IP = sampGetCurrentServerAddress()

	-- CHECK ALL TRINITY SERVERS
	if IP:find(TRINITYGTA_IP["RPG"]) or IP:find(TRINITYGTA_IP["RP1"]) or IP:find(TRINITYGTA_IP["RP2"]) then

		-- LOAD TEXTURES
		for TEXTURE, PATH in pairs(TEXTURES) do
			loadTexture[TEXTURE] = renderLoadTextureFromFile(MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. PATH[1])
		end
		-- LOAD TEXTURES (WEAPON)
		for TEXTURE, PATH in pairs(TEXTURES_WEAPON) do
			loadWeaponTexture[TEXTURE] = renderLoadTextureFromFile(MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. WEAPON_PATH .. PATH[1])
		end

		-- CHECK TRINITY SERVERS
		if IP:find(TRINITYGTA_IP["RPG"]) then
			GET_SERVER = "RPG"
		elseif IP:find(TRINITYGTA_IP["RP1"]) then
			GET_SERVER = "RP1"
		elseif IP:find(TRINITYGTA_IP["RP2"]) then
			GET_SERVER = "RP2" 
		end
		--
		TRINITYGTA = true
		sendToChatMsg(string.format("������ {FFCC00}%s (v%s){FFFFFF} �������. �����: {FFCC00}%s{FFFFFF}. ������ {FFCC00}%s", SCRIPT.name, SCRIPT.version,unpack(SCRIPT.authors), CMD_SCRIPT), "done")
	else
		TRINITYGTA = false
		sendToChatMsg(string.format("������ {FFCC00}%s{9E9E9E} �� �������. �� ������� �� �� {FFFFFF}Trinity{75C225}GTA{FFFFFF}.", SCRIPT.name), "warning")
		unloadScript()
	end

	-- COMMANDS
	sampRegisterChatCommand("hud", function(cmd)
		if (cmd == "view" or cmd == "vw") then
			DB[GET_SERVER]["VIEW"] = not DB[GET_SERVER]["VIEW"]
			if DB[GET_SERVER]["VIEW"] then
				DB[GET_SERVER]["VIEW"] = true
				sendToChatMsg("�� �������� ����� HUD.", "done", true)
			else
				DB[GET_SERVER]["VIEW"] = false
				sendToChatMsg("�� ��������� ����� HUD.", "warning", true)
			end
		saveSetting()
		elseif cmd == ("chat") then
			DB[GET_SERVER]["VIEW_CHAT"] = not DB[GET_SERVER]["VIEW_CHAT"]
			if DB[GET_SERVER]["VIEW_CHAT"] then
				DB[GET_SERVER]["VIEW_CHAT"] = true
				sendToChatMsg("�� �������� ����� HUD ��� ������� ����.", "done", true)
			else
				DB[GET_SERVER]["VIEW_CHAT"] = false
				sendToChatMsg("�� ��������� ����� HUD ��� ������� ����.", "warning", true)
			end
		saveSetting()
		elseif cmd == ("time") then
			DB[GET_SERVER]["VIEW_TIME"] = not DB[GET_SERVER]["VIEW_TIME"]
			if DB[GET_SERVER]["VIEW_TIME"] then
				DB[GET_SERVER]["VIEW_TIME"] = true
				sendToChatMsg("�� �������� ����� ������� ��� ������� HUD.", "done", true)
			else
				DB[GET_SERVER]["VIEW_TIME"] = false
				sendToChatMsg("�� ��������� ����� ������� ��� ������� HUD.", "warning", true)
			end
		saveSetting()
		elseif (cmd == "update" or cmd == "up") then -- UPDATE
			DB["AUTOUPDATE"] = not DB["AUTOUPDATE"]
			if DB["AUTOUPDATE"] then
				DB["AUTOUPDATE"] = true
				sendToChatMsg(string.format("�� �������� �������������� ��� ������� %s.", SCRIPT.name), "done", true)
			else
				DB["AUTOUPDATE"] = false
				sendToChatMsg(string.format("�� ��������� �������������� ��� ������� %s.", SCRIPT.name), "warning", true)
			end
		reloadScript()
		saveSetting()
		-- REMOVE CACHE
		elseif cmd == "reset" then -- REMOVE SETTINGS
			os.remove(MAIN_PATH .. FOLDER_PATH .. CONFIG_PATH .. SETTINGS_PATH)
			reloadScript()
		elseif cmd == "resetall" then -- REMOVE CACHE
			sendToChatMsg(string.format("�� ��������� {FF3232}����� ����{FFFFFF} ������ ������� %s.", SCRIPT.name), "done", true)
			removeFilesCache("all")
			reloadScript()
		--
		elseif #cmd == 0 then
			createWindowHelp()
		else
			sendToChatMsg("����������� �������.", "error", true)
		end
	end)

-- BODY [START]
	while true do wait(0)
		if TRINITYGTA == true then
			hidePlayerNeeds() -- HIDE STANDART NEEDS
			displayHud(false)
			findTextDarwTime()
			local spawnPlayer = sampIsLocalPlayerSpawned()
			if spawnPlayer then
				-- CHECK NEEDS
				if not sampIsScoreboardOpen() then
						createTime()
					if not sampTextdrawIsExists(TABLE_TDW["INV"]) and not sampTextdrawIsExists(TABLE_TDW["CHIP"]) then
						if (sampIsChatVisible() or DB[GET_SERVER]["VIEW_CHAT"]) then
							createHUD() -- RENDER HUD 
						end
					end
				end
			end
		end
	end
-- BODY [END]
	wait(-1)
end
-- MAIN [END]
 
-- <FUNCTION> HUD [START]
function createHUD()
	local hudX, hudY = 560, 0
	
	-- COLORS
	local COLOR = {
		["NEED"] ={
			["EAT"] = '0xFFFFFFFF', -- WHITE
			["WATER"] = '0xFFFFFFFF', -- WHITE
			["HYGIENE"] = '0xFFFFFFFF', -- WHITE
			},
		["RED"] = '0xFFFF0000', -- RED
		["GREEN"] = '0xFF63C10F', -- EAT 
		["YELLOW"] = '0xFFE3A51E', -- WATER
		["BLUE"] = '0xFF3B79B3', -- HYGIENE
	}
	-- COLORS NEEDS
	if getPlayerFood(TABLE_TDW["EAT"]) <= 22 then COLOR["GREEN"] = COLOR["RED"]; COLOR["NEED"]["EAT"] = COLOR["RED"] end
	if getPlayerFood(TABLE_TDW["WATER"]) <= 22 then COLOR["YELLOW"] = COLOR["RED"]; COLOR["NEED"]["WATER"] = COLOR["RED"] end
	if getPlayerFood(TABLE_TDW["HYGIENE"]) <= 22 then COLOR["BLUE"] = COLOR["RED"]; COLOR["NEED"]["HYGIENE"] = COLOR["RED"] end

	-- SERVER PLAYER INFO
	local playerID = select(2,sampGetPlayerIdByCharHandle(PLAYER_PED))
	-- PLAYER INFO
	-- WEAPON INFO [START]
	local function getAmmoInClip()
		local pointer = getCharPointer(PLAYER_PED)
		local weapon = getCurrentCharWeapon(PLAYER_PED)
		local slot = getWeapontypeSlot(weapon)
		local cweapon = pointer + 0x5A0
		local current_cweapon = cweapon + slot * 0x1C
		return memory.getuint32(current_cweapon + 0x8)
	end

	local plWeaponID = getCurrentCharWeapon(PLAYER_PED)
	local plWeaponAmmo = getAmmoInCharWeapon(PLAYER_PED, getCurrentCharWeapon(PLAYER_PED)) - getAmmoInClip()
	-- WEAPON INFO [END]

	-- TIME INFO [START]
	local TIME = os.time(os.date("!*t"))
	local TIME_MSK = TIME + 3 * 60 * 60

	local TimeFormate = os.date("%H:%M:%S", TIME_MSK)
	local DateFormate = os.date("%d.%m.%y", TIME_MSK)
	local DateDay = os.date("%A", TIME_MSK)
	-- TIME INFO [END]
	if DB[GET_SERVER]["VIEW"] then
		-- HUD BODY [START]
		renderDrawTexture(loadTexture["hud-bg" or dev_hud], sX - hudX, hudY, 512, 256, 0, 0xFFFFFFFF) -- BACKGROUND
		-- HP
		renderDrawTexture(loadTexture["hud-health"], sX - hudX + 222, hudY + 64, 32, 32, 0, 0xFFFFFFFF) -- ICON
		dxDrawText(getCharHealth(PLAYER_PED), sX - hudX + 280, hudY + 68, FONTS["hud-16"], "center", 0xFFFFFFFF) -- TEXT
		dxDrawRoundBox(sX-hudX + 316, hudY + 76 - 4, 176, 16, 0xFF0C0C17, "horizontal") -- BG
		if getCharHealth(PLAYER_PED) ~= 0 then
			dxDrawRoundBox(sX-hudX + 316, hudY + 76, getCharHealth(PLAYER_PED) * 1.76, 8, 0xFFFF3232, "horizontal") -- BAR
		end
		-- ARMOR
		renderDrawTexture(loadTexture["hud-armor"], sX-hudX + 222, hudY + 102, 32, 32, 0, 0xFFFFFFFF) -- ICON
		dxDrawText(getCharArmour(PLAYER_PED), sX - hudX + 280, hudY + 106, FONTS["hud-16"], "center", 0xFFFFFFFF) -- TEXT
		dxDrawRoundBox(sX-hudX + 316, hudY + 114 - 4, 176, 16, 0xFF0C0C17, "horizontal") -- BG
		if getCharArmour(PLAYER_PED) ~= 0 then
			dxDrawRoundBox(sX-hudX + 316, hudY+114, getCharArmour(PLAYER_PED) * 1.76, 8, 0xFFBDCCD4, "horizontal") -- BAR
		end
		-- HUD BODY [END]
		-- HUD HEADER [START]
		-- GREEN ZONE
		if sampTextdrawIsExists(TABLE_TDW["GREEN_ZONE"]) then 
			gzX, gzY = 168, 0
			renderDrawTexture(loadTexture["green-zone"], sX - hudX + 256, hudY + 18, 256, 32, 0, 0xFFFFFFFF) -- GREEN ZONE
		else gzX, gzY = 0, 0 end
		-- ONLINE SERVER
		renderDrawTexture(loadTexture["hud-bg-head"], sX-hudX  - gzX + 448, hudY + 18, 64, 32, 0, 0xFFFFFFFF) -- BG
		renderDrawTexture(loadTexture["hud-online"], sX-hudX - gzX + 448 + 8, hudY + 26, 16, 16, 0, 0xFFFFFFFF) -- ICON
		dxDrawText(sampGetPlayerCount(false) - 24, sX-hudX - gzX + 448 + 42, hudY + 22, FONTS["hud-14"], "center", 0xFFFFFFFF) -- TEXT
		-- ID
		renderDrawTexture(loadTexture["hud-bg-head"], sX-hudX - gzX + 380, hudY + 18, 64, 32, 0, 0xFFFFFFFF) -- BG
		renderDrawTexture(loadTexture["hud-id"], sX-hudX - gzX + 380 + 8, hudY + 26, 16, 16, 0, 0xFFFFFFFF) -- ICON
		dxDrawText(playerID, sX-hudX - gzX + 380 + 42, hudY + 22, FONTS["hud-14"], "center", 0xFFFFFFFF) -- TEXT
		-- TIME
		renderDrawTexture(loadTexture["hud-bg-time"], sX-hudX - gzX + 248, hudY + 18, 128, 32, 0, 0xFFFFFFFF) -- BG
		-- renderDrawTexture(loadTexture["hud-time"], sX - hudX - gzX + 248 + 48, hudY + 26, 16, 16, 0, 0xFFFFFFFF) -- ICON
		dxDrawText(TimeFormate, sX-hudX - gzX + 248 + 82, hudY + 18, FONTS["hud-14"], "center", 0xFFFFFFFF) -- TEXT
		dxDrawText(DateFormate, sX-hudX - gzX + 248 + 82, hudY + 35, FONTS["hud-10"], "center", 0xAAFFFFFF) -- TEXT
		-- HUD HEADER [END]
		-- HUD BOTTOM [START]
		-- OXYGEN
		renderDrawTexture(loadTexture["hud-oxygen"], sX-hudX + 222, hudY + 156, 32, 32, 0, 0xFFFFFFFF) -- ICON
		dxDrawRoundBox(sX-hudX + 262, hudY + 164, 8, 18, 0xFF0C0C17, "vertical") -- BG
		if math.floor(memory.getfloat(0xB7CDE0) / 39.9 / 5.5) ~= 0 then
			dxDrawRoundBox(sX-hudX + 262 + 2, hudY + 164 + 18 - math.floor(memory.getfloat(0xB7CDE0) / 39.9 / 5.5), 4, math.floor(memory.getfloat(0xB7CDE0) / 39.9 / 5.5), 0xFF3FA9F5, "vertical") -- BAR
		end
		-- NEED EAT
		renderDrawTexture(loadTexture["hud-eat"], sX-hudX + 298, hudY + 156, 32, 32, 0, COLOR["NEED"]["EAT"]) -- ICON
		dxDrawRoundBox(sX-hudX + 338, hudY + 164, 8, 18, 0xFF0C0C17, "vertical") -- BG
		if getPlayerFood(TABLE_TDW["EAT"]) ~= 0 then
			dxDrawRoundBox(sX-hudX + 338 + 2, hudY + 164 + 18 - math.floor(getPlayerFood(TABLE_TDW["EAT"]) / 5.88), 4, math.floor(getPlayerFood(TABLE_TDW["EAT"]) / 5.88), COLOR["GREEN"], "vertical") -- BAR
		end
		-- NEED WATER
		renderDrawTexture(loadTexture["hud-water"], sX-hudX + 374, hudY + 156, 32, 32, 0, COLOR["NEED"]["WATER"]) -- ICON
		dxDrawRoundBox(sX-hudX + 414, hudY + 164, 8, 18, 0xFF0C0C17, "vertical") -- BG
		if getPlayerFood(TABLE_TDW["WATER"]) ~= 0 then
			dxDrawRoundBox(sX-hudX + 414 + 2, hudY + 164 + 18 - math.floor(getPlayerFood(TABLE_TDW["WATER"]) / 5.88), 4, math.floor(getPlayerFood(TABLE_TDW["WATER"]) / 5.88), COLOR["YELLOW"], "vertical") -- BAR
		end
		-- NEED HYGIENE
		renderDrawTexture(loadTexture["hud-hygiene"], sX-hudX + 450, hudY + 156, 32, 32, 0, COLOR["NEED"]["HYGIENE"]) -- ICON
		dxDrawRoundBox(sX-hudX + 490, hudY + 164, 8, 18, 0xFF0C0C17, "vertical") -- BG
		if getPlayerFood(TABLE_TDW["HYGIENE"]) ~= 0 then
			dxDrawRoundBox(sX-hudX + 490 + 2, hudY + 164 + 18 - math.floor(getPlayerFood(TABLE_TDW["HYGIENE"]) / 5.88), 4, math.floor(getPlayerFood(TABLE_TDW["HYGIENE"]) / 5.88), COLOR["BLUE"], "vertical") -- BAR
		end
		-- HUD BOTTOM [END]
		-- MONEY
		renderDrawTexture(loadTexture["hud-money"], sX-hudX + 486, hudY + 206, 32, 32, 0, 0xAAFFFFFF) -- ICON
		if getPlayerMoney() == 0 then
			dxDrawText("�� ����� ��� �����", sX-hudX + 486, hudY + 209, FONTS["hud-16"], "right", 0x40FFFFFF) -- TEXT (MONEY)
		else
			dxDrawText(convertMoney(getPlayerMoney()), sX-hudX + 486, hudY + 205, FONTS["hud-22"], "right", 0xFFFFFFFF) -- TEXT (MONEY)
		end
		-- WEAPON [START]
		renderDrawTexture(loadTexture["hud-bg-weapon"], sX - hudX + 80, hudY, 128, 256, 0, 0xFFFFFFFF) -- BG WEAPON BLOCK
		for _, weaponID in ipairs({0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 46}) do
			if getCurrentCharWeapon(PLAYER_PED) == weaponID then
				renderDrawTexture(loadWeaponTexture["" .. getCurrentCharWeapon(PLAYER_PED) .. ""], sX - hudX + 98, hudY + 56, 128, 128, 0, 0xFFFFFFFF) -- ICON WEAPON
			end
		end
		
		for _, weaponID in ipairs({16, 17, 18, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45}) do
			if getCurrentCharWeapon(PLAYER_PED) == weaponID then
				renderDrawTexture(loadWeaponTexture["" .. getCurrentCharWeapon(PLAYER_PED) .. ""], sX - hudX + 98, hudY + 36, 128, 128, 0, 0xFFFFFFFF) -- ICON WEAPON
				renderDrawTexture(loadTexture["hud-ammo"], sX-hudX + 134, hudY + 166, 16, 16, 0, 0xAAFFFFFF) -- ICON AMMO
				dxDrawText(getAmmoInClip(), sX-hudX + 164, hudY + 136, FONTS["hud-18"], "center", 0xFFFFFFFF) -- TEXT (CLIP)
				if plWeaponAmmo > 10000 then plWeaponAmmo = "10�+" end
				dxDrawText(plWeaponAmmo, sX-hudX + 154, hudY + 162, FONTS["hud-16"], "left", 0xAAFFFFFF) -- TEXT (AMMO)
			end
		end
		-- WEAPON [END]
	end
end
-- HUD [END]


-- <FUNCTION> CREATE TIME [START]
function createTime()
	local hudX, hudY = 560, 0
	local gzX, gzY = -100, 0

		-- TIME INFO [START]
	local TIME = os.time(os.date("!*t"))
	local TIME_MSK = TIME + 3 * 60 * 60

	local TimeFormate = os.date("%H:%M:%S", TIME_MSK)
	local DateFormate = os.date("%d.%m.%y", TIME_MSK)
	local DateDay = os.date("%A", TIME_MSK)
	-- TIME INFO [END]

	if DB[GET_SERVER]["VIEW_TIME"] and not DB[GET_SERVER]["VIEW"] or sampTextdrawIsExists(TABLE_TDW["INV"]) or sampTextdrawIsExists(TABLE_TDW["CHIP"]) then
		renderDrawTexture(loadTexture["hud-bg-time"], sX-hudX - gzX + 248, hudY + 18, 128, 32, 0, 0xFFFFFFFF) -- BG
		-- renderDrawTexture(loadTexture["hud-time"], sX - hudX - gzX + 248 + 48, hudY + 26, 16, 16, 0, 0xFFFFFFFF) -- ICON
		dxDrawText(TimeFormate, sX-hudX - gzX + 248 + 82, hudY + 18, FONTS["hud-14"], "center", 0xFFFFFFFF) -- TEXT
		dxDrawText(DateFormate, sX-hudX - gzX + 248 + 82, hudY + 35, FONTS["hud-10"], "center", 0xAAFFFFFF) -- TEXT
	end
end
-- <FUNCTION> CREATE TIME [END]

-- <FUNCTION> PLAYER NEEDS [START]
function hidePlayerNeeds()
	if not sampTextdrawIsExists(TABLE_TDW["INV"]) then
		for key, val in pairs(TABLE_TDW["OTHER"]) do
			if sampTextdrawIsExists(val) then
				sampTextdrawDelete(val)
			end
		end
		
		if TABLE_TDW["EAT"] ~= -1 then
			if sampTextdrawIsExists(TABLE_TDW["EAT"]) then
				local posX, posY = sampTextdrawGetPos(TABLE_TDW["EAT"])
					if posX ~= -20 and posY ~= -20 then
						sampTextdrawSetPos(TABLE_TDW["EAT"], -20, -20)
					end
			end
		end
		if TABLE_TDW["WATER"] ~= -1 then
			if sampTextdrawIsExists(TABLE_TDW["WATER"]) then
				local posX, posY = sampTextdrawGetPos(TABLE_TDW["WATER"])
				if posX ~= -20 and posY ~= -20 then
					sampTextdrawSetPos(TABLE_TDW["WATER"], -20, -20)
				end
			end
		end
		if TABLE_TDW["HYGIENE"] ~= -1 then
			if sampTextdrawIsExists(TABLE_TDW["HYGIENE"]) then
				local posX, posY = sampTextdrawGetPos(TABLE_TDW["HYGIENE"])
				if posX ~= -20 and posY ~= -20 then
					sampTextdrawSetPos(TABLE_TDW["HYGIENE"], -20, -20)
				end
			end
		end

		if TABLE_TDW["GREEN_ZONE"] ~= -1 then
			if sampTextdrawIsExists(TABLE_TDW["GREEN_ZONE"]) then
				local posX, posY = sampTextdrawGetPos(TABLE_TDW["GREEN_ZONE"])
				if posX ~= -20 and posY ~= -20 then
					sampTextdrawSetPos(TABLE_TDW["GREEN_ZONE"], -20, -20)
				end
			end
		end
		if TABLE_TDW["TIME"] ~= -1 then
			if sampTextdrawIsExists(TABLE_TDW["TIME"]) then
				sampTextdrawDelete(TABLE_TDW["TIME"])
				sampTextdrawDelete(TABLE_TDW["DATE"])
			end
		end
	end
end
-- PLAYER NEEDS [END]

-- <FUNCTION> Money Formate
function convertMoney(number)
	local text = number
	while true do
		text, k = string.gsub(text, "^(-?%d+)(%d%d%d)", '%1 %2')
		if (k == 0) then
			break
		end
	end
	return text
end

-- <FUNCTION> Show Textdraw
function sampev.onShowTextDraw(id, data)
	if data.text:find("�A� �H�EH�AP�") then
		TABLE_TDW["INV"] = id
	end	
	if data.text:find("���K�") then
		TABLE_TDW["CHIP"] = id
	end
	-- FIND EAT BAR
	if data.letterColor == -14500865 or data.letterColor == -14518409 then
		TABLE_TDW["WATER"] = id
	end
	-- FIND WATER BAR 
	if data.letterColor == -15744669 or data.letterColor == -13399996 then
		TABLE_TDW["EAT"] = id
	end
	-- FIND HYGIENE BAR
	if data.letterColor == -3372988 then
		TABLE_TDW["HYGIENE"] = id
	end
	-- FIND BLACK BACKGROUND BAR
	if data.letterColor == -16777216 then
		if not search(id, TABLE_TDW["OTHER"]) then
			table.insert(TABLE_TDW["OTHER"], id)
		end
	end
	-- GREEN ZONE
	if data.text:find("green zone") then
		TABLE_TDW["GREEN_ZONE"] = id
		-- return true
	end
end

-- <FUNCTION> Find Textdraw Time
function findTextDarwTime()
	for i = 1, 3000 do
		letSizeX, letSizeY, _ = sampTextdrawGetLetterSizeAndColor(i)
		outline,  ocolor = sampTextdrawGetOutlineColor(i)
		style = sampTextdrawGetStyle(i)
		text = sampTextdrawGetString(i)
		prop = sampTextdrawGetProportional(i)
		letSizeY = math.floor(letSizeY)
        if letSizeX == 0.5 and letSizeY == 2 and outline == 1 and style == 2 and text:match("%d+:%d%d") and prop == 1 then
            TABLE_TDW["TIME"] = i
            TABLE_TDW["DATE"] = i + 1
            return
        end
    end
end

-- <FUNCTION> Player Needs
function getPlayerFood(id)
	if TRINITYGTA then
		if id ~= -1 then
			if sampTextdrawIsExists(id) then
				local box, color, sizeX, sizeY = sampTextdrawGetBoxEnabledColorAndSize(id)
				return sizeX
			end
		end
	end
	return 0
end

function getPlayerWater(id)
	if TRINITYGTA then
		if id ~= -1 then
			if sampTextdrawIsExists(id) then
				local box, color, sizeX, sizeY = sampTextdrawGetBoxEnabledColorAndSize(id)
				return sizeX
			end
		end
	end
	return 0
end

function getPlayerHygiene(id)
	if TRINITYGTA then
		if id ~= -1 then
			if sampTextdrawIsExists(id) then
				local box, color, sizeX, sizeY = sampTextdrawGetBoxEnabledColorAndSize(id)
				return sizeX
			end
		end
	end
	return 0
end

function search(str, tab)
	if str ~= nil then
		for key, val in pairs(tab) do
			if str == val then
				return true
			end
		end
	end
	return false
end

-- HELP WINDOW [START]
local TITLE = "������ ��: {FFFFFF}"
local TITLE_COLOR = "{AFE7FF}"
local TEXT = [[
{ffcc00}�������� �������:{ffffff}

{AFE7FF}/hud{ffffff} - ���� ������
{AFE7FF}/hud view (vw){ffffff} - ��������/������
{AFE7FF}/hud chat{ffffff} - ��������/������ ��� ������� ����
{AFE7FF}/hud time{ffffff} - ����� ������� ��� ������� HUD
{AFE7FF}/hud reset{ffffff} - ����� ���� ��������
{AFE7FF}/hud resetall{ffffff} - �������� ���� ������ ����
{AFE7FF}/hud (up)date{ffffff} - �������������� (��������/���������)

{ffcc00}�������� ������:{ffffff}

{AFE7FF}[1]{ffffff} ���� ��� ����������� ���������� "0" � {FF3232}����� �������{ffffff}, �������� � �������� ���������.
{AFE7FF}[2]{ffffff} ��� ���������� ������ ������������ � HUD, �������� ��������� �����������.
{F5DEB3}/mm 3{FFFFFF} > {F5DEB3}������ ������, ����� � �������{FFFFFF} > {F5DEB3}���������� {32FF32}[��]{FFFFFF}

{ffcc00}� �������:{ffffff}

]]

if DB["AUTOUPDATE"] == true then autoupdate_state = "{32FF32}��������" else autoupdate_state = "{FF3232}���������" end

local ABOUT = {
	{"{AFE7FF}����� �������", unpack(SCRIPT.authors)},
	{"{AFE7FF}�������� ������� (������)", SCRIPT.name .. "{AFE7FF} ( " .. SCRIPT.version .. " )"},
	{"{AFE7FF}���� ����������", SCRIPT.url},
	{"{AFE7FF}���� ���������� ����������", SCRIPT.description},
	{"{AFE7FF}��������������", autoupdate_state},
}

local function info(num)
	local element = table.concat(ABOUT[num], ":{ffffff} ")
	return element
end
--
function createWindowHelp()
	sampShowDialog(10001, TITLE_COLOR .. TITLE .. thisScript().name, string.format("%s%s\n%s\n%s\n%s\n%s", TEXT, info(1), info(2), info(3), info(4), info(5)), "X")
end
-- HELP WINDOW [END]

-- ASSETS TOOLS
-- <FUNCTION> Send Message to Chat
function sendToChatMsg(text, typeMsg, sound)
	if sound then sound_id = CHAT_MSG[typeMsg].sound_id else sound_id = 0 end

	sampAddChatMessage(string.format("[%s]: {%s}%s", CHAT_MSG["TAG"], CHAT_MSG[typeMsg].colorText, text), CHAT_MSG[typeMsg].color)
	addOneOffSound(0.0, 0.0, 0.0, sound_id)
end

-- <FUNCTION> Render Text
function dxDrawText(text, x, y, font, align, color)
	if not align or align == "left" then renderFontDrawText(font, text, x, y, color) end
	if align == "right" then renderFontDrawText(font, text, x - renderGetFontDrawTextLength(font, text), y, color) end
	if align == "center" then renderFontDrawText(font, text, x - renderGetFontDrawTextLength(font, text) / 2, y, color) end
end

-- <FUNCTION> Render Box Rounded
function dxDrawRoundBox(x, y, x1, y1, color, type)
	renderDrawBox(x, y, x1, y1, color) -- BG BAR
	if not type or type == "horizontal" then
		renderDrawTexture(loadTexture["round"], x - (y1/2), y, y1, y1, 0, color)
		renderDrawTexture(loadTexture["round"], x + x1 - (y1/2), y, y1, y1, 180, color)
	end
	if type == "vertical" then
		renderDrawTexture(loadTexture["round"], x, y - (x1/2), x1, x1, 90, color)
		renderDrawTexture(loadTexture["round"], x, y + y1 - (x1/2), x1, x1, 270, color)
	end
end

-- <FUNCTION> SAVE SETTINGS
function saveSetting()
	local settingFile = io.open(MAIN_PATH .. FOLDER_PATH .. CONFIG_PATH .. SETTINGS_PATH, "w")
	settingFile:write(encodeJson(DB))
	settingFile:flush()
	print("���� {FFFFFF}'" .. SETTINGS_PATH .. "'{CCCCCC} ������� ��������!")
	settingFile:close()
end

-- <FUNCTION> RELOAD SCRIPT
function reloadScript()
	lua_thread.create(function()
		sendToChatMsg(string.format("����� 5 ������� ���������� ���������� ������� %s.", SCRIPT.name), "warning")
		wait(5000) SCRIPT:reload()
	end)
end

-- <FUNCTION> UNLOAD SCRIPT
function unloadScript()
	lua_thread.create(function()
		SCRIPT:unload()
	end)
end

-- <FUNCTION> DELETE FILES CACHE
function removeFilesCache(type)
	if not type then print("�� ������ ��� ������ ������") end

	if type == "all" then
		for _, NAME in pairs(TEXTURES) do
			os.remove(MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. NAME[1]) -- DEL FILES
			if not doesFileExist(MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. NAME[1]) then
				print(string.format("���� �� ����: {FFFFFF}%s{FF3232}%s{CCCCCC} ������� ������.", MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH, NAME[1]))
			end
		end
		for _, NAME in pairs(TEXTURES_WEAPON) do
			os.remove(MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. WEAPON_PATH .. NAME[1]) -- DEL FILES
			if not doesFileExist(MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. WEAPON_PATH .. NAME[1]) then
				print(string.format("���� �� ����: {FFFFFF}%s{FF3232}%s{CCCCCC} ������� ������.", MAIN_PATH .. FOLDER_PATH .. TEXTURES_PATH .. WEAPON_PATH, NAME[1]))
			end
		end

		os.remove(MAIN_PATH .. FOLDER_PATH .. CONFIG_PATH .. SETTINGS_PATH) -- DEL SETTING FILE
		print(string.format("���� �� ����: {FFFFFF}%s{FF3232}%s{CCCCCC} ������� ������.", MAIN_PATH .. FOLDER_PATH .. CONFIG_PATH, SETTINGS_PATH))
	end
end

-- <FUNCTION> AUTO-UPDATE (cred: qrlk / red: eweest)
function autoupdate(json_url, prefix, url)
	local dlstatus = require('moonloader').download_status
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json,
	function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(json) then
				local f = io.open(json, 'r')
				if f then
					local info = decodeJson(f:read('*a'))
					updatelink = info.updateurl
					updateversion = info.latest
					f:close()
					os.remove(json)
					if updateversion > thisScript().version then
						lua_thread.create(function(prefix)
						local dlstatus = require('moonloader').download_status
						sendToChatMsg(string.format("������� ���������� ��� ������� {FFCC00}%s", SCRIPT.name), "done", true)
						sendToChatMsg(string.format("���� ���������� c ������ {FFCC00}%s{FFFFFF} �� ������ {FFCC00}%s", SCRIPT.name, updateversion), "done")
						wait(250)
							downloadUrlToFile(updatelink, thisScript().path, 
							function(id3, status1, p13, p23)
								if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
									print(string.format("��������� %d �� %d.", p13, p23))
								elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
									-- REMOVE FILES
									removeFilesCache()
									--
									print("{32FF32}�������� ���������� ���������.")
									sendToChatMsg(string.format("���������� {FFCC00}%s{FFFFFF} ���������!", SCRIPT.name), "done", true)
									goupdatestatus = true 
									lua_thread.create(reloadScript()) -- RELOAD SCRIPT
								end
								if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
									if goupdatestatus == nil then
										sendToChatMsg(string.format("������ ����������. ������ ������ ������...", SCRIPT.name), "error", true)

										update = false
									end
								end
							end)
						end, prefix)
					else
						update = false
						print("{32FF32}v" .. thisScript().version .. ": ���������� ������. {CCCCCC}���������� �� ���������.")
					end
				end
			else
				print("{FF3232}v" .. thisScript().version .. ": �� ���� ��������� ����������. {CCCCCC}�������� �� ���� � ���� ������.")
				update = false
			end
		end
	end)
	while update ~= false do wait(100) end
end
----