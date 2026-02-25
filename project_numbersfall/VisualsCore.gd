# Copyright 2026 TeamJeZxLee.Itch.io
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute,
# sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# "VisualsCore.gd"
extends Node2D

var DEBUG = true

var FramesPerSecondArrayIndex = 0
var FramesPerSecondArray = []
var FramesPerSecondAverage = 0
var FramesPerSecondLastSecondTick = Time.get_ticks_msec()
var FramesPerSecondFrames = 0

class FPSClass:
	var TextImage = []
	var TextIndex = []
	var TextScreenX = []
	var TextScreenY = []
	var TextHorizontalJustification = []
	var TextSize = []
	var TextScaleX = []
	var TextScaleY = []
	var TextRotation = []
	var TextColorRed  = []
	var TextColorGreen = []
	var TextColorBlue = []
	var TextColorAlpha = []
	var TextOutlineRed = []
	var TextOutlineGreen = []
	var TextOutlineBlue = []
var FramesPerSecondText = FPSClass.new()

var ScreenWidth = 1024
var ScreenHeight = 640

class SpriteClass:
	var ci_rid = []
	var SpriteImage = []
	var SpriteImageWidth = []
	var SpriteImageHeight = []
	var SpriteActive = []
	var SpriteScreenX = []
	var SpriteScreenY = []
	var SpriteScaleX = []
	var SpriteScaleY = []
	var SpriteRotation = []
	var SpriteColorRed = []
	var SpriteColorGreen = []
	var SpriteColorBlue = []
	var SpriteColorAlpha = []
var Sprites = SpriteClass.new()

var FontTTF = []

var TextIsUsed = []

var TextCurrentIndex;

class TextClass:
	var TextImage = []
	var TextIndex = []
	var TextScreenX = []
	var TextScreenY = []
	var TextHorizontalJustification = []
	var TextSize = []
	var TextScaleX = []
	var TextScaleY = []
	var TextRotation = []
	var TextColorRed  = []
	var TextColorGreen = []
	var TextColorBlue = []
	var TextColorAlpha = []
	var TextOutlineRed = []
	var TextOutlineGreen = []
	var TextOutlineBlue = []
var Texts = TextClass.new()

class AboutText:
	var AboutTextsText = []
	var AboutTextsBlue = []
var AboutTexts = AboutText.new()

var AboutTextsStartIndex
var AboutTextsEndIndex

var PieceSpriteCurrentIndex = []
var PlayfieldSpriteCurrentIndex = []

var KeyboardControlsAlphaTimer;

var KeepAspectRatio
var FullScreenMode

var StarX = []
var StarY = []
var StarScale = []
var StarRotation = []
var StarAlpha = []
var StarColorR = []
var StarColorG = []
var StarColorB = []

