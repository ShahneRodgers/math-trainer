module Score where

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (..)
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Debug
import Color exposing (green, gray)

type alias Score = 
    { points : Int
    , startTime : Time
    }

initScore : Score
initScore = 
    { points = 0
    , startTime = 0.0 }

updateScore : Score -> Bool -> Float -> Score
updateScore score wasCorrect currTime =
    if wasCorrect then
        { score | points = score.points + (convertTimeToPoints currTime score.startTime)
                , startTime = currTime
        }
    else
        { score | points = score.points - 1 }

convertTimeToPoints : Float -> Float -> Int
convertTimeToPoints currTime startTime =
    if startTime == 0 then
        1
    else
        Basics.max (10 - round(inSeconds (currTime -  startTime))) 1

innerProgress : Float -> Float -> Score -> Form
innerProgress width height score = 
    let points = toFloat(score.points) in
    filled green (rect (points*width/100) (height-2)) 
    |> move (-width/2, 0)
        
progressBar : Int -> Int -> Score -> Element
progressBar width height score = color gray (collage width height [innerProgress (toFloat width) (toFloat height) score])

displayScore : Score -> (Int, Int) -> Html
displayScore score (width, height) = 
    fromElement (progressBar width 50 score)
    