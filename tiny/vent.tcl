
namespace eval Tiny::Vent {

    # //// Note: Risk of softlock if you kill the rat. Make sure
    # there's another way out.

    proc heartRoom {} {
        puts "== Heart Room - Tiny =="
        puts -nonewline "The enormous set of stairs leading up to the main room of the\
        research facility seems impossible to scale. Even the pedestal in the center of\
        the room is difficult to climb onto and off of. The lasers surrounding the\
        pedestal are pointing up into the air, well above your height."
        if {[state get stairs-tried] eq {yes}} then {
            puts " There is an air vent in the corner of the room that may be low\
            enough for you to enter."
        } else {
            puts {}
        }
        prompt {} {
            {"Climb the stairs" yes heartStairs}
            {"Enter the air vent" {[state get stairs-tried] eq {yes}} ventilation}
            {"Stand on the pedestal" yes heartPedestal}
        }
    }

    proc heartStairs {} {
        puts "You leap up and try to scale the massive staircase, but you're simply\
        too small. You can't even reach the first step."
        puts {}
        state put stairs-tried yes
        return heartRoom
    }

    proc heartPedestal {} {
        puts "You climb up onto the pedestal, but nothing happens. The lasers do not\
        even seem to acknowledge your presence."
        puts {}
        return heartRoom
    }

    proc ventilation {} {
        puts "== Ventilation Shaft =="
        puts -nonewline "The ventilation shaft certainly would not have held you\
        at full size, but in your current state it's more than roomy enough. The\
        shaft continues with a steady incline upward and also forks off to the left."
        if {[state get talked-to-grigory]} then {
            puts " Grigory is standing next to the fork, glancing shiftily back and\
            forth."
        } else {
            puts " A man in an air conditioning repair uniform is standing at the fork."
        }
        # //// Up
        prompt {} {
            {"Go down" yes heartRoom}
            {"Go up" yes {::Empty::back ::Tiny::Vent::ventilation}}
            {"Go left" yes deepVent}
            {"Talk to the air conditioning man" {![state get talked-to-grigory]} grigory}
            {"Talk to Grigory" {[state get talked-to-grigory]} grigory}
        }
    }

    proc grigory {} {
        if {[state get talked-to-grigory]} then {
            puts "\"Good evening.\""
            prompt {} {
                {"\"Directions?\"" yes directions}
                {"\"Later.\"" yes ventilation}
            }
        } else {
            puts "\"Good evening, I am Grigory, the air condition repair man.\""
            puts "Grigory speaks with a very thick accent."
            puts "\"I repair air condition for hotel. When suddenly, I am fall\
            into ventilation.\""
            state put talked-to-grigory yes
            prompt {} {
                {"\"Do you know your way around here?\"" yes directions}
                {"\"Never mind.\"" yes ventilation}
            }
        }
    }

    proc directions {} {
        puts "\"Up that way leads outside. Down goes to science lab. Fork is\
        dangerous. There is, how you say, giant vermin in fork.\""
        puts {}
        return ventilation
    }

    proc deepVent {} {
        puts "== Deep Ventilation Shaft =="
        puts "Deeper into the air conditioning vents, the path winds and turns quite a\
        bit more. If you're not careful, you could get lost in here."
        puts {}
        puts "A giant rat appears out of nowhere!"
        prompt {} {
            {"Run" yes runAway}
            {"Fight" yes ratFight}
        }
    }

    proc runAway {} {
        puts "You flee back into the safety of the fork. The rat seems to get lost\
        following you."
        puts {}
        return ventilation
    }

    proc ratFight {} {
        puts "You endeavor to fight the rat, but with your current size and stature you\
        are easily dispatched."
        # //// Rat poison will take care of him (possibly have to keep it normal sized) (also, maybe an easter egg if you try to use Atheena's blade, although it will ultimately be ineffectual) (maybe not something poisonous, so you can ride him later?)
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door wildlife
        }
        puts {}
        return ::Underworld::Lobby::wildlife
    }

}
