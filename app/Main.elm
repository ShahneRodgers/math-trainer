module Main where

import Html exposing(..)
import Html.Events exposing (onClick, targetValue, on)
import Random.PCG as Rand
import Time


--MODEL

type alias Model =
  { numA: Int
  , numB: Int
  , operator: String
  , score: Int
  , answer: String
  }



initialModel : Model
initialModel =
  { numA = 0
  , numB = 0
  , operator = "*"
  , score = 0
  , answer = ""
  }
  --let
  --  emptyModel =
  --    { score = 0 }
  --in
  --  Maybe.withDefault emptyModel incoming


--UPDATE

type Action = NoOp | Check | Answer String

update : (Float, Action) -> Model -> Model
update (time, action) model =
  case action of
    NoOp ->
      model

    Answer ans ->
      { model | answer = ans }

    Check ->
      let
        seedM = Rand.initialSeed2 (round time) 12345
        (num1, seed1) = Rand.generate generator seedM
        (num2, seed2) = Rand.generate generator seed1
      in
        { model | score = model.score + 1
                , numA = num1
                , numB = num2
        }


generator : Rand.Generator Int
generator =
    Rand.int 1 10

getAnswer ans =
  ans


--VIEW

view : Model -> Html
view model =
  div []
    [ div
        []
        [ text (toString model.numA)
        , text (model.operator)
        , text (toString model.numB)
        , text " = "
        , input
          [ on "input" targetValue (Signal.message answer.address) ]
          [ ]
        , button
          [ onClick inbox.address Check ]
          [ text "Submit" ]
        ]
    , div
        []
        [ text "Score: "
        , text (toString model.score)
        ]
    , div
        []
        [ text "Answer: "
        , text model.answer
        ]
    ]


--SIGNALS

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  inbox.signal



answer : Signal.Mailbox String
answer =
  Signal.mailbox ""

answerS : Signal String
answerS =
  answer.signal

combined =
  Signal.mergeMany
    [ actions
    , Signal.map (\ans -> Answer ans) answerS
    ]


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







