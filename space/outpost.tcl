
namespace eval Space::Outpost {

    proc outside {} {
        if {[state get moon-research] eq {no}} then {
            puts -nonewline "As you approach the fortress, you are greeted by several tall,\
            lanky, green aliens with large heads. They are dressed in matching\
            white uniforms and are all carrying some sort of two-handed alien\
            firearm."
            if {[inv has {Universal Translator}]} then {
                puts " The aliens begin yelling at you."
                puts "\"Human intruder! Surrender yourself to our custody now, human!\""
            } else {
                puts " The aliens begin yelling at you in an unknown language."
            }
            prompt {} {
                {"Run away" yes outsideFlee}
                {"Put your hands in the air" yes outsideSurrender}
                {"\"Hey, what's going on?\"" yes outsideArgue}
            }
        } else {
            return {::Empty::back {::Space::Moon::darkSide low}}
        }
    }

    proc outsideFlee {} {
        puts "You turn and run away, only to feel the intense force of\
        several laser beams in your back."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc outsideSurrender {} {
        puts "You throw your hands in the air and surrender peacefully.\
        The aliens approach and rather roughly force you inside the fortress and\
        into a nearby large cylindrical building, before exiting and sealing the\
        door behind you."
        puts {}
        return prisonTopFloor
    }

    proc outsideArgue {} {
        if {[inv has {Universal Translator}]} then {
            puts "\"You're trespassing on a military outpost!\""
        } else {
            puts -nonewline "The aliens begin yelling at you in an unknown language. "
        }
        puts "The aliens approach you and rather roughly force you inside the\
        fortress and into a nearby large cylindrical building, before exiting\
        and sealing the door behind you."
        puts {}
        return prisonTopFloor
    }

    proc prisonTopFloor {} {
        puts "== Military Prison - Top Floor =="
        # ////
        prompt {} {
            {"Walk down the ramp" yes prisonMiddleFloor}
        }
    }

    proc prisonMiddleFloor {} {
        puts "== Military Prison - Middle Floor =="
        # ////
        prompt {} {
            {"Walk up the ramp" yes prisonTopFloor}
            {"Walk down the ramp" yes prisonBottomFloor}
            {"Enter the sleeping chambers" yes prisonSleepingChambers}
        }
    }

    proc prisonBottomFloor {} {
        puts "== Military Prison - Bottom Floor =="
        # ////
        prompt {} {
            {"Walk up the ramp" yes prisonMiddleFloor}
        }
    }

    proc prisonSleepingChambers {} {
        puts "== Military Prison - Sleeping Chambers =="
        # ////
        prompt {} {
            {"Exit the sleeping chambers" yes prisonMiddleFloor}
            {"Step into a pod and go to sleep" yes {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}}
        }
    }

}
