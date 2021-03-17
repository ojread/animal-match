extends MarginContainer

onready var Card = preload("res://objects/card/card.tscn")
onready var card_types = preload("res://objects/card/card_types.gd")

var card1 = null
var card2 = null

var flip_timer = Timer.new()

func _ready():
	randomize()
	var cards = init_cards(6)
	deal_cards(cards)
	flip_timer.connect("timeout", self, "check_cards")
	flip_timer.set_one_shot(true);
	add_child(flip_timer)
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
		$Cards.add_child(card)
	
func on_card_pressed(card):
	if card1 == null:
		card1 = card
		card1.flip()
		card1.set_disabled(true)
	elif card2 == null:
		card2 = card
		card2.flip()
		card2.set_disabled(true)
		flip_timer.start(1)
		
func check_cards():
	print_debug(card1.type, card2.type)
	if card1.type == card2.type:
		print_debug("Match")
		card1.set_normal_texture(null)
		card2.set_normal_texture(null)
	else:
		card1.flip()
		card2.flip()
		card1.set_disabled(false)
		card2.set_disabled(false)
	card1 = null
	card2 = null
	
	
