module Utils.Colors where

-- Some colors for pretty output
data Color
    = Green
    | Purple
    | Blue
    | Red


-- Take a color and a string to get the string in the given color
color :: Color -> String -> String
color Green text  = "\x1b[32m" ++ text ++ "\x1b[0m"
color Purple text = "\x1b[35m" ++ text ++ "\x1b[0m"
color Blue text   = "\x1b[36m" ++ text ++ "\x1b[0m"
color Red text    = "\x1b[31m" ++ text ++ "\x1b[0m"
