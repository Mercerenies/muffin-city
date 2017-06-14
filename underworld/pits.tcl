
namespace eval Underworld::Pits {

    proc fire {} {
        # ////
    }

    proc fireEntry {} {
        if {[inv has {Fireproof Suit}]} then {
            # ////
            return -gameover
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
