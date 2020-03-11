
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
            {"\"What is this place?\"" {[state get know-about-moon-war] eq {no}} purpleElderWar}
            {"\"Why is this place here on earth's moon?\"" {([state get know-about-moon-war] eq {yes}) && ([state get abduction-escape] eq {no})} purpleElderResearch}
            {"\"The human escapees?\"" {[state get abduction-escape] eq {rumors}} purpleElderResearch1}
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
        puts "\"We're really all the same. I don't know how we became so divided.\
        But for many decades, a line has been drawn between the races,\
        the green and the purple. The war began several years ago,\
        but it feels like centuries. I was drafted as a spy and\
        sent here to discern our enemies' plan with regard to the humans\
        on earth. Unfortunately, I was captured and left here to rot.\""
        prompt {} {
            {"\"I'm sorry.\"" yes purpleElderWar2}
        }
    }

    proc purpleElderWar2 {} {
        puts "\"I appreciate your sympathy. But I've made my peace with it.\
        If there's anything you need from me, don't hesitate to ask. I don't\
        have much in the way of material goods to offer, but I am an open\
        book if you have any questions.\""
        state put know-about-moon-war yes
        prompt {} {
            {"\"Why are the green aliens here on earth's moon?\"" yes purpleElderResearch}
            {"\"Thank you.\"" yes prisonTopFloor}
        }
    }

    proc purpleElderResearch {} {
        puts "\"There's a research facility adjacent to this prison. It\
        seems they're abducting humans and performing experiments in an\
        effort to create the perfect soldier. I wasn't able to find out\
        too many specifics, sadly.\""
        puts "The elder looks at you for a moment."
        puts "\"Unfortunately, they'll probably send you there soon.\
        Once they determine that you have no military ties, you'll\
        be nothing more valuable than a lab rat to them.\""
        prompt {} {
            {"\"Has any human ever escaped the facility?\"" yes purpleElderResearch1}
        }
    }

    proc purpleElderResearch1 {} {
        puts "\"There are rumors, yes. I understand that two human girls managed to\
        subdue the scientists, steal a shuttle, and escape back to earth. Since you\
        seem to be interested in the facility, those two girls might be able to\
        tell you more. But alas, we have no way of contacting them from up here.\""
        prompt {} {
            {"\"Do you know where they are now?\"" yes purpleElderResearch2}
        }
    }

    proc purpleElderResearch2 {} {
        puts "\"Soldiers were, of course, immediately sent to investigate the stolen\
        shuttle crash site and the humans' place of residence. They're likely still\
        monitoring the girls' home and the homes of any known acquaintances. Given\
        that the two haven't been recaptured, they're likely constantly moving, from\
        motel to motel, to evade capture.\""
        prompt {} {
            {"\"Thank you.\"" yes purpleElderResearch3}
        }
    }

    proc purpleElderResearch3 {} {
        puts "\"You're welcome. I'm not sure what you intend to do with that\
        information here. But I'm glad to have been of some assistance.\""
        state put abduction-escape rumors
        puts {}
        return prisonTopFloor
    }

}
