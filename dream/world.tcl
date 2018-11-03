
namespace eval Dream::World {

    proc suitcase {} {
        puts "== Stolen Suitcase =="
        puts "You are no longer moving, and you do not hear anyone nearby."
        prompt {} {
            {"Exit the suitcase" yes unclaimed}
        }
    }

    proc unclaimed {} {
        puts "== Unclaimed Luggage Center =="
        # //// We'd like something that's only here if you actually
        # did just arrive in the suitcase, so that you're required to
        # go that way at least once (I will likely allow other ways to
        # get to the dream world)
        puts "You find yourself in a large, circular room. The walls are an odd mixture of\
        colors that you can't quite name, and it seems as though the color scheme shifts as\
        the focus of your eyes changes. There is a sign overhead that reads \"Magical Deluge\
        Gun\", or something like it; you can't quite focus on the sign very well. There are\
        other suitcases and boxes here. A staircase leads up and out of the area."
        prompt {} {
            {"Go up the stairs" yes {commons 1}}
        }
    }

    proc commons {depth} {
        puts "== Floating Commons =="
        switch $depth {
            1 {
                puts "You are on a central platform with several modes of transportation surrounding\
                it. The area, and especially the horizon, is odd, and your eyes can't properly focus\
                on any single object. There appears to be a train station to the left, a pier to the\
                right, and an airport straight ahead. A set of stairs leads down into an underground\
                room. The platform seems to be suspended in midair, held above an empty void by\
                nothing."
                prompt {} {
                    {"Go to the station" yes station}
                    {"Go to the pier" yes {pier 1}}
                    {"Go to the airport" yes airport}
                    {"Go downstairs" yes unclaimed}
                }
            }
            2 {
                puts "The commons is more blurry than usual. Your vision is very unfocused."
                prompt {} {
                    {"Go to the station" yes {clear station}}
                    {"Go to the pier" yes {pier 2}}
                    {"Go to the airport" yes {clear airport}}
                    {"Go downstairs" yes {clear unclaimed}}
                }
            }
            3 {
                puts "You can barely see anything. If not for the fact that you've been\
                here before, it is unlikely that you would be able to navigate the area\
                cleanly."
                prompt {} {
                    {"Go to the station" yes {clear station}}
                    {"Go to the pier" yes {pier 3}}
                    {"Go to the airport" yes {clear airport}}
                    {"Go downstairs" yes {clear unclaimed}}
                }
            }
        }
    }

    proc station {} {
        puts "== Train Station =="
        if {[state get moon-train] eq {yes}} then {
            puts "The train station is slightly elevated from the remainder of the commons.\
            The area is deserted, and there is no train on the tracks."
            prompt {} {
                {"Go back to the commons" yes {commons 1}}
            }
        } else {
            puts "The train station is slightly elevated from the remainder of the commons. A\
            conductor is standing by the train, which is sitting stationary on the tracks."
            prompt {} {
                {"Talk to the conductor" yes conductor}
                {"Board the train" yes third}
                {"Go back to the commons" yes {commons 1}}
            }
        }
    }

    proc pier {depth} {
        puts "== Floating Pier =="
        if {([state get butler-game] ni {no cell cell1 pawn}) && ([state get captain-boat-place] eq {dream})} then {
            puts "The pier floats over an infinite void. A single ship sits at the\
            pier, floating over nothingness. The ship's captain stands at the edge,\
            in traditional sailor garb."
        } else {
            puts "The pier floats over an infinite void. You fail to see how a boat\
            could sail on this void, as there seems to be no water."
        }
        set option1 "{Leap over the edge} yes {pierEdge $depth}"
        if {$depth > 1} then {
            set option2 {{Talk to the captain} {([state get butler-game] ni {no cell cell1 pawn}) && ([state get captain-boat-place] eq {dream})} {clear captain}}
        } else {
            set option2 {{Talk to the captain} {([state get butler-game] ni {no cell cell1 pawn}) && ([state get captain-boat-place] eq {dream})} captain}
        }
        set option3 "{Go back to the commons} yes {commons $depth}"
        prompt {} [list $option1 $option2 $option3]
    }

    proc airport {} {
        puts "== Airport =="
        puts -nonewline "The airport is indoors, but as you look around you feel as\
        though the walls are thin and possibly not even there."
        if {[state get prison-guard] eq {search}} then {
            puts -nonewline " The mustached prison guard is sitting on a bench in\
            the corner. Despite the saddened look on his face, he is still holding a\
            donut in each hand."
        }
        if {[state get golden-arches]} then {
            puts -nonewline " Next to the exit, a glimmering gold arch hovers."
        }
        puts {}
        prompt {} {
            {"Talk to the guard" {[state get prison-guard] eq {search}} airportGuard}
            {"Pass through the walls" yes airportWall}
            {"Pass through the golden arch" {[state get golden-arches]} ::Console::Hall::future}
            {"Go back to the commons" yes {commons 1}}
        }
    }

