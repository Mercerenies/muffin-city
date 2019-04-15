
namespace eval ::Tiny::PastHut {

    # //// This whole place is a softlock right now: there's no way out.

    proc basement {} {
        puts "== Tiny Hut Basement - Past =="
        # //// Update this once the mime / officer have left the area
        puts "The hut basement is impossibly large. The ladder leading back to\
        the main room is far too large to climb now. A giant mime stands next to\
        a giant police officer trapped in a glass box, and neither of them are\
        paying you any mind. In the corner of the basement, there is a small\
        exposed pipe that you could probably use to escape."
        prompt {} {
            {"Try to get the mime's attention" yes noMime}
            {"Try to get the officer's attention" yes noOfficer}
            {"Enter the pipe" yes basementPipe}
        }
    }

    proc noMime {} {
        puts "The mime pays you no mind, no matter how hard you try."
        puts {}
        return basement
    }

    proc noOfficer {} {
        puts "The officer doesn't even seem to know that you're there."
        puts {}
        return basement
    }

    proc basementPipe {} {
        puts "The pipe leads to a wider area fairly quickly."
        puts {}
        return sewerEast
    }

    proc sewerEast {} {
        puts "== East Sewer - Past =="
        puts "The sewer is wide and empty. To the west, the tunnel extends indefinitely.\
        To the east, the pipe seems to narrow and enter someone's house. To the south,\
        there is a small hole in the pipe which leads to some sort of ceremonious altar."
        prompt {} {
            {"Go west" yes sewerWest}
            {"Enter the narrower pipe" yes basement}
            {"Head toward the altar" yes altar}
        }
    }

    proc altar {} {
        puts "== Ceremonial Altar =="
        puts "The area seems to have been set up very formally. In contrast to the rusted\
        appearance of the pipe you entered through, the altar has been set up with folding\
        chairs facing a decorated stage, in preparation for some kind of formal ceremony.\
        All of the chairs are empty, as the ceremony seems not to have started yet."
        prompt {} {
            {"Go back into the sewer" yes sewerEast}
        }
    }

    proc sewerWest {} {
        puts "== West Sewer - Past =="
        # //// The underground empire
        puts -nonewline "The west side of the sewer is empty as well. To the east, the tunnel\
        extends for a ways."
        if {[state get heart-pipe] eq {no}} then {
            puts "To the west, the pipe makes an abrupt 90 degree turn, but it looks\
            like there's a weak point in the edge of the pipe that you may be able to\
            exploit."
        } else {
            puts "To the west, there is a hole in the pipe before it makes a 90 degree\
            turn which you could probably fit through."
        }
        prompt {} {
            {"Kick the weak spot in the pipe" {[state get heart-pipe] eq {no}} kickPipe}
            {"Go through the hole" {[state get heart-pipe] eq {yes}} heartRoom}
            {"Go east" yes sewerEast}
        }
    }

    proc kickPipe {} {
        puts "You kick, but the pipe barely budges."
        prompt {} {
            {"Kick it again" yes kickPipe1}
            {"Give up" yes sewerWest}
        }
    }

    proc kickPipe1 {} {
        puts "You kick again. The pipe moves a bit more."
        prompt {} {
            {"Kick it again" yes kickPipe2}
            {"Give up" yes sewerWest}
        }
    }

    proc kickPipe2 {} {
        puts "The pipe suddenly gives, leaving a hole large enough for you to pass through."
        state put heart-pipe yes
        prompt {} {
            {"Go through the hole" yes heartRoom}
            {"Don't go" yes sewerWest}
        }
    }

    proc heartRoom {} {
        puts "== Tiny Heart Room - Past =="
        puts -nonewline "There is a pedestal in the center of the room, low enough\
        that you may be able to climb it. The pedestal is surrounded by several tall\
        lasers, all of them pointed at the pedestal. The stairs leading out of the\
        room are unfortunately much too high to be scaled at your height. A small\
        air vent in the corner of the room appears to be sealed off, and a giant\
        moth-like creature is hovering above the ground in the opposite corner of\
        the room."
        if {[state get heart-pipe] eq {yes}} then {
            puts " A pipe in the corner of the room has a hole large enough for you to\
            fit through."
        } else {
            puts {}
        }
        prompt {} {
            {"Enter the air vent" yes ventilation}
            {"Stand on the pedestal" yes heartPedestal}
            {"Enter the pipe" {[state get heart-pipe] eq {yes}} sewerWest}
            {"Talk to the moth" {[state get moth-king] eq {no}} mothka}
            {"Talk to Mothka" {[state get moth-king] ne {no}} mothka}
        }
    }

