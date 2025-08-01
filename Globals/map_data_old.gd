extends Node

func get_map_data0(map: int):
	match map:
		GameConsts.MAP_LIST.WOODS:
			return [Vector2(-450,-579.0), Vector2(1.068,1.116), Vector2i(15,12), Vector2i(1,0), Vector2i(17,13)]
		GameConsts.MAP_LIST.STADIUM:
			return [Vector2(-469.0,-675.0), Vector2(1.155,1.125), Vector2i(14,12), Vector2i(1,1), Vector2i(16,14)]
		GameConsts.MAP_LIST.OFFICE:
			return [Vector2(-452.0,-662.0), Vector2(1.072,1.035), Vector2i(15,13), Vector2i(1,1), Vector2i(17,15)]
		GameConsts.MAP_LIST.DISCO:
			[Vector2(-453.0,-663.0), Vector2(1.012,0.972), Vector2i(16,14), Vector2i(1,1), Vector2i(18,16)]
		GameConsts.MAP_LIST.CAVE:
			return [Vector2(-368.0,-578.0), Vector2(1.006,0.963), Vector2i(16,14), Vector2i(0,0), Vector2i(17,15)]
		GameConsts.MAP_LIST.BEACH:
			return [Vector2(-447.0,-657.0), Vector2(1.006,0.966), Vector2i(16,14), Vector2i(1,1), Vector2i(18,16)]

func get_map_data1(map: int):
	match map:
		GameConsts.MAP_LIST.WOODS:
			return [Vector2(-366.0,-580.0), Vector2(1.003,1.035), Vector2i(16,13), Vector2i(0,0), Vector2i(17,14)]
		GameConsts.MAP_LIST.STADIUM:
			return [Vector2(-369.0,-664.0), Vector2(1.074,1.037), Vector2i(15,13), Vector2i(0,1), Vector2i(16,15)]
		GameConsts.MAP_LIST.OFFICE:
			return [Vector2(-369.0,-578.0), Vector2(1.007,0.963), Vector2i(15,13), Vector2i(0,0), Vector2i(17,15)]
		GameConsts.MAP_LIST.DISCO:
			return [Vector2(-369.0,-576.0), Vector2(0.951,0.901), Vector2i(17,15), Vector2i(0,0), Vector2i(18,16)]
		GameConsts.MAP_LIST.CAVE:
			return [Vector2(-366.0,-577.0), Vector2(0.948,0.901), Vector2i(17,15), Vector2i(0,0), Vector2i(18,16)]
		GameConsts.MAP_LIST.BEACH:
			return [Vector2(-368.0,-649.0), Vector2(0.951,0.901), Vector2i(17,15), Vector2i(0,1), Vector2i(18,17)]
			
func get_map_data2(map: int):
	match map:
		GameConsts.MAP_LIST.WOODS:
			return [Vector2(-293.0,-501.0), Vector2(0.949,0.965), Vector2i(17,14), Vector2i(-1,-1), Vector2i(17,14)]
		GameConsts.MAP_LIST.STADIUM:
			return [Vector2(-363.0,-575.0), Vector2(1.002,0.956), Vector2i(16,14), Vector2i(0,0), Vector2i(17,15)]
		GameConsts.MAP_LIST.OFFICE:
			return [Vector2(-366.0,-577.0), Vector2(0.949,0.901), Vector2i(17,15), Vector2i(0,0), Vector2i(18,16)]
		GameConsts.MAP_LIST.DISCO:
			return [Vector2(-293.0,-504.0), Vector2(0.894,0.842), Vector2i(18,16), Vector2i(-1,0), Vector2i(18,17)]
		GameConsts.MAP_LIST.CAVE:
			return [Vector2(-292.0,-506.0), Vector2(0.895,0.844), Vector2i(18,16), Vector2i(-1,-1), Vector2i(18,16)]
		GameConsts.MAP_LIST.BEACH:
			return [Vector2(-364.0,-573.0), Vector2(0.896,0.844), Vector2i(18,16), Vector2i(0,0), Vector2i(19,17)]

func get_map_data3(map: int):
	match map:
		GameConsts.MAP_LIST.WOODS:
			return [Vector2(-293.0,-501.0), Vector2(0.897,0.897), Vector2i(18,15), Vector2i(-1,-1), Vector2i(18,15)]
		GameConsts.MAP_LIST.STADIUM:
			return [Vector2(-292.0,-506.0), Vector2(0.896,0.844), Vector2i(18,16), Vector2i(-1,-1), Vector2i(18,16)]
		GameConsts.MAP_LIST.OFFICE:
			return [Vector2(-294.0,-509.0), Vector2(0.85,0.796), Vector2i(20,18), Vector2i(-1,-1), Vector2i(19,17)]
		GameConsts.MAP_LIST.DISCO:
			return [Vector2(-297.0,-510.0), Vector2(0.851,0.751), Vector2i(19,18), Vector2i(-1,-1), Vector2i(19,18)]
		GameConsts.MAP_LIST.CAVE:
			return [Vector2(-294.0,-508.0), Vector2(0.849,0.794), Vector2i(19,17), Vector2i(-1,-1), Vector2i(19,17)]
		GameConsts.MAP_LIST.BEACH:
			return [Vector2(-296.0,-508.0), Vector2(0.807,0.794), Vector2i(20,17), Vector2i(-1,-1), Vector2i(20,17)]
