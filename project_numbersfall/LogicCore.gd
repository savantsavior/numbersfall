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

var Version = "Retail 1.1.0"

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

var PlusIndex
var MinusIndex
var MinusTwoIndex
var MultiplyIndex
var DivideIndex
var DecimalIndex
var DecimalTwoIndex
var EqualIndex

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

		Playfield[randi() % 12][randi() % 2] = 10
		Playfield[randi() % 12][randi() % 2] = 11
		Playfield[randi() % 12][randi() % 2] = 12
		Playfield[randi() % 12][randi() % 2] = 13

		Playfield[randi() % 12][randi() % 2] = 11

		Playfield[randi() % 12][randi() % 2] = 14
		Playfield[randi() % 12][randi() % 2] = 14

		Playfield[randi() % 12][randi() % 2] = 15

		var shownPlus = false
		var shownMinus = false
		var shownMinusTwo = false
		var shownMultiply = false
		var shownDivide = false
		var shownDecimal = false
		var shownDecimalTwo = false
		var shownEqual = false
		for y in range(0, 12):
			for x in range(0, 18):
				if (Playfield[x][y] == 10):  shownPlus = true
				
				if (Playfield[x][y] == 11):
					if (shownMinus == false):
						shownMinus = true
					elif (shownMinusTwo == false):
						shownMinusTwo = true
				
				if (Playfield[x][y] == 12):  shownMultiply = true
				if (Playfield[x][y] == 13):  shownDivide = true

				if (Playfield[x][y] == 14):
					if (shownDecimal == false):
						shownDecimal = true
					elif (shownDecimalTwo == false):
						shownDecimalTwo = true

				if (Playfield[x][y] == 15):  shownEqual = true

		if (shownPlus == true and shownMinus == true and shownMinusTwo == true and shownMultiply == true and shownDivide == true and shownDecimal == true and shownDecimalTwo == true and shownEqual == true):
			allTilesShown = true

	FallingTileX = 0
	FallingTileY = 11
	FallingTileScreenX = 99-11
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

	FallingTileScreenX = 99 - 11 + (FallingTileX*50)
	FallingTileScreenY = (500-37+11) - (FallingTileY*50)
	FallingTileYoffset = 0

	FallingTile = (randi() % 10)

	var allTilesShown = false
	while (allTilesShown == false):
		var shownPlus = false
		var shownMinus = false
		var shownMinusTwo = false
		var shownMultiply = false
		var shownDivide = false
		var shownDecimal = false
		var shownDecimalTwo = false
		var shownEqual = false
		for y in range(0, 12):
			for x in range(0, 18):
				if (Playfield[x][y] == 10):  shownPlus = true
				
				if (Playfield[x][y] == 11):
					if (shownMinus == false):
						shownMinus = true
					elif (shownMinusTwo == false):
						shownMinusTwo = true
				
				if (Playfield[x][y] == 12):  shownMultiply = true
				if (Playfield[x][y] == 13):  shownDivide = true

				if (Playfield[x][y] == 14):
					if (shownDecimal == false):
						shownDecimal = true
					elif (shownDecimalTwo == false):
						shownDecimalTwo = true

				if (Playfield[x][y] == 15):  shownEqual = true

		if (shownEqual == false):
			FallingTile = 15
			return
		elif (shownPlus == false):
			FallingTile = 10
			return
		elif (shownMinus == false):
			FallingTile = 11
			return
		elif (shownMultiply == false):
			FallingTile = 12
			return
		elif (shownDivide == false):
			FallingTile = 13
			return
		elif (shownDecimal == false):
			FallingTile = 14
			return
		elif (shownMinusTwo == false):
			FallingTile = 11
			return
		elif (shownDecimalTwo == false):
			FallingTile = 14
			return

		if (shownPlus == true and shownMinus == true and shownMinusTwo == true and shownMultiply == true and shownDivide == true and shownDecimalTwo == true and shownDecimalTwo == true and shownEqual == true):
			allTilesShown = true

	pass

#----------------------------------------------------------------------------------------
func ConvertTilesToString():
	ThereIsAnOperator = false
	ThereIsAnEqual = false
	
	PlusIndex = -1
	MinusIndex = -1
	MinusTwoIndex = -1
	MultiplyIndex = -1
	DivideIndex = -1
	DecimalIndex = -1
	DecimalTwoIndex = -1
	EqualIndex = -1

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
				PlusIndex = index
				ThereIsAnOperator = true
			elif (part == 11):
				ValueToCheck+="-"

				if (MinusIndex == -1):
					MinusIndex = index
				elif (MinusTwoIndex == -1):
					MinusTwoIndex = index

				ThereIsAnOperator = true
			elif (part == 12):
				ValueToCheck+="*"
				ThereIsAnOperator = true
				MultiplyIndex = index
			elif (part == 13):
				ValueToCheck+="/"
				ThereIsAnOperator = true
				DivideIndex = index
			elif (part == 14):
				ValueToCheck+="."

				if (DecimalIndex == -1):
					DecimalIndex = index
				elif (DecimalTwoIndex == -1):
					DecimalTwoIndex = index

			elif (part == 15):
				ValueToCheck+="="
				ThereIsAnEqual = true
				EqualIndex = index

			index+=1

	pass

