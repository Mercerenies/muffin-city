
namespace eval Past::Science {

    proc clubRoom {} {
        puts "== Inactive Club Room =="
        puts "You are in a small, round room. The room is completely empty, save for a single blue\
        button on a stand in the middle of the room, and the lights are off. The walls look\
        heavily reinforced; you doubt any sounds would get through them. Immediately below the\
        blue button, there is a digital display, but the display is off. There is a note taped to\
        the button that reads \"Untested! Do not use!\""
        prompt {} {
            {"Hit the blue button" yes clubRoomBoom}
            {"Go back out" yes ::Empty::place}
        }
    }

    proc clubRoomBoom {} {
        puts "You ignore the warning and press down on the blue button. The machine sparks\
        and you feel electricity coursing through your veins."
        state put lobby-door other
        puts {}
        return ::Underworld::Pits::mysteryRoom
    }

}
