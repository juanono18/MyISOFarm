#Unidades: 0 P/u: $10 Total:$0

extends AnimatedSprite2D
var inShop=false
var opened= false;
var unidades=0
var id
var shop={
	"sellPrice":{
		"dirtBlock":20,
		"wheatSeed":1,
		"carrotSeed":1,
		"wheat":10,
		"carrot":15
	},
	"buyPrice":{
		"dirtBlock":100,
		"wheatSeed":5,
		"carrotSeed":10
	}
}
var shopInv={
	"carrotSeed":"$10",
	"wheatSeed":"$5",
	"dirtBlock":"$100"
	
}
var idTex= {
	"dirtBlock":"res://DirtIcon.png",
	"wheatSeed":"res://wheatSeedBagTexture.png",
	"carrotSeed":"res://carrotSeedBagTexture.png",
	"wheat":"res://WheatIcon.png",
	"carrot":"res://carrotIcon.png"
}
var inventorySlots =[]
# Called when the node enters the scene tree for the first time.
func _ready():
	loadInventory()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateShop():
	for itemSlot in $ScrollContainer/GridContainer.get_children():
				for ItemSlotChild in itemSlot.get_children():
					if ItemSlotChild.name == "ItemSprite" and ItemSlotChild.texture == null:
						itemSlot.disabled = false
					if ItemSlotChild.name == "ItemSprite":
						ItemSlotChild.texture = null
					if ItemSlotChild.name == "QuantityLabel":
						ItemSlotChild.text=""
					if ItemSlotChild.name == "idLabel":
						ItemSlotChild.text=""
	loadShop()
func updateInventory():
	for itemSlot in $ScrollContainer/GridContainer.get_children():
				for ItemSlotChild in itemSlot.get_children():
					if ItemSlotChild.name == "ItemSprite" and ItemSlotChild.texture == null:
						itemSlot.disabled = false
					if ItemSlotChild.name == "ItemSprite":
						ItemSlotChild.texture = null
					if ItemSlotChild.name == "QuantityLabel":
						ItemSlotChild.text=""
					if ItemSlotChild.name == "idLabel":
						ItemSlotChild.text=""

						
	loadInventory()

func loadInventory():
	var found = false
	var inventory = $"../../../TileMap".getInventory()
	for itemSlot in $ScrollContainer/GridContainer.get_children():
				if itemSlot.get_signal_connection_list("pressed").size() < 1:
					itemSlot.pressed.connect( _on_item_button_pressed.bind(itemSlot))
				#print(itemSlot)
				var itemSlotList=[]
				for ItemSlotChild in itemSlot.get_children():
					
					if ItemSlotChild.name == "ItemSprite" and ItemSlotChild.texture == null:
						found = true
						itemSlotList.append(ItemSlotChild)
					if ItemSlotChild.name == "QuantityLabel" and found:
						itemSlotList.append(ItemSlotChild)
					if ItemSlotChild.name == "idLabel" and found:
						itemSlotList.append(ItemSlotChild)
					inventorySlots.append(itemSlotList)
	for item in inventory:
		#print(item)
		for slot in inventorySlots:
			if slot[0].texture == null and item in idTex:
				slot[0].texture = load(idTex[item])
				slot[1].text = str(inventory[item])
				slot[2].text = item
				break
		continue
	for itemSlot in $ScrollContainer/GridContainer.get_children():
				for ItemSlotChild in itemSlot.get_children():
					if ItemSlotChild.name == "ItemSprite" and ItemSlotChild.texture == null:
						itemSlot.disabled = true
						
	$"../WheatScore/Money".text = "${0}".format([inventory["money"]])
						
		
			
func loadShop():
	var found = false
	var inventory = $"../../../TileMap".getInventory()
	for itemSlot in $ScrollContainer/GridContainer.get_children():
				if itemSlot.get_signal_connection_list("pressed").size() < 1:
					itemSlot.pressed.connect( _on_item_button_pressed.bind(itemSlot))
				#print(itemSlot)
				var itemSlotList=[]
				for ItemSlotChild in itemSlot.get_children():
					
					if ItemSlotChild.name == "ItemSprite" and ItemSlotChild.texture == null:
						found = true
						itemSlotList.append(ItemSlotChild)
					if ItemSlotChild.name == "QuantityLabel" and found:
						itemSlotList.append(ItemSlotChild)
					if ItemSlotChild.name == "idLabel" and found:
						itemSlotList.append(ItemSlotChild)
					inventorySlots.append(itemSlotList)
	for item in shopInv:
		print(item)
		for slot in inventorySlots:
			if slot[0].texture == null and item in idTex:
				slot[0].texture = load(idTex[item])
				slot[1].text = str(shopInv[item])
				slot[2].text = item
				break
		continue
	for itemSlot in $ScrollContainer/GridContainer.get_children():
				for ItemSlotChild in itemSlot.get_children():
					if ItemSlotChild.name == "ItemSprite" and ItemSlotChild.texture == null:
						itemSlot.disabled = true
						
	$"../WheatScore/Money".text = "${0}".format([inventory["money"]])
				
		
