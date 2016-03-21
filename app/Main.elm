module Main where

import Html exposing(..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random.PCG as Rand
import Time


--MODEL

type alias Model =
  { numA: Int
  , numB: Int
  , operator: String
  , score: Int
  }



initialModel : Model
initialModel =
  { numA = 0
  , numB = 0
  , operator= "*"
  , score = 0
  }
  --let
  --  emptyModel =
  --    { score = 0 }
  --in
  --  Maybe.withDefault emptyModel incoming


--UPDATE

type Action = NoOp | Check

update : (Float, Action) -> Model -> Model
update (time, action) model =
  case action of
    NoOp ->
      model
    Check ->
      let
        initSeed = Rand.initialSeed2 (round time) 12345
        (num1, nextSeed) = Rand.generate generator initSeed
        (num2, _) = Rand.generate generator nextSeed
      in
        { model | score = model.score + 1
                , numA = num1
                , numB = num2
        }


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
        ]
      , div
        [ class "row" ]
        [ text (toString model.score) ]
      , div
        [ class "row" ]
        [ button
          [ onClick inbox.address Check, class "button-primary" ]
          [ text "Submit" ]
        ]
      ]
    ]


--SIGNALS

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  inbox.signal


--PORTS

-- there is a bug with incoming data. need to be fixed.

--port incoming : Maybe Model

--port outgoing : Signal Model
--port outgoing =
--  model


--WIRING

model : Signal Model
model =
  Signal.foldp update initialModel (Time.timestamp actions)


main : Signal Html
main =
  Signal.map view model













