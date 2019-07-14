
namespace eval City::Shopping {

    proc pawnShop {} {
        puts "== Pawn Shop =="
        if {([state get butler-game] eq {cell1}) && ([state get talked-to-louis] eq {yes}) &&
            ([state get jumped-into-fire] eq {yes})} then {
            state put butler-game pawn
        }
        puts -nonewline "The pawn shop has several knick-knacks that don't seem very useful to\
        anybody. There is a shady man standing over in the corner. Presumably, he runs the shop."
        if {[state get butler-game] in {pawn pawn1}} then {
            puts " A familiar man in a butler's uniform is standing behind the door."
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to him" {[state get butler-game] ni {pawn pawn1}} pawnTalk}
            {"Talk to the shady man" {[state get butler-game] in {pawn pawn1}} pawnTalk}
            {"Talk to the butler" {[state get butler-game] in {pawn pawn1}} pawnButler}
            {"Go outside" yes ::City::District::shopping}
        }
    }

    proc pawnTalk {} {
        puts "\"Hey. You're not a cop, are ya? ... ... Nah, of course not. Listen, I do\
        business with... special goods here. I'll let you know if I end up with any goods\
        you'd be interested in.\""
        prompt {} {
            {"\"Okay.\"" yes pawnShop}
            {"\"Do you have a pirate costume?\"" {[state get pirate-attack] eq {hat}} pawnHat}
            {"\"Do you have a ship's wheel?\"" {[state get captain-boat] eq {spoken}} pawnWheel}
            {"\"Ship's wheel?\"" {[state get captain-boat] eq {requested}} pawnWheelBuy}
        }
    }

    proc pawnWheel {} {
        puts "\"A ship's wheel? Can't say that I have that. If you had asked me this morning,\
        I probably coulda had it by now.\""
        puts {}
        return pawnShop
    }

    proc pawnWheelBuy {} {
        puts "\"Oh, yeah. Your wheel got here a few hours ago. That'll be one silver coin.\""
        prompt {} {
            {"Hand him a Silver Coin" {[inv has {Silver Coin}]} pawnWheelBuy1}
            {"\"I'll be back.\"" yes pawnShop}
        }
    }

    proc pawnWheelBuy1 {} {
        puts "\"Pleasure doin' business.\""
        puts "You hand the pawn shop owner a Silver Coin, and he hands you a Ship's Wheel."
        inv remove {Silver Coin}
        inv add {Ship's Wheel}
        state put captain-boat obtained
        puts {}
        return pawnShop
    }

    proc pawnHat {} {
        puts "\"Costume's ain't really my thing. But there is a guy who may be\
        able to help. He lives in a basement in the forest by the prison. Guy's\
        obsessed with hats. He may be able to help.\""
        puts {}
        return pawnShop
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
            state put butler-game pawn1
        }
        puts {}
        return pawnShop
    }

