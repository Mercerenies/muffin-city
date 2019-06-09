
namespace eval Dream::Transit {

    proc cargo {} {
        puts "== Cargo Car =="
        puts "You enter a car full of heavy boxes stacked on top of one another. The boxes are\
        blocking the way, so you won't be able to go back any further."
        prompt {} {
            {"Hide among the boxes" yes hideFail}
            {"Hide in the Stolen Suitcase" {[inv has {Stolen Suitcase}]} hideSuccess}
            {"Go forward one car" yes third}
        }
    }

    proc third {} {
        puts "== 3rd Class Car =="
        puts -nonewline "You enter the train car and find yourself in a relatively dingy\
        hallway without much adornment. One of the bedrooms is open."
        if {[state get city-thug] eq {hiding}} then {
            puts " A man is sitting on a bench in the middle of the room, and you recognize\
            him immediately as the robber who shot you."
        } else {
            puts {}
        }
        prompt {} {
            {"Go backward one car" yes cargo}
            {"Go forward one car" yes secondGate}
            {"Enter the room" yes thirdRoom}
            {"Pull the emergency brake" yes ::Space::Moon::crashing}
            {"Talk to the robber" {[state get city-thug] eq {hiding}} thirdTalk}
        }
    }

    proc second {} {
        # //// Are we sure we want the third-second door to be locked? Does it make sense?
        puts "== 2nd Class Car =="
        puts "You enter the car and find yourself in a moderately well-kept corridor, with a few\
        decorations hanging on the wall. There are a few doors on the left side, and one of them\
        is open."
        prompt {} {
            {"Go backward one car" yes toThird}
            {"Go forward one car" yes kitchen}
            {"Enter the room" yes secondRoom}
        }
    }

    proc kitchen {} {
        # //// Make the chef's room accessible after some quest is done
        puts "== Dining Car =="
        puts "You enter the dining car. There are a few tables with chairs in front of them,\
        and a small room for the chef to do his work, but no one appears to be eating right now."
        prompt {} {
            {"Go backward one car" yes second}
            {"Go forward one car" yes firstGate}
        }
    }

    proc first {} {
        puts "== 1st Class Car =="
        puts "You enter the high-class train car. This is truly a place only the richest of the\
        rich could afford to stay. As you enter the luxurious halls, adorned with a traditional\
        chandelier and several tapestries along the walls, you momentarily forget that you\
        are on a train. One of the bedrooms is accessible to you."
        prompt {} {
            {"Go backward one car" yes toKitchen}
            {"Go forward one car" yes engine}
            {"Enter the room" yes firstRoom}
        }
    }

    proc engine {} {
        # //// We should be able to talk to him
        puts "== Engine =="
        puts "You reach the front car of the train. The engineer sits in a large chair and is\
        operating the train."
        prompt {} {
            {"Go backward one car" yes first}
        }
    }

    proc secondGate {} {
        if {[state get second-class-door]} then {
            return second
        } else {
            puts "The door to the next cabin is locked. It looks like it would unlock if opened from\
            the other side."
            puts {}
            return third
        }
    }

    proc firstGate {} {
        if {[state get first-class-door]} then {
            return first
        } else {
            puts "The door to the next cabin is locked. It looks like it would unlock if opened from\
            the other side."
            puts {}
            return second
        }
    }

    proc toThird {} {
        state put second-class-door yes
        return third
    }

    proc toKitchen {} {
        state put first-class-door yes
        return kitchen
    }

    proc thirdRoom {} {
        puts "== 3rd Class Room =="
        puts "You find yourself in a small room. The amenities are basic: a small bed, a nightstand,\
        and an old lamp."
        prompt {} {
            {"Go to sleep" yes {sleep ::Dream::Destination::thirdRoom}}
            {"Exit the room" yes third}
        }
    }

    proc secondRoom {} {
        puts "== 2nd Class Room =="
        puts "You are in a small room. There is a large bed in the corner of the room,\
        opposite a nightstand and a small desk."
        prompt {} {
            {"Go to sleep" yes {sleep ::Dream::Destination::secondRoom}}
            {"Exit the room" yes second}
        }
    }

    proc firstRoom {} {
        # //// Hit the call button?
        puts "== 1st Class Room =="
        puts "You look around at the luxurious suite. There is a large bed in the center of the\
        room, with sofas on either side, and a small gray button that has the word \"Call\"\
        written above it."
        prompt {} {
            {"Go to sleep" yes {sleep ::Dream::Destination::firstRoom}}
            {"Exit the room" yes first}
        }
    }

    proc thirdTalk {} {
        puts "\"It's you! I didn't figure dose blokes in duh underworld could keep you too\
        long. Listen, me shootin' you an' all that, it's nothin' personal. Just business. So\
        just stay outta my alley. Anyway, I gotta get goin'.\""
        puts "The robber gets up and walks toward the back of the train."
        state put city-thug no
        puts {}
        return third
    }

    proc hideFail {} {
        puts "You attempt to hide among the boxes. When you climb over one of the larger boxes,\
        you manage to trip and cause a ruckus as the boxes fall in on themselves. A train\
        conductor rushes in to see what the issue is."
        puts "\"Excuse me! But we cannot have passengers flitting about in the cargo hold.\""
        puts "The conductor ushers you back out of the cargo hold."
        puts {}
        return third
    }

    proc hideSuccess {} {
        puts "You successfully zip yourself inside the Stolen Suitcase."
        puts {}
        return suitcase
    }

    proc suitcase {} {
        puts "== Stolen Suitcase =="
        puts "The suitcase is cramped, leaving very little room to move around. No light gets\
        in through the sealed zipper."
        prompt {} {
            {"Go to sleep" yes {sleep ::Dream::World::suitcase}}
            {"Exit the suitcase" yes cargo}
        }
    }

    proc awaken {room} {
        puts "You fall asleep easily..."
        puts {}
        puts "...And awaken sometime later on a train."
        puts {}
        if {[state get crypto-king] eq {closer}} then {
            state put crypto-king ready
        }
        state put moon-train no
        return $room
    }

    proc sleep {room} {
        puts "You decide to go back to sleep..."
        puts {}
        puts "...And awaken sometime later."
        puts {}
        return $room
    }

}
