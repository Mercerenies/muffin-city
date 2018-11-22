
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
        prompt {} {
            {"Talk to the hunter" {[state get hunter-trail] eq {under}} hunter}
            {"Use the Soul Crystal" {([state get hunter-trail] eq {under}) && ![state get hunter-soul] && [inv has {Soul Crystal}]} stealing}
            {"Step out the door" yes hub}
        }
    }

    proc mercury {} {
        puts "== Mercury Room =="
        puts -nonewline "You enter a small room with dangerous looking silver liquid flowing\
        down from the walls. There is a single door leading out of the room."
        if {[state get mercury-muffin] eq {no}} then {
            puts " There is a muffin sitting in the middle of the room, seemingly untouched\
            by the flowing liquids."
        } else {
            puts {}
        }
        prompt {} {
            {"Take the muffin" {[state get mercury-muffin] eq {no}} mercuryMuffin}
            {"Step out the door" yes hub}
        }
    }

    proc other {} {
        puts "== Other Room =="
        puts -nonewline "You find yourself in a rather strange room with odd implements\
        scattered throughout. On one side, there are some basic dental instruments. On a\
        table near the back, there are some children's toys. There seems to only be one\
        door leading out of this room."
        if {[state get steve-disappeared] eq {resurrected}} then {
            puts " Steve is leaning against one of the tables, looking somewhat confused."
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to Steve" yes steve}
            {"Step out the door" yes hub}
        }
    }

    proc mercuryMuffin {} {
        puts "You claim the muffin in the center of the room."
        puts "You got the Cream Cheese Muffin!"
        state put mercury-muffin yes
        muffin add {Cream Cheese Muffin}
        puts {}
        return mercury
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

    proc steve {} {
        # /////
        return -gameover
    }

    proc hub {} {
        puts "== Underworld Lobby =="
        if {([state get city-thug] eq {chasing}) && ([state get sa-coin] eq {yes})} then {
            state put city-thug no
        }
        if {[state get lobby-door] eq {yes}} then {
            puts "You enter the small rounded lobby. There are a few basic chairs and office\
            amenities here. There is a door leading to a large staircase on one side. On the\
            opposite side of the room, there are several doors, each with a label above\
            them: \"Murder\", \"Wildlife Attack\", \"Mercury Poisoning\", and \"Other\"."
            prompt {} {
                {"Enter Murder Room" yes murder}
                {"Enter Wildlife Room" yes wildlife}
                {"Enter Mercury Room" yes mercury}
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
            them: \"Murder\", \"Wildlife Attack\", \"Mercury Poisoning\", and \"Other\".\
            $doorComment"
            prompt {} {
                {"Enter Murder Room" {[state get lobby-door] eq {murder}} murder}
                {"Enter Wildlife Room" {[state get lobby-door] eq {wildlife}} wildlife}
                {"Enter Mercury Room" {[state get lobby-door] eq {mercury}} mercury}
                {"Enter Other Room" {[state get lobby-door] eq {other}} other}
                {"Go toward the staircase" yes ::Underworld::Elevator::staircase}
            }
        }
    }

}
