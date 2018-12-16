
namespace eval Past::Shopping {

    proc pawnShopEntry {} {
        if {[state get pawn-shop-pass] eq {yes}} then {
            return pawnShop
        }
        puts "The door to the pawn shop is locked."
        puts "\"Oi! We're closed right now!\""
        prompt {} {
            {"Kick down the door" yes pawnShopKick}
            {"\"Bowling tournament!\"" {[state get pawn-shop-pass] eq {has}} pawnShop}
            {"\"Alright, I'll come back later.\"" yes ::Past::District::shopping}
        }
    }

    proc pawnShopKick {} {
        puts "You kick the door. It has little effect."
        prompt {} {
            {"Leave" yes ::Past::District::shopping}
        }
    }

    proc pawnShopAccept {} {
        puts "The door to the pawn shop clicks as it unlocks."
        puts {}
        return pawnShop
    }

    proc pawnShop {} {
        puts "== Pawn Shop - Past =="
        state put pawn-shop-pass yes
        puts "The pawn shop has several knick-knacks that don't seem very useful to\
        anybody. There is a shady man standing over in the corner. Presumably, he\
        runs the shop."
        prompt {} {
            {"Talk to him" yes pawnTalk}
            {"Go outside" yes ::Past::District::shopping}
        }
    }

    proc pawnTalk {} {
        puts "\"You mus' know some guys who know some guys in order to have my password,\
        if ya know what I mean. Let me know if there's any merchandise I can... acquire for\
        you.\""
        prompt {} {
            {"\"Can you get me a ship's wheel?\"" {[state get captain-boat] eq {spoken}} pawnWheel}
            {"\"Do you have a pirate costume?\"" {[state get pirate-attack] eq {hat}} pawnHat}
            {"\"The wheel?\"" {[state get captain-boat] eq {requested}} pawnWheelNotYet}
            {"\"Thank you.\"" yes pawnShop}
        }
    }

    proc pawnWheel {} {
        puts "\"A ship's wheel? Sure, I can get that for ya. Just gimme a few hours.\""
        state put captain-boat requested
        puts {}
        return pawnShop
    }

    proc pawnWheelNotYet {} {
        puts "\"It'll be a few more hours before your wheel gets here.\""
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

    proc locksmithEntry {} {
        # //// Will not be allowed to enter once the police have raided
        return locksmith
    }

    proc locksmith {} {
        puts "== Steve's Smash-a-Lock =="
        puts -nonewline "The locksmith's shop is very disorganized, with various locks, keys,\
        and other objects scattered around the floor."
        if {[state get steve-disappeared] ne {no}} then {
            if {([state get reaper-helper] eq {locksmith1}) && (![inv has {Cursed Chest}])} then {
                puts " The Cursed Chest is sitting on the counter."
                prompt {} {
                    {"Take the Cursed Chest" yes locksmithCurse}
                    {"Leave" yes ::Past::District::shopping}
                    }
            } else {
                puts {}
                prompt {} {
                    {"Leave" yes ::Past::District::shopping}
                }
            }
        } elseif {[state get talked-to-steve] eq {yes}} then {
            puts " Steve is standing behind the counter, fiddling with a small\
            padlock."
            prompt {} {
                {"Talk to Steve" yes steve}
                {"Leave" yes ::Past::District::shopping}
            }
        } else {
            puts " A young woman with glasses and hair in a ponytail is standing behind the\
            counter."
            prompt {} {
                {"Talk to the woman" yes steve}
                {"Leave" yes ::Past::District::shopping}
            }
        }
    }

    proc locksmithCurse {} {
        puts "You got the Cursed Chest!"
        inv add {Cursed Chest}
        puts {}
        return locksmith
    }

    proc steve {} {
        if {[state get talked-to-steve] eq {yes}} then {
            puts "\"If you've got a lock, we'll smash it!\""
            prompt {} {
                {"Show her the Cursed Chest" {[inv has {Cursed Chest}]} steveChest}
                {"\"The chest?\"" {[state get reaper-helper] eq {locksmith}} steveChestBusy}
                {"\"Have a nice day.\"" yes locksmith}
            }
        } else {
            state put talked-to-steve yes
            puts "\"Hi, there! I'm Steve, of Steve's Smash-a-Lock! If you've got a lock,\
            we'll smash it! What can I do for you?\""
            prompt {} {
                {"Show her the Cursed Chest" {[inv has {Cursed Chest}]} steveChest}
                {"\"Nothing right now. Thank you.\"" yes locksmith}
            }
        }
    }

    proc steveChest {} {
        puts "\"You need this chest opened? Sure, I can do that.\""
        prompt {} {
            {"\"What's your price?\"" yes steveChest1}
        }
    }

    proc steveChest1 {} {
        puts "\"Tell you what. I won't even charge anything. All you've got to do\
        is help me out with something.\""
        puts "Steve takes a briefcase out of a desk drawer and sets it in front of you."
        puts "\"I just need you to hold onto this for awhile. Just make sure the police\
        don't get their hands on it.\""
        prompt {} {
            {"\"It's a deal.\"" yes steveChestYes}
            {"\"I don't feel good about this.\"" yes steveChestNo}
        }
    }

    proc steveChestNo {} {
        puts "\"Hm... well let me know if you change your mind.\""
        puts {}
        return locksmith
    }

    proc steveChestYes {} {
        puts "You got the Suspicious Briefcase!"
        inv add {Suspicious Briefcase}
        puts "You set the Cursed Chest on Steve's desk."
        inv remove {Cursed Chest}
        puts "\"I'll get to that in just a bit. I have to finish up with this\
        one first.\""
        state put reaper-helper locksmith
        prompt {} {
            {"Warn her about the curse" yes steveChest2}
            {"Assume she'll figure it out" yes locksmith}
        }
    }

    proc steveChest2 {} {
        puts "\"What's that? An ancient curse? Oh, alright. I'll be careful.\""
        puts {}
        return locksmith
    }

    proc steveChestBusy {} {
        puts "\"I'll get on it as soon as I finish up over here.\""
        puts {}
        return locksmith
    }

}
