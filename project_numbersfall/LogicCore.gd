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

# "LogicCore.gd"
extends Node2D

var HideCopyright = false

var Version = "Retail 1.1.0 R3"

const ChildStoryMode				= 0
const TeenStoryMode					= 2
const AdultStoryMode				= 1
const TurboStoryMode				= 3
const ChildNeverMode				= 4
const TeenNeverMode					= 6
const AdultNeverMode				= 5
const TurboNeverMode				= 7
var GameMode = AdultStoryMode

const Playing				= 1
const FadingTiles			= 2
const ApplyingGravity		= 3
var GameState = Playing

var LevelAdvance = []

var TotalTilesCleared = 0

var SecretCode = []
var SecretCodeCombined = 0

var PAUSEgame = false
var PauseWasJustPressed = false

var Score
var ScoreChanged
var ScoreText

var Level
var LevelText

var TotalClearedTiles
var LevelCleared
var CurrentClearedTiles

var GameWon

var StillPlaying

var Playfield = []

var TileSpriteIndex = []

var FallingTileScreenX
var FallingTileScreenY
var FallingTileX
var FallingTileY
var FallingTileYoffset

var FallingTile

var GameOver

var SelectedTilePlayfieldX = []
var SelectedTilePlayfieldY = []
var SelectedTileIndex

var UndoButtonDelay

var BadEquationRedTimer

var EquationString: String = ""
var ValueToCheck: String = ""
var EquationStringNew = ""

var DrawEverything

var ThereIsAnOperator

var ThereIsAnEqual

var SelectedTilesAlpha = 1.0

var PiecesCanStillFall = false

var BonusScore

var PlusIndex = []
var MinusIndex = []
var MultiplyIndex = []
var DivideIndex = []
var DecimalIndex = []
var EqualIndex

var PlusShown = []
var MinusShown = []
var MultiplyShown = []
var DivideShown = []
var DecimalShown = []
var EqualShown

var TheEnd

var number = []
var mathOperator = []

var GameQuit

var CurrentHeightOfPlayfield

var CutSceneAlpha
var CutSceneScale
var CutSceneTimer
var CutSceneBlackBackgroundAlpha

var UndoAction = 1

var EnableRightClick = 1

var FramesSinceLastPlayerInput = 0

#---------------------------------------------------------------------------------------
func ClearShown():
	for index in range(2):
		PlusShown[index] = false
		MinusShown[index] = false
		MultiplyShown[index] = false
		DivideShown[index] = false
		DecimalShown[index] = false

	EqualShown = false

	pass

#---------------------------------------------------------------------------------------
func FindOperators():
	ClearShown()

	for y in range(0, 12):
		for x in range(0, 18):
			if (Playfield[x][y] == 10):
				if (PlusShown[0] == false):
					PlusShown[0] = true
				else:
					PlusShown[1] = true
			elif (Playfield[x][y] == 11):
				if (MinusShown[0] == false):
					MinusShown[0] = true
				else:
					MinusShown[1] = true
			elif (Playfield[x][y] == 12):
				if (MultiplyShown[0] == false):
					MultiplyShown[0] = true
				else:
					MultiplyShown[1] = true
			elif (Playfield[x][y] == 13):
				if (DivideShown[0] == false):
					DivideShown[0] = true
				else:
					DivideShown[1] = true
			elif (Playfield[x][y] == 14):
				if (DecimalShown[0] == false):
					DecimalShown[0] = true
				else:
					DecimalShown[1] = true
			elif (Playfield[x][y] == 15):
				EqualShown = true

	pass

