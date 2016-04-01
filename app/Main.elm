module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, targetValue, on)
import Random.PCG as Rand
import Time exposing (..)



--MODEL

type alias Model =
  { numA: Int
  , numB: Int
  , operator: String
  }



initialModel : Model
initialModel =
  { numA = 0
  , numB = 0
  , operator = "x"
  }
  --let
  --  emptyModel =
  --    { score = 0 }
  --in
  --  Maybe.withDefault emptyModel incoming


--UPDATE

type Action = Check String

update : (Float, Action) -> Model -> Model
update (time, action) model =
  case action of
    Check answerU ->
      let
        seedM = Rand.initialSeed2 (round time) 12345
        (num1, seed1) = Rand.generate generator seedM
        (num2, seed2) = Rand.generate generator seed1

        answerC = model.numA * model.numB
      in
        if (toString answerC) == answerU then --to integer
          { model | numA = num1
                  , numB = num2
          }
        else
          model


generator : Rand.Generator Int
generator =
    Rand.int 1 10


--VIEW

view : Model -> Html
view model =
  div
    [ class "container" ]
    [ div
      [ class "row" ]
      [ div
        [ class "row" ]
        [ text (toString model.numA)
        , text (model.operator)
        , text (toString model.numB)
        , text " = "
        , input
          [ value ""
          , on "input" targetValue (\str -> Signal.message inputBox.address (Check str)) ]
          [ ]
        , button
          [ onClick clickBox.address "click"]
          [ text "Submit" ]
        ]
      ]
    ]


--SIGNALS

inputBox : Signal.Mailbox Action
inputBox =
  Signal.mailbox (Check "0")


clickBox : Signal.Mailbox String
clickBox =
  Signal.mailbox "click"


actions : Signal Action
actions =
  Signal.sampleOn clickBox.signal inputBox.signal




--PORTS

-- there is a bug with incoming data. need to be fixed.

--port incoming : Maybe Model

--port outgoing : Signal Model
--port outgoing =
--  model


--WIRING

model : Signal Model
model =
  Signal.foldp update initialModel (timestamp actions)



main : Signal Html
main =
  Signal.map view model