#----------------------------------------------------------------------------------------
func _ready():
	for _index in range(0, 10):
		FramesPerSecondArray.append(0)

	StarX.resize(250)
	StarY.resize(250)
	StarScale.resize(250)
	StarRotation.resize(250)
	StarAlpha.resize(250)
	StarColorR.resize(250)
	StarColorG.resize(250)
	StarColorB.resize(250)

	for _index in range(0, 40000):
		Sprites.ci_rid.append(-1)
		Sprites.ci_rid[_index] = RenderingServer.canvas_item_create()
		RenderingServer.canvas_item_set_parent(Sprites.ci_rid[_index], get_canvas_item())
		Sprites.SpriteImage.append(-1)
		Sprites.SpriteImageWidth.append(0)
		Sprites.SpriteImageHeight.append(0)
		Sprites.SpriteActive.append(false)
		Sprites.SpriteScreenX.append(-99999)
		Sprites.SpriteScreenY.append(-99999)
		Sprites.SpriteScaleX.append(1.0)
		Sprites.SpriteScaleY.append(1.0)
		Sprites.SpriteRotation.append(0)
		Sprites.SpriteColorRed.append(1.0)
		Sprites.SpriteColorGreen.append(1.0)
		Sprites.SpriteColorBlue.append(1.0)
		Sprites.SpriteColorAlpha.append(1.0)

	for _index in range(0, 1000):
		TextIsUsed.append(false)

	Sprites.SpriteImage[0] = load("res://media/images/backgrounds/BG_Fading_Black.png")
	Sprites.SpriteActive[0] = true

	Sprites.SpriteImage[2] = load("res://media/images/backgrounds/BG_Paused.png")
	Sprites.SpriteActive[2] = true

	Sprites.SpriteImage[5] = load("res://media/images/logos/BG_Godot_Logo.png")
	Sprites.SpriteActive[5] = true

	Sprites.SpriteImage[10] = load("res://media/images/backgrounds/BG_Title.png")
	Sprites.SpriteActive[10] = true

	Sprites.SpriteImage[20] = load("res://media/images/logos/SPR_Logo.png")
	Sprites.SpriteActive[20] = true

	Sprites.SpriteImage[23] = load("res://media/images/backgrounds/BG_Title_Logo.png")
	Sprites.SpriteActive[23] = true

	Sprites.SpriteImage[26] = load("res://media/images/gui/NF_GP_QR_Code.png")
	Sprites.SpriteActive[26] = true

	for index in range(30, 40):
		Sprites.SpriteImage[index] = load("res://media/images/gui/ScreenLine2.png")
		Sprites.SpriteActive[index] = true

	for index in range(40, 50):
		Sprites.SpriteImage[index] = load("res://media/images/gui/Button2.png")
		Sprites.SpriteActive[index] = true

	Sprites.SpriteImage[50] = load("res://media/images/gui/ButtonSelectorLeft.png")
	Sprites.SpriteActive[50] = true
	Sprites.SpriteImage[51] = load("res://media/images/gui/ButtonSelectorRight.png")
	Sprites.SpriteActive[51] = true

	Sprites.SpriteImage[60] = load("res://media/images/gui/SelectorLine.png")
	Sprites.SpriteActive[60] = true

	for index in range(70, 100, 2):
		Sprites.SpriteImage[index] = load("res://media/images/gui/ButtonSelectorLeft.png")
		Sprites.SpriteActive[index] = true
		Sprites.SpriteImage[index+1] = load("res://media/images/gui/ButtonSelectorRight.png")
		Sprites.SpriteActive[index+1] = true

	Sprites.SpriteImage[110] = load("res://media/images/gui/SpeakerOFF.png")
	Sprites.SpriteActive[110] = true
	Sprites.SpriteImage[111] = load("res://media/images/gui/SpeakerON.png")
	Sprites.SpriteActive[111] = true

	Sprites.SpriteImage[117] = load("res://media/images/gui/Exit2.png")
	Sprites.SpriteActive[117] = true

	Sprites.SpriteImage[118] = load("res://media/images/gui/Pause.png")
	Sprites.SpriteActive[118] = true

	Sprites.SpriteImage[119] = load("res://media/images/gui/Play.png")
	Sprites.SpriteActive[119] = true

	Sprites.SpriteImage[180] = load("res://media/images/gui/Keyboard.png")
	Sprites.SpriteActive[180] = true
	Sprites.SpriteImage[181] = load("res://media/images/gui/MouseTouch.png")
	Sprites.SpriteActive[181] = true

	Sprites.SpriteImage[190] = load("res://media/images/gui/Play2.png")
	Sprites.SpriteActive[190] = true

	Sprites.SpriteImage[191] = load("res://media/images/playing/Tile1.png")
	Sprites.SpriteActive[191] = true

	Sprites.SpriteImage[192] = load("res://media/images/playing/TilePlus.png")
	Sprites.SpriteActive[192] = true

	Sprites.SpriteImage[193] = load("res://media/images/playing/Tile2.png")
	Sprites.SpriteActive[193] = true

	Sprites.SpriteImage[194] = load("res://media/images/playing/TileEqual.png")
	Sprites.SpriteActive[194] = true

	Sprites.SpriteImage[195] = load("res://media/images/playing/Tile3.png")
	Sprites.SpriteActive[195] = true

	for index in range(0, 100):
		Sprites.SpriteImage[200+index] = load("res://media/images/gui/NameInputButton2.png")
		Sprites.SpriteActive[200+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[20000+index] = load("res://media/images/playing/Tile0-S.png")
		Sprites.SpriteActive[20000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[21000+index] = load("res://media/images/playing/Tile1-S.png")
		Sprites.SpriteActive[21000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[22000+index] = load("res://media/images/playing/Tile2-S.png")
		Sprites.SpriteActive[22000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[23000+index] = load("res://media/images/playing/Tile3-S.png")
		Sprites.SpriteActive[23000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[24000+index] = load("res://media/images/playing/Tile4-S.png")
		Sprites.SpriteActive[24000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[25000+index] = load("res://media/images/playing/Tile5-S.png")
		Sprites.SpriteActive[25000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[26000+index] = load("res://media/images/playing/Tile6-S.png")
		Sprites.SpriteActive[26000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[27000+index] = load("res://media/images/playing/Tile7-S.png")
		Sprites.SpriteActive[27000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[28000+index] = load("res://media/images/playing/Tile8-S.png")
		Sprites.SpriteActive[28000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[29000+index] = load("res://media/images/playing/Tile9-S.png")
		Sprites.SpriteActive[29000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[30000+index] = load("res://media/images/playing/TilePlus-S.png")
		Sprites.SpriteActive[30000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[31000+index] = load("res://media/images/playing/TileMinus-S.png")
		Sprites.SpriteActive[31000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[32000+index] = load("res://media/images/playing/TileMuliply-S.png")
		Sprites.SpriteActive[32000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[33000+index] = load("res://media/images/playing/TileDivide-S.png")
		Sprites.SpriteActive[33000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[34000+index] = load("res://media/images/playing/TileDecimal-S.png")
		Sprites.SpriteActive[34000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[35000+index] = load("res://media/images/playing/TileEqual-S.png")
		Sprites.SpriteActive[35000+index] = true

	for index in range(0, 999):
		Sprites.SpriteImage[36000+index] = load("res://media/images/playing/Selected-S.png")
		Sprites.SpriteActive[36000+index] = true

	Sprites.SpriteImage[2001] = load("res://media/images/playing/UndoButton-S.png")
	Sprites.SpriteActive[2001] = true

	Sprites.SpriteImage[2002] = load("res://media/images/playing/CheckButton-S.png")
	Sprites.SpriteActive[2002] = true

	Sprites.SpriteImage[2000] = load("res://media/images/playing/Playfield.png")
	Sprites.SpriteActive[2000] = true

	Sprites.SpriteImage[3000] = load("res://media/images/backgrounds/BG_Title.png")
	Sprites.SpriteActive[3000] = true

	Sprites.SpriteImage[3001] = load("res://media/images/backgrounds/BG_Title_Logo.png")
	Sprites.SpriteActive[3001] = true

	Sprites.SpriteImage[3002] = load("res://media/images/story/Anime1.png")
	Sprites.SpriteActive[3002] = true

	Sprites.SpriteImage[3003] = load("res://media/images/story/Anime2.png")
	Sprites.SpriteActive[3003] = true

	Sprites.SpriteImage[3004] = load("res://media/images/story/Anime3.png")
	Sprites.SpriteActive[3004] = true

	Sprites.SpriteImage[3005] = load("res://media/images/story/Anime4.png")
	Sprites.SpriteActive[3005] = true

	Sprites.SpriteImage[3006] = load("res://media/images/story/Anime5.png")
	Sprites.SpriteActive[3006] = true

	Sprites.SpriteImage[3007] = load("res://media/images/story/Anime6.png")
	Sprites.SpriteActive[3007] = true

	Sprites.SpriteImage[3008] = load("res://media/images/story/Anime7.png")
	Sprites.SpriteActive[3008] = true

	Sprites.SpriteImage[3009] = load("res://media/images/story/Anime8.png")
	Sprites.SpriteActive[3009] = true

	Sprites.SpriteImage[3010] = load("res://media/images/story/Anime9.png")
	Sprites.SpriteActive[3010] = true

	for indexStar in range(250):
		Sprites.SpriteImage[4000+indexStar] = load("res://media/images/gui/Star.png")
		Sprites.SpriteActive[4000+indexStar] = true

	Sprites.SpriteImage[5000] = load("res://media/images/backgrounds/BG_Fading_Black.png")
	Sprites.SpriteActive[5000] = true

	Sprites.SpriteImage[19999] = load("res://media/images/backgrounds/BG_Fading_Black.png")
	Sprites.SpriteActive[19999] = true

	var sprite_size
	for index in range(0, 40000):
		if Sprites.SpriteActive[index] == true:
			sprite_size = Sprites.SpriteImage[index].get_size()
			Sprites.SpriteImageWidth[index] = sprite_size.x
			Sprites.SpriteImageHeight[index] = sprite_size.y
			RenderingServer.canvas_item_add_texture_rect(Sprites.ci_rid[index], Rect2(Vector2.ZERO, sprite_size), Sprites.SpriteImage[index])
			var xform = Transform2D().translated(Vector2(-99999 - sprite_size.x / 2.0, -99999 - sprite_size.y / 2.0))
			RenderingServer.canvas_item_set_transform(Sprites.ci_rid[index], xform)

			if (index == 0):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 999999999)
			elif (index == 2):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 500)
			elif (index == 10):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -25)
			elif (index == 130):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -100)
			elif (index > 39 && index < 49):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -10)
			elif (index > 49 && index < 129):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -3)
			elif (index > 139 && index < 150):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -5)
			elif (index == 170):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -20)
			elif (index == 171):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -15)
			elif (index == 172):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -10)
			elif (index == 173):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -5)
			elif (index > 9999 and index < 19980):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -2)
			elif (index > 19999 and index < 36000):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 0)
			elif (index > 35999 and index < 37000):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 1)
			elif (index == 131):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -99999)
			elif (index == 132):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 1)
			elif (index == 134):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 1)
			elif (index == 135):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 250)
			elif (index == 19980):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 100)
			elif (index == 3000):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 999998)
			elif (index > 3000 and index < 3010):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 3)
			elif (index == 3010):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 5)
			elif (index == 5000):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 9999)
			elif (index == 20000):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 600)

	FontTTF.append(-1)
	FontTTF[0] = load("res://media/fonts/FNT_01.ttf")
	FontTTF.append(-1)
	FontTTF[1] = load("res://media/fonts/FNT_02.ttf")
	TextCurrentIndex = 0

	AboutTextsStartIndex = 0
	AboutTextsEndIndex = 0

	RenderingServer.canvas_item_set_transform(Sprites.ci_rid[60], Transform2D().scaled(Vector2(2.845, 1.0)))#xform)

	RenderingServer.canvas_item_set_modulate(Sprites.ci_rid[60], Color(1.0, 1.0, 1.0, 0.4))

	sprite_size = Sprites.SpriteImage[60].get_size()
	RenderingServer.canvas_item_set_transform(Sprites.ci_rid[60], Transform2D().translated(Vector2(-99999 - sprite_size.x / 2.0, -99999 - sprite_size.y / 2.0)))

	RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[60], 1000)
	
	DrawSprite(0, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
	FramesPerSecondText.TextImage.append(RichTextLabel.new())
	add_child(FramesPerSecondText.TextImage[0])
	var fontToUseIndex = 1
	var fontSize = 26

	FramesPerSecondText.TextImage[0].text = "30/30"
	FramesPerSecondText.TextImage[0].set_use_bbcode(false)

	FramesPerSecondText.TextImage[0].clip_contents = false
	FramesPerSecondText.TextImage[0].add_theme_font_override("normal_font", FontTTF[fontToUseIndex])
	FramesPerSecondText.TextImage[0].add_theme_font_size_override("normal_font_size", fontSize)
	FramesPerSecondText.TextImage[0].add_theme_color_override("default_color", Color(1.0, 1.0, 1.0, 1.0))
	FramesPerSecondText.TextImage[0].add_theme_constant_override("outline_size", 15.0)
	FramesPerSecondText.TextImage[0].add_theme_color_override("font_outline_color", Color(0.2, 0.2, 0.2, 1.0))

	var textHeight = FramesPerSecondText.TextImage[0].get_theme_font("normal_font").get_string_size(FramesPerSecondText.TextImage[0].text).y

	FramesPerSecondText.TextImage[0].global_position.x = 1
	FramesPerSecondText.TextImage[0].global_position.y = 600+7
	FramesPerSecondText.TextImage[0].set_size(Vector2(VisualsCore.ScreenWidth, VisualsCore.ScreenHeight), false)
	FramesPerSecondText.TextImage[0].pivot_offset = Vector2((VisualsCore.ScreenWidth / 2.0), (textHeight / 2.0))
	FramesPerSecondText.TextImage[0].scale = Vector2(1.0, 1.0)
	FramesPerSecondText.TextImage[0].rotation = 0.0

	FullScreenMode = false

	pass

#----------------------------------------------------------------------------------------
func SetFramesPerSecond(fpsValue):
	Engine.max_fps = fpsValue

	pass

#----------------------------------------------------------------------------------------
func SetFullScreenMode():
	if (FullScreenMode == true):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
	elif (FullScreenMode == false):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)

	pass