#---------------------------------------------------------------------------------------
func SetupForNewGame():
	PAUSEgame = false

	GameState = Playing

	TotalTilesCleared = 0

	Score = 0
	Level = 1

	BonusScore = 0

	GameQuit = false

	TotalClearedTiles = 0

	GameWon = false

	for y in range(0, 12):
		for x in range(0, 18):
			Playfield[x][y] = -1

	var allTilesShown = false
	while (allTilesShown == false):
		for y in range(0, 3):
			for x in range(0, 18):
				Playfield[x][y] = (randi() % 10)

		for index in range(2):
			Playfield[randi() % 12][randi() % 2] = 10
			Playfield[randi() % 12][randi() % 2] = 11
			Playfield[randi() % 12][randi() % 2] = 12
			Playfield[randi() % 12][randi() % 2] = 13
			Playfield[randi() % 12][randi() % 2] = 14

		Playfield[randi() % 12][randi() % 2] = 15

		FindOperators()

		if (PlusShown[0] == true and PlusShown[1] == true and MinusShown[0] == true and MinusShown[1] == true and MultiplyShown[0] == true and MultiplyShown[1] == true and DivideShown[0] == true and DivideShown[1] == true and DecimalShown[0] == true and DecimalShown[1] == true and EqualShown == true):
			allTilesShown = true

	FallingTileX = 0
	FallingTileY = 11
	FallingTileScreenX = 99-11-1
	FallingTileScreenY = (500-37+10) - (FallingTileY*50)
	FallingTileYoffset = 0

	FallingTile = (randi() % 10)

	StillPlaying = true

	GameOver = false

	for index in range(0, 20):
		SelectedTilePlayfieldX[index] = -1
		SelectedTilePlayfieldY[index] = -1

	SelectedTileIndex = 0

	UndoButtonDelay = 0

	BadEquationRedTimer = 0

	EquationString = ""

	DrawEverything = true
	ScoreChanged = true

	ThereIsAnEqual = false

	SelectedTilesAlpha = 1.0

	PiecesCanStillFall = false

	CurrentClearedTiles = 0

	CurrentHeightOfPlayfield = 0

	if (GameMode < 4):
		CutSceneAlpha = 0.0
		CutSceneScale = 1.0
		CutSceneTimer = 0
		CutSceneBlackBackgroundAlpha = 1.0
		
	else:
		CutSceneAlpha = 0.0
		CutSceneScale = 0.0
		CutSceneTimer = 0
		CutSceneBlackBackgroundAlpha = 0.0

	if (LogicCore.SecretCodeCombined == 2776):
		Score = 95788340
		Level = 9
		TotalClearedTiles = 109

	FramesSinceLastPlayerInput = 0

	pass

#----------------------------------------------------------------------------------------
func SetUpNextFallingTile():
	DrawEverything = true

	GameState = Playing

	PiecesCanStillFall = false

	SelectedTilesAlpha = 1.0

	AudioCore.PlayEffect(3)

	if (FallingTileX < 17):
		FallingTileX+=1
	else:
		FallingTileX = 0

	FallingTileY = 11

	if (Playfield[FallingTileX][FallingTileY-1] > -1):
		StillPlaying = false
		GameOver = true
		AudioCore.PlayEffect(4)
		return

	FallingTileScreenX = 99 - 11 - 1 + (FallingTileX*50)
	FallingTileScreenY = (500-37+11) - (FallingTileY*50)
	FallingTileYoffset = 0

	FallingTile = (randi() % 10)

	FindOperators()

	if (EqualShown == false):
		FallingTile = 15

	elif (PlusShown[0] == false):
		FallingTile = 10
	elif (MinusShown[0] == false):
		FallingTile = 11
	elif (MultiplyShown[0] == false):
		FallingTile = 12
	elif (DivideShown[0] == false):
		FallingTile = 13
	elif (DecimalShown[0] == false):
		FallingTile = 14

	elif (PlusShown[1] == false):
		FallingTile = 10
	elif (MinusShown[1] == false):
		FallingTile = 11
	elif (MultiplyShown[1] == false):
		FallingTile = 12
	elif (DivideShown[1] == false):
		FallingTile = 13
	elif (DecimalShown[1] == false):
		FallingTile = 14

	pass

#----------------------------------------------------------------------------------------
func ConvertTilesToString():
	for index in range(2):
		PlusIndex[index] = -1
		MinusIndex[index] = -1
		MultiplyIndex[index] = -1
		DivideIndex[index] = -1
		DecimalIndex[index] = -1

	EqualIndex = -1

	ThereIsAnOperator = false
	ThereIsAnEqual = false

	TheEnd = 0

	CurrentClearedTiles = 0

	ValueToCheck = ""
	var index = 0
	while (index < 18 and SelectedTilePlayfieldX[index] != -1 and SelectedTilePlayfieldY[index] != -1):
		var selX = SelectedTilePlayfieldX[index]
		var selY = SelectedTilePlayfieldY[index]
		if (Playfield[selX][selY] > -1 and Playfield[selX][selY] < 16):
			CurrentClearedTiles+=1
			var part = Playfield[selX][selY]
			if   (part ==  0):  ValueToCheck+="0"
			elif (part ==  1):  ValueToCheck+="1"
			elif (part ==  2):  ValueToCheck+="2"
			elif (part ==  3):  ValueToCheck+="3"
			elif (part ==  4):  ValueToCheck+="4"
			elif (part ==  5):  ValueToCheck+="5"
			elif (part ==  6):  ValueToCheck+="6"
			elif (part ==  7):  ValueToCheck+="7"
			elif (part ==  8):  ValueToCheck+="8"
			elif (part ==  9):  ValueToCheck+="9"
			elif (part == 10):
				ValueToCheck+="+"

				if (PlusIndex[0] == -1):
					PlusIndex[0] = index
				else:
					PlusIndex[1] = index

				ThereIsAnOperator = true
			elif (part == 11):
				ValueToCheck+="-"

				if (MinusIndex[0] == -1):
					MinusIndex[0] = index
				else:
					MinusIndex[1] = index

				ThereIsAnOperator = true
			elif (part == 12):
				ValueToCheck+="*"

				if (MultiplyIndex[0] == -1):
					MultiplyIndex[0] = index
				else:
					MultiplyIndex[1] = index

				ThereIsAnOperator = true
			elif (part == 13):
				ValueToCheck+="/"

				if (DivideIndex[0] == -1):
					DivideIndex[0] = index
				else:
					DivideIndex[1] = index

				ThereIsAnOperator = true
			elif (part == 14):
				ValueToCheck+="."

				if (DecimalIndex[0] == -1):
					DecimalIndex[0] = index
				else:
					DecimalIndex[1] = index
			elif(part == 15):
				ValueToCheck+="="
				ThereIsAnEqual = true
				EqualIndex = index

			index+=1

	pass

