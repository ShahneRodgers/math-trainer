module Main where

import Html exposing(..)


--MODEL

type alias Model =
  { score: Int }


type alias Math =
  { numA: Int
  , numB: Int
  , operator: String
  }


initialModel : Model
initialModel =
  let
    emptyModel =
      { score = 0 }
  in
    Maybe.withDefault emptyModel incoming


--UPDATE

type Action = NoOp | Check

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    Check ->
      { model | score = model.score + 1 }



--VIEW

view : Math -> Model -> Html
view numbers model =
  div []
    [ div
        []
        [ text (toString numbers.numA)
        , text (numbers.operator)
        , text (toString numbers.numB)
        ]
    , div
        []
        [ text (toString model.score) ]
    ]


--SIGNALS

inbox1 : Signal.Mailbox Action
inbox1 =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  inbox1.signal


inbox2 : Signal.Mailbox Math
inbox2 =
  Signal.mailbox  { numA = 0
                  , numB = 0
                  , operator = "*"
                  }

numbers : Signal Math
numbers =
  inbox2.signal


--PORTS

port incoming : Maybe Model

port outgoing : Signal Model
port outgoing =
  model


--WIRING

model : Signal Model
model =
  Signal.foldp update initialModel actions


main : Signal Html
main =
  Signal.map2 view numbers model