#----------------------------------------------------------------------------------------
# Godot Version 3.5 To 4.0 Conversion By: "flairetic":
func SetScreenStretchMode():
	var window = get_tree().root 
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	if (VisualsCore.KeepAspectRatio == 1):
		window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_WIDTH
	elif (VisualsCore.KeepAspectRatio == 0):
		window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE

	pass
#                                   Godot Version 3.5 To 4.0 Conversion By: "flairetic"
#----------------------------------------------------------------------------------------
func MoveAllActiveSpritesOffScreen():
	for index in range(1, 20001):
		if Sprites.SpriteActive[index] == true:
			var sprite_size = Sprites.SpriteImage[index].get_size()
			RenderingServer.canvas_item_set_transform(Sprites.ci_rid[index], Transform2D().translated(Vector2(-99999 - sprite_size.x / 2.0, -99999 - sprite_size.y / 2.0)))

	pass

#----------------------------------------------------------------------------------------
# Godot Version 3.5 To 4.0 Conversion By: "flairetic":
func DrawSprite(index, x, y, scaleX, scaleY, rotationDegree, red, green, blue, alpha):
	var sprite_size = Sprites.SpriteImage[index].get_size()
	sprite_size.x = sprite_size.x * scaleX
	sprite_size.y = sprite_size.y * scaleY
	RenderingServer.canvas_item_set_transform(Sprites.ci_rid[index], Transform2D(rotationDegree, Vector2(scaleX, scaleY), 0.0, Vector2(x - (sprite_size.x / 2.0), y - (sprite_size.y / 2.0))))

	RenderingServer.canvas_item_set_modulate(Sprites.ci_rid[index], Color(red, green, blue, alpha))

	Sprites.SpriteActive[index] = true
	Sprites.SpriteScreenX[index] = x
	Sprites.SpriteScreenY[index] = y
	Sprites.SpriteScaleX[index] = scaleX
	Sprites.SpriteScaleY[index] = scaleY
	Sprites.SpriteRotation[index] = rotationDegree
	Sprites.SpriteColorRed[index] = red
	Sprites.SpriteColorGreen[index] = green
	Sprites.SpriteColorBlue[index] = blue
	Sprites.SpriteColorAlpha[index] = alpha

	pass