#----------------------------------------------------------------------------------------
func CheckEquationNewPerfect():
	ConvertTilesToString()

	var numberOfOperators = 0

	var text = ValueToCheck
	var re: RegEx = RegEx.create_from_string("[\\d\\.]+")
	var text_floatized = re.sub(text, "float($0)", true)
	var ex: Expression = Expression.new()
	var exTwo: Expression = Expression.new()
	var resultLeft = null
	var resultRight = null
	var token = text_floatized.split("=")
	ex.parse(token[0])
	exTwo.parse(token[1])
	resultLeft = ex.execute()
	resultRight = exTwo.execute()

	if (resultLeft == null or resultRight == null):  return(false)

	if (is_equal_approx(resultLeft, resultRight) == true):
		var scoreAdd = 0

		for index in range(2):
			if (MultiplyIndex[index] > -1):
				scoreAdd+=(5)
				numberOfOperators+=1
			if (DivideIndex[index] > -1):
				scoreAdd+=(10)
				numberOfOperators+=1
			if (PlusIndex[index] > -1):
				scoreAdd+=(5)
				numberOfOperators+=1
			if (MinusIndex[index] > -1):
				scoreAdd+=(10)
				numberOfOperators+=1
			if (DecimalIndex[index] > -1):
				scoreAdd+=(15)

		if (Level < 10):
			Score+=( scoreAdd * Level * SelectedTileIndex * numberOfOperators )
		else:
			Score+=( scoreAdd * 10 * SelectedTileIndex * numberOfOperators )

		ScoreChanged = true

		TotalClearedTiles+=SelectedTileIndex

		if (SecretCodeCombined == 1111):  TotalClearedTiles = ( LevelAdvance[GameMode] + 1)

		if ( TotalClearedTiles > ( LevelAdvance[GameMode]) ):
			AudioCore.PlayEffect(8)
			TotalClearedTiles = 0
			LevelAdvance[GameMode]+=10
			Level+=1

			if (GameMode < 4):
				CutSceneAlpha = 0.0
				CutSceneScale = 2.0
				CutSceneTimer = 0

				if (Level == 4):  AudioCore.PlayMusic(2, true)
				elif (Level == 6):  AudioCore.PlayMusic(3, true)
				elif (Level == 8):  AudioCore.PlayMusic(4, true)
				elif (Level == 9):  AudioCore.PlayMusic(5, true)

				if (Level == 10):
					StillPlaying = false
					GameWon = true
				else:
					ScreensCore.ScreenFadeStatus = ScreensCore.FadingToBlack
			else:
				CutSceneAlpha = 0.0
				CutSceneScale = 0.0
				CutSceneTimer = 0

		return(true)
	else:
		return(false)

#----------------------------------------------------------------------------------------
func RunGameplayCore():
	if (GameMode > 3):
		if (AudioCore.MusicPlayer.playing == false):
			var index = randi_range(1, 6)
			while (index == AudioCore.MusicCurrentlyPlaying):
				index = randi_range(1, 6)

			AudioCore.PlayMusic(index, false)

	if (GameState == FadingTiles):
		DrawEverything = true

		BonusScore = 0

		SelectedTilesAlpha-=0.1
		if (SelectedTilesAlpha < 0.0):
			SelectedTilesAlpha = 0.0
			GameState = ApplyingGravity

			for index in range(9):
				for y in range(12):
					for x in range(18):
						if (Playfield[x][y] > -1):
							if (SelectedTilePlayfieldX[index] == x and SelectedTilePlayfieldY[index] == y):
								Playfield[x][y] = -1
								index+=1

			for index in range(20):
				SelectedTilePlayfieldX[index] = -1
				SelectedTilePlayfieldY[index] = -1

			SelectedTileIndex = 0

			ThereIsAnEqual = false
	elif (GameState == ApplyingGravity):
		DrawEverything = true

		SelectedTilesAlpha = 1.0

		for y in range(11):
			for x in range(18):
				if (Playfield[x][y] == -1 and Playfield[x][y+1] > -1):
					for yTwo in range(y+1, 11):
						Playfield[x][yTwo-1] = Playfield[x][yTwo]
					
					Playfield[x][7] = -1

		PiecesCanStillFall = false
		for y in range(11):
			for x in range(18):
				if (Playfield[x][y] == -1 and Playfield[x][y+1] > -1):
					PiecesCanStillFall = true

		if (PiecesCanStillFall == false):
			GameState = Playing
			DrawEverything = true
	elif (GameState == Playing):
		CurrentHeightOfPlayfield = 0
		for y in range(12):
			for x in range(18):
				if (LogicCore.Playfield[x][y] > -1):
					if (y > CurrentHeightOfPlayfield):
						CurrentHeightOfPlayfield = y

		var allowTileSelection = false
		var xPos = -1
		var yPos = -1

		if (Level < 10):
			FallingTileYoffset+=(7+Level)
		else:
			FallingTileYoffset+=(7+9)

		if (CurrentHeightOfPlayfield < 4):
			FallingTileYoffset+=35
			FramesSinceLastPlayerInput = 0

		if (FramesSinceLastPlayerInput > 500):  FallingTileYoffset+=35

		if (FallingTileYoffset > 50):
			FallingTileYoffset = 0
			FallingTileScreenY+=50
			FallingTileY-=1

			if (FallingTileY == 0):
				Playfield[FallingTileX][FallingTileY] = FallingTile
				SetUpNextFallingTile()
			elif (Playfield[FallingTileX][FallingTileY-1] > -1):
				Playfield[FallingTileX][FallingTileY] = FallingTile
				SetUpNextFallingTile()

		if (InputCore.MouseButtonLeftPressed == true and InputCore.DelayAllUserInput == -1 and CutSceneScale == 0.0):
			ConvertTilesToString()
			var screenY = 500-37+11
			var screenX = 99-11
			for y in range(12):
				for x in range(18):
					if (Playfield[x][y] > -1):
						DrawEverything = true

						if (SelectedTileIndex < 16):
							var mY = InputCore.MouseScreenY
							var mX = InputCore.MouseScreenX
							if ( mY > (screenY - 25) and mY < (screenY + 25) and mX > (screenX - 25) and mX < (screenX + 25) ):
								xPos = x
								yPos = y
								var selected = false
								for index in range(0, 18):
									if (SelectedTilePlayfieldX[index] == x and SelectedTilePlayfieldY[index] == y):
										selected = true

								if (selected == false):
									allowTileSelection = true

					screenX+=50

				screenX = 99-11
				screenY-=50

		if (allowTileSelection == true):
			SelectedTilePlayfieldX[SelectedTileIndex] = xPos
			SelectedTilePlayfieldY[SelectedTileIndex] = yPos
			SelectedTileIndex+=1
			ConvertTilesToString()
			AudioCore.PlayEffect(0)
			FramesSinceLastPlayerInput = 0

			DrawEverything = true

		FramesSinceLastPlayerInput+=1

	pass

