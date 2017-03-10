module Translations exposing (..)


type Language
    = En
    | Es
    | Fr


shareYourExperiance : Language -> String -> String
shareYourExperiance language buisnessName =
    case language of
        En ->
            "Would you like to share your Experiance about " ++ buisnessName ++ "?"

        Es ->
            "¿Te gustaría compartir tu experiencia sobre " ++ buisnessName ++ "?"

        Fr ->
            "Souhaitez-vous partager votre expérience sur " ++ buisnessName ++ "?"


otherSite : Language -> String
otherSite translation =
    case translation of
        En ->
            "Other site"

        Es ->
            "Otro sitio"

        Fr ->
            "Autre site"


leaveAReview : Language -> String -> String
leaveAReview translation site =
    case translation of
        En ->
            "Leave a Review on " ++ site

        Es ->
            "Deja un comentario sobre " ++ site

        Fr ->
            "Laisser un avis sur " ++ site
