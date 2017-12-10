
namespace eval Past::Science {

    proc mainRoom {} {
        puts "== Research Facility - Past =="
        puts "The research facility in the basement is dim. There is no one working right now,\
        so all the lights are out. The Club Room door's lock has been disabled, but the other\
        doors seem to be functioning. There is a door leading out to the main portion of the\
        hotel on the opposite wall."
        prompt {} {
            {"Enter the Spade Room" yes spadeRoom}
            {"Enter the Heart Room" yes heartRoom}
            {"Enter the Club Room" yes clubRoom}
            {"Enter the Diamond Room" yes diamondRoom}
            {"Go back upstairs" yes ::Past::Hotel::ritzyHall}
        }
    }

    proc clubRoomBoom {} {
        puts "You ignore the warning and press down on the blue button. The machine sparks\
        and you feel electricity coursing through your veins."
        puts {}
        return ::Underworld::Pits::mysteryRoom
    }

    proc clubRoom {} {
        puts "== Club Room - Past =="
        puts "You are in a small, round room. The room is completely empty, save for a single blue\
        button on a stand in the middle of the room, and the lights are off. The walls look\
        heavily reinforced; you doubt any sounds would get through them. Immediately below the\
        blue button, there is a digital display, but the display is off. There is a note taped to\
        the button that reads \"Untested! Do not use!\""
        prompt {} {
            {"Hit the blue button" yes clubRoomBoom}
            {"Exit the room" yes mainRoom}
        }
    }

    proc heartRoom {} {
        if {![inv has {Heart Key}]} then {
            puts "The door is locked."
            puts {}
            return mainRoom
        }
        puts "== Heart Room - Past =="
        # ////
        prompt {} {
            {"Go back out" yes mainRoom}
        }
    }

    proc diamondRoom {} {
        if {![inv has {Diamond Key}]} then {
            puts "The door is locked."
            puts {}
            return mainRoom
        }
        puts "== Diamond Room - Past =="
        # ////
        prompt {} {
            {"Go back out" yes mainRoom}
        }
    }

    proc spadeRoom {} {
        if {![inv has {Spade Key}]} then {
            puts "The door is locked."
            puts {}
            return mainRoom
        }
        puts "== Spade Room - Past =="
        # ////
        prompt {} {
            {"Go back out" yes mainRoom}
        }
    }

}
