extends Node

var moritz: Array[String] = 	[
					"S031X1411",
					"W077b42b06s43054b07s13s34103X1411",
					"R106b59s20s060510b00093b42s61s13035X1411",
					"W018b60s13s43005b34s44s38104b19s43s37081X1411",
					"R014s58s60s38067b42b19s33073b33s51s39031s32s51s30T044b06s61s23020s29s61s47094s39s47s44001X1411",
					"W086b03s55s32078b42s06s13053b43s20s44011X1414",
					"S027b03s60s550012b19s32s06048b29b51b47035b52b04s48T0910b43s44s16013s20s58s33b61s26s50107b34s38s23064b05b48s22B058s13s38s32b49b09s440827b21b38s23070s23s10s59b000514Y1414",
					"S105s44s16s55037b47b59b61011b03s34s51051s48s04s12O044b29s60s50001s50s04s44097b04s42s09084b64s48s05B021b00070s01065s32s16s37071X1414",
					"R043b47s42s37105b21s26s44077b61s39s51034b48b62s64C063s63s42s370919b43s59s33021b51s20s09055b54b49s63B0143X1415",
					"S089b03s50s60039s51s50s55b43s21s20041X1422",
					"R086b21s51s23066b19b13s44003b00102s14s59s64T028b29s37s16033b43s23s39050b47s42s14013s48s50s53G094b61s51s20040b00071X1422",
					"W0012s37s55s61b42b34s13013b43s26s35028b19b35s26045b12s36s61T057b09s60s55036b06s61s200916b47s07s26065b07b36s54B102s38s26s590813b29b32s26074b51b39s550911Y1422",
					"W109b34b39s230410b32b61s23009s51s50s59b40s37s16094b54b35s41T0318X1422",
					"W0311b19b37s43078b42b47s38099s60s51s06s23s51s06b32s39s38082b31s48s06O102s03s51s20025b61s39s16063b00052X159",
					"W091s37s09s29079b42s61s20082b29s34s21035b53b34s59O005b35s09s20052b19s36s16043X1517",
					"W0211b29b34s37073b19s09s59053s16s20s09046b64b35s09C107b00096b01061b42s60s50011b40b36s53G083b00031X1517",
					"W0311b06b60s32104b47s23s260610b44s61s55011b53b45s48O076b19s48s34053b42s09s13021s34s38s510410X179"
				]

var nexus: Array[String] = 		[
									"R016b03b06s21053s50s32s16065b29b39s26042s40s07s53T035b43s09s20086b26s51s16022X1520",
									"W0014b16s58s13107b09s26s55074b42b37b39054b54b10s40O028X1521",
									"R086s43s20s060911b38s44s32016b42b43s16002b22b20s50T0610s61s33s29s59s50s440411b13s44s61074b06b23s32102b07s14s53G053b34s24s59030s59s19s55022s35s60s33101X1521",
									"R093b03s60s26077b38b23s21047b09b37s60025b04s10s54O0017b47b21s61019b34s39s60103s26s50s20b24b10s55060b25b48s52G050s58s59s06080s13s58s35032s39s58s49021Y1721"
								]

var esvee: Array[String] = 		[
									"S0210b60b47s51097b19s50s48056s16s58s20s26s09s06s42s37s50b26s48s20041X1417",
									"S106b19s51s060911b61b59s16032b09s43s33021b10s62s12O049b47s38s260814s50s43s06b44b62b33056b42b43s58006b54b11s48B0134X1418",
									"W065b61s06s231014s23s50s13s03s16s13b59b44b29076b16b19s500812b45b17s52C096b20s34s38032s62s26s42054b60s13s460410b62b46s54D0224s23s42s43b03b23s420033s37s39s42s43s26s63s26s50s32s39s38s32s42s26s50s06s37s32s37s58s09s18s24s43b24s51s320131s47s34s13s43s39s51s63s04s47s63s43s510240Y1418",
									"W0416b51b09b190910s37s26s50b10b55s37015b16b44s39079b31b11s17C0810b50b29s13007X1419",
									"R0113b09b34s32038b29b03s58108b04b42b160714b22b05b35O0626s33s44s06b61s58s260221b47b60s260515b62s37s060812b48b63s64B049s26s44s33b10s51s500016b17b43s260916s44s19s59b11b59s320712Y1420",
									"S0311b38b39b090115s40s37s59b29s44s200610b43b03s190710b12b40b10C1015s58s61s50b06s44s550920b41s44s500019b07b23s34041X1420"								]

