
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
            {"\"Thank you.\"" yes pawnShop}
        }
    }

    proc locksmithEntry {} {
        # //// Will not be allowed to enter once the police have raided
        return locksmith
    }

    proc locksmith {} {
        puts "== Steve's Smash-a-Lock =="
        puts -nonewline "The locksmith's shop is very disorganized, with various locks, keys,\
        and other objects scattered around the floor. "
        if {[state get talked-to-steve] eq {yes}} then {
            puts "Steve is standing behind the counter, fiddling with a small\
            padlock."
        } else {
            puts "A young woman with glasses and hair in a ponytail is standing behind the\
            counter."
        }
        prompt {} {
            {"Talk to Steve" {[state get talked-to-steve] eq {yes}} steve}
            {"Talk to the woman" {[state get talked-to-steve] eq {no}} steve}
            {"Leave" yes ::Past::District::shopping}
        }
    }

    proc steve {} {
        if {[state get talked-to-steve] eq {yes}} then {
            puts "\"If you've got a lock, we'll smash it!\""
            prompt {} {
                {"\"Have a nice day.\"" yes locksmith}
            }
        } else {
            state put talked-to-steve yes
            puts "\"Hi, there! I'm Steve, of Steve's Smash-a-Lock! If you've got a lock,\
            we'll smash it! What can I do for you?\""
            prompt {} {
                {"\"Nothing right now. Thank you.\"" yes locksmith}
            }
        }
    }

}
