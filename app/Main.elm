module Main where

import Html exposing(..)


--MODEL

type alias Model =
  { numA: Int
  , numB: Int
  , operator: String
  }


initialModel : Model
initialModel =
  let
    emptyModel =
      { numA = 0
      , numB = 0
      , operator = "-"
      }
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
      { model | numA = 1 }



--VIEW

view : Model -> Html
view model =
  div []
    [ text (toString model.numA)
    , text (model.operator)
    , text (toString model.numB)
    ]


--SIGNALS

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  inbox.signal


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
  Signal.map view model







