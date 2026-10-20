extends Area2D
signal hit

@export var speed = 400 #プレイヤーの移動速度(pixels/sec)
var screen_size #ゲームウィンドウの大きさ
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size # Replace with function body.
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#delta:前のフレームから今の画面が描写されるまでにかかった時間
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed #.normalizedは正規化で、ベクトルの長さを1にする
		# それにspeedを掛けると常に速さはspeed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) #clamp(A, B):AからBの間にpositionを収める
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(_body):#_:この関数内でbody:敵を使わなくても警告が出なくなる。
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)#衝突判定を複数回ださないように

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