#each array contains vector groups for the existing maps.
#Vector1 describes map position, Vector 2 describes map scale, Vector 3 describes grid size
#Vector4 and Vector 5 describe upper left / lower right corner of the barrier "frame"
var map_data_size0: Array = [	
										[Vector2(-450,-579.0), Vector2(1.068,1.116), Vector2i(15,12), Vector2i(1,0), Vector2i(17,13)],
										[Vector2(-469.0,-675.0), Vector2(1.155,1.125), Vector2i(14,12), Vector2i(1,1), Vector2i(16,14)],
										[Vector2(-452.0,-662.0), Vector2(1.072,1.035), Vector2i(15,13), Vector2i(1,1), Vector2i(17,15)],
										[Vector2(-453.0,-663.0), Vector2(1.012,0.972), Vector2i(16,14), Vector2i(1,1), Vector2i(18,16)],
										[Vector2(-368.0,-578.0), Vector2(1.006,0.963), Vector2i(16,14), Vector2i(0,0), Vector2i(17,15)],
										[Vector2(-447.0,-657.0), Vector2(1.006,0.966), Vector2i(16,14), Vector2i(1,1), Vector2i(18,16)],
										[Vector2(0,0), Vector2(0,0), Vector2i(0,0), Vector2i(0,0), Vector2i(0,0)],
										[Vector2(0,0),Vector2(0,0), Vector2i(0,0), Vector2i(0,0), Vector2i(0,0)],
										[Vector2(-487.0,-697.0), Vector2(1.345,1.345), Vector2i(12,10), Vector2i(1,1), Vector2i(14,12)]
									]
var map_data_size1: Array = [	
										[Vector2(-366.0,-580.0), Vector2(1.003,1.035), Vector2i(16,13), Vector2i(0,0), Vector2i(17,14)],
										[Vector2(-369.0,-664.0), Vector2(1.074,1.037), Vector2i(15,13), Vector2i(0,1), Vector2i(16,15)],
										[Vector2(-369.0,-578.0), Vector2(1.007,0.963), Vector2i(15,13), Vector2i(0,0), Vector2i(17,15)],
										[Vector2(-369.0,-576.0), Vector2(0.951,0.901), Vector2i(17,15), Vector2i(0,0), Vector2i(18,16)],
										[Vector2(-366.0,-577.0), Vector2(0.948,0.901), Vector2i(17,15), Vector2i(0,0), Vector2i(18,16)],
										[Vector2(-368.0,-649.0), Vector2(0.951,0.901), Vector2i(17,15), Vector2i(0,1), Vector2i(18,17)],
										[Vector2(0,0), Vector2(0,0), Vector2i(0,0), Vector2i(0,0), Vector2i(0,0)],
										[Vector2(0,0),Vector2(0,0), Vector2i(0,0), Vector2i(0,0), Vector2i(0,0)],
										[Vector2(-365.0,-592.0), Vector2(1.14,1.14), Vector2i(14,12), Vector2i(0,0), Vector2i(15,13)]
									]
var map_data_size2: Array = [	
										[Vector2(-293.0,-501.0), Vector2(0.949,0.965), Vector2i(17,14), Vector2i(-1,-1), Vector2i(17,14)],
										[Vector2(-363.0,-575.0), Vector2(1.002,0.956), Vector2i(16,14), Vector2i(0,0), Vector2i(17,15)],
										[Vector2(-366.0,-577.0), Vector2(0.949,0.901), Vector2i(17,15), Vector2i(0,0), Vector2i(18,16)],
										[Vector2(-293.0,-504.0), Vector2(0.894,0.842), Vector2i(18,16), Vector2i(-1,0), Vector2i(18,17)],
										[Vector2(-292.0,-506.0), Vector2(0.895,0.844), Vector2i(18,16), Vector2i(-1,-1), Vector2i(18,16)],
										[Vector2(-364.0,-573.0), Vector2(0.896,0.844), Vector2i(18,16), Vector2i(0,0), Vector2i(19,17)],
										[Vector2(0,0), Vector2(0,0), Vector2i(0,0), Vector2i(0,0), Vector2i(0,0)],
										[Vector2(0,0),Vector2(0,0), Vector2i(0,0), Vector2i(0,0), Vector2i(0,0)],
										[Vector2(-285.0,-499.0), Vector2(1.07,1.03), Vector2i(15,13), Vector2i(-1,-1), Vector2i(15,13)]
									]
var map_data_size3: Array = [	
										[Vector2(-293.0,-501.0), Vector2(0.897,0.897), Vector2i(18,15), Vector2i(-1,-1), Vector2i(18,15)],
										[Vector2(-292.0,-506.0), Vector2(0.896,0.844), Vector2i(18,16), Vector2i(-1,-1), Vector2i(18,16)],
										[Vector2(-294.0,-509.0), Vector2(0.85,0.796), Vector2i(20,18), Vector2i(-1,-1), Vector2i(19,17)],
										[Vector2(-297.0,-510.0), Vector2(0.851,0.751), Vector2i(19,18), Vector2i(-1,-1), Vector2i(19,18)],
										[Vector2(-294.0,-508.0), Vector2(0.849,0.794), Vector2i(19,17), Vector2i(-1,-1), Vector2i(19,17)],
										[Vector2(-296.0,-508.0), Vector2(0.807,0.794), Vector2i(20,17), Vector2i(-1,-1), Vector2i(20,17)],
										[Vector2(0,0), Vector2(0,0), Vector2i(0,0), Vector2i(0,0), Vector2i(0,0)],
										[Vector2(0,0),Vector2(0,0), Vector2i(0,0), Vector2i(0,0), Vector2i(0,0)],
										[Vector2(-289.0,-501.0), Vector2(1.01,0.965), Vector2i(16,14), Vector2i(-1,-1), Vector2i(19,18)]
									]
