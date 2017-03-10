module Main exposing (..)

import CDN exposing (bass)
import Html exposing (..)
import Html.Attributes exposing (class, href, selected, style)
import Html.Events exposing (onClick)
import List.Zipper as ZipList
import Translations exposing (Language)


type alias Url =
    String


type alias BuisnessName =
    String


type SiteName
    = Google
    | Yelp
    | Facebook
    | DealerRater
    | Other


type alias SiteList =
    ZipList.Zipper ( SiteName, Url )


type alias Model =
    { buisnessName : BuisnessName
    , reviewPages : SiteList
    , language : Translations.Language
    }


init : ( Model, Cmd msg )
init =
    ( { buisnessName = "Elm Street"
      , language = Translations.Es
      , reviewPages =
            -- this is a little weird how it's defined, basically it assures that the
            -- list is never empty. In the real life this won't really happen or
            -- we'll want to explicitly handle the "no sites" case
            ZipList.fromList
                [ ( Google, "http://google.com" )
                , ( Yelp, "http://yelp.com" )
                , ( DealerRater, "http://dearrater.com" )
                ]
                |> Maybe.withDefault (ZipList.singleton ( Other, "google.com" ))
      }
    , Cmd.none
    )


reviewWebsiteToString : SiteName -> String
reviewWebsiteToString reviewWebsite =
    case reviewWebsite of
        Google ->
            "Google"

        Yelp ->
            "Yelp"

        Facebook ->
            "Facebook"

        DealerRater ->
            "DealerRater"

        Other ->
            "Other"


type Msg
    = NextPage
    | PreviousPage


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NextPage ->
            let
                reviewPages =
                    model.reviewPages
                        |> ZipList.next
            in
                case reviewPages of
                    Just reviewPages ->
                        ( { model | reviewPages = reviewPages }, Cmd.none )

                    Nothing ->
                        -- TODO: Go to "sending you to... page"
                        ( model, Cmd.none )

        PreviousPage ->
            let
                reviewPages =
                    model.reviewPages
                        |> ZipList.previous
                        |> Maybe.withDefault (ZipList.singleton ( Other, "http://podium.com" ))
            in
                ( { model | reviewPages = reviewPages }, Cmd.none )


viewBack : Model -> Html Msg
viewBack model =
    let
        message =
            case ZipList.previous model.reviewPages of
                Just _ ->
                    "< back"

                Nothing ->
                    ""
    in
        a [ class "m3 left", onClick PreviousPage ] [ text message ]


buttonStyle : SiteName -> Attribute msg
buttonStyle site =
    let
        textColor =
            ( "color", "white" )

        transition =
            ( "transition", "background-color 0.4s" )
    in
        case site of
            Google ->
                style [ textColor, transition, ( "background-color", "#217df3" ) ]

            Yelp ->
                style [ textColor, transition, ( "background-color", "red" ) ]

            Facebook ->
                style [ textColor, transition, ( "background-color", "blue" ) ]

            DealerRater ->
                style [ textColor, transition, ( "background-color", "#ff7800" ) ]

            Other ->
                style [ textColor, transition, ( "background-color", "gray" ) ]


styleFullScreen : Attribute msg
styleFullScreen =
    style
        [ ( "height", "100vh" )
        , ( "position", "relitive" )
        ]


styleVerticalCenter : Attribute msg
styleVerticalCenter =
    style
        [ ( "position", "absolute" )
        , ( "top", "50%" )
        , ( "left", "50%" )
        , ( "transform", "translate(-50%,-50%)" )
        ]


view : Model -> Html Msg
view model =
    let
        ( page, url ) =
            (ZipList.current model.reviewPages)
    in
        div [ styleFullScreen ]
            [ bass.css
            , viewBack model
            , div [ class "center", styleVerticalCenter ]
                [ p [ class "h2" ]
                    [ text <| Translations.shareYourExperiance model.language model.buisnessName
                    ]
                , reviewButton model.language url page
                , div [ class "p3" ]
                    [ viewNext model
                    ]
                ]
            ]


reviewButton : Language -> Url -> SiteName -> Html msg
reviewButton language url page =
    let
        pageName =
            reviewWebsiteToString page
    in
        a
            [ buttonStyle page
            , class "white p2 my2 border rounded white bg-blue text-decoration-none"
            , href url
            ]
            [ text <| Translations.leaveAReview language pageName ]


viewNext : Model -> Html Msg
viewNext model =
    let
        message =
            case ZipList.next model.reviewPages of
                Just _ ->
                    Translations.otherSite model.language

                Nothing ->
                    ""
    in
        a [ class "m3", onClick NextPage ] [ text message ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }
