module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


--import Html.Attributes exposing (..)

import Html.App as App
import Http
import Task
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)


main : Program Never
main =
    App.program { init = init, view = view, update = update, subscriptions = subscriptions }


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        task =
            Http.get decoder url

        cmd =
            Task.perform Fail Joke task
    in
        cmd



--decoder : Decoder String
--decoder =
--    at [ "value", "joke" ] string


decoder : Decoder Response
decoder =
    decode Response
        |> required "id" int
        |> required "joke" string
        |> optional "categories" (list string) []
        |> at [ "value" ]


type alias Response =
    { id : Int
    , joke : String
    , categories : List String
    }



-- model


type alias Model =
    String


initModel : Model
initModel =
    "Finding a joke..."


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )



-- update


type Msg
    = Joke Response
    | Fail Http.Error
    | GetJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke response ->
            ( toString response.id ++ " " ++ response.joke, Cmd.none )

        Fail error ->
            ( toString error, Cmd.none )

        GetJoke ->
            ( "fetching a joke...", randomJoke )



-- view


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model ]
        , button [ onClick GetJoke ] [ text "Get New Joke" ]
        ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