#                                   Godot Version 3.5 To 4.0 Conversion By: "flairetic"
#----------------------------------------------------------------------------------------
func DeleteAllTexts():
	var size = (TextCurrentIndex - 1)

	for index in range(size, 9, -1):
		if (TextIsUsed[index] == true):
			remove_child(Texts.TextImage[index])

	for _index in range(0, TextCurrentIndex):
		TextIsUsed[_index] = false

	TextCurrentIndex = 10

	pass

#----------------------------------------------------------------------------------------
func DrawnTextChangeScaleRotation(index, scaleX, scaleY, rotations):
	var textHeight = Texts.TextImage[index].get_theme_font("normal_font").get_string_size(Texts.TextImage[index].text).y
	Texts.TextImage[index].pivot_offset = Vector2((VisualsCore.ScreenWidth / 2.0), (textHeight / 2.0))

	Texts.TextImage[index].scale = Vector2(scaleX, scaleY)
	Texts.TextImage[index].rotation = rotations

	pass

#----------------------------------------------------------------------------------------
# Godot Version 3.5 To 4.0 Conversion By: "flairetic":
func DrawText(index, text, x, y, horizontalJustification, fontToUseIndex, fontSize, scaleX, scaleY, rotations, red, green, blue, alpha, outlineRed, outlineGreen, outlineBlue):
	if ( index > (TextCurrentIndex-1) ):
		Texts.TextImage.append(RichTextLabel.new())
		add_child(Texts.TextImage[index])
		TextIsUsed[index] = true

	var xValue = x
