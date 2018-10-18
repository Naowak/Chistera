import json
import sys
sys.path.append('../game/')
import Battle

NUMBER_PLAYER_GAME = 1
free_game_ids = list(range(1, 100))

def encode(data) :
	return json.dumps(data)

class GameManager() :

	def __init__(self) :
		self.games = {}
		self.ask_to_play = []

	def treat_request(self, client, mess) :
		if not "action" in mess :
			print("Action pas défini !")
		if mess["action"] == "ask_to_play" :
			self.ask_to_play += [[client, mess["team"]]]
			if len(self.ask_to_play) >= NUMBER_PLAYER_GAME :
				self.create_game()


	def create_game(self) :
		player, team = self.ask_to_play.pop()
		game_id = free_game_ids.pop()
		new_battle = Battle.Battle(game_id, player.id, team)
		self.games[game_id] = new_battle
		
		msg = {"action" : "new_game",
			"grid" : new_battle.grid.get_serializable_grid(),
			"state" : new_battle.get_state()}
		player.sendMessage(encode(msg))


