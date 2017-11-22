
namespace eval City::Science {

    proc mainRoom {} {
        puts "== Research Facility =="
        if {[state get talked-to-louis]} then {
            puts "You enter the research lab and see Dr. Louis working on a small robot. There\
            are several various machines and gizmos lying about on all the surfaces in the room.\
            On the back wall, there are four doors, each containing the emblem of a playing card\
            suit."
        } else {
            puts "You enter the basement and find yourself in a strange research lab. There are\
            several gizmos and machines on all of the counters surrounding the room. Everything\
            looks incredibly futuristic, and you can see everything from test tubes to rocket parts\
            sitting about. There is a young woman in a lab coat working on a small robot. On the back\
            wall, there are four doors, each containing the emblem of a playing card suit."
        }
        prompt {} {
            {"Talk to Dr. Louis" {[state get talked-to-louis]} talkTo}
            {"Talk to the woman" {![state get talked-to-louis]} talkTo}
            {"Enter the Spade Room" yes spadeRoom}
            {"Enter the Heart Room" yes heartRoom}
            {"Enter the Club Room" yes clubRoom}
            {"Enter the Diamond Room" yes diamondRoom}
            {"Go back upstairs" yes ::City::Hotel::ritzyHall}
        }
    }

    proc talkTo {} {
        if {[state get talked-to-louis]} then {
            puts "\"Hey, can I help you?\""
            prompt {} {
                {"\"Not right now.\"" yes mainRoom}
            }
        } else {
            puts "\"Oh, wonderful! They told me they'd been sending an extra pair of hands down here.\
            We need you to test out the time machine. Here's the key to the Club Room.\""
            puts "The woman hands you the Club Key."
            state put talked-to-louis yes
            inv add {Club Key}
            puts "\"I'm Dr. Louis, by the way.\""
            puts {}
            return mainRoom
        }
    }

    proc clubRoomJump {} {
        puts "You hit the blue button. The entire room suddenly lights up in a blindingly bright\
        white, forcing you to close your eyes. When you reopen them, everything has gone dark."
        puts {}
        return ::Past::Science::clubRoom
    }

    proc clubRoom {} {
        if {![inv has {Club Key}]} then {
            puts "The door is locked."
            puts {}
            return mainRoom
        }
        puts "== Club Room =="
        puts "You are in a small, round room. The room is completely empty, save for a single blue\
        button on a stand in the middle of the room. The walls look heavily reinforced; you doubt\
        any sounds would get through them. Immediately below the blue button, there is a digital\
        display with yesterday's date on it."
        prompt {} {
            {"Hit the blue button" yes clubRoomJump}
            {"Go back out" yes mainRoom}
        }
    }

    proc heartRoom {} {
        if {![inv has {Heart Key}]} then {
            puts "The door is locked."
            puts {}
            return mainRoom
        }
        puts "== Heart Room =="
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
        puts "== Diamond Room =="
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
        puts "== Spade Room =="
        # ////
        prompt {} {
            {"Go back out" yes mainRoom}
        }
    }

}
