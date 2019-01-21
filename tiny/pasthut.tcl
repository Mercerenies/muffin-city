
namespace eval ::Tiny::PastHut {

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
        # //// Empty
        prompt {} {
            {"Kick the weak spot in the pipe" {[state get heart-pipe] eq {no}} kickPipe}
            {"Go through the hole" {[state get heart-pipe] eq {yes}} ::Empty::place}
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
        # ////
        prompt {} {
            {"Go through the hole" yes ::Empty::place}
            {"Don't go" yes sewerWest}
        }
    }

}
