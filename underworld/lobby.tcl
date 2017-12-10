
namespace eval Underworld::Lobby {

    proc murder {} {
        puts "== Murder Room =="
        puts "You find yourself in a strange room with human skeletal remains scattered about\
        haphazardously. There is a single door on one of the walls."
        prompt {} {
            {"Step out the door" yes hub}
        }
    }

    proc wildlife {} {
        puts "== Wildlife Room =="
        puts -nonewline "You find yourself in a rounded room. There are stuffed bears and\
        lions mounted on the walls. Between two rather intimidating bears, there is a single\
        door leading out of the room."
        if {[state get hunter-trail] eq {under}} then {
            if {[state get hunter-soul] eq {no}} then {
                puts " The hunter is sitting on the floor, understandably confused."
                if {[inv has {Soul Crystal}]} then {
                    puts "... Your Soul Crystal starts vibrating in your pocket."
                }
            } else {
                puts " The hunter is sitting on the floor, looking mostly bored and\
                slightly sad."
            }
        } else {
            puts {}
        }
        # ////
        prompt {} {
            {"Talk to the hunter" {[state get hunter-trail] eq {under}} hunter}
            {"Use the Soul Crystal" {([state get hunter-trail] eq {under}) && ![state get hunter-soul] && [inv has {Soul Crystal}]} stealing}
            {"Step out the door" yes hub}
        }
    }

    # ///// Muffin in this room
    proc blogging {} {
        puts "== Blogging Room =="
        puts "You enter a small room with several computers scattered about. Unfortunately, they seem\
        to be purely decorative, as the insides have been stripped out of them. There is a single door\
        leading out of the room."
        prompt {} {
            {"Step out the door" yes hub}
        }
    }

    proc other {} {
        puts "== Other Room =="
        puts "You find yourself in a rather strange room with odd implements scattered throughout. On\
        one side, there are some basic dental instruments. On a table near the back, there are some\
        children's toys. There seems to only be one door leading out of this room."
        prompt {} {
            {"Step out the door" yes hub}
        }
    }

    proc hunter {} {
        if {[state get hunter-soul] eq {no}} then {
            puts "\"I went into the cave like ya said. I dunno how I ended up here...\""
        } else {
            puts "\"...\""
        }
        puts {}
        return wildlife
    }

    proc stealing {} {
        puts "You activate your Soul Crystal, and a floating essence emerges from the guard,\
        not unlike the essences in Johnny Death's display case. You got the Hunter's Soul!"
        inv add {Hunter's Soul}
        state put hunter-soul yes
        puts {}
        return wildlife
    }

    proc hub {} {
        puts "== Underworld Lobby =="
        if {[state get lobby-door] eq {yes}} then {
            puts "You enter the small rounded lobby. There are a few basic chairs and office\
            amenities here. There is a door leading to a large staircase on one side. On the\
            opposite side of the room, there are several doors, each with a label above\
            them: \"Murder\", \"Wildlife Attack\", \"Blogging Accident\", and \"Other\"."
            prompt {} {
                {"Enter Murder Room" yes murder}
                {"Enter Wildlife Room" yes wildlife}
                {"Enter Blogging Room" yes blogging}
                {"Enter Other Room" yes other}
                {"Go toward the staircase" yes ::Underworld::Elevator::staircase}
            }
        } else {
            if {[state get lobby-door] eq {no}} then {
                set doorComment "None of the doors appear to be accessible, however."
            } else {
                set doorComment "Only the [state get lobby-door] door seems to be open at the moment,\
                                 however."
            }
            puts "You enter the small rounded lobby. There are a few basic chairs and office\
            amenities here. There is a door leading to a large staircase on one side. On the\
            opposite side of the room, there are several doors, each with a label above\
            them: \"Murder\", \"Wildlife Attack\", \"Blogging Accident\", and \"Other\".\
            $doorComment"
            prompt {} {
                {"Enter Murder Room" {[state get lobby-door] eq {murder}} murder}
                {"Enter Wildlife Room" {[state get lobby-door] eq {wildlife}} wildlife}
                {"Enter Blogging Room" {[state get lobby-door] eq {blogging}} blogging}
                {"Enter Other Room" {[state get lobby-door] eq {other}} other}
                {"Go toward the staircase" yes ::Underworld::Elevator::staircase}
            }
        }
    }

}
