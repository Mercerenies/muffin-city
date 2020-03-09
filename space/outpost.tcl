
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
        puts "The top area of the prison consists of a single large,\
        round, open room. There are no windows, and the only door\
        leading outside is sealed shut. An older purple alien is\
        sitting on a bench near the outer wall, looking at you."
        prompt {} {
            {"Walk down the ramp" yes prisonMiddleFloor}
            {"Talk to the purple elder" yes purpleElder}
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

    proc purpleElder {} {
        puts "\"Good day to you.\""
        prompt {} {
            {"\"You can speak English?\"" yes purpleElderEnglish}
            {"\"What is this place?\"" yes purpleElderWar}
            {"\"Goodbye.\"" yes prisonTopFloor}
        }
    }

    proc purpleElderEnglish {} {
        puts "The alien motions to a small cylindrical contraption attached\
        to his belt."
        puts "\"Not natively. But my Universal Translator allows us to\
        communicate.\""
        # //// Asking about the translator
        prompt {} {
            {"\"Interesting.\"" yes prisonTopFloor}
        }
    }

    proc purpleElderWar {} {
        puts "\"A military prison. An artifact of an endless, pointless\
        war.\""
        prompt {} {
            {"\"What war?\"" yes purpleElderWar1}
        }
    }

    proc purpleElderWar1 {} {
        puts "\"We're all proud Semotians at heart. But for many decades, a dividing\
        line has been drawn between the races, the green and the purple. The war\
        began several years ago, but it feels like centuries. I was drafted as a\
        spy and sent here to discern our enemies' plan with regard to the humans\
        on earth. Unfortunately, I was captured and left here to rot.\""
        # /////
        puts {}
        return {::Empty::back ::Space::Outpost::purpleElder}
    }

}
