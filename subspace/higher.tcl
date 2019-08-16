
namespace eval ::Subspace::Higher {

    proc hub {} {
        puts "== Higher Subspace =="
        puts -nonewline "You are in the center of a large cross-shaped hallway. The\
        walls, floor, and ceiling are all blindingly white and completely featureless. At\
        each of the four ends of the hallway, there is a door."
        switch [state get spicy-visit] {
            0 {
                puts {}
            }
            1 {
                puts " Only the south door is open; the others are sealed shut."
            }
            2 {
                puts " The south and west doors are open, while the other two doors remain\
                sealed."
            }
            3 {
                puts " The east door remains sealed shut, but the south, west, and north doors\
                are all open."
            }
            4 {
                puts " All four doors are open."
            }
        }
        prompt {} {
            {"Enter the south room" yes south}
            {"Enter the west room" {[state get spicy-visit] > 1} west}
            {"Enter the north room" {[state get spicy-visit] > 2} west}
            {"Enter the east room" {[state get spicy-visit] > 3} west}
        }
    }

    proc south {} {
        puts "== Higher Subspace - South Room =="
        if {[state get spicy-visit] in {0 1}} then {
            # First visit
            puts "The south room is arranged like a bedroom, with a\
            twin bed in one corner, a disorganized desk in another, and\
            an old television sitting opposite them both. A tall man in\
            a trenchcoat is standing in the middle of the room."
            prompt {} {
                {"Talk to the man in the trenchcoat" yes southVisit}
                {"Go back" yes hub}
            }
        } else {
            # Revisit
            # ////
            prompt {} {
                {"Go back" yes hub}
            }
        }
    }

    proc southVisit {} {
        puts "The man says nothing and crosses his arms, seemingly waiting for you to\
        make the first move."
        prompt {} {
            {"\"Hi!\"" yes southVisit1}
            {"\"Yo!\"" yes southVisit1}
            {"\"Wassup!\"" yes southVisit1}
        }
    }

    proc southVisit1 {} {
        puts "The man speaks in a rhythmic, almost singsongy voice."
        puts "\"It seems you found me. I'm sure we'll be meeting again before too\
        long. Take my card.\""
        puts "You got the Strange Business Card!"
        inv add {Strange Business Card}
        puts "\"For now, however, it's time for you to go.\""
        puts "Your vision fades to white once again."
        puts {}
        return exitCondition
    }

    proc west {} {
        puts "== Higher Subspace - West Room =="
        # ////
        prompt {} {
            {"Go back" yes hub}
        }
    }

    proc north {} {
        puts "== Higher Subspace - North Room =="
        # ////
        prompt {} {
            {"Go back" yes hub}
        }
    }

    proc east {} {
        puts "== Higher Subspace - East Room =="
        # ////
        prompt {} {
            {"Go back" yes hub}
        }
    }

    proc exitCondition {} {
        switch [state get spicy-return] {
            no {
                # Shouldn't encounter this state but meh
                return ::City::District::entrance
            }
            hotel {
                return ::City::Hotel::ritzyRecovery
            }
        }
    }

}
