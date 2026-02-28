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

# "ScreensCore.gd"
extends Node2D

var ItchBuild = false

var VideoHTML5 = false
var VideoAndroid = false

var SeeEndingStaff = false

var OptionsTextMusicVol
var OptionsTextEffectsVol
var OptionsTextAspectRatio
var OptionsTextGamepads
var OptionsTextGameMode
var OptionsTextCompPlayers
var OptionsTextCompPlayersSys
var OptionsTextCodeOne
var OptionsTextCodeTwo
var OptionsTextCodeThree
var OptionsTextCodeFour

var OptionsTextUndoAction

var OptionsTextRightMouseButtonAction

const FadingIdle			= -1
const FadingFromBlack		= 0
const FadingToBlack			= 1
var ScreenFadeStatus
var ScreenFadeTransparency

var ScreenDisplayTimer

const HTML5Screen			= -1
const GodotScreen			= 0
const FASScreen				= 1
const TitleScreen			= 2
const OptionsScreen			= 3
const HowToPlayScreen		= 4
const HighScoresScreen		= 5
const AboutScreen			= 6
const MusicTestScreen		= 7
const PlayingGameScreen		= 8
const CutSceneScreen		= 9
const NewHighScoreScreen	= 10
const WonGameScreen			= 11
const InputScreen			= 12

var ScreenToDisplay
var ScreenToDisplayNext

const OSDesktop				= 1
const OSHTMLFive			= 2
const OSAndroid				= 3
var OperatingSys 			= 0

var TS1ScreenY

var DemoTextIndex
var DemoRotation
var DemoRotationDirection

var StaffScreenTSOneScale

var CutSceneTextIndex = []
var CutSceneTextScale = []
var CutSceneTextScaleIndex

var CutSceneScene
var CutSceneSceneTotal = []

var NewHighScoreString = " "
var NewHighScoreStringIndex

var videostream = VideoStreamTheora.new()
var videoplayer = VideoStreamPlayer.new()

var NewHighScoreNameInputJoyX
var NewHighScoreNameInputJoyY

const JoySetupNotStarted		= 0
const JoySetup1Up				= 1
const JoySetup1Down				= 2
const JoySetup1Left				= 3
const JoySetup1Right			= 4
const JoySetup1Button1			= 5
const JoySetup1Button2			= 6
const JoySetup2Up				= 7
const JoySetup2Down				= 8
const JoySetup2Left				= 9
const JoySetup2Right			= 10
const JoySetup2Button1			= 11
const JoySetup2Button2			= 12
const JoySetup3Up				= 13
const JoySetup3Down				= 14
const JoySetup3Left				= 15
const JoySetup3Right			= 16
const JoySetup3Button1			= 17
const JoySetup3Button2			= 18
var JoystickSetupIndex = JoySetupNotStarted

var WonSunsetY
var WonHimX
var WonHerX

var P1ScoreText
var P2ScoreText
var P3ScoreText
var LevelText

var fps = []

var TSOneDisplayTimer

var DontDisplayJoinIn

var JoinInFlash

var TitleScreenOldMusicVol
var TitleScreenOldEffectsVol

var CutSceneClickTextFlash

#----------------------------------------------------------------------------------------
func _ready():
	ScreenFadeStatus = FadingFromBlack
	ScreenFadeTransparency = 1.0

	ScreenToDisplay = GodotScreen

	if (OS.get_name() == "Windows" or OS.get_name() == "Linux"):
		OperatingSys = OSDesktop
	elif OS.get_name() == "Web":
		OperatingSys = OSHTMLFive
	elif OS.get_name() == "Android":
		OperatingSys = OSAndroid

	if (OperatingSys == OSHTMLFive):
		ScreenToDisplay = TitleScreen
		AudioCore.PlayMusic(0, true)
		AudioCore.PlayEffect(2)

	if (VideoAndroid == true):
		OperatingSys = OSAndroid

	var _warnErase = CutSceneTextIndex.resize(7)
	_warnErase = CutSceneTextScale.resize(7)
	CutSceneTextScale[0] = 0.0
	CutSceneTextScale[1] = 0.0
	CutSceneTextScale[2] = 0.0
	CutSceneTextScale[3] = 0.0
	CutSceneTextScale[4] = 0.0
	CutSceneTextScale[5] = 0.0
	CutSceneTextScale[6] = 0.0
	CutSceneTextScaleIndex = 0

	_warnErase = CutSceneSceneTotal.resize(10)
	CutSceneSceneTotal[1] = 1
	CutSceneSceneTotal[2] = 2
	CutSceneSceneTotal[3] = 2
	CutSceneSceneTotal[4] = 1
	CutSceneSceneTotal[5] = 3
	CutSceneSceneTotal[6] = 4
	CutSceneSceneTotal[7] = 1
	CutSceneSceneTotal[8] = 3
	CutSceneSceneTotal[9] = 1

	_warnErase = fps.resize(8)
	fps[0] = 20
	fps[2] = 45
	fps[1] = 30
	fps[3] = 60
	fps[4] = 20
	fps[6] = 45
	fps[5] = 30
	fps[7] = 60

	TitleScreenOldMusicVol = -1
	TitleScreenOldEffectsVol = -1

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass

#----------------------------------------------------------------------------------------
func ApplyScreenFadeTransition():
	if ScreenFadeStatus == FadingIdle: return
	
	if ScreenFadeStatus == FadingFromBlack:
		if ScreenFadeTransparency > 0.25:
			ScreenFadeTransparency-=0.25
		else:
			ScreenFadeTransparency = 0.0
			ScreenFadeStatus = FadingIdle
	elif ScreenFadeStatus == FadingToBlack:
		if ScreenFadeTransparency < 0.75:
			ScreenFadeTransparency+=0.25
		else:
			ScreenFadeTransparency = 1.0
			ScreenFadeStatus = FadingFromBlack
			
			VisualsCore.MoveAllActiveSpritesOffScreen()
			VisualsCore.DeleteAllTexts()
			InterfaceCore.DeleteAllGUI()
			InterfaceCore.InitializeGUI(false)

			ScreenToDisplay = ScreenToDisplayNext

	RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[0], Color(1.0, 1.0, 1.0, ScreenFadeTransparency))

	pass

#----------------------------------------------------------------------------------------
func DisplayHTML5Screen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		InterfaceCore.CreateIcon(129, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0), " ")

		ScreenToDisplayNext = GodotScreen
		ScreenFadeStatus = FadingToBlack

		ScreenDisplayTimer = 100

	if InterfaceCore.ThisIconWasPressed(0, -1) == true:
		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 20

	if ScreenDisplayTimer == 1:
		ScreenToDisplayNext = GodotScreen
		ScreenFadeStatus = FadingToBlack
		ScreenDisplayTimer = -1
		if InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed:  AudioCore.PlayEffect(1)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = GodotScreen
		InputCore.DelayAllUserInput = 15

	pass

#----------------------------------------------------------------------------------------
func DisplayGodotScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		if (ScreensCore.OperatingSys == OSHTMLFive):
			if (InputCore.HTML5input == InputCore.InputTouchOne):
				var window: Window = get_tree().get_root()
				window.mode = Window.Mode.MODE_FULLSCREEN

		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(5, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, DataCore.GODOT_VERSION, 445+10, 185+20+15-5-14, 0, 1, 35, 1.0, 1.0, 0, 0.7, 0.7, 0.7, 1.0, 0.9, 0.9, 0.9)

		ScreenDisplayTimer = (120*2)

		if (VideoHTML5 == true or VideoAndroid == true):
			ScreenDisplayTimer+=2000

	if (InputCore.DelayAllUserInput == -1 && (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed)) && ScreenDisplayTimer > 1:
		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 20

	if 	ScreenDisplayTimer > 1:
		ScreenDisplayTimer-=1
	elif ScreenDisplayTimer == 1:
		ScreenToDisplayNext = FASScreen
		ScreenFadeStatus = FadingToBlack
		ScreenDisplayTimer = -1
		if InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed:  AudioCore.PlayEffect(1)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = TitleScreen
		AudioCore.PlayEffect(2)
		AudioCore.PlayMusic(0, true)
		InputCore.DelayAllUserInput = 15

	pass