    proc ventilation {} {
        puts "The air vent is tightly sealed off. You can't get in."
        puts {}
        return heartRoom
    }

    proc heartPedestal {} {
        puts "You climb up on the pedestal, but nothing happens. The lasers don't\
        even seem to realize you're there."
        puts {}
        return heartRoom
    }

    proc mothka {} {
        switch [state get moth-king] {
            no {
                puts "\"Halt! You are trespassing on the domain of Mothka, the evil\
                moth king! Bow before his majesty!\""
                prompt {} {
                    {"\"I will never!\"" yes mothkaRefuse}
                    {"\"Who? You?\"" yes mothkaDisrespect}
                    {"Bow before his majesty" yes mothkaBow}
                }
            }
            met {
                puts "\"Halt! You are trespassing on the domain of... ... you clever\
                insect! You survived the execution chamber of the moth king.\""
                prompt {} {
                    {"\"You won't defeat me so easily, Mothka!\"" yes mothkaChallenge}
                    {"\"That rat was your execution chamber?\"" yes mothkaChallenge}
                }
            }
            default {
                puts "\"The evil moth king anticipates his battle with you! In the\
                meantime, you must be removed.\""
                puts "Mothka swoops toward you and picks you up. He flies you\
                into his execution chamber and seals the vent."
                puts {}
                return ratFight
            }
        }
    }

    proc mothkaRefuse {} {
        puts "\"Such insolence! The evil moth king will teach you a lesson!\""
        puts "Mothka swoops toward you suddenly and picks you up. He flies you\
        up the stairs and into a small air vent, where he drops you and seals the vent behind you."
        puts "\"Good luck, insolent fool! Remember this next time you defy royalty!\""
        state put moth-king met
        puts {}
        return ratFight
    }

    proc mothkaDisrespect {} {
        puts "\"The evil moth king will not be disrespected thusly! He will teach you\
        a lesson!\""
        puts "Mothka swoops toward you suddenly and picks you up. He flies you\
        up the stairs and into a small air vent, where he drops you and seals the vent behind you."
        puts "\"Good luck, insolent fool! Remember this next time you disrespect royalty!\""
        state put moth-king met
        puts {}
        return ratFight
    }

    proc mothkaBow {} {
        puts "\"Very good! For your behavior, the evil moth king grants you a swift death.\""
        puts "Mothka swoops toward you suddenly and picks you up. He flies you\
        up the stairs and into a small air vent, where he drops you and seals the vent behind you."
        state put moth-king met
        puts {}
        return ratFight
    }

    proc mothkaChallenge {} {
        puts "\"Indeed. The moth king shall have to try harder! In fact, the moth king\
        challenges you to a game of intelligence!\""
        prompt {} {
            {"\"I'm listening.\"" yes mothkaChallenge1}
            {"\"Not interested.\"" yes mothkaNoChallenge}
        }
    }

    proc mothkaChallenge1 {} {
        puts "\"Since the moth king has failed to defeat you in direct combat, he will\
        fight you in a battle of wits. Meet the moth king in the basement on the other\
        side of the sewers in twelve hours' time.\""
        prompt {} {
            {"\"I'll be there.\"" yes mothkaChallenge2}
        }
    }

    proc mothkaChallenge2 {} {
        puts "\"Excellent! Unfortunately, you are still trespassing on the moth king's\
        territory.\""
        state put moth-king challenged
        puts "Mothka swoops toward you and picks you up. He flies you\
        into his execution chamber and seals the vent."
        puts {}
        return ratFight
    }

    proc mothkaNoChallenge {} {
        puts "\"Then the moth king has no need for you.\""
        puts "Mothka swoops toward you and picks you up. He flies you\
        into his execution chamber and seals the vent."
        puts {}
        return ratFight
    }

    proc ratFight {} {
        puts "== Deep Ventilation Shaft =="
        # //// Make sure that whatever lets you kill the rat in the
        # present can't work here. This is always an instant death.
        puts "A winding path of air vents stretches out before you. Behind you, the air vent\
        has been sealed shut. In front of you, a giant hungry rat stares you down."
        prompt {} {
            {"\"Go on! Leave me alone!\"" yes ratDeath}
            {"\"Nice kitty.\"" yes ratDeath}
            {"\"Whatever the moth king is paying you, I'll double it.\"" yes ratDeath}
        }
    }

    proc ratDeath {} {
        puts "The rat eats you."
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door wildlife
        }
        puts {}
        return ::Underworld::Lobby::wildlife
    }

}
