module Translations exposing (..)


type Translation
    = En
    | Es
    | Fr


shareYourExperiance : Translation -> String -> String
shareYourExperiance language buisnessName =
    case language of
        En ->
            "Would you like to share your Experiance about " ++ buisnessName ++ "?"

        Es ->
            "¿Te gustaría compartir tu experiencia sobre " ++ buisnessName ++ "?"

        Fr ->
            "Souhaitez-vous partager votre expérience sur " ++ buisnessName ++ "?"