#----------------------------------------------------------------------------------------
func DisplayFASScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:

		RenderingServer.set_default_clear_color(Color(0.1, 0.1, 0.1, 1.0))

		VisualsCore.DrawSprite(7, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		ScreenDisplayTimer = (160*2)

	if (InputCore.DelayAllUserInput == -1 && (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed)) && ScreenDisplayTimer > 1:
		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 15

	if 	ScreenDisplayTimer > 1:
		ScreenDisplayTimer-=1
	elif ScreenDisplayTimer == 1:
		ScreenToDisplayNext = TitleScreen
		ScreenFadeStatus = FadingToBlack
		ScreenDisplayTimer = -1
		if InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed:  AudioCore.PlayEffect(1)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = TitleScreen
		InputCore.DelayAllUserInput = 15

		AudioCore.PlayMusic(0, true)

	pass

#----------------------------------------------------------------------------------------
func DisplayTitleScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		DataCore.SaveOptionsAndHighScores()
		
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "  Learn To Have Fun!™", 0, 12+2+8-15-3, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		if (AudioCore.MusicVolume == 0.0 && AudioCore.EffectsVolume == 0.0):
			InterfaceCore.CreateIcon(110, 40, 40, " ")
		else:
			InterfaceCore.CreateIcon(111, 40, 40, " ")

		InterfaceCore.CreateIcon(117, VisualsCore.ScreenWidth-40, 40, " ")

		if (OperatingSys != OSAndroid):
			VisualsCore.DrawSprite(20, VisualsCore.ScreenWidth/2.0, 107.0, 1.5, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		elif (OperatingSys == OSAndroid):
			VisualsCore.DrawSprite(20, VisualsCore.ScreenWidth/2.0, 107.0, 1.5, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 150+45-10, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		var highScoreFullText
		highScoreFullText = "''"+DataCore.HighScoreName[LogicCore.GameMode][0]+"'' Scored: "+str(DataCore.HighScoreScore[LogicCore.GameMode][0])
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, highScoreFullText, 0, 170+35+15-12-15, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(31, VisualsCore.ScreenWidth/2.0, 194+35+20-20, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		if (OperatingSys != OSAndroid):
			RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[15], Color(1.0, 1.0, 1.0, 1.0))
		else:
			RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[26], Color(1.0, 1.0, 1.0, 1.0))

		var buttonY = 223+70-10-14
		var buttonOffsetY = 70
		InterfaceCore.CreateButton (0, (VisualsCore.ScreenWidth/2.0), (buttonY))
		buttonY+=buttonOffsetY
		InterfaceCore.CreateButton (1, (VisualsCore.ScreenWidth/2.0), (buttonY))
		buttonY+=buttonOffsetY
		InterfaceCore.CreateButton (2, (VisualsCore.ScreenWidth/2.0), (buttonY))
		buttonY+=buttonOffsetY
		InterfaceCore.CreateButton (3, (VisualsCore.ScreenWidth/2.0), (buttonY))
		buttonY+=buttonOffsetY
		InterfaceCore.CreateButton (4, (VisualsCore.ScreenWidth/2.0), (buttonY))
		buttonY+=buttonOffsetY

		VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 602-15+18, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		if (LogicCore.HideCopyright == false):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "(C)2026 By TeamJeZxLee.Itch.io", 0, 640-19-4-15+10, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.HideCopyright == true):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "(C)2026 By SavantSavior.Itch.io", 0, 640-19-4-15+10, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, LogicCore.Version, 10, VisualsCore.ScreenHeight-15, 0, 1, 15, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		InterfaceCore.ArrowSetSelectedByKeyboardLast = -1

		for index in range(20):
			for indexTwo in range(999):
				RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[(20000+indexTwo) + (1000*index)], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(-99999, -99999)))

		LogicCore.GameWon = false

		if (LogicCore.SecretCodeCombined == 5432 or LogicCore.SecretCodeCombined == 5431):
			InterfaceCore.CreateIcon( 190, 40, (110), " " )

	if InterfaceCore.ThisIconWasPressed(0, -1) == true:
		if (AudioCore.MusicVolume == 0.0 && AudioCore.EffectsVolume == 0.0):
			if (TitleScreenOldMusicVol == -1):
				AudioCore.MusicVolume = 1.0
			else:
				AudioCore.MusicVolume = TitleScreenOldMusicVol

			if (TitleScreenOldEffectsVol == -1):
				AudioCore.EffectsVolume = 0.5
			else:
				AudioCore.EffectsVolume = TitleScreenOldEffectsVol

			RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[110], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(-99999, -99999)))
			InterfaceCore.Icons.IconSprite[0]  = 111
		else:
			TitleScreenOldMusicVol =AudioCore.MusicVolume
			AudioCore.MusicVolume = 0.0

			TitleScreenOldEffectsVol = AudioCore.EffectsVolume
			AudioCore.EffectsVolume = 0.0

			RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[111], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(-99999, -99999)))
			InterfaceCore.Icons.IconSprite[0]  = 110
			
		AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		DataCore.SaveOptionsAndHighScores()
	elif InterfaceCore.ThisIconWasPressed(1, -1) == true:
		DataCore.SaveOptionsAndHighScores()
		if OperatingSys == OSDesktop || OperatingSys == OSAndroid:
			get_tree().quit()
	elif ( (LogicCore.SecretCodeCombined == 5432 || LogicCore.SecretCodeCombined == 5431) and InterfaceCore.ThisIconWasPressed(2, -1) == true ):
		ScreenToDisplayNext = MusicTestScreen
		ScreenFadeStatus = FadingToBlack
	#
		if AudioCore.MusicVolume == 0.0:
			AudioCore.MusicVolume = 0.5
			AudioCore.EffectsVolume = 0.5
			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
			AudioCore.PlayMusic(0, true)

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		LogicCore.SetupForNewGame()
		ScreenToDisplayNext = PlayingGameScreen
		if (LogicCore.GameMode < 4):  AudioCore.PlayMusic(1, true)
		else:  AudioCore.PlayMusic(6, true)
		InputCore.MouseButtonLeftPressed = false
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(1) == true:
		ScreenToDisplayNext = OptionsScreen
		InputCore.OptionsInJoySetup = false
		JoystickSetupIndex = JoySetupNotStarted
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(2) == true:
		ScreenToDisplayNext = HowToPlayScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(3) == true:
		ScreenToDisplayNext = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(4) == true:
		ScreenToDisplayNext = AboutScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(5) == true:
		DataCore.SaveOptionsAndHighScores()
		if OperatingSys == OSDesktop || OperatingSys == OSAndroid:
			get_tree().quit()

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		InputCore.DelayAllUserInput = 15

	pass

#----------------------------------------------------------------------------------------
func DisplayInputScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		InterfaceCore.CreateIcon(180, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0)-160, " ")
		InterfaceCore.CreateIcon(181, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0)+160, " ")

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "CHOOSE YOUR INPUT!", 0, (VisualsCore.ScreenHeight/2.0)-40-9, 1, 1, 80, 1.0, 1.0, 0, 0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		ScreenDisplayTimer = 100

	if InterfaceCore.ThisIconWasPressed(0, -1) == true:
		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 20
	elif InterfaceCore.ThisIconWasPressed(1, -1) == true:
		VisualsCore.FullScreenMode = true
		VisualsCore.SetFullScreenMode()

		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 20

	if ScreenDisplayTimer == 1:
		ScreenToDisplayNext = GodotScreen
		ScreenFadeStatus = FadingToBlack
		ScreenDisplayTimer = -1
		if InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed:  AudioCore.PlayEffect(1)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = GodotScreen
		InputCore.DelayAllUserInput = 15

	pass

#----------------------------------------------------------------------------------------
func DisplayOptionsScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		if (JoystickSetupIndex == JoySetupNotStarted):
			VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.65)
	
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "O  P  T  I  O  N  S:", 0, 12-8, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30+8, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Music Volume:", 95, 51, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
	
			InterfaceCore.CreateArrowSet(0, 65)
			if AudioCore.MusicVolume == 1.0:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "100% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.75:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "75% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.5:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "50% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.25:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "25% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.0:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "0% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Sound Effects Volume:", 95, 51+50, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(1, 65+50)
			if AudioCore.EffectsVolume == 1.0:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "100% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.75:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "75% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.5:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "50% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.25:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "25% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.0:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "0% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Full Screen Mode:", 95, 51+50+50, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(2, 65+50+50)
			if (VisualsCore.FullScreenMode == true or OperatingSys == OSAndroid):
				OptionsTextAspectRatio = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "On", -95, 51+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.FullScreenMode == false):
				OptionsTextAspectRatio = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Off", -95, 51+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Screen Display Option:", 95, 51+50+50+50, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(6, 65+50+50+50)
			if (VisualsCore.KeepAspectRatio == 0):
				OptionsTextCompPlayersSys = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Stretch & Fill Screen", -95, 51+50+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.KeepAspectRatio == 1):
				OptionsTextCompPlayersSys = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Keep Aspect Ratio[Black Borders]", -95, 51+50+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawSprite(31, VisualsCore.ScreenWidth/2.0, 250, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Game Mode:", 95, 51+50+50+50+65-7+5, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(4, 70+50+50+50+65-7)
			if LogicCore.GameMode == LogicCore.ChildStoryMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Easy Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenStoryMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Hard Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultStoryMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Normal Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboStoryMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Very Hard Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.ChildNeverMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Easy Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenNeverMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Hard Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultNeverMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Normal Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboNeverMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Very Hard Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Undo Button Action:", 95, 70+50+50+50+65+50-14-13+2, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(5, 70+50+50+50+65+50-14+2)
			if LogicCore.UndoAction == 1:
				OptionsTextUndoAction = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Clear All Tiles", -95, 70+50+50+50+65+50-14-13+2, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.UndoAction == 0:
				OptionsTextUndoAction = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Clear One Tile At A Time", -95, 70+50+50+50+65+50-14-13+2, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Right Mouse Buttton Action:", 95, 70+50+50+50+65+50-14+50-2-14, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(5, 70+50+50+50+65+50-14+50-2)
			if LogicCore.EnableRightClick == 1:
				OptionsTextRightMouseButtonAction = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Clear One Tile", -95, 70+50+50+50+65+50-14+50-2-14, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.EnableRightClick == 0:
				OptionsTextRightMouseButtonAction = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Disabled", -95, 70+50+50+50+65+50-14+50-2-14, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 318+47+3+21+5, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Secret Code #1:", 95, 51+50+65+50+50+70+47+21+5, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(7, 70+50+65+50+50+70+47+21)
			OptionsTextCodeOne = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.SecretCode[0]), -95, 51+50+65+50+50+70+47+21+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Secret Code #2:", 95, 51+50+65+50+50+70+50+47+14+5, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(8, 70+50+65+50+50+70+50+47+14)
			OptionsTextCodeTwo = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.SecretCode[1]), -95, 51+50+65+50+50+70+50+47+14+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Secret Code #3:", 95, 51+50+65+50+50+70+50+50+47+7+5, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(9, 70+50+65+50+50+70+50+50+47+7)
			OptionsTextCodeThree = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.SecretCode[2]), -95, 51+50+65+50+50+70+50+50+47+7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Secret Code #4:", 95, 51+50+65+50+50+70+50+50+50+47+5, 0, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(10, 70+50+65+50+50+70+50+50+50+47)
			OptionsTextCodeFour = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.SecretCode[3]), -95, 51+50+65+50+50+70+50+50+50+47+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			DataCore.SaveOptionsAndHighScores()

			VisualsCore.DrawSprite(33, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
			InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25)
		elif (JoystickSetupIndex == JoySetup1Up):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [UP] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Down):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [DOWN] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Left):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [LEFT] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Right):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [RIGHT] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Button1):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 1] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Button2):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 2] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Up):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [UP] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Down):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [DOWN] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Left):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [LEFT] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Right):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [RIGHT] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Button1):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 1] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Button2):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 2] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Up):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [UP] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Down):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [DOWN] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Left):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [LEFT] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Right):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [RIGHT] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Button1):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 1] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Button2):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 2] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		if (JoystickSetupIndex > JoySetupNotStarted):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [F1] TO QUIT[Resetting Config]", 0.0, (VisualsCore.ScreenHeight/2.0)+75, 1, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [Esc] TO QUIT[Keeping Config]", 0.0, (VisualsCore.ScreenHeight/2.0)+75+45, 1, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if InputCore.DelayAllUserInput == -1 and Input.is_action_pressed("ConfigureJaoysticks"):
		InputCore.DelayAllUserInput = 50

		ScreenToDisplayNext = OptionsScreen
		ScreenFadeStatus = FadingToBlack

		if (InputCore.OptionsInJoySetup == false):
			JoystickSetupIndex = JoySetup1Up
			InputCore.OptionsInJoySetup = true
		else:
			JoystickSetupIndex =  JoySetupNotStarted
			InputCore.OptionsInJoySetup = false

			for index in range(0, 9):
				InputCore.JoyUpMapped[index][0] = 11+10
				InputCore.JoyDownMapped[index][0] = 12+10
				InputCore.JoyLeftMapped[index][0] = 13+10
				InputCore.JoyRightMapped[index][0] = 14+10
				InputCore.JoyButtonOneMapped[index][0] = 0+10
				InputCore.JoyButtonTwoMapped[index][0] = 1+10

		AudioCore.PlayEffect(2)

	if (JoystickSetupIndex == JoySetup1Up):
		if ( InputCore.GetJoystickInputForMapping(0, false) != -1):
			InputCore.JoyUpMapped[0][0] = InputCore.GetJoystickInputForMapping(0, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup1Down):
		if ( InputCore.GetJoystickInputForMapping(0, false) != -1):
			InputCore.JoyDownMapped[0][0] = InputCore.GetJoystickInputForMapping(0, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup1Left):
		if ( InputCore.GetJoystickInputForMapping(0, false) != -1):
			InputCore.JoyLeftMapped[0][0] = InputCore.GetJoystickInputForMapping(0, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup1Right):
		if ( InputCore.GetJoystickInputForMapping(0, false) != -1):
			InputCore.JoyRightMapped[0][0] = InputCore.GetJoystickInputForMapping(0, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup1Button1):
		if ( InputCore.GetJoystickInputForMapping(0, true) != -1):
			InputCore.JoyButtonOneMapped[0][0] = InputCore.GetJoystickInputForMapping(0, true)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup1Button2):
		if ( InputCore.GetJoystickInputForMapping(0, true) != -1):
			InputCore.JoyButtonTwoMapped[0][0] = InputCore.GetJoystickInputForMapping(0, true)
			AudioCore.PlayEffect(1)

			if ( Input.get_joy_name(1) != "" ):
				JoystickSetupIndex = JoySetup2Up
			else:
				JoystickSetupIndex = JoySetupNotStarted

			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
	elif (JoystickSetupIndex == JoySetup2Up):
		if ( InputCore.GetJoystickInputForMapping(1, false) != -1):
			InputCore.JoyUpMapped[1][0] = InputCore.GetJoystickInputForMapping(1, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup2Down):
		if ( InputCore.GetJoystickInputForMapping(1, false) != -1):
			InputCore.JoyDownMapped[1][0] = InputCore.GetJoystickInputForMapping(1, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup2Left):
		if ( InputCore.GetJoystickInputForMapping(1, false) != -1):
			InputCore.JoyLeftMapped[1][0] = InputCore.GetJoystickInputForMapping(1, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup2Right):
		if ( InputCore.GetJoystickInputForMapping(1, false) != -1):
			InputCore.JoyRightMapped[1][0] = InputCore.GetJoystickInputForMapping(1, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup2Button1):
		if ( InputCore.GetJoystickInputForMapping(1, true) != -1):
			InputCore.JoyButtonOneMapped[1][0] = InputCore.GetJoystickInputForMapping(1, true)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup2Button2):
		if ( InputCore.GetJoystickInputForMapping(1, true) != -1):
			InputCore.JoyButtonTwoMapped[1][0] = InputCore.GetJoystickInputForMapping(1, true)
			AudioCore.PlayEffect(1)

			if ( Input.get_joy_name(2) != "" ):
				JoystickSetupIndex = JoySetup3Up
			else:
				JoystickSetupIndex = JoySetupNotStarted

			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
	elif (JoystickSetupIndex == JoySetup3Up):
		if ( InputCore.GetJoystickInputForMapping(2, false) != -1):
			InputCore.JoyUpMapped[2][0] = InputCore.GetJoystickInputForMapping(2, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup3Down):
		if ( InputCore.GetJoystickInputForMapping(2, false) != -1):
			InputCore.JoyDownMapped[2][0] = InputCore.GetJoystickInputForMapping(2, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup3Left):
		if ( InputCore.GetJoystickInputForMapping(2, false) != -1):
			InputCore.JoyLeftMapped[2][0] = InputCore.GetJoystickInputForMapping(2, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup3Right):
		if ( InputCore.GetJoystickInputForMapping(2, false) != -1):
			InputCore.JoyRightMapped[2][0] = InputCore.GetJoystickInputForMapping(2, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup3Button1):
		if ( InputCore.GetJoystickInputForMapping(2, true) != -1):
			InputCore.JoyButtonOneMapped[2][0] = InputCore.GetJoystickInputForMapping(2, true)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1)
	elif (JoystickSetupIndex == JoySetup3Button2):
		if ( InputCore.GetJoystickInputForMapping(2, true) != -1):
			InputCore.JoyButtonTwoMapped[2][0] = InputCore.GetJoystickInputForMapping(2, true)
			AudioCore.PlayEffect(1)

			JoystickSetupIndex = JoySetupNotStarted

			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
	elif (JoystickSetupIndex == JoySetupNotStarted):
		if InterfaceCore.ThisArrowWasPressed(0) == true:
			if AudioCore.MusicVolume > 0.0:
				AudioCore.MusicVolume-=0.25
			else:  AudioCore.MusicVolume = 1.0
			
			if AudioCore.MusicVolume == 1.0:
				VisualsCore.DrawText(OptionsTextMusicVol, "100% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.75:
				VisualsCore.DrawText(OptionsTextMusicVol, "75% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.5:
				VisualsCore.DrawText(OptionsTextMusicVol, "50% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.25:
				VisualsCore.DrawText(OptionsTextMusicVol, "25% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.0:
				VisualsCore.DrawText(OptionsTextMusicVol, "0% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			
			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		elif InterfaceCore.ThisArrowWasPressed(0.5) == true:
			if AudioCore.MusicVolume < 1.0:
				AudioCore.MusicVolume+=0.25
			else:  AudioCore.MusicVolume = 0.0
			
			if AudioCore.MusicVolume == 1.0:
				VisualsCore.DrawText(OptionsTextMusicVol, "100% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.75:
				VisualsCore.DrawText(OptionsTextMusicVol, "75% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.5:
				VisualsCore.DrawText(OptionsTextMusicVol, "50% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.25:
				VisualsCore.DrawText(OptionsTextMusicVol, "25% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.0:
				VisualsCore.DrawText(OptionsTextMusicVol, "0% Volume", -95, 51, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		elif InterfaceCore.ThisArrowWasPressed(1.0) == true:
			if AudioCore.EffectsVolume > 0.0:
				AudioCore.EffectsVolume-=0.25
			else:  AudioCore.EffectsVolume = 1.0
			
			if AudioCore.EffectsVolume == 1.0:
				VisualsCore.DrawText(OptionsTextEffectsVol, "100% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.75:
				VisualsCore.DrawText(OptionsTextEffectsVol, "75% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.5:
				VisualsCore.DrawText(OptionsTextEffectsVol, "50% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.25:
				VisualsCore.DrawText(OptionsTextEffectsVol, "25% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.0:
				VisualsCore.DrawText(OptionsTextEffectsVol, "0% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		elif InterfaceCore.ThisArrowWasPressed(1.5) == true:
			if AudioCore.EffectsVolume < 1.0:
				AudioCore.EffectsVolume+=0.25
			else:  AudioCore.EffectsVolume = 0.0

			if AudioCore.EffectsVolume == 1.0:
				VisualsCore.DrawText(OptionsTextEffectsVol, "100% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.75:
				VisualsCore.DrawText(OptionsTextEffectsVol, "75% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.5:
				VisualsCore.DrawText(OptionsTextEffectsVol, "50% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.25:
				VisualsCore.DrawText(OptionsTextEffectsVol, "25% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.0:
				VisualsCore.DrawText(OptionsTextEffectsVol, "0% Volume", -95, 51+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			
			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		elif InterfaceCore.ThisArrowWasPressed(2.0) == true and OperatingSys != OSAndroid:
			if VisualsCore.FullScreenMode == true:
				VisualsCore.FullScreenMode = false
			else:  VisualsCore.FullScreenMode = true

			VisualsCore.SetFullScreenMode()

			if (VisualsCore.FullScreenMode == true):
				VisualsCore.DrawText(OptionsTextAspectRatio, "On", -95, 51+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.FullScreenMode == false):
				VisualsCore.DrawText(OptionsTextAspectRatio, "Off", -95, 51+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(2.5) == true and OperatingSys != OSAndroid:
			if VisualsCore.FullScreenMode == false:
				VisualsCore.FullScreenMode = true
			else:  VisualsCore.FullScreenMode = false

			VisualsCore.SetFullScreenMode()

			if (VisualsCore.FullScreenMode == true):
				VisualsCore.DrawText(OptionsTextAspectRatio, "On", -95, 51+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.FullScreenMode == false):
				VisualsCore.DrawText(OptionsTextAspectRatio, "Off", -95, 51+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		elif InterfaceCore.ThisArrowWasPressed(3.0) == true:
			if VisualsCore.KeepAspectRatio == 0:
				VisualsCore.KeepAspectRatio = 1
			else:  VisualsCore.KeepAspectRatio = 0

			if (VisualsCore.KeepAspectRatio == 0):
				VisualsCore.DrawText(OptionsTextCompPlayersSys, "Stretch & Fill Screen", -95, 51+50+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.KeepAspectRatio == 1):
				VisualsCore.DrawText(OptionsTextCompPlayersSys, "Keep Aspect Ratio[Black Borders]", -95, 51+50+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.SetScreenStretchMode()

		elif InterfaceCore.ThisArrowWasPressed(3.5) == true:
			if VisualsCore.KeepAspectRatio == 0:
				VisualsCore.KeepAspectRatio = 1
			else:  VisualsCore.KeepAspectRatio = 0

			if (VisualsCore.KeepAspectRatio == 0):
				VisualsCore.DrawText(OptionsTextCompPlayersSys, "Stretch & Fill Screen", -95, 51+50+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.KeepAspectRatio == 1):
				VisualsCore.DrawText(OptionsTextCompPlayersSys, "Keep Aspect Ratio[Black Borders]", -95, 51+50+50+50, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.SetScreenStretchMode()

		elif InterfaceCore.ThisArrowWasPressed(4.0) == true:
			if LogicCore.GameMode > 0:
				LogicCore.GameMode-=1
			else:  LogicCore.GameMode = 7
			
			if LogicCore.GameMode == LogicCore.ChildStoryMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Easy Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenStoryMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Hard Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultStoryMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Normal Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboStoryMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Very Hard Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.ChildNeverMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Easy Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenNeverMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Hard Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultNeverMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Normal Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboNeverMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Very Hard Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(4.5) == true:
			if LogicCore.GameMode < 7:
				LogicCore.GameMode+=1
			else:  LogicCore.GameMode = 0
			
			if LogicCore.GameMode == LogicCore.ChildStoryMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Easy Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenStoryMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Hard Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultStoryMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Normal Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboStoryMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Very Hard Story Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.ChildNeverMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Easy Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenNeverMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Hard Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultNeverMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Normal Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboNeverMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Very Hard Never End Mode", -95, 51+50+50+50+65-7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(5.0) == true:
			if (LogicCore.UndoAction == 0):
				LogicCore.UndoAction = 1
			else:
				LogicCore.UndoAction = 0

			if LogicCore.UndoAction == 1:
				VisualsCore.DrawText(OptionsTextUndoAction, "Clear All Tiles", -95, 70+50+50+50+65+50-14-13+2, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.UndoAction == 0:
				VisualsCore.DrawText(OptionsTextUndoAction, "Clear One Tile At A Time", -95, 70+50+50+50+65+50-14-13+2, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(5.5) == true:
			if (LogicCore.UndoAction == 0):
				LogicCore.UndoAction = 1
			else:
				LogicCore.UndoAction = 0

			if LogicCore.UndoAction == 1:
				VisualsCore.DrawText(OptionsTextUndoAction, "Clear All Tiles", -95, 70+50+50+50+65+50-14-13+2, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.UndoAction == 0:
				VisualsCore.DrawText(OptionsTextUndoAction, "Clear One Tile At A Time", -95, 70+50+50+50+65+50-14-13+2, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(6.0) == true:
			if (LogicCore.EnableRightClick == 0):
				LogicCore.EnableRightClick = 1
			else:
				LogicCore.EnableRightClick = 0

			if LogicCore.EnableRightClick == 1:
				VisualsCore.DrawText(OptionsTextRightMouseButtonAction, "Clear One Tile", -95, 70+50+50+50+65+50-14+50-2-14, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.EnableRightClick == 0:
				VisualsCore.DrawText(OptionsTextRightMouseButtonAction, "Disabled", -95, 70+50+50+50+65+50-14+50-2-14, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(6.5) == true:
			if (LogicCore.EnableRightClick == 0):
				LogicCore.EnableRightClick = 1
			else:
				LogicCore.EnableRightClick = 0

			if LogicCore.EnableRightClick == 1:
				VisualsCore.DrawText(OptionsTextRightMouseButtonAction, "Clear One Tile", -95, 70+50+50+50+65+50-14+50-2-14, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.EnableRightClick == 0:
				VisualsCore.DrawText(OptionsTextRightMouseButtonAction, "Disabled", -95, 70+50+50+50+65+50-14+50-2-14, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(7.0) == true:
			if LogicCore.SecretCode[0] > 0:
				LogicCore.SecretCode[0]-=1
			else:  LogicCore.SecretCode[0] = 9

			VisualsCore.DrawText(OptionsTextCodeOne, str(LogicCore.SecretCode[0]), -95, 51+50+65+50+50+70+47+21+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(7.5) == true:
			if LogicCore.SecretCode[0] < 9:
				LogicCore.SecretCode[0]+=1
			else:  LogicCore.SecretCode[0] = 0

			VisualsCore.DrawText(OptionsTextCodeOne, str(LogicCore.SecretCode[0]), -95, 51+50+65+50+50+70+47+21+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(8.0) == true:
			if LogicCore.SecretCode[1] > 0:
				LogicCore.SecretCode[1]-=1
			else:  LogicCore.SecretCode[1] = 9

			VisualsCore.DrawText(OptionsTextCodeTwo, str(LogicCore.SecretCode[1]), -95, 51+50+65+50+50+70+50+47+14+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(8.5) == true:
			if LogicCore.SecretCode[1] < 9:
				LogicCore.SecretCode[1]+=1
			else:  LogicCore.SecretCode[1] = 0

			VisualsCore.DrawText(OptionsTextCodeTwo, str(LogicCore.SecretCode[1]), -95, 51+50+65+50+50+70+50+47+14+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(9.0) == true:
			if LogicCore.SecretCode[2] > 0:
				LogicCore.SecretCode[2]-=1
			else:  LogicCore.SecretCode[2] = 9

			VisualsCore.DrawText(OptionsTextCodeThree, str(LogicCore.SecretCode[2]), -95, 51+50+65+50+50+70+50+50+47+7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(9.5) == true:
			if LogicCore.SecretCode[2] < 9:
				LogicCore.SecretCode[2]+=1
			else:  LogicCore.SecretCode[2] = 0

			VisualsCore.DrawText(OptionsTextCodeThree, str(LogicCore.SecretCode[2]), -95, 51+50+65+50+50+70+50+50+47+7+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(10.0) == true:
			if LogicCore.SecretCode[3] > 0:
				LogicCore.SecretCode[3]-=1
			else:  LogicCore.SecretCode[3] = 9

			VisualsCore.DrawText(OptionsTextCodeFour, str(LogicCore.SecretCode[3]), -95, 51+50+65+50+50+70+50+50+50+47+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(10.5) == true:
			if LogicCore.SecretCode[3] < 9:
				LogicCore.SecretCode[3]+=1
			else:  LogicCore.SecretCode[3] = 0

			VisualsCore.DrawText(OptionsTextCodeFour, str(LogicCore.SecretCode[3]), -95, 51+50+65+50+50+70+50+50+50+47+5, 2, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		if (InterfaceCore.ThisButtonWasPressed(0) == true):
			ScreenToDisplayNext = TitleScreen
			ScreenFadeStatus = FadingToBlack

	LogicCore.SecretCodeCombined = (LogicCore.SecretCode[0]*1000)+(LogicCore.SecretCode[1]*100)+(LogicCore.SecretCode[2]*10)+(LogicCore.SecretCode[3]*1)
	if (LogicCore.SecretCodeCombined == 2777 || LogicCore.SecretCodeCombined == 8888 || LogicCore.SecretCodeCombined == 8889):
		VisualsCore.FramesPerSecondText.TextImage[0].global_position.x = 10
	else:
		VisualsCore.FramesPerSecondText.TextImage[0].global_position.x = -9999

	if (InputCore.MouseButtonRightPressed == true):
		ScreenFadeStatus = FadingToBlack
		ScreenFadeTransparency = 0.0
		ScreenToDisplayNext = TitleScreen
		AudioCore.PlayEffect(1)
		InputCore.MouseButtonRightPressed = false

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		LogicCore.SecretCodeCombined = (LogicCore.SecretCode[0]*1000)+(LogicCore.SecretCode[1]*100)+(LogicCore.SecretCode[2]*10)+(LogicCore.SecretCode[3]*1)

	pass

#----------------------------------------------------------------------------------------
func DisplayHowToPlayScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.65)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "H  O  W   T  O   P  L  A  Y:", 0, 12-8, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30+8, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Pieces will fall from the top of the playfield.", 0, 35+30-10, 1, 0, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Select pieces that have fell & form valid equations.", 0, 35+30+40-10, 1, 0, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(21001, VisualsCore.ScreenWidth/2.0 - 225, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(20001, VisualsCore.ScreenWidth/2.0 - 175, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(20002, VisualsCore.ScreenWidth/2.0 - 125, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(30000, VisualsCore.ScreenWidth/2.0 - 75, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(21000, VisualsCore.ScreenWidth/2.0 - 25, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(20000, VisualsCore.ScreenWidth/2.0 + 25, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(35000, VisualsCore.ScreenWidth/2.0 + 75, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(21002, VisualsCore.ScreenWidth/2.0 + 125, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(21003, VisualsCore.ScreenWidth/2.0 + 175, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(20003, VisualsCore.ScreenWidth/2.0 + 225, 173, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Valid equations will be removed from the playfield.", 0, 35+30+40+40+70, 1, 0, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "As you form equations, new pieces will fall from top.", 0, 35+30+40+40+70+40, 1, 0, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Keep an eye on the height of the playfield.", 0, 35+30+40+40+70+40+70, 1, 0, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The game will be over if the pieces reach the top.", 0, 35+30+40+40+70+40+70+40, 1, 0, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		if (LogicCore.GameMode < 4):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Do you have the skill to beat this Math game?", 0, 35+30+40+40+70+40+70+40+70, 1, 0, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		else:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Do you have the skill to get a new high score?", 0, 35+30+40+40+70+40+70+40+70, 1, 0, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "   Learn To Have Fun!™", 0, 35+30+40+40+70+40+70+40+70+60, 1, 0, 77, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
		InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25.0)

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenToDisplayNext = TitleScreen
		ScreenFadeStatus = FadingToBlack

	if (InputCore.MouseButtonRightPressed == true):
		ScreenFadeStatus = FadingToBlack
		ScreenFadeTransparency = 0.0
		ScreenToDisplayNext = TitleScreen
		AudioCore.PlayEffect(1)
		InputCore.MouseButtonRightPressed = false

	pass

#----------------------------------------------------------------------------------------
func DisplayHighScoresScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.65)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "H  I  G  H    S  C  O  R  E  S:", 0, 12-8, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30+8, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		InterfaceCore.CreateArrowSet(0, 70)

		VisualsCore.DrawSprite(31, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		if (LogicCore.SecretCodeCombined != 2777 && LogicCore.SecretCodeCombined != 8888):
			InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25)
		else:
			InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25)
			InterfaceCore.CreateButton (7, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25-67)
			InterfaceCore.ButtonSelectedByKeyboard = 1

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		if LogicCore.GameMode == LogicCore.ChildStoryMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Easy Story Mode''", 0, 70-14, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.TeenStoryMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Hard Story Mode''", 0, 70-14, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.AdultStoryMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Normal Story Mode''", 0, 70-14, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.TurboStoryMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Very Hard Story Mode''", 0, 70-14, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.ChildNeverMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Easy Never End Mode''", 0, 70-14, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.TeenNeverMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Hard Never End Mode''", 0, 70-14, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.AdultNeverMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Normal Never End Mode''", 0, 70-14, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.TurboNeverMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Very Hard Never End Mode''", 0, 70-14, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "NAME:", 55+26, 120, 0, 0, 25, 1.0, 1.0, 0, 0.7, 0.7, 0.7, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "LEVEL:", 690, 120, 0, 0, 25, 1.0, 1.0, 0, 0.7, 0.7, 0.7, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "SCORE:", 820, 120, 0, 0, 25, 1.0, 1.0, 0, 0.7, 0.7, 0.7, 1.0, 0.0, 0.0, 0.0)
	
		var screenY = 154
		var blue
		for rank in range(0, 10):
			blue = 1.0
			if (LogicCore.Score == DataCore.HighScoreScore[LogicCore.GameMode][rank] and LogicCore.Level == DataCore.HighScoreLevel[LogicCore.GameMode][rank]):
				blue = 0
	
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(1+rank)+".", 15-4+26, screenY, 0, 0, 35, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, DataCore.HighScoreName[LogicCore.GameMode][rank], 55+26, screenY, 0, 0, 35, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)

			var level = int(DataCore.HighScoreLevel[LogicCore.GameMode][rank])
			if level < 10:
				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(DataCore.HighScoreLevel[LogicCore.GameMode][rank]), 690, screenY, 0, 0, 35, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)
			elif (LogicCore.GameMode == LogicCore.ChildStoryMode || LogicCore.GameMode == LogicCore.TeenStoryMode || LogicCore.GameMode == LogicCore.AdultStoryMode || LogicCore.GameMode == LogicCore.TurboStoryMode):
				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "WON!", 690, screenY, 0, 0, 35, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)
			else:
				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(DataCore.HighScoreLevel[LogicCore.GameMode][rank]), 690, screenY, 0, 0, 35, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(DataCore.HighScoreScore[LogicCore.GameMode][rank]), 820, screenY, 0, 0, 35, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)

			screenY+=37

	if InterfaceCore.ThisArrowWasPressed(0) == true:
		if LogicCore.GameMode > 0:
			LogicCore.GameMode-=1
		else:  LogicCore.GameMode = 7
		
		ScreenToDisplayNext = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisArrowWasPressed(0.5) == true:
		if LogicCore.GameMode < 7:
			LogicCore.GameMode+=1
		else:  LogicCore.GameMode = 0
		
		ScreenToDisplayNext = HighScoresScreen
		ScreenFadeStatus = FadingToBlack

	if InterfaceCore.ThisButtonWasPressed(1) == true:
		DataCore.ClearHighScores()
		ScreenToDisplayNext = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenToDisplayNext = TitleScreen
		ScreenFadeStatus = FadingToBlack

	if (InputCore.MouseButtonRightPressed == true):
		ScreenFadeStatus = FadingToBlack
		ScreenFadeTransparency = 0.0
		ScreenToDisplayNext = TitleScreen
		AudioCore.PlayEffect(1)
		InputCore.MouseButtonRightPressed = false

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		InputCore.DelayAllUserInput = 10

	pass

#----------------------------------------------------------------------------------------
func SetupAboutScreenStars():
	for index in range(250):
		VisualsCore.StarX[index] = (randi() % 1024)
		VisualsCore.StarY[index] = (randi() % 640)
		VisualsCore.StarY[index]-=(640+30)
		VisualsCore.StarScale[index] = 0.5
		VisualsCore.StarRotation[index] = (randf() * 360.0)
		VisualsCore.StarAlpha[index] = 0.25
		VisualsCore.StarColorR[index] = (randf() * 1.0)
		VisualsCore.StarColorG[index] = (randf() * 1.0)
		VisualsCore.StarColorB[index] = (randf() * 1.0)

		VisualsCore.DrawSprite(4000+index, VisualsCore.StarX[index], VisualsCore.StarY[index], VisualsCore.StarScale[index], VisualsCore.StarScale[index], VisualsCore.StarRotation[index], VisualsCore.StarColorR[index], VisualsCore.StarColorG[index], VisualsCore.StarColorB[index], VisualsCore.StarAlpha[index])

	pass

#----------------------------------------------------------------------------------------
func DisplayAboutScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		SetupAboutScreenStars()

		if (LogicCore.GameWon == true):
			VisualsCore.DrawSprite(3010, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
		else:
			VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.65)

		VisualsCore.LoadAboutScreenTexts()

		TS1ScreenY = (VisualsCore.Texts.TextImage[VisualsCore.AboutTextsEndIndex-1].global_position.y + 390+150)
		StaffScreenTSOneScale = 1.0
		VisualsCore.DrawSprite(23, VisualsCore.ScreenWidth/2.0, TS1ScreenY, StaffScreenTSOneScale, StaffScreenTSOneScale, 0, 1.0, 1.0, 1.0, 1.0)

		for index in range(20):
			for indexTwo in range(999):
				RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[(20000+indexTwo) + (1000*index)], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(-99999, -99999)))

		TSOneDisplayTimer = 125

	if ScreenFadeStatus == FadingIdle:
		for index in range(250):
			if (VisualsCore.StarY[index] < 640+40):
				VisualsCore.StarY[index] += 5
			else:
				VisualsCore.StarY[index] = -20
				VisualsCore.StarX[index] = (randi() % 1024)
				VisualsCore.StarScale[index] = 0.5

			if (VisualsCore.StarY[index] > -30):
				if (VisualsCore.StarScale[index] > 0.0):
					VisualsCore.StarScale[index]-=0.0035
				else:
					VisualsCore.StarScale[index] = 0.0

			if (VisualsCore.StarRotation[index] < 360.0):
				VisualsCore.StarRotation[index]+=0.01
			else:
				VisualsCore.StarRotation[index] = 0.0
			VisualsCore.DrawSprite(4000+index, VisualsCore.StarX[index], VisualsCore.StarY[index], VisualsCore.StarScale[index], VisualsCore.StarScale[index], VisualsCore.StarRotation[index], VisualsCore.StarColorR[index], VisualsCore.StarColorG[index], VisualsCore.StarColorB[index], VisualsCore.StarAlpha[index])

		var textScrollSpeed = (1.32*2.0)
		if (LogicCore.GameWon == false):
			textScrollSpeed = (2.0*2.0)

		if (VisualsCore.Sprites.SpriteScreenY[23] > (VisualsCore.ScreenHeight/2.0)):
			for index in range(VisualsCore.AboutTextsStartIndex, VisualsCore.AboutTextsEndIndex):
				if (VisualsCore.Texts.TextImage[index].global_position.y > -100):
					VisualsCore.Texts.TextImage[index].global_position.y-=textScrollSpeed

			TS1ScreenY-=textScrollSpeed

		if (LogicCore.GameWon == false):
			if (InputCore.JoystickDirection[0] == InputCore.JoyUp and TS1ScreenY > 320):
				for index in range(VisualsCore.AboutTextsStartIndex, VisualsCore.AboutTextsEndIndex):
					VisualsCore.Texts.TextImage[index].global_position.y-=20.0
				TS1ScreenY = TS1ScreenY - 20.0

		if VisualsCore.Texts.TextImage[VisualsCore.AboutTextsEndIndex-1].global_position.y != -99999: # BANDAID - FIX IT
			if (InputCore.DelayAllUserInput == -1 && (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed)):
				ScreenFadeStatus = FadingToBlack
				
		if (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed): 
			InputCore.DelayAllUserInput = 30
			ScreenFadeStatus = FadingToBlack
		elif (TS1ScreenY <= (VisualsCore.ScreenHeight/2.0)):
			if (TSOneDisplayTimer > 0):
				TSOneDisplayTimer-=1
			else:
				StaffScreenTSOneScale = StaffScreenTSOneScale - 0.01

				if (StaffScreenTSOneScale < 0):
					ScreenFadeStatus = FadingToBlack

					InputCore.DelayAllUserInput = 30

		if (TS1ScreenY < 1000 and LogicCore.GameWon == false):
			VisualsCore.DrawSprite(23, VisualsCore.ScreenWidth/2.0, TS1ScreenY, StaffScreenTSOneScale, StaffScreenTSOneScale, 0, 1.0, 1.0, 1.0, 1.0)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		if (LogicCore.GameWon == true and LogicCore.GameMode == LogicCore.TurboStoryMode and LogicCore.SecretCodeCombined != 2778):
			LogicCore.SecretCode[0] = 5
			LogicCore.SecretCode[1] = 4
			LogicCore.SecretCode[2] = 3
			LogicCore.SecretCode[3] = 1
			LogicCore.SecretCodeCombined = 5431

		if (LogicCore.GameWon == true && DataCore.NewHighScoreRank < 999):
			LogicCore.GameWon = false

			ScreenToDisplayNext = NewHighScoreScreen
		elif (LogicCore.GameWon == true):
			LogicCore.GameWon = false

			ScreenToDisplayNext = HighScoresScreen
		else:
			ScreenToDisplayNext = TitleScreen

	pass

#----------------------------------------------------------------------------------------
func DisplayMusicTestScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.65)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "B . G . M .   M  U  S  I  C   T  E  S  T:", 0, 12-8, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30+8, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		InterfaceCore.CreateArrowSet( 0, (VisualsCore.ScreenHeight/2.0)-85 )
		if AudioCore.MusicCurrentlyPlaying == 0:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: Title", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		if AudioCore.MusicCurrentlyPlaying == 1:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame 1", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 2:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame 2", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 3:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame 3", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 4:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame 4", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 5:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame 5", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 6:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Never Ending", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 7:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: New High Score", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 8:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: Ending", 0, (VisualsCore.ScreenHeight/2.0)-85-12, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM Music Soundtrack By Suno.com", 0, 395, 1, 0, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(31, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
		InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25.0)

	if InterfaceCore.ThisArrowWasPressed(0.0):
		if AudioCore.MusicCurrentlyPlaying > 0:
			AudioCore.MusicCurrentlyPlaying-=1
		else:
			AudioCore.MusicCurrentlyPlaying = (AudioCore.MusicTotal - 1)

		if (LogicCore.SecretCodeCombined == 5432 and AudioCore.MusicCurrentlyPlaying == AudioCore.MusicTotal - 1):
			AudioCore.MusicCurrentlyPlaying = AudioCore.MusicTotal - 2

		AudioCore.PlayMusic(AudioCore.MusicCurrentlyPlaying, true)

		ScreenToDisplayNext = MusicTestScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisArrowWasPressed(0.5):
		if AudioCore.MusicCurrentlyPlaying < (AudioCore.MusicTotal - 1):
			AudioCore.MusicCurrentlyPlaying+=1
		else:
			AudioCore.MusicCurrentlyPlaying = 0

		if (LogicCore.SecretCodeCombined == 5432 and AudioCore.MusicCurrentlyPlaying == AudioCore.MusicTotal - 1):
			AudioCore.MusicCurrentlyPlaying = 0

		AudioCore.PlayMusic(AudioCore.MusicCurrentlyPlaying, true)

		ScreenToDisplayNext = MusicTestScreen
		ScreenFadeStatus = FadingToBlack

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenToDisplayNext = TitleScreen
		ScreenFadeStatus = FadingToBlack

	if (InputCore.MouseButtonRightPressed == true):
		ScreenFadeStatus = FadingToBlack
		ScreenFadeTransparency = 0.0
		ScreenToDisplayNext = TitleScreen
		AudioCore.PlayEffect(1)
		InputCore.MouseButtonRightPressed = false

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		if ScreenToDisplayNext == TitleScreen:
			if AudioCore.MusicCurrentlyPlaying > 0:
				AudioCore.PlayMusic(0, true)

		for alphaFix in range(0, 10):
			RenderingServer.canvas_item_set_draw_index(VisualsCore.Sprites.ci_rid[141+alphaFix], -5)

	pass

#----------------------------------------------------------------------------------------
func DisplayPlayingGameScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		if (LogicCore.GameMode == LogicCore.ChildStoryMode or LogicCore.GameMode == LogicCore.ChildNeverMode):
			VisualsCore.SetFramesPerSecond(20)
		elif (LogicCore.GameMode == LogicCore.TeenStoryMode or LogicCore.GameMode == LogicCore.TeenNeverMode):
			VisualsCore.SetFramesPerSecond(45)
		elif (LogicCore.GameMode == LogicCore.AdultStoryMode or LogicCore.GameMode == LogicCore.AdultNeverMode):
			VisualsCore.SetFramesPerSecond(30)
		elif (LogicCore.GameMode == LogicCore.TurboStoryMode or LogicCore.GameMode == LogicCore.TurboNeverMode):
			VisualsCore.SetFramesPerSecond(60)

		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0), 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(2000, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0), 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		InterfaceCore.CreateIcon(117, 31, VisualsCore.ScreenHeight-31, " ")

		InterfaceCore.CreateIcon(2001, (99 - 11 + (50*16)), -99999, " ")

		InterfaceCore.CreateIcon(2002, (99 - 11 + (50*17)), 600-50-1, " ")
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[2002], Color(0.0, 1.0, 0.0, 1.0))

		InterfaceCore.CreateIcon(118, VisualsCore.ScreenWidth-30, VisualsCore.ScreenHeight-30, " ")

		var scoreFullText
		scoreFullText = "Score: "+str(LogicCore.Score)
		LogicCore.ScoreText = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, scoreFullText, 75, 600, 0, 0, 40, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		var levelFullText
		levelFullText = "Level: "+str(LogicCore.Level)

		if (LogicCore.GameMode < 4 and LogicCore.Level == 9):
			levelFullText = "Level: Final!"

		LogicCore.LevelText = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, levelFullText, 0, 600, 1, 0, 40, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	LogicCore.CutSceneScale = 0.0
	if (LogicCore.CutSceneScale < 0.85 or LogicCore.CutSceneScale == 0.0):
		if (LogicCore.PAUSEgame == false):  LogicCore.RunGameplayCore()

		if (LogicCore.Level > 0 and LogicCore.Level < 10):
			VisualsCore.DrawSprite(3000+LogicCore.Level, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0), LogicCore.CutSceneScale, LogicCore.CutSceneScale, 0, 1.0, 1.0, 1.0, LogicCore.CutSceneAlpha)
	
		if (LogicCore.CutSceneScale < 0.0):
			LogicCore.CutSceneScale = 0.0

			if (LogicCore.Level > 0 and LogicCore.Level < 10):
				VisualsCore.DrawSprite(3000+LogicCore.Level, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0), LogicCore.CutSceneScale, LogicCore.CutSceneScale, 0, 1.0, 1.0, 1.0, LogicCore.CutSceneAlpha)

	for index in range(16):
		LogicCore.TileSpriteIndex[index] = 1

	if (LogicCore.DrawEverything == true):
		for index in range(20):
			for indexTwo in range(999):
				RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[(20000+indexTwo) + (1000*index)], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(-99999, -99999)))

		var selectedIndex = 0
		var screenY = 500-37+11
		var screenX = 99-11
		for y in range(12):
			for x in range(18):
				if (LogicCore.Playfield[x][y] > -1):
					VisualsCore.DrawSprite(20000+LogicCore.TileSpriteIndex[LogicCore.Playfield[x][y]] + (1000*LogicCore.Playfield[x][y]), screenX, screenY, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

					for index in range(0, LogicCore.SelectedTileIndex):
						if (LogicCore.SelectedTilePlayfieldX[index] == x and LogicCore.SelectedTilePlayfieldY[index] == y):
							VisualsCore.DrawSprite(20000+LogicCore.TileSpriteIndex[LogicCore.Playfield[x][y]] + (1000*LogicCore.Playfield[x][y]), screenX, screenY, 1.0, 1.0, 0, 1.0, 1.0, 1.0, LogicCore.SelectedTilesAlpha)

							if (LogicCore.GameState != LogicCore.FadingTiles):
								VisualsCore.DrawSprite(36000+selectedIndex, screenX, screenY, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
							elif (LogicCore.GameState == LogicCore.FadingTiles):
								VisualsCore.DrawSprite(36000+selectedIndex, screenX, screenY, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.0)

							selectedIndex+=1

					LogicCore.TileSpriteIndex[LogicCore.Playfield[x][y]]+=1

				screenX+=50
			
			screenX = 99-11
			screenY-=50

		screenY = 500-37+86
		screenX = 99-11

		for index in range(16):
			LogicCore.TileSpriteIndex[index] = 900

		for index in range(16):
			if (LogicCore.SelectedTilePlayfieldX[index] > -1 and LogicCore.SelectedTilePlayfieldY[index] > -1):
				VisualsCore.DrawSprite(20000+LogicCore.TileSpriteIndex[LogicCore.Playfield[LogicCore.SelectedTilePlayfieldX[index]][LogicCore.SelectedTilePlayfieldY[index]]] + (1000*LogicCore.Playfield[LogicCore.SelectedTilePlayfieldX[index]][LogicCore.SelectedTilePlayfieldY[index]]), screenX, screenY, 1.0, 1.0, 0, 1.0, 1.0, 1.0, LogicCore.SelectedTilesAlpha)
				LogicCore.TileSpriteIndex[LogicCore.Playfield[LogicCore.SelectedTilePlayfieldX[index]][LogicCore.SelectedTilePlayfieldY[index]]]+=1

			screenX+=50

		LogicCore.DrawEverything = false

	if (LogicCore.GameWon == false):
		if (LogicCore.GameOver == false):  VisualsCore.DrawSprite(20000 + (1000*LogicCore.FallingTile), LogicCore.FallingTileScreenX, LogicCore.FallingTileScreenY+LogicCore.FallingTileYoffset, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		if (LogicCore.GameOver == true):
			ScreenFadeStatus = FadingToBlack

		if (LogicCore.SelectedTileIndex > 0):
			InterfaceCore.Icons.IconScreenY[1] = 600-50-1
		else:
			InterfaceCore.Icons.IconScreenY[1] = -99999

		if (LogicCore.UndoButtonDelay > 0):  LogicCore.UndoButtonDelay-=1

		if (LogicCore.BadEquationRedTimer > 0):
			LogicCore.BadEquationRedTimer-=1
			if (LogicCore.BadEquationRedTimer == 1):
				RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[2002], Color(0.0, 1.0, 0.0, 1.0))

		if (LogicCore.PAUSEgame == false):
			if InterfaceCore.ThisIconWasPressed(0, -1) == true:
				ScreenToDisplayNext = TitleScreen
				ScreenFadeStatus = FadingToBlack
				LogicCore.StillPlaying = false
				LogicCore.GameQuit = true
				LogicCore.GameOver = true
				InputCore.MouseButtonLeftPressed = false
				InputCore.DelayAllUserInput = 35
			elif InterfaceCore.ThisIconWasPressed(1, -1) == true:
				if (LogicCore.GameState == LogicCore.Playing):
					if (LogicCore.UndoButtonDelay == 0):
						AudioCore.PlayEffect(5)
						LogicCore.UndoButtonDelay = 6

						if (LogicCore.UndoAction == 0):
							if (LogicCore.SelectedTileIndex > 0):
								LogicCore.SelectedTileIndex-=1
								LogicCore.SelectedTilePlayfieldX[LogicCore.SelectedTileIndex] = -1
								LogicCore.SelectedTilePlayfieldY[LogicCore.SelectedTileIndex] = -1
						elif (LogicCore.UndoAction == 1):
							if (LogicCore.SelectedTileIndex > 0):
								for index in range(LogicCore.SelectedTileIndex):
									LogicCore.SelectedTileIndex-=1
									LogicCore.SelectedTilePlayfieldX[LogicCore.SelectedTileIndex] = -1
									LogicCore.SelectedTilePlayfieldY[LogicCore.SelectedTileIndex] = -1
			elif ( InterfaceCore.ThisIconWasPressed(2, -1) == true and LogicCore.ThereIsAnOperator == true and LogicCore.ThereIsAnEqual == true and LogicCore.SelectedTileIndex > 4):
				if (LogicCore.GameState == LogicCore.Playing):
					if (LogicCore.BadEquationRedTimer == 0):
						if ( LogicCore.CheckEquationNewPerfect() == false ):
							AudioCore.PlayEffect(6)
							RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[2002], Color(1.0, 0.0, 0.0, 1.0))
							LogicCore.BadEquationRedTimer = 20
						else:
							AudioCore.PlayEffect(7)
							LogicCore.BadEquationRedTimer = 20
							LogicCore.GameState = LogicCore.FadingTiles
							LogicCore.SelectedTilesAlpha = 1.0

							LogicCore.DrawEverything = true
			elif InterfaceCore.ThisIconWasPressed(3, -1) == true:
				if (LogicCore.GameState == LogicCore.Playing):
					if (LogicCore.PAUSEgame == false):
						LogicCore.PAUSEgame = true
						LogicCore.PauseWasJustPressed = true

						InputCore.OldMusicVolume = AudioCore.MusicVolume
						AudioCore.MusicPlayer.set_volume_db(AudioCore.ConvertLinearToDB(0.0))

						InputCore.DelayAllUserInput = 25

		if (LogicCore.EnableRightClick == 1 and InputCore.MouseButtonRightPressed == true and LogicCore.UndoButtonDelay == 0):
			if (LogicCore.SelectedTileIndex > 0):
				LogicCore.SelectedTileIndex-=1
				LogicCore.SelectedTilePlayfieldX[LogicCore.SelectedTileIndex] = -1
				LogicCore.SelectedTilePlayfieldY[LogicCore.SelectedTileIndex] = -1

				LogicCore.DrawEverything = true

				AudioCore.PlayEffect(5)
				LogicCore.UndoButtonDelay = 6

		if (LogicCore.ScoreChanged == true):
			var scoreFullText
			scoreFullText = "Score: "+str(LogicCore.Score)
			VisualsCore.DrawText(LogicCore.ScoreText, scoreFullText, 75, 600, 0, 0, 40, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			var levelFullText
			levelFullText = "Level: "+str(LogicCore.Level)

			if (LogicCore.GameMode < 4 and LogicCore.Level == 9):
				levelFullText = "Level: Final!"

			VisualsCore.DrawText(LogicCore.LevelText, levelFullText, 0, 600, 1, 0, 40, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			LogicCore.ScoreChanged = false
	elif (LogicCore.GameWon == true):
		ScreenFadeStatus = FadingToBlack

	if (LogicCore.PAUSEgame == true):
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(2, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0), 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		VisualsCore.SetFramesPerSecond(30)
		InputCore.MouseButtonLeftPressed = false

		for index in range(20):
			for indexTwo in range(999):
				RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[(20000+indexTwo) + (1000*index)], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(-99999, -99999)))

		if (LogicCore.StillPlaying == false):
			if (LogicCore.GameQuit == true):
				ScreenToDisplayNext = TitleScreen
				AudioCore.PlayMusic(0, true)
			elif (LogicCore.GameWon == false):
				DataCore.CheckForNewHighScore()
				if (DataCore.NewHighScoreRank == 999):
					AudioCore.PlayMusic(0, true)
					ScreenToDisplayNext = HighScoresScreen
				else:
					AudioCore.PlayMusic(7, true)
					ScreenToDisplayNext = NewHighScoreScreen
			elif (LogicCore.GameWon == true):
				DataCore.CheckForNewHighScore()
				AudioCore.PlayMusic(8, true)
				ScreenToDisplayNext = AboutScreen
		elif (LogicCore.GameQuit == false):
			LogicCore.CutSceneAlpha = 0.0
			LogicCore.CutSceneScale = 2.0
			LogicCore.CutSceneTimer = 0
			LogicCore.CutSceneBlackBackgroundAlpha = 1.0
			ScreenToDisplayNext = CutSceneScreen

	pass

#----------------------------------------------------------------------------------------
func DisplayNewHighScoreScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		NewHighScoreString = " "
		NewHighScoreStringIndex = 0

		NewHighScoreNameInputJoyX = 0
		NewHighScoreNameInputJoyY = 0

		NewHighScoreString = NewHighScoreString.left(-1)

		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "N E W  H I G H  S C O R E  N A M E  I N P U T:", 0, 12-8, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30+8, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You Achieved A New High Score! Please Enter Your Name:", 0, 70, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		var screenY = 230
		var screenX = 68
		var offsetX = 75
		var spriteIndex = 0
		for index in range(65, 78):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		screenY = 230+75
		screenX = 68
		for index in range(78, 91):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		screenY = 230+75+75
		screenX = 68
		for index in range(97, 110):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		screenY = 230+75+75+75
		screenX = 68
		for index in range(110, 123):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		screenY = 230+75+75+75+75
		screenX = 68
		for index in range(48, 58):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(43) )
		spriteIndex+=1
		InterfaceCore.CreateIcon( 200+(spriteIndex), screenX+75, screenY, char(95) )
		spriteIndex+=1
		InterfaceCore.CreateIcon( 200+(spriteIndex), screenX+75+75+9999, screenY, char(60) )

		InterfaceCore.CreateIcon( 200+(spriteIndex+1), screenX+75+75, screenY, "<" )

		var _lastIndex = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, NewHighScoreString, 0, 70+55, 1, 0, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
		InterfaceCore.CreateButton (5, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25.0)

	var highScoreNameTextIndex = 77

	if (InputCore.KeyTypedOnKeyboard != "`"):
		var letter = InputCore.KeyTypedOnKeyboard.unicode_at(0)
		if (letter > 64 && letter < 91):
			InterfaceCore.Icons.IconAnimationTimer[letter-65] = 3
			InputCore.DelayAllUserInput = 2
		elif (letter > 96 && letter < 123):
			InterfaceCore.Icons.IconAnimationTimer[(letter-96)+25] = 3
			InputCore.DelayAllUserInput = 2
		elif (letter > 47 && letter < 58):
			InterfaceCore.Icons.IconAnimationTimer[(letter-46)+50] = 3
			InputCore.DelayAllUserInput = 2
		elif (letter == 43):
			InterfaceCore.Icons.IconAnimationTimer[62] = 3
			InputCore.DelayAllUserInput = 2
		elif (letter == 95):
			InterfaceCore.Icons.IconAnimationTimer[63] = 3
			InputCore.DelayAllUserInput = 2

	if (InputCore.KeyboardBackspacePressed == true):
		InterfaceCore.Icons.IconAnimationTimer[65] = 3
		InputCore.DelayAllUserInput = 5

	for index in range(0, 100):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+index], Color(1.0, 1.0, 1.0, 1.0))

	for index in range(40, 50):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[index], Color(1.0, 1.0, 1.0, 1.0))

	for index in range(0, 10):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[40+index], Color(1.0, 1.0, 1.0, 1.0))

	if (InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(1)

		if (NewHighScoreNameInputJoyY == 0):
			InterfaceCore.Icons.IconAnimationTimer[NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 1):
			InterfaceCore.Icons.IconAnimationTimer[13+NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 2):
			InterfaceCore.Icons.IconAnimationTimer[26+NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 3):
			InterfaceCore.Icons.IconAnimationTimer[39+NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 4):
			InterfaceCore.Icons.IconAnimationTimer[52+NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 5):
			ScreenFadeStatus = FadingToBlack
	elif (InputCore.JoyButtonTwo[InputCore.InputAny] == InputCore.Pressed):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(1)

		if (NewHighScoreStringIndex > 0):
			NewHighScoreString = NewHighScoreString.left(-1)
			NewHighScoreStringIndex-=1
			VisualsCore.DrawText(highScoreNameTextIndex, NewHighScoreString, 0, 70+55, 1, 0, 35, 1.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if (InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyUp):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(0)
		if (NewHighScoreNameInputJoyY > 0):
			NewHighScoreNameInputJoyY-=1
		else:
			NewHighScoreNameInputJoyY = 5
	elif (InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyDown):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(0)
		if (NewHighScoreNameInputJoyY < 5):
			NewHighScoreNameInputJoyY+=1
		else:
			NewHighScoreNameInputJoyY = 0
	elif (InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyLeft):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(0)
		if (NewHighScoreNameInputJoyX > 0):
			NewHighScoreNameInputJoyX-=1
		else:
			NewHighScoreNameInputJoyX = 12
	elif (InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyRight):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(0)
		if (NewHighScoreNameInputJoyX < 12):
			NewHighScoreNameInputJoyX+=1
		else:
			NewHighScoreNameInputJoyX = 0

	for index in range(0, InterfaceCore.NumberOfIconsOnScreen):
		if (InterfaceCore.ThisIconWasPressed(index, 0)):
			if (index < 63 && NewHighScoreStringIndex < 20):
				NewHighScoreString+=InterfaceCore.Icons.IconText[index]
				NewHighScoreStringIndex+=1
				if (InputCore.MouseButtonLeftPressed == true || InputCore.TouchTwoPressed == true):  InputCore.DelayAllUserInput = 10
				AudioCore.PlayEffect(0)
				VisualsCore.DrawText(highScoreNameTextIndex, NewHighScoreString, 0, 70+55, 1, 0, 55, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (index == 63 && NewHighScoreStringIndex < 20):
				NewHighScoreString+=" "
				NewHighScoreStringIndex+=1
				if (InputCore.MouseButtonLeftPressed == true || InputCore.TouchTwoPressed == true):  InputCore.DelayAllUserInput = 10
				AudioCore.PlayEffect(0)
				VisualsCore.DrawText(highScoreNameTextIndex, NewHighScoreString, 0, 70+55, 1, 0, 55, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (index == 65):
				if (NewHighScoreStringIndex > 0):
					NewHighScoreString = NewHighScoreString.left(-1)
					NewHighScoreStringIndex-=1
					if (InputCore.MouseButtonLeftPressed == true || InputCore.TouchTwoPressed == true):  InputCore.DelayAllUserInput = 10
					AudioCore.PlayEffect(0)
					VisualsCore.DrawText(highScoreNameTextIndex, NewHighScoreString, 0, 70+55, 1, 0, 55, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenFadeStatus = FadingToBlack

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = HighScoresScreen

		if (NewHighScoreStringIndex == 0):
			NewHighScoreString = "No Name Entered?"

		DataCore.HighScoreName[LogicCore.GameMode][DataCore.NewHighScoreRank] = NewHighScoreString

		for index in range(0, 100):
			RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+index], Color(1.0, 1.0, 1.0, 1.0))

		for index in range(0, 10):
			RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[40+index], Color(1.0, 1.0, 1.0, 1.0))

	pass

#----------------------------------------------------------------------------------------
func DisplayCutSceneScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.65)
		VisualsCore.DrawSprite( 3000+(LogicCore.Level), VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0 )

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Level # "+str(LogicCore.Level)+" Of 9", 0, 9, 1, 0, 50, 1.0, 1.0, 0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Mouse Left Button Click To Continue!", 0,(VisualsCore.ScreenHeight - 50), 1, 0, 50, 1.0, 1.0, 0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0)

		CutSceneClickTextFlash = 0

		InputCore.DelayAllUserInput = 35

	if (InputCore.MouseButtonLeftPressed == true):
		ScreenToDisplayNext = PlayingGameScreen
		ScreenFadeStatus = FadingToBlack

	pass

#----------------------------------------------------------------------------------------
func ProcessScreenToDisplay():
	if ScreenToDisplay == HTML5Screen:
		DisplayHTML5Screen()
	elif ScreenToDisplay == GodotScreen:
		DisplayGodotScreen()
	elif ScreenToDisplay == FASScreen:
		DisplayFASScreen()
	elif ScreenToDisplay == TitleScreen:
		DisplayTitleScreen()
	elif ScreenToDisplay == InputScreen:
		DisplayInputScreen()
	elif ScreenToDisplay == OptionsScreen:
		DisplayOptionsScreen()
	elif ScreenToDisplay == HowToPlayScreen:
		DisplayHowToPlayScreen()
	elif ScreenToDisplay == HighScoresScreen:
		DisplayHighScoresScreen()
	elif ScreenToDisplay == AboutScreen:
		DisplayAboutScreen()
	elif ScreenToDisplay == MusicTestScreen:
		DisplayMusicTestScreen()
	elif ScreenToDisplay == PlayingGameScreen:
		DisplayPlayingGameScreen()
	elif ScreenToDisplay == NewHighScoreScreen:
		DisplayNewHighScoreScreen()
	elif ScreenToDisplay == CutSceneScreen:
		DisplayCutSceneScreen()

	if (ScreenToDisplay != PlayingGameScreen):
		InterfaceCore.DrawAllButtons()
		InterfaceCore.DrawAllArrowSets()

	InterfaceCore.DrawAllIcons()

	ApplyScreenFadeTransition()

	if (LogicCore.SecretCodeCombined == 2777 || LogicCore.SecretCodeCombined == 8888 || LogicCore.SecretCodeCombined == 8889):
		VisualsCore.FramesPerSecondText.TextImage[0].global_position.x = (VisualsCore.ScreenWidth-80)

		VisualsCore.FramesPerSecondFrames = (VisualsCore.FramesPerSecondFrames + 1)

		var ticks = Time.get_ticks_msec()
		if (ticks > (1000+VisualsCore.FramesPerSecondLastSecondTick)):
			VisualsCore.FramesPerSecondLastSecondTick = ticks

			VisualsCore.FramesPerSecondArrayIndex = (VisualsCore.FramesPerSecondArrayIndex + 1)
			if (VisualsCore.FramesPerSecondArrayIndex > 9):  VisualsCore.FramesPerSecondArrayIndex = 0

			VisualsCore.FramesPerSecondArray[VisualsCore.FramesPerSecondArrayIndex] = VisualsCore.FramesPerSecondFrames

			VisualsCore.FramesPerSecondFrames = 0

			VisualsCore.FramesPerSecondAverage = 0
			for index in range(0, 10):
				VisualsCore.FramesPerSecondAverage+=VisualsCore.FramesPerSecondArray[index]

			VisualsCore.FramesPerSecondAverage = (VisualsCore.FramesPerSecondAverage / 10)
			VisualsCore.FramesPerSecondAverage = floor(VisualsCore.FramesPerSecondAverage)

			if (ScreenToDisplay == PlayingGameScreen):
				VisualsCore.FramesPerSecondText.TextImage[0].text = (" "+str(VisualsCore.FramesPerSecondAverage)+"/"+str(fps[LogicCore.GameMode]))
			elif (ScreenToDisplay != PlayingGameScreen):
				VisualsCore.FramesPerSecondText.TextImage[0].text = (" "+str(VisualsCore.FramesPerSecondAverage)+"/30")
	else:
		VisualsCore.FramesPerSecondText.TextImage[0].global_position.x = -9999

	pass
