
namespace eval City::Shopping {

    proc pawnShop {} {
        puts "== Pawn Shop =="
        if {([state get butler-game] eq {cell}) && ([state get talked-to-louis] eq {yes}) &&
            ([state get jumped-into-fire] eq {yes})} then {
            state put butler-game pawn
        }
        puts -nonewline "The pawn shop has several knick-knacks that don't seem very useful to\
        anybody. There is a shady man standing over in the corner. Presumably, he runs the shop."
        if {[state get butler-game] eq {pawn}} then {
            puts " A familiar man in a butler's uniform is standing behind the door."
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to him" {[state get butler-game] ne {pawn}} pawnTalk}
            {"Talk to the shady man" {[state get butler-game] eq {pawn}} pawnTalk}
            {"Talk to the butler" {[state get butler-game] eq {pawn}} pawnButler}
            {"Go outside" yes ::City::District::shopping}
        }
    }

    proc pawnTalk {} {
        puts "\"Hey. You're not a cop, are ya? ... ... Nah, of course not. Listen, I do business with... special\
        goods here. I'll let you know if I end up with any goods you'd be interested in.\""
        prompt {} {
            {"\"Okay.\"" yes pawnShop}
        }
    }

    proc pawnButler {} {
        if {[state get collected-suit] eq {yes}} then {
            puts "\"Please make good use of that Fireproof Suit.\""
        } else {
            puts "\"Dr. Louis tells me that you spoke to her. Please continue assisting her with\
            her research. Also, take this.\""
            puts "The Butler hands you a Fireproof Suit."
            inv add {Fireproof Suit}
            state put collected-suit yes
        }
        puts {}
        return pawnShop
    }

}
