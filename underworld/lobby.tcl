
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
        puts "You find yourself in a rounded room. There are stuffed bears and lions mounted on the\
        walls. Between two rather intimidating bears, there is a single door leading out of the room."
        prompt {} {
            {"Step out the door" yes hub}
        }
    }

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