#
	if horizontalJustification == 0:
		Texts.TextImage[index].text = text
		Texts.TextImage[index].set_use_bbcode(false)
	elif horizontalJustification == 1:
		Texts.TextImage[index].text = "[center]"+text+"[/center]"
		Texts.TextImage[index].set_use_bbcode(true)
	elif horizontalJustification == 2:
		Texts.TextImage[index].text = "[right]"+text+"[/right]"
		Texts.TextImage[index].set_use_bbcode(true)
	elif horizontalJustification == 4:
		Texts.TextImage[index].text = text
		Texts.TextImage[index].set_use_bbcode(false)

		var textWidth = Texts.TextImage[index].get_theme_font("normal_font").get_string_size(Texts.TextImage[index].text).x
		xValue = x - (textWidth/2)

	Texts.TextImage[index].clip_contents = false
	Texts.TextImage[index].add_theme_font_override("normal_font", FontTTF[fontToUseIndex])
	Texts.TextImage[index].add_theme_font_size_override("normal_font_size", fontSize)
	Texts.TextImage[index].add_theme_color_override("default_color", Color(red, green, blue, alpha))
	Texts.TextImage[index].add_theme_constant_override("outline_size", 15.0)
	Texts.TextImage[index].add_theme_color_override("font_outline_color", Color(outlineRed, outlineGreen, outlineBlue, alpha)) 

	var textHeight = Texts.TextImage[index].get_theme_font("normal_font").get_string_size(Texts.TextImage[index].text).y

	Texts.TextImage[index].global_position.x = xValue#x
	Texts.TextImage[index].global_position.y = ( y - (textHeight / 2) )
	Texts.TextImage[index].set_size(Vector2(VisualsCore.ScreenWidth, VisualsCore.ScreenHeight), false)
	Texts.TextImage[index].pivot_offset = Vector2((VisualsCore.ScreenWidth / 2.0), (textHeight / 2.0))
	Texts.TextImage[index].scale = Vector2(scaleX, scaleY)
	Texts.TextImage[index].rotation = rotations

	Texts.TextIndex.append(index)
	Texts.TextScreenX.append(x)
	Texts.TextScreenY.append(y)
	Texts.TextHorizontalJustification.append(horizontalJustification)
	Texts.TextSize.append(fontSize)
	Texts.TextScaleX.append(scaleX)
	Texts.TextScaleY.append(scaleY)
	Texts.TextRotation.append(rotations)
	Texts.TextColorRed.append(red)
	Texts.TextColorGreen.append(green)
	Texts.TextColorBlue.append(blue)
	Texts.TextColorAlpha.append(alpha)
	Texts.TextOutlineRed.append(outlineRed)
	Texts.TextOutlineGreen.append(outlineGreen)
	Texts.TextOutlineBlue.append(outlineBlue)

	if ( index > (TextCurrentIndex-1) ):
		TextCurrentIndex+=1

	return(TextCurrentIndex-1)