var gamma: Array[String] = 		[
									"R101s16s38s32023b29s20s47072X1416",
									"W017b59s16s03065b38b39s37094b26s37s16022s27s40s31T086X1418"
								]

var kech: Array[String] = 		[
									"W041s33s51s09010s58s03s44024b29s60s03072b47s33s31T004s20s59s09084b32s13s59101X1421",
									"S034s58s60s34052b27s42s60014b47s43s33077b54b48s28O0616X1421",
									"S037b39s43s13049b21s13s19086b34b06s32092X1421"
								]

var timo: Array[String] =		[
									"S083b03s23s29039b34s50s13053b35s58s20023X1422",
									"R076b42s19s32026b26b20s13086b09s39s44002b27s10s54T052s51s03s23063b43s58s16098b39b03s16100s40s10s53G030s16s40s61012s13s47s10043b00041Y1423"
								]

var caner: Array[String] =		[
									"S091s39s37s03s17s58s50102X1612"
								]

var neik: Array[String] =		[
									"S054b34s29s61106b26b55s20041s56s58s35014b52s35s56C030s44s19s29085X1614",
									"W0712b29b26b16107b32s13s09022b34s39s06050s27s35s52O006b59s61s13014X1614"
								]

var basti: Array[String] =		[
									"W081s42s55s21098b29b37s47060s06s42s50s00002X1412",
									"W051s19s32s16015b38s23s44070s37s55s44023b03s42s12C080s26s04s59001X1413",
									"S051X1413",
									"W081s32s26s21049b33b43s42072b26s16s51055X1413",
									"R052s13s50s55085b61b16s58073b60s26s03007b17s62s22T062b38s06s18048b33b39s13031b03s43s21101X1413",
									"R043b55s59s13013b61s60s56054b42s33s44004b62s56s12T082s44s21s47093b60s06s33036b29b26s63102s27s56s54D060s00074b03s59s56021X1415",
									"W108b23b33s260911b56b34s47032b39b29s50062s24s57s54C042s58s47s37085X1416",
									"S011s33s51s38009b20b29s50073b19s16s44095b03s06s54T105b51s50s61066s13s32s37b60s32s58024b23s50s06034b31s04s24G080s37s38s320513X1416",
									"S0210b29b39s37055b26b43s20016b34b44s19043s45s24s31T065b35s51s32076s32s20s55b37s55s16087b24s58s21101b53s25s40B035b19s20s38091X1416",
									"R022s58s21s03099b33b42s23032s21s43s61044b22s56s32T108b09b60s20017b03s32s13056b43b59b23008b10b04s54G0710b51b37s060821s26s21s16b56s26s580610b11b61b340716Y1417"
								]

var player_runs = [moritz, nexus, esvee, gamma, kech, timo, caner, neik, basti]
var player_names = ["moritz", "nexus", "esvee", "gamma", "kech", "timo", "caner", "neik", "basti"]

