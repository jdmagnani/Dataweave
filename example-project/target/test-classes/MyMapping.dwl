/**
* This mapping won't be shared through your library, but you can use it to try out your module and create integration tests.
*/
%dw 2.0
output application/json

import every from dw::core::Arrays
import helloWorld from MyModule
import lines from dw::core::Strings
var maxRed = 12
var maxGreen = 13
var maxBlue = 14
---
lines(payload) map ((game, gameidx) -> do {
    var sets = game[8 to -1] splitBy ";" map (
        trim($) splitBy "," reduce ((item, acc={}) -> 
                acc ++ {
                    ((item scan /red|green|blue/)[0][0]): ((item scan /\d+/)[0][0]) as Number
                }
            )
        )
    --- 
    {
        game: gameidx+1,
        sets: sets,
        isPossible: (sets reduce ((set, acc=[]) -> 
            acc
            + ((set.red  default 0) <= maxRed)
            + ((set.green  default 0) <= maxGreen)
            + ((set.blue  default 0) <= maxBlue)
        )) every $
    } 
}) 
filter $.isPossible
then $.game
then sum($)