    proc airportWall {} {
        puts "You pass effortlessly through the wall and end up on the other side of\
        the room."
        # //// If you have a specific item, this goes elsewhere
        puts {}
        return airport
    }

    proc airportGuard {} {
        if {[state get attorney-guard] eq {okay}} then {
            puts "\"Ngh... thanks...\""
            puts {}
            return airport
        } else {
            puts "\"Ngh... such a pain... fired for taking bribes... I need a lawyer...\
            such a pain...\""
            prompt {} {
                {"Tell him about Attorney-Man" {([state get attorney-man] in {fed 1 2 done}) && ([state get attorney-guard] eq {no})} airportGuardOkay}
                {"\"I'm sorry.\"" yes airport}
            }
        }
    }

    proc airportGuardOkay {} {
        puts "\"Hm? ... ... a lawyer... okay... fine...\""
        state put attorney-guard okay
        puts {}
        return airport
    }

    proc pierEdge {depth} {
        if {$depth >= 3} then {
            puts "You leap into the infinite void and fall. After falling for a time, you land\
            in a strange room where the only sound is the hum of several computers."
            # //// Console room
            return -gameover
        } else {
            puts "You leap into the infinite void and fall. After falling for a time, you land\
            very suddenly in the common area near the pier."
            puts {}
            return "commons [expr {$depth + 1}]"
        }
    }

    proc captain {} {
        switch [state get captain-boat] {
            no {
                puts "\"Climb aboard, mate! ... ... ... Or at least, that's what I'd\
                like say. You see, I've got a slight problem.\""
                prompt {} {
                    {"\"What's wrong?\"" yes captainHelp}
                    {"\"Later.\"" yes {pier 1}}
                }
            }
            spoken - requested - obtained {
                puts "\"I need a wheel...\""
                prompt {} {
                    {"\"Here you go.\"" {[inv has {Ship's Wheel}]} captainWheel}
                    {"\"I'll let you know if I think of anything.\"" yes {pier 1}}
                }
            }
            yes {
                puts "\"Climb aboard, mate!\""
                # //// Eventually, pirates will attack the ship after a few voyages, opening a new avenue
                prompt {} {
                    {"Climb aboard" yes captainSail}
                    {"\"Maybe later.\"" yes {pier 1}}
                }
            }
        }
    }

    proc captainHelp {} {
        puts "\"Well, y'see, it's my ship. It doesn't have a wheel. Without a wheel, I\
        can't steer. If you can find me a ship's wheel, I'd be more than happy to let\
        you ride.\""
        state put captain-boat spoken
        prompt {} {
            {"\"I'll see what I can do.\"" yes {pier 1}}
        }
    }

    proc captainWheel {} {
        puts "\"A wheel? Where did you find this?\""
        puts "You hand the Ship's Wheel to the captain."
        inv remove {Ship's Wheel}
        state put captain-boat yes
        puts "\"Anytime you want, I'll sail you out to sea. What do you say?\""
        prompt {} {
            {"\"I'll keep that in mind.\"" yes {pier 1}}
        }
    }

    proc captainSail {} {
        puts "\"And we're off.\""
        puts "The captain hoists the anchor out of the void and sets sail."
        puts {}
        puts "Some time later, you arrive on a deserted island."
        state put captain-boat-place warehouse
        puts {}
        return ::Warehouse::Outside::dock
    }

    proc conductor {} {
        puts "\"Good evening. Feel free to step aboard the train whenever you are ready\
        to depart.\""
        # //// He should do something
        prompt {} {
            {"\"Thank you.\"" yes station}
        }
    }

    proc third {} {
        puts "== 3rd Class Car =="
        puts "The car is completely abandoned and the lights appear to be off. The door exiting\
        the train is open."
        prompt {} {
            {"Go backward one car" yes {::Dream::Destination::locked ::Dream::World::third}}
            {"Go forward one car" yes {::Dream::Destination::locked ::Dream::World::third}}
            {"Enter the room" yes thirdRoom}
            {"Get off the train" yes station}
        }
    }

    proc thirdRoom {} {
        puts "== 3rd Class Room =="
        puts "The room is deserted, and the lights are off."
        prompt {} {
            {"Go to sleep" yes {::Dream::Transit::sleep ::Dream::Destination::thirdRoom}}
            {"Exit the room" yes third}
        }
    }

    proc clear {room} {
        puts "Your vision suddenly clears."
        puts {}
        return $room
    }

}
