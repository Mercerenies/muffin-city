
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
        puts "\"Hey. You're not a cop, are ya? ... ... Nah, of course not. Listen, I do\
        business with... special goods here. I'll let you know if I end up with any goods\
        you'd be interested in.\""
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

    proc market {} {
        puts "== Market =="
        switch [state get merchant-bot] {
            no {
                set bot0 "A robot"
                set bot1 "the robot"
            }
            met {
                set bot0 "Merchant-bot"
                set bot1 "Merchant-bot"
            }
        }
        puts "The market is neatly organized, with shelves full of various objects. $bot0 is\
        hovering behind the counter, and a man with glasses typing at a computer off\
        in the corner."
        # //// Opportunity to talk to Todd
        prompt {} {
            {"Talk to the robot" yes marketBot}
            {"Go back outside" yes ::City::District::shopping}
        }
    }

    proc marketBot {} {
        switch [state get merchant-bot] {
            no {
                puts "\"BZZT! I am MERCHANT-BOT! How may I be of service? BZZT!\""
                puts "Merchant-bot's chest switches to a display containing the\
                items available for purchase."
                state put merchant-bot met
            }
            met {
                puts "\"BZZT! Welcome back! How may I be of service? BZZT!\""
                puts "Merchant-bot's chest switches to a display containing the\
                items available for purchase."
            }
        }
        # //// Expensive item as well (possibly the lantern?)
        prompt {} {
            {"Buy a Green Olive (1 Silver Coin)" {![state get olive-bought]} marketOlive}
            {"\"Never mind.\"" yes market}
        }
    }

    proc marketOlive {} {
        if {[inv has {Silver Coin}]} then {
            switch [state get merchant-bot] {
                no - met {
                    puts "A slot opens in the top of Merchant-bot's head. You insert a\
                    Silver Coin in the slot."
                    puts "\"BZZT! Payment accepted! Enjoy your GREEN OLIVE! BZZT!\""
                    puts "You collect the Green Olive."
                    inv remove {Silver Coin}
                    inv add {Green Olive}
                    state put olive-bought yes
                }
            }
        } else {
            switch [state get merchant-bot] {
                no - met {
                    puts "\"BZZT! You cannot afford a GREEN OLIVE! BZZT!\""
                }
            }
        }
        puts {}
        return market
    }

}