    proc market {} {
        puts "== Market =="
        if {([state get merchant-war] eq {yes}) && ([state get resolved-todd] eq {no})} then {
            return marketConfession
        }
        if {[state get resolved-todd] ne {no}} then {
            return marketNoTodd
        }
        switch [state get merchant-war] {
            chip - yes {
                puts -nonewline "The market is neatly organized, with shelves full\
                of various objects."
                if {[state get talked-to-todd] ne {no}} then {
                    puts " Todd is sitting at his computer typing away."
                } else {
                    puts " A man with glasses typing at a computer off\
                    in the corner."
                }
                prompt {} {
                    {"Talk to the man" {[state get talked-to-todd] eq {no}} marketTodd}
                    {"Talk to Todd" {[state get talked-to-todd] ne {no}} marketTodd}
                    {"Go back outside" yes ::City::District::shopping}
                }
            }
            default {
                if {[state get merchant-bot] eq {no}} then {
                    puts -nonewline "The market is neatly organized, with shelves full\
                    of various objects. A one-eyed robot is hovering behind the counter,"
                } else {
                    puts -nonewline "The market is neatly organized, with shelves\
                    full of various objects. Merchant-bot is hovering behind the counter,"
                }
                if {[state get talked-to-todd] ne {no}} then {
                    puts " and Todd is sitting at his computer typing away."
                } else {
                    puts " and a man with glasses typing at a computer off\
                    in the corner."
                }
                prompt {} {
                    {"Talk to the robot" {[state get merchant-bot] eq {no}} marketBot}
                    {"Talk to Merchant-bot" {[state get merchant-bot] ne {no}} marketBot}
                    {"Talk to the man" {[state get talked-to-todd] eq {no}} marketTodd}
                    {"Talk to Todd" {[state get talked-to-todd] ne {no}} marketTodd}
                    {"Go back outside" yes ::City::District::shopping}
                }
            }
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

    proc marketTodd {} {
        switch [state get talked-to-todd] {
            no {
                if {[state get merchant-war] eq {chip}} then {
                    puts "\"Hi, I'm Todd. I manage all of the inventory for this shop.\
                    My manager, Merchant-bot, is out right now, so you'll have to come\
                    back later.\""
                } else {
                    puts "\"Hi, I'm Todd. I manage all of the inventory for this shop.\
                    Please talk to Merchant-bot if you want to make a purchase.\""
                }
                state put talked-to-todd spoken
                puts {}
                return market
            }
            spoken {
                if {[inv has {Fireproof Suit}]} then {
                    if {[state get merchant-war] eq {chip}} then {
                        puts "\"Is that a Fireproof Suit? I've been looking\
                        for one of those actually. I'll trade you my Scuba\
                        Suit for your Fireproof Suit.\""
                    } else {
                        puts "\"Please talk to Merchant-bot if you w- Is that a\
                        Fireproof Suit? I've been looking for one of those actually.\
                        I'll trade you my Scuba Suit for your Fireproof Suit.\""
                    }
                    state put talked-to-todd {Scuba Suit}
                    prompt {} {
                        {"Trade" yes marketTrade}
                        {"\"Later.\"" yes market}
                    }
                } else {
                    return marketToddPassive
                }
            }
            {Scuba Suit} {
                if {[inv has {Fireproof Suit}]} then {
                    puts "\"Want to trade? I'll give you my Scuba Suit for your Fireproof Suit.\""
                    prompt {} {
                        {"Trade" yes marketTrade}
                        {"\"Where is Merchant-bot?\"" {[state get merchant-war] eq {chip}} marketToddPanic}
                        {"\"Later.\"" yes market}
                    }
                } else {
                    return marketToddPassive
                }
            }
            {Fireproof Suit} {
                if {[inv has {Scuba Suit}]} then {
                    puts "\"Want to trade? I'll give you back your Fireproof Suit for the\
                    Scuba Suit.\""
                    prompt {} {
                        {"Trade" yes marketTrade}
                        {"\"Where is Merchant-bot?\"" {[state get merchant-war] eq {chip}} marketToddPanic}
                        {"\"Later.\"" yes market}
                    }
                } else {
                    return marketToddPassive
                }
            }
        }
    }

    proc marketToddPassive {} {
        if {[state get merchant-war] eq {chip}} then {
            puts "\"Merchant-bot isn't here right. You'll have to come back later.\""
        } else {
            puts "\"Please talk to Merchant-bot if you want to make a purchase.\""
        }
        puts {}
        return market
    }

    proc marketToddPanic {} {
        puts "\"It was the strangest thing. A few minutes ago, Merchant-bot just stormed out\
        of here without saying a word. I don't know where he went.\""
        puts "Todd glances about the market nervously for a moment but says nothing more."
        puts {}
        return market
    }

    proc marketTrade {} {
        switch [state get talked-to-todd] {
            {Scuba Suit} {
                puts "\"Excellent!\""
                puts "You give up your Fireproof Suit and take the Scuba Suit."
                inv remove {Fireproof Suit}
                inv add {Scuba Suit}
                state put talked-to-todd {Fireproof Suit}
                puts {}
                return market
            }
            {Fireproof Suit} {
                puts "\"Excellent!\""
                puts "You give up your Scuba Suit and take the Fireproof Suit."
                inv remove {Scuba Suit}
                inv add {Fireproof Suit}
                state put talked-to-todd {Scuba Suit}
                puts {}
                return market
            }
            default {
                puts {}
                return market
            }
        }
    }

    proc marketConfession {} {
        if {[state get talked-to-todd] eq {no}} then {
            puts "A man with glasses gets up from his chair and confronts\
            you."
        } else {
            puts "Todd immediately gets up from his chair and confronts you."
        }
        puts "\"What's that in your pocket?!\""
        puts "He points at Merchant-bot's Eye."
        prompt {} {
            {"\"Uhhh... nothing?\"" yes marketDeny}
            {"\"Merchant-bot's eye.\"" yes marketAccept}
            {"\"I killed Merchant-bot.\"" yes marketBrag}
        }
    }

    proc marketDeny {} {
        puts "\"That's Merchant-bot's Eye! He's dead! You killed him!\""
        prompt {} {
            {"\"Okay, fine, I did it.\"" yes marketBrag}
        }
    }

    proc marketAccept {} {
        puts "\"But that means... is he dead? Is Merchant-bot dead?\""
        prompt {} {
            {"\"I had to do it.\"" yes marketBrag}
        }
    }

    proc marketBrag {} {
        puts "\"I knew it! I knew you were the one! Merchant-bot had been acting funny lately,\
        so I figured someone had gotten my notes.\""
        prompt {} {
            {"\"You left those clues for me?\"" yes marketBrag1}
        }
    }

    proc marketBrag1 {} {
        if {[state get talked-to-todd] eq {no}} then {
            puts "\"I guess I should explain. My name is Todd.\""
            state put talked-to-todd spoken
        } else {
            puts "\"I guess I should explain.\""
        }
        puts "Todd straightens his glasses nervously."
        puts "\"I started working for Merchant-bot several years ago. About a year ago,\
        I got a better offer and turned in my resignation. Merchant-bot wouldn't let me\
        quit. He kidnapped my family and forced me to keep working here. I've been looking\
        for a way out ever since. A few months ago, Merchant-bot had me deliver a message\
        for him. It looked important, so I made a copy and left it in the warehouse for\
        someone to find. I buried a spare key to the warehouse and left a message, hoping\
        someone would put the pieces together. And you did! So thank you!\""
        prompt {} {
            {"\"What will you do now?\"" yes marketBrag2}
        }
    }

    proc marketBrag2 {} {
        puts "\"Well, I still need to find my family. But without Merchant-bot watching over\
        my shoulder, that should be a lot easier. I'm definitely not staying here. Listen,\
        if you need me for anything, I'll probably be over at the Ritzy Inn. I know some\
        people there who may be able to help me with my search.\""
        puts "Todd steps by you and walks out the exit."
        state put resolved-todd searching
        puts {}
        return market
    }

    proc marketNoTodd {} {
        puts -nonewline "The market is neatly organized, with shelves full\
        of various objects. "
        # //// Merchant-bot 2.0?
        puts "Unfortunately, there doesn't appear to be anyone here to sell you\
        anything right now."
        prompt {} {
            {"Steal everything" yes marketSteal}
            {"Go back outside" yes ::City::District::shopping}
        }
    }

    proc marketSteal {} {
        puts "As soon as you touch one of the products, an automated alarm starts\
        blasting in your ears, and the walls open up to reveal hidden lasers,\
        which instantly vaporize you."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door other
        }
        puts {}
        return ::Underworld::Lobby::other
    }

    proc boarded {} {
        puts "== Boarded Building =="
        # //// This place probably shouldn't be boarded up. Maybe
        # locked and surrounded in police tape but not boarded
        puts "The relatively small building has wooden boards nailed to the doors and\
        all of the windows. The sign which used to contain the name of the business\
        seems to have been taken away."
        prompt {} {
            {"Force the door" yes boardedForce}
            {"Go back" yes ::City::District::shopping}
        }
    }

    proc boardedForce {} {
        puts "The boards do not budge, no matter how hard you shove them."
        puts {}
        return boarded
    }

}
