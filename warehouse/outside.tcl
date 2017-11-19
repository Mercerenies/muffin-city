
namespace eval Warehouse::Outside {

    # /////

    proc north {} {
        puts "== Secret Island - North =="
        puts "The path leads around the back of the warehouse. There is nothing of interest\
        here except a few trees."
        # //// Something interesting here
        prompt {} {
            {"Head east" yes east}
            {"Head west" yes west}
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

}