func _on_open_close_button_pressed():
	var tween = self.create_tween()
	var camtween = $"../../../Camera2D".create_tween()
	if opened:
		$"../../../Sounds/closemenu".play()
		self.set_frame(0)
		camtween.tween_property($"../../../Camera2D","offset",Vector2(100,0),0.3)
		tween.tween_property(self,"position",Vector2(position.x,position.y+210),0.3)
		tween.tween_property(self,"position",Vector2(position.x,position.y+200),0.1)
		opened = false
	else:
		$"../../../Sounds/closemenu".play()
		
		self.set_frame(1)
		camtween.tween_property($"../../../Camera2D","offset",Vector2(100,25),0.3)
		tween.tween_property(self,"position",Vector2(position.x,position.y-210),0.3)
		tween.tween_property(self,"position",Vector2(position.x,position.y-200),0.1)
		opened = true
	pass # Replace with function body.


func _on_inv_button_pressed():
	if opened:
		updateInventory()
		$BuySellDialog/buy/Label.text = "vender"
		$BuySellDialog.text = str("Selecciona un item")
		inShop=false
		$"../../../Sounds/UIClick".play()
		self.set_frame(1)
	pass # Replace with function body.


func _on_shop_button_pressed():
	if opened:
		updateShop()
		$BuySellDialog.text = str("Selecciona un item")
		$BuySellDialog/buy/Label.text = "comprar"
		inShop=true
		$"../../../Sounds/UIClick".play()
		self.set_frame(2)
	pass # Replace with function body.







func _on_item_button_pressed(sender):
	$"../../../Sounds/UIClick".play()
	id=sender.get_child(2).text
	unidades=0
	if !inShop:
			$BuySellDialog.text = str("Unidades: {0} P/u: ${1} Total:${2}").format([unidades,shop["sellPrice"][id],unidades*shop["sellPrice"][id]])
	else:
			$BuySellDialog.text = str("Unidades: {0} P/u: ${1} Total:${2}").format([unidades,shop["buyPrice"][id],unidades*shop["buyPrice"][id]])
	if not inShop:
		$"../../../TileMap".setSelectedItem(id)
	pass # Replace with function body.


func _on_addunit_pressed():
	var inventory = $"../../../TileMap".getInventory()

	if id!=null and inventory[id]-1 >= unidades or inShop:
		$"../../../Sounds/UIClick".play()
		if Input.is_key_pressed(KEY_SHIFT):
			if unidades+5 > inventory[id]:
				unidades= inventory[id]
			else:
				unidades+=5
		else:
			unidades+=1
		if !inShop:
			$BuySellDialog.text = str("Unidades: {0} P/u: ${1} Total:${2}").format([unidades,shop["sellPrice"][id],unidades*shop["sellPrice"][id]])
		else:
			$BuySellDialog.text = str("Unidades: {0} P/u: ${1} Total:${2}").format([unidades,shop["buyPrice"][id],unidades*shop["buyPrice"][id]])
	
	pass # Replace with function body.


func _on_removeunit_pressed():
	if(unidades>1):
		$"../../../Sounds/UIClick".play()
		unidades-=1
		if !inShop:
			$BuySellDialog.text = str("Unidades: {0} P/u: ${1} Total:${2}").format([unidades,shop["sellPrice"][id],unidades*shop["sellPrice"][id]])
		else:
			$BuySellDialog.text = str("Unidades: {0} P/u: ${1} Total:${2}").format([unidades,shop["buyPrice"][id],unidades*shop["buyPrice"][id]])
	
	pass # Replace with function body.


func _on_buy_pressed():
	
	var inventory = $"../../../TileMap".getInventory()
	if inShop:
		
		if inventory["money"] >= (unidades*shop["buyPrice"][id]):
			inventory[id]+=unidades
			inventory["money"]-= (unidades*shop["buyPrice"][id])
			updateShop()
	else:
		$"../../../Sounds/buysell".play()
		inventory["money"]+= (unidades*shop["sellPrice"][id])
		inventory[id]-=unidades
		updateInventory()
	
	pass # Replace with function body.
