
namespace eval Space::Satellite {

    proc elevatorRoom {} {
        puts "== Satellite - Elevator Room =="
        puts "The circular room is mostly empty, aside from the elevator in the center.\
        There is a large window on one half of the room, revealing that you are in fact\
        in space, orbiting the earth. Aside from the elevator, there is a small hatch in\
        the wall that seems to lead to the remainder of the satellite."
        prompt {} {
            {"Go through the hatch" yes transportBay}
            {"Enter the elevator" yes {::Underworld::Elevator::lift ::Space::Satellite::elevatorRoom}}
        }
    }

    proc transportBay {} {
        puts "== Satellite - Transport Bay =="
        puts -nonewline "The transport bay consists of a single large teleporter against\
        the back wall, as well as some miscellaneous tools and repair equipment that would\
        be useful in space travel. A hatch to the right leads to a room with\
        an elevator in it, and a hatch to the left leads to a common area."
        switch [state get moon-mechanic] {
            no {
                puts {}
            }
            present {
                puts " A bearded man in a dark blue jumpsuit covered in oil stains is\
                standing by the teleporter."
            }
            talked {
                puts " The mechanic is standing by the teleporter."
            }
        }
        prompt {} {
            {"Go to the elevator room" yes elevatorRoom}
            {"Go to the common area" yes commonArea}
            {"Talk to the man" {[state get moon-mechanic] eq {present}} mechanic}
            {"Talk to the mechanic" {[state get moon-mechanic] ni {no present}} mechanic}
            {"Use the teleporter" yes teleporter}
        }
    }

    proc mechanic {} {
        switch [state get moon-mechanic] {
            no {
                return transportBay
            }
            present {
                puts "\"You're the new recruit, huh? I'm the mechanic around here. I've\
                turned on the teleporter for you. It'll take you down to the moon's surface.\
                And take this Oxygen Tank. You'll need it down there.\""
                puts "You got an Oxygen Tank!"
                puts {}
                inv add {Oxygen Tank}
                state put moon-mechanic talked
                return transportBay
            }
            talked {
                puts "\"Good luck down there!\""
                # //// More here (Golden Wrench and stuff)
                prompt {} {
                    {"\"Thanks!\"" yes transportBay}
                }
            }
        }
    }

    proc teleporter {} {
        if {[state get moon-teleport] eq {yes}} then {
            puts "You step inside the teleportation device. A white light engulfs you,\
            and when the light clears, you are in a different location."
            puts {}
            return ::Space::Moon::humanBase
        } else {
            puts "The teleporter appears to be inactive at the moment."
            puts {}
            return transportBay
        }
    }

    proc commonArea {} {
        puts "== Satellite - Common Area =="
        puts "The common area consists of a table in the center with several chairs around\
        it. There are astronauts wandering back and forth carrying various objects. A hatch\
        in the back leads to the transport bay."
        prompt {} {
            {"Talk to the astronauts" yes astronauts}
            {"Go to the transport bay" yes transportBay}
        }
    }

    proc astronauts {} {
        if {[state get moon-teleport] ne {yes}} then {
            puts "\"Hi, there. Are you a new recruit?\""
            prompt {} {
                {"\"Yes, that's me.\"" yes recruitYes}
                {"\"Nope, just a guest.\"" yes recruitNo}
            }
        } else {
            # //// These guys need to serve more purpose
            puts "\"Good luck!\""
            puts {}
            return commonArea
        }
    }

    proc recruitNo {} {
        puts "\"Ah. Carry on, then.\""
        puts {}
        return commonArea
    }

    proc recruitYes {} {
        puts "\"Perfect! In that case, I'll send someone over to activate the\
        teleporter for you.\""
        puts {}
        state put moon-teleport yes
        state put moon-mechanic present
        return commonArea
    }

}
