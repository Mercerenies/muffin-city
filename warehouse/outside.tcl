
namespace eval Warehouse::Outside {

    # /////

    proc north {} {
        puts "== Secret Island - North =="
        puts -nonewline "The path leads around the back of the warehouse. There is nothing of\
        interest here except a few trees."
        if {[state get city-thug] eq {island}} then {
            puts -nonewline " The man who robbed you back in the city is sitting on a rock down\
            by the sea."
        }
        switch [state get attorney-man] {
            no - met {}
            talked {
                puts -nonewline " Attorney-Man is lying on the ground, seemingly asleep."
            }
            talked1 {
                puts -nonewline " Attorney-Man is lying on the ground, staring up at\
                the sky."
            }
        }
        puts {}
        # //// Something interesting here
        prompt {} {
            {"Head east" yes east}
            {"Head west" yes west}
            {"Talk to the robber" {[state get city-thug] eq {island}} northTalk}
            {"Talk to Attorney-Man" {[state get attorney-man] in {talked talked1}} northAttorney}
        }
    }

    proc south {} {
        puts "== Secret Island - South =="
        # //// Unlock warehouse from inside
        puts "The southern end of the island contains the entrance to a massive warehouse."
        prompt {} {
            {"Head west" yes west}
            {"Head east" yes east}
            {"Enter the warehouse" yes enterDoor}
        }
    }

    proc east {} {
        puts "== Secret Island - East =="
        # ////
        puts "This edge of the island contains a small dock. You can see the warehouse behind\
        you, but there is no entrance on this side."
        prompt {} {
            {"Head south" yes south}
            {"Head north" yes north}
            {"Approach the dock" yes dock}
        }
    }

    proc west {} {
        puts "== Secret Island - West =="
        if {[state get fe-coin] eq {no}} then {
            state put fe-coin exists
        }
        puts "The western edge of the island is deserted, aside from a few gulls flying to\
        and fro. There is a large outhouse-like structure with the words \"Freight Elevator\"\
        written on the front."
        prompt {} {
            {"Head north" yes north}
            {"Head south" yes south}
            {"Enter the freight elevator" yes ::Underworld::Pits::freight}
        }
    }

    proc enterDoor {} {
        puts "The warehouse entrance is bolted shut."
        puts {}
        return south
    }

    proc dock {} {
        puts "== Island Dock =="
        # //// Dream ship
        puts "The dock is small and deserted. It doesn't look like there have been any ships\
        here in some time."
        prompt {} {
            {"Leave the dock" yes east}
            {"Jump into the water" yes diveIn}
        }
    }

    proc diveIn {} {
        puts "You leap into the water without a second thought."
        state put lobby-door other
        puts {}
        return ::Underworld::Lobby::other
    }

    proc northTalk {} {
        puts "\"Huh?! Ya found me?! Well yer good, I'll give ya that. Here, have yer\
        [state get stolen-good] back and leave me alone!\""
        puts "The robber hands you your [state get stolen-good] and runs off."
        puts {}
        inv add [state get stolen-good]
        state put stolen-good {}
        state put city-thug no
        return north
    }

    proc northAttorney {} {
        switch [state get attorney-man] {
            no - met {}
            talked {
                puts "Attorney-Man jerks awake when you say his name."
                puts "\"Aha! Justice awaits! But... I'm so hungry... I can't\
                enact the trademarked Attorney-Man fist of justice without eating\
                a super special beef 'n' cheese taco first!\""
                state put attorney-man talked1
                prompt {} {
                    {"\"I see...\"" yes north}
                }
            }
            talked1 {
                puts "\"My fist of justice must be fed. A super special beef 'n' cheese\
                taco would do. But where could I possibly get one?\""
                prompt {} {
                    {"\"Good question...\"" yes north}
                }
            }
        }
    }

}