#                                   Godot Version 3.5 To 4.0 Conversion By: "flairetic"
#----------------------------------------------------------------------------------------
func AddAboutScreenText(text, blue):
	AboutTexts.AboutTextsText.append(text)
	AboutTexts.AboutTextsBlue.append(blue)

	AboutTextsEndIndex+=1

	pass

#----------------------------------------------------------------------------------------
func LoadAboutScreenTexts():
	AboutTextsStartIndex = 10
	AboutTextsEndIndex = AboutTextsStartIndex

	AddAboutScreenText("TM", 0.0)

	AddAboutScreenText(" ", 0.0)

	AddAboutScreenText("''NumbersFall 110%™''", 0.0)

	AddAboutScreenText(LogicCore.Version, 1.0)

	AddAboutScreenText("Copyright 2026 By:", 1.0)
	AddAboutScreenText("TeamJeZxLee.itch.io", 1.0)

	AddAboutScreenText("Original Concept By:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("Video Game Made Possible By Our Mentors:", 0.0)
	AddAboutScreenText("Garry Kitchen", 1.0)
	AddAboutScreenText("Andre' LaMothe", 1.0)

	AddAboutScreenText("Made With 100% FREE:", 0.0)
	AddAboutScreenText("''Godot Game Engine''", 1.0)
	AddAboutScreenText(DataCore.GODOT_VERSION, 1.0)
	AddAboutScreenText("[GodotEngine.org]", 1.0)

	AddAboutScreenText("''Godot Game Engine'' Recommended By:", 0.0)
	AddAboutScreenText("''Yuri S.''", 1.0)

	AddAboutScreenText("Game Built On:", 0.0)
	AddAboutScreenText("Genuine ''Linux Mint Cinnamon 64Bit'' Linux OS", 1.0)
	AddAboutScreenText("[LinuxMint.com]", 1.0)
	AddAboutScreenText("Real Programmers Use Linux!", 1.0)

	AddAboutScreenText("Project Produced By:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("Project Directed By:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("Godot "+ DataCore.GODOT_VERSION + " 2-D Game Engine Framework:", 0.0)
	AddAboutScreenText("The ''Grand National GNX™'' v2 Engine By:", 1.0)
	AddAboutScreenText("JeZxLee", 1.0)
	AddAboutScreenText("''flairetic''", 1.0)

	AddAboutScreenText("Graphics Core(Texts/Sprites) Ported & Turbocharged By:", 0.0)
	AddAboutScreenText("''flairetic''", 1.0)

	AddAboutScreenText("Lead Game Designer:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("Lead Game Programmer:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("Lead Game Tester:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("P.E.M.D.A.S. Tiles To Equations Conversion By:", 0.0)
	AddAboutScreenText("''wchc''", 1.0)
	AddAboutScreenText("''kraasch''", 1.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("Support Game Programmers:", 0.0)
	AddAboutScreenText("''flairetic''", 1.0)
	AddAboutScreenText("''EvanR''", 1.0)
	AddAboutScreenText("''Daotheman''", 1.0)
	AddAboutScreenText("''theweirdn8''", 1.0)
	AddAboutScreenText("''mattmatteh''", 1.0)

	AddAboutScreenText("Director Of Quality Control:", 0.0)
	AddAboutScreenText("''ComicallyUnfunny''", 1.0)

	AddAboutScreenText("Story Comic Book Illustrator:", 0.0)
	AddAboutScreenText("''Studiorudi''", 1.0)
	AddAboutScreenText("For Hire Professional Graphic Artist On:", 1.0)
	AddAboutScreenText("[Fiverr.com]", 1.0)

	AddAboutScreenText("Lead Graphic Artist:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("Support Graphic Artist:", 0.0)
	AddAboutScreenText("''Oshi Bobo''", 1.0)

	AddAboutScreenText("Music Soundtrack By:", 0.0)
	AddAboutScreenText("Suno A.I. Created Music With Vocals[Paid]", 1.0)
	AddAboutScreenText("[Suno.com]", 1.0)

	AddAboutScreenText("Sound Effects Compiled & Edited By:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("''Neo's Kiss™'' Graphical User Interface By:", 0.0)
	AddAboutScreenText("JeZxLee", 1.0)

	AddAboutScreenText("PNG Graphics Edited In:", 0.0)
	AddAboutScreenText("Genuine ''PixelNEO'' For Windows", 1.0)
	AddAboutScreenText("[https://VisualNEO.com/product/pixelneo]", 1.0)
	AddAboutScreenText("- Free Linux Alternative: ''Krita'' -", 1.0)

	AddAboutScreenText("PNG Graphics Optimized Using:", 0.0)
	AddAboutScreenText("''TinyPNG''", 1.0)
	AddAboutScreenText("[TinyPNG.com]", 1.0)

	AddAboutScreenText("OGG Audio Edited In:", 0.0)
	AddAboutScreenText("Genuine ''GoldWave'' For Windows", 1.0)
	AddAboutScreenText("[GoldWave.com]", 1.0)
	AddAboutScreenText("- Free Linux Alternative: ''Audacity'' -", 1.0)

	AddAboutScreenText("OGG Audio Optimized Using:", 0.0)
	AddAboutScreenText("''OGGResizer''", 1.0)
	AddAboutScreenText("[SkyShape.com]", 1.0)

	AddAboutScreenText("''NumbersFall 110%™'' Logo Created In:", 0.0)
	AddAboutScreenText("Genuine Microsoft Office 2021 Professional Plus Publisher", 1.0)
	AddAboutScreenText("[Office.com]", 1.0)

	AddAboutScreenText("Game Created On A:", 0.0)
	AddAboutScreenText("Hyper-Custom ''JeZxLee'' Pro-Built Desktop", 1.0)
	AddAboutScreenText("Desktop Code Name: ''Megatron''", 1.0)
	AddAboutScreenText("Build Date: June 11th, 2022", 1.0)
	AddAboutScreenText("Genuine ''Linux Mint Cinnamon 64Bit'' Linux OS", 1.0)
	AddAboutScreenText("Silverstone Tek ATX Mid Tower Case", 1.0)
	AddAboutScreenText("EVGA Supernova 650 GT 80 Plus Gold 650W Power Supply", 1.0)
	AddAboutScreenText("Asus AM4 TUF Gaming X570-Plus [Wi-Fi] Motherboard", 1.0)
	AddAboutScreenText("AMD Ryzen 7 5800X[4.7GHz Turbo] 8-Core CPU", 1.0)
	AddAboutScreenText("Noctua NH-U12S chromax.Black 120mm CPU Cooler", 1.0)
	AddAboutScreenText("Corsair Vengeance LPX 32GB[2X16GB] DDR4 3200MHz RAM Memory", 1.0)
	AddAboutScreenText("MSI Gaming nVidia GeForce RTX 3060 12GB GDDR6 OC GPU", 1.0)
	AddAboutScreenText("Samsung 980 PRO 2TB PCIe NVMe Gen 4 M.2 Drive", 1.0)
	AddAboutScreenText("Seagate FireCuda 4TB 3.5 Inch Hard Drive", 1.0)

	AddAboutScreenText("HTML5 Version Tested On (Windows/Linux/macOS):", 0.0)
	AddAboutScreenText("Mozilla Firefox", 1.0)
	AddAboutScreenText("Google Chrome", 1.0)
	AddAboutScreenText("Opera", 1.0)
	AddAboutScreenText("Microsoft Edge", 1.0)
	AddAboutScreenText("Apple macOS Safari", 1.0)

	AddAboutScreenText("Big Thank You To People Who Helped Us:", 0.0)
	AddAboutScreenText("''Yuri S.''", 1.0)
	AddAboutScreenText("''TwistedTwigleg''", 1.0)
	AddAboutScreenText("''Megalomaniak''", 1.0)
	AddAboutScreenText("''SIsilicon28''", 1.0)
	AddAboutScreenText("''vimino''", 1.0)
	AddAboutScreenText("( : ''PurpleConditioner'' : )", 1.0)
	AddAboutScreenText("''Kequc''", 1.0)
	AddAboutScreenText("''qeed''", 1.0)
	AddAboutScreenText("''Calinou''", 1.0)
	AddAboutScreenText("''Sosasees''", 1.0)
	AddAboutScreenText("''ArRay_''", 1.0)
	AddAboutScreenText("''blast007''", 1.0)
	AddAboutScreenText("''fogobogo''", 1.0)
	AddAboutScreenText("''CYBEREALITY''", 1.0)
	AddAboutScreenText("''Perodactyl''", 1.0)
	AddAboutScreenText("''floatcomplex''", 1.0)
	AddAboutScreenText("''DaveTheCoder''", 1.0)
	AddAboutScreenText("''Dominus''", 1.0)
	AddAboutScreenText("''lawnjelly''", 1.0)
	AddAboutScreenText("''EvanR''", 1.0)
	AddAboutScreenText("''Zelta''", 1.0)
	AddAboutScreenText("''slidercrank''", 1.0)
	AddAboutScreenText("''epicspaces''", 1.0)
	AddAboutScreenText("''powersnap55''", 1.0)
	AddAboutScreenText("''cybereality''", 1.0)
	AddAboutScreenText("''Unforgiven''", 1.0)
	AddAboutScreenText("''Neil Kenneth David''", 1.0)
	AddAboutScreenText("''gioele''", 1.0)
	AddAboutScreenText("''TatBou''", 1.0)
	AddAboutScreenText("''fire7side''", 1.0)
	AddAboutScreenText("''YaroslavFox''", 1.0)
	AddAboutScreenText("''Erich_L''", 1.0)
	AddAboutScreenText("''Zoinkers''", 1.0)
	AddAboutScreenText("''Sanne''", 1.0)
	AddAboutScreenText("''circuitbone''", 1.0)
	AddAboutScreenText("''duane''", 1.0)	
	AddAboutScreenText("''Pixophir''", 1.0)
	AddAboutScreenText("''Zireael''", 1.0)
	AddAboutScreenText("''Kojack''", 1.0)
	AddAboutScreenText("''akien-mga''", 1.0)
	AddAboutScreenText("''Valedict''", 1.0)
	AddAboutScreenText("''Aliencodex''", 1.0)
	AddAboutScreenText("''leonardus''", 1.0)
	AddAboutScreenText("''Donitz''", 1.0)
	AddAboutScreenText("''furrykef''", 1.0)
	AddAboutScreenText("''Remi Verschelde''", 1.0)
	AddAboutScreenText("''Xananax''", 1.0)
	AddAboutScreenText("''Adam Scott''", 1.0)
	AddAboutScreenText("''sslcon[m]''", 1.0)
	AddAboutScreenText("''TheRookie''", 1.0)
	AddAboutScreenText("''CuffLimbs''", 1.0)
	AddAboutScreenText("''zleap''", 1.0)
	AddAboutScreenText("''tibaverus''", 1.0)
	AddAboutScreenText("''secretagent''", 1.0)
	AddAboutScreenText("''DeanOrTori''", 1.0)
	AddAboutScreenText("''Ejsstiil''", 1.0)
	AddAboutScreenText("''gertkeno''", 1.0)
	AddAboutScreenText("''dragonforge-dev''", 1.0)
	AddAboutScreenText("''wchc''", 1.0)
	AddAboutScreenText("''kraasch''", 1.0)
	AddAboutScreenText("''normalized''", 1.0)
	AddAboutScreenText("''justin_Creative''", 1.0)
	AddAboutScreenText("''ChezBergur''", 1.0)
	AddAboutScreenText("''paintsimmon''", 1.0)
	AddAboutScreenText("''hyvernox''", 1.0)
	AddAboutScreenText("''TokyoFunkScene''", 1.0)

	AddAboutScreenText(" ", 1.0)
	AddAboutScreenText("''You!''", 1.0)

	AddAboutScreenText("A 110% By TeamJeZxLee.Itch.io !", 0.0)
	AddAboutScreenText(" ", 1.0)

	DrawText(AboutTextsStartIndex, AboutTexts.AboutTextsText[AboutTextsStartIndex], ((ScreenWidth/2.0)+100.0), ScreenHeight+25, 1, 1, 30, 1.0, 1.0, 0, 1.0, 1.0, AboutTexts.AboutTextsBlue[AboutTextsStartIndex-10], 0.0, 0.0, 0.0, 0.0)

	var screenY = ScreenHeight-300
	for index in range(AboutTextsStartIndex+1, AboutTextsEndIndex):
		if (AboutTexts.AboutTextsBlue[index-10] == 1.0 && AboutTexts.AboutTextsBlue[index-1-10] == 0.0):
			screenY+=50
		elif (AboutTexts.AboutTextsBlue[index-10] == 1.0 && AboutTexts.AboutTextsBlue[index-1-10] == 1.0):
			screenY+=50
		else:
			screenY+=180

		DrawText(index, AboutTexts.AboutTextsText[index-10], 0, screenY, 1, 1, 30, 1.0, 1.0, 0, 1.0, 1.0, AboutTexts.AboutTextsBlue[index-10], 1.0, 0.0, 0.0, 0.0)

	Texts.TextImage[AboutTextsEndIndex-2].global_position.y+=(ScreenHeight/2.0)
	Texts.TextImage[AboutTextsEndIndex-1].global_position.y+=(ScreenHeight/2.0)

	pass
