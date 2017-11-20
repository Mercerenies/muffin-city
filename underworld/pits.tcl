
namespace eval Underworld::Pits {

    proc freight {} {
        puts "== Freight Elevator =="
        puts -nonewline "The freight elevator is large, obviously designed to carry significant\
        amounts of cargo. There are only two buttons on the elevator's controls."
        if {[state get fe-coin] eq {exists}} then {
            puts " Someone left a Silver Coin on the floor of the elevator."
        } else {
            puts {}
        }
        prompt {} {
            {"Go to the storage room" yes backRoom}
            {"Go to the warehouse" yes ::Warehouse::Outside::west}
            {"Pick up the coin" {[state get fe-coin] eq {exists}} freightCoin}
        }
    }

    proc freightCoin {} {
        puts "You collect the Silver Coin."
        state put fe-coin yes
        inv add {Silver Coin}
        puts {}
        return freight
    }

    proc backRoom {} {
        puts "== Underworld Storage =="
        puts "You find yourself in a small room with cardboard boxes lining the\
        walls. There is an elevator in the back labeled \"Freight Elevator\". An\
        opening on the opposite side leads to pits of fire."
        prompt {} {
            {"Go toward the fire pits" yes fire}
            {"Enter the elevator" yes freight}
        }
    }

    proc fire {} {
        if {[inv has {Fireproof Suit}]} then {
            puts "== Fire Pits =="
            puts "There is fire all around you, but it seems to cower away from you.\
            The balcony is too high to climb onto, so the only way out of the pits is\
            through the back exit."
            prompt {} {
                {"Exit through the back" yes backRoom}
            }
        } else {
            puts "The fire burns all around you, but you feel no pain. In a blind panic,\
            you rush toward the nearest exit."
            puts {}
            return backRoom
        }
    }

    proc fireEntry {} {
        if {[inv has {Fireproof Suit}]} then {
            puts "You don your Fireproof Suit and leap into the fire pits. The fire sways outward,\
            almost as though it's actively avoiding you."
            puts {}
            return fire
        } else {
            if {[state get talked-to-johnny]} then {
                set johnny "Johnny Death"
            } else {
                set johnny "The strange man"
            }
            puts "Without a second thought, you leap into the fire pits. You immediately catch\
            fire, yet strangely you don't seem to be feeling any pain. $johnny throws a\
            rope over the edge, which doesn't seem to catch fire."
            puts "\"Climb on!\""
            prompt {} {
                {"Climb the rope" yes ::Underworld::Johnny::climbed}
                {"Run away" yes fireEntryRun}
            }
        }
    }

    proc fireEntryRun {} {
        puts "You run about, but with the flames in your face you can't see well enough to get out\
        of the immediate area."
        prompt {} {
            {"Climb the rope" yes ::Underworld::Johnny::climbed}
        }
    }

}