#----------------------------------------------------------------------------------------
func _ready():
	SecretCode.append(0)
	SecretCode.append(0)
	SecretCode.append(0)
	SecretCode.append(0)

	LogicCore.SecretCodeCombined = 0000

	LevelAdvance.resize(8)
	LevelAdvance[ChildStoryMode] = 15
	LevelAdvance[TeenStoryMode]  = (15 * 3)
	LevelAdvance[AdultStoryMode] = (15 * 2)
	LevelAdvance[TurboStoryMode] = (15 * 4)
	LevelAdvance[ChildNeverMode] = 15
	LevelAdvance[TeenNeverMode]  = (15 * 3)
	LevelAdvance[AdultNeverMode] = (15 * 2)
	LevelAdvance[TurboNeverMode] = (15 * 4)

	Playfield.resize(18)
	for x in range(18):
		Playfield[x] = []
		Playfield[x].resize(12)
		for y in range(12):
			Playfield[x][y] = []

	TileSpriteIndex.resize(16)

	Score = 0
	Level = 0

	SelectedTilePlayfieldX.resize(20)
	SelectedTilePlayfieldY.resize(20)

	SelectedTileIndex = 0

	UndoButtonDelay = 0

	BadEquationRedTimer = 0

	EquationString = ""

	DrawEverything = true
	ScoreChanged = true
	ThereIsAnEqual = false

	GameState = Playing

	SelectedTilesAlpha = 1.0

	PiecesCanStillFall = false

	PlusIndex.resize(2)
	MinusIndex.resize(2)
	MultiplyIndex.resize(2)
	DivideIndex.resize(2)
	DecimalIndex.resize(2)

	for index in range(2):
		PlusIndex[index] = -1
		MinusIndex[index] = -1
		MultiplyIndex[index] = -1
		DivideIndex[index] = -1
		DecimalIndex[index] = -1

	EqualIndex = -1

	PlusShown.resize(2)
	MinusShown.resize(2)
	MultiplyShown.resize(2)
	DivideShown.resize(2)
	DecimalShown.resize(2)

	ClearShown()

	number.resize(16)
	mathOperator.resize(16)

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass
