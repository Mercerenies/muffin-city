
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
            {"Go toward the fire pits" yes {fire backRoom}}
            {"Enter the elevator" yes freight}
        }
    }

    proc fire {room} {
        if {[inv has {Fireproof Suit}]} then {
            puts "== Fire Pits =="
            puts "There is fire all around you, but it seems to cower away from you.\
            The balcony is too high to climb onto, so the only way out of the pits is\
            through one of the two exits on the back wall."
            if {[state get fire-pit] eq {no}} then {
                state put fire-pit odd
            }
            # //// Not sure if {fire backRoom} is right here, but it works for now
            prompt {} {
                {"Head toward the storage room" yes backRoom}
                {"Head toward the secret chamber" yes "secretRoomEnter {fire backRoom}"}
            }
        } else {
            puts "The fire burns all around you, but you feel no pain. In a blind panic,\
            you rush toward the nearest exit."
            puts {}
            return $room
        }
    }

    proc fireEntry {} {
        if {[inv has {Fireproof Suit}]} then {
            puts "You don your Fireproof Suit and leap into the fire pits. The fire sways outward,\
            almost as though it's actively avoiding you."
            puts {}
            return {fire backRoom}
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

    proc secretRoomEnter {room} {
        if {[state get secret-chamber-door]} then {
            return secretRoom
        } else {
            puts "An invisible barrier prevents your entry into the secret chamber."
            puts {}
            return $room
        }
    }

    proc secretRoomExit {} {
        if {[state get secret-chamber-door]} then {
            return {fire secretRoom}
        } else {
            puts "An invisible barrier prevents you from passing."
            puts {}
            return secretRoom
        }
    }

    proc secretRoom {} {
        puts "== Secret Chamber =="
        if {[state get secret-chamber-door]} then {
            set lever "Additionally, there is a lever on the wall next to the fire pits in the\
            OFF poisiton."
        } else {
            set lever "Additionally, there is a lever on the wall next to the fire pits in the\
            ON poisiton, accompanied by the quiet hum of a machine."
        }
        puts "You enter the large, square room. The chamber is mostly empty, but there is a\
        door leading out the back and a staircase leading down further into the chamber, as well\
        as a tunnel leading to a room full of fire. $lever"
        prompt {} {
            {"Head downstairs" yes ::Subspace::Hub::attic}
            {"Head out the door" yes mysteryRoom}
            {"Switch the lever on" {[state get secret-chamber-door]} secretLeverOn}
            {"Switch the lever off" {![state get secret-chamber-door]} secretLeverOff}
            {"Go to the fire pits" yes secretRoomExit}
        }
    }

    proc secretLeverOff {} {
        puts "You switch the lever off. The sound of machinery within the walls disappears."
        state put secret-chamber-door yes
        puts {}
        return secretRoom
    }

    proc secretLeverOn {} {
        puts "You switch the lever on. The quiet hum of a strange machine sounds."
        state put secret-chamber-door no
        puts {}
        return secretRoom
    }

    proc mysteryRoom {} {
        puts "== Mystery Room =="
        puts "You find yourself in a small room with several puzzles scattered about\
        and riddles pinned to the walls. There is a single door leading out of the room."
        prompt {} {
            {"Step out the door" yes secretRoom}
        }
    }

}
