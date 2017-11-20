
namespace eval Warehouse::Outside {

    # /////

    proc north {} {
        puts "== Secret Island - North =="
        puts -nonewline "The path leads around the back of the warehouse. There is nothing of\
        interest here except a few trees."
        if {[state get city-thug] eq {island}} then {
            puts " The man who robbed you back in the city is sitting on a rock down by the sea."
        } else {
            puts {}
        }
        # //// Something interesting here
        prompt {} {
            {"Head east" yes east}
            {"Head west" yes west}
            {"Talk to the robber" {[state get city-thug] eq {island}} northTalk}
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
        # //// Jump in
        puts "The dock is small and deserted. It doesn't look like there have been any ships\
        here in some time."
        prompt {} {
            {"Leave the dock" yes east}
        }
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

}