#----------------------------------------------------------------------------------------
func CheckEquationNewPerfect():
	ConvertTilesToString()

	var splitEquation = ValueToCheck.split("=", true, 0)

	var expression = Expression.new()
	expression.parse(splitEquation[0])
	var resultLeft = expression.execute()

	var expressionTwo = Expression.new()
	expressionTwo.parse(splitEquation[1])
	var resultRight = expressionTwo.execute()

	if (resultLeft == null or resultRight == null):  return(false)

	if (is_equal_approx(resultLeft, resultRight) == true):
		var numberOfOperators = 0
		var scoreAdd = 0
		if (MultiplyIndex > -1):
			scoreAdd+=(50*Level)
			numberOfOperators+=1
		if (DivideIndex > -1):
			scoreAdd+=(100*Level)
			numberOfOperators+=1
		if (PlusIndex > -1):
			scoreAdd+=(25*Level)
			numberOfOperators = 0
		if (MinusIndex > -1):
			scoreAdd+=(75*Level)
			numberOfOperators+=1
		if (MinusTwoIndex > -1):
			scoreAdd+=(75*2*Level)
			numberOfOperators+=1
		if (DecimalIndex > -1):
			scoreAdd+=(125*Level)
		if (DecimalTwoIndex > -1):
			scoreAdd+=(125*2*Level)

		Score+=scoreAdd
		Score+=(250**Level*numberOfOperators)
		Score+=(SelectedTileIndex*50*Level)
		ScoreChanged = true

		TotalClearedTiles+=SelectedTileIndex

		if (SecretCodeCombined == 1111):  TotalClearedTiles = ( LevelAdvance[GameMode] + 1)

		if ( TotalClearedTiles > ( LevelAdvance[GameMode]) ):
			AudioCore.PlayEffect(8)
			TotalClearedTiles = 0
			LevelAdvance[GameMode]+=10
			Level+=1

			if (Level == 4):  AudioCore.PlayMusic(2, true)
			elif (Level == 6):  AudioCore.PlayMusic(3, true)
			elif (Level == 8):  AudioCore.PlayMusic(4, true)
			elif (Level == 9):  AudioCore.PlayMusic(5, true)

			if (GameMode < 4):
				CutSceneAlpha = 0.0
				CutSceneScale = 2.0
				CutSceneTimer = 0
				
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
		for y in range(7):
			for x in range(12):
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

		if (InputCore.MouseButtonLeftPressed == true and CutSceneScale == 0.0):
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
									if (SelectedTileIndex == 0):
										if ( (Playfield[x][y] > 0 and Playfield[x][y] < 10) or (Playfield[x][y] == 11) or (Playfield[x][y] == 14) ):
											allowTileSelection = true
									elif (SelectedTileIndex > 0):
										var posX = SelectedTilePlayfieldX[SelectedTileIndex-1]
										var posY = SelectedTilePlayfieldY[SelectedTileIndex-1]

										if ( (Playfield[x][y] > -1 and Playfield[x][y] < 10) ):
											allowTileSelection = true
											
											if ( Playfield[x][y] == 0 and (Playfield[posX][posY] == 10 or Playfield[posX][posY] == 11 or Playfield[posX][posY] == 12 and Playfield[posX][posY] == 13) ):
												allowTileSelection = false

											if ( Playfield[x][y] == 0 and (Playfield[posX][posY] == 15) ):
												allowTileSelection = false

											if ( Playfield[x][y] == 0 and (Playfield[posX][posY] == 13) ):
												allowTileSelection = false
										elif (Playfield[posX][posY] > -1 and Playfield[posX][posY] < 10):
											if (Playfield[x][y] == 10):
												if (PlusIndex == -1):
													allowTileSelection = true
											elif (Playfield[x][y] == 11):
												if (MinusIndex == -1):
													allowTileSelection = true
											elif (Playfield[x][y] == 12):
												if (MultiplyIndex == -1):
													allowTileSelection = true
											elif (Playfield[x][y] == 13):
												if (DivideIndex == -1):
													allowTileSelection = true

											if (Playfield[x][y] == 15 and SelectedTileIndex > 2 and ThereIsAnOperator == true):
												if (ThereIsAnEqual == false):
													allowTileSelection = true

										if (Playfield[x][y] == 11 and (Playfield[posX][posY] == 10 or Playfield[posX][posY] == 12 or Playfield[posX][posY] == 13) ):
											allowTileSelection = true

										if (Playfield[x][y] == 0 and Playfield[posX][posY] == 12):
											allowTileSelection = false

										if (Playfield[x][y] == 11 and Playfield[posX][posY] == 15):
											allowTileSelection = true

										if (ThereIsAnEqual == true and MinusIndex > -1 and Playfield[posX][posY] == 15 and Playfield[x][y] == 0):
											allowTileSelection = true

										if (SelectedTileIndex > 1):
											var checkX = SelectedTilePlayfieldX[SelectedTileIndex-2]
											var checkY = SelectedTilePlayfieldY[SelectedTileIndex-2]
											if (ThereIsAnEqual == true and MinusIndex > -1 and Playfield[checkX][checkY] == 15 and Playfield[posX][posY] == 0 and Playfield[x][y] > -1 and Playfield[x][y] < 10):
												allowTileSelection = false

										if ( Playfield[x][y] == 14 and ((Playfield[posX][posY] > -1 and Playfield[posX][posY] < 10)) ):
											allowTileSelection = true

										if ( Playfield[x][y] == 14 and (Playfield[posX][posY] > 9 and Playfield[posX][posY] < 14) or Playfield[posX][posY] == 15 ):
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

	PlusIndex = -1
	MinusIndex = -1
	MultiplyIndex = -1
	DivideIndex = -1
	DecimalIndex = -1
	EqualIndex = -1

	number.resize(16)
	mathOperator.resize(16)

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass
