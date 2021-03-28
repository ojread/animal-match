extends MarginContainer

onready var Card = preload("res://objects/card/card.tscn")
onready var card_types = preload("res://objects/card/card_types.gd")

var score = 0
var pair_count = 6
var card1 = null
var card2 = null

var flip_timer = Timer.new()
var game_over_timer = Timer.new()

func _ready():
	randomize()
	score = 0
	flip_timer.connect("timeout", self, "check_cards")
	flip_timer.set_one_shot(true);
	game_over_timer.connect("timeout", self, "game_over")
	game_over_timer.set_one_shot(true);
	add_child(flip_timer)
	add_child(game_over_timer)
	var cards = init_cards(pair_count)
	deal_cards(cards)
	pass

func init_cards(pairs) -> Array:
	var cards = []
	card_types.data.shuffle()
	for pair in range(pairs):
		for _i in range(2):
			var card = Card.instance()
			card.init(card_types.data[pair])
			card.connect("pressed", self, "on_card_pressed", [card])
			cards.append(card)
	return cards
			
func deal_cards(cards: Array) -> void:
	cards.shuffle()
	for card in cards:
		$HBoxContainer/Cards.add_child(card)
	
func on_card_pressed(card):
	if card1 == null:
		card1 = card
		card1.flip()
		card1.set_disabled(true)
	elif card2 == null:
		card2 = card
		card2.flip()
		card2.set_disabled(true)
		flip_timer.start(2)
		
func check_cards():
	#print_debug(card1.type, card2.type)
	if card1.type == card2.type:
		#print_debug("Match")
		card1.set_normal_texture(null)
		card2.set_normal_texture(null)
		score += 1
		$HBoxContainer/ScorePanel/ScoreLabel.text = str(score)
		if (score >= pair_count):
			$GameOverLabel.visible = true
			game_over_timer.start(3)
	else:
		card1.flip()
		card2.flip()
		card1.set_disabled(false)
		card2.set_disabled(false)
	card1 = null
	card2 = null
	
func game_over():
	print_debug("game_over")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/menu/menu.tscn")