class Player:
	var name: String
	var runs: Array[String]
	var wins: int
	var death_locations: Array[String]
	var death_mods: Array
	var win_specials
	
	func _init(_name, _runs) -> void:
		name = _name
		runs = _runs
		wins = calculate_wins(_runs)
		death_locations = calculate_death_locations(_runs)
		death_mods = calculate_death_mods(_runs)
		win_specials = calculate_win_specials(_runs)
	
	func calculate_wins(r:Array[String]):
		var win_count = 0
		for run in r:
			if "Y" in run:
				win_count+=1
		return win_count

	func calculate_win_specials(r:Array[String]):
		var win_specials = []
		var special_bought_strings = ["b12", "b22", "b30", "b31", "b52", "b53", "b54", "b64"]
		var total = 0
		for run in r:
			if "X" in run:
				continue
			if "b12" in run:
				win_specials.append("Cheater")
				continue
			if "b22" in run:
				win_specials.append("Petrified")
				continue
			if "b30" in run:
				win_specials.append("Moulting")
				continue
			if "b31" in run:
				win_specials.append("Anchor")
				continue
			if "b52" in run:
				win_specials.append("Dance")
				continue
			if "b53" in run:
				win_specials.append("Half Gone")
				continue
			if "b54" in run:
				win_specials.append("Allergy")
				continue
			if "b64" in run:
				win_specials.append("Overfed")
				continue
		return win_specials
				
	func calculate_death_locations(r:Array[String]):
		var locations: Array[String] = []
		for run: String in r:
			if run.find("C") == -1 and run.find("T") == -1 and run.find("O") == -1:
				if run.find("W") != -1:
					locations.append("Woods")
				elif run.find("R") != -1:
					locations.append("Restaurant")
				elif run.find("S") != -1:
					locations.append("Stadium")
				else:
					print("ERROR: Player died before act two but no act 1 map was found")
			elif run.find("B") == -1 and run.find("D") == -1 and run.find("G") == -1:
				if run.find("C") != -1:
					locations.append("Cave")
				elif run.find("T") != -1:
					locations.append("Train")
				elif run.find("O") != -1:
					locations.append("Office")
				else:
					print("ERROR: Player died before act three but no act 2 map was found")
			elif run.find("Y") == -1:
				if run.find("B") != -1:
					locations.append("Beach")
				elif run.find("D") != -1:
					locations.append("Disco")
				elif run.find("G") != -1:
					locations.append("Tomb")
				else:
					print("ERROR: Player died in act three but no act 3 map was found")
		return locations
	
	func calculate_death_mods(r:Array[String]):
		var mods = []
		for run in r :
			if not "X" in run:
				continue
			var index = skip_shop_phase(run, run.find("X"))
			if index == null:
				continue
			if run[index] == "0":
				if run[index+1] == "0":
					mods.append("CAFFEINATED")
				if run[index+1] == "1":
					mods.append("TAILVIRUS")
				if run[index+1] == "2":
					mods.append("EDIBLE_PAPER")
				if run[index+1] == "3":
					mods.append("LASER")
				if run[index+1] == "4":
					mods.append("FRUIT_BODY")
				if run[index+1] == "5":
					mods.append("TETRI_FRUIT")
				if run[index+1] == "6":
					mods.append("MOVING_FRUIT")
				if run[index+1] == "7":
					mods.append("ANTI_MAGNET")
				if run[index+1] == "8":
					mods.append("GHOST_INVASION")
				if run[index+1] == "9":
					mods.append("FAR_AWAY")
			elif run[index] == "1":
				if run[index+1] == "0":
					mods.append("DARK")
		return mods
	
	func skip_shop_phase(code: String, start_pos: int):
		var correct_index
		for index in code.length():
			#skip to the start position
			if start_pos > 0:
				start_pos -= 1
				continue
			#skip forward until shop phase is done
			if code[index] == "b" or code[index] == "s" or\
			code[index+1] == "b" or code[index+1] == "s" or\
			code[index+2] == "b" or code[index+2] == "s":
				continue
			correct_index = index
			break
		
		while correct_index > 0:
			#jump back to last shop occurance
			if ["1","2","3","4","5","6","7","8","9","0","R","W","S","C","O","T","B","D","G","X","Y"].has(code[correct_index]):
				correct_index -= 1
			else:
				#skip that last shop occurance
				correct_index += 3
				#if new map is shown, skip that letter
				if ["R","W","S","C","O","T","B","D","G"].has(code[correct_index]):
					correct_index += 1
				return correct_index
			

func _ready() -> void:
	var players: Array[Player] = []
	for i in player_runs.size():
		var player = Player.new(player_names[i], player_runs[i])
		players.append(player)
	
	for player in players:
		print(player.name, ":")
		print(player.wins, " out of ",player.runs.size(), " runs won")
		print("Maps lost on: ", player.death_locations)
		print("Modifications lost on: ", player.death_mods)
		print("Special Upgrades won with: ", player.win_specials)
		print("")
