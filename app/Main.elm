module Main where

import Html exposing(..)
import Html.Events exposing (onClick)
import Random.PCG as Rand


--MODEL

type alias Model =
  { numA: Int
  , numB: Int
  , operator: String
  , score: Int
  , seed: Rand.Seed
  }



initialModel : Model
initialModel =
  { numA = 0
  , numB = 0
  , operator= "*"
  , score = 0
  , seed = Rand.initialSeed2 12345 67890
  }
  --let
  --  emptyModel =
  --    { score = 0 }
  --in
  --  Maybe.withDefault emptyModel incoming


--UPDATE

type Action = NoOp | Check

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    Check ->
      let
        (num1, seed1) = Rand.generate generator model.seed
        (num2, seed2) = Rand.generate generator seed1
      in
        { model | score = model.score + 1
                , numA = num1
                , numB = num2
                , seed = seed2
        }


generator : Rand.Generator Int
generator =
    Rand.int 1 10

--VIEW

view : Model -> Html
view model =
  div []
    [ div
        []
        [ text (toString model.numA)
        , text (model.operator)
        , text (toString model.numB)
        ]
    , div
        []
        [ text (toString model.score) ]
    , button
        [ onClick inbox.address Check ]
        [ text "Submit" ]
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
  Signal.foldp update initialModel actions


main : Signal Html
main =
  Signal.map view model







