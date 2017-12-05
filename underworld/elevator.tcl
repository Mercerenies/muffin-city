
namespace eval Underworld::Elevator {

    proc staircase {} {
        puts "== Grand Staircase =="
        puts "You approach a grand set of stairs leading up to a rather intimidating set of\
        double doors. At the base of the stairs, there is a smaller door that leads to a small lobby.\
        Off to the side, there is a strange hole in the wall leading to some kind of tunnel."
        prompt {} {
            {"Enter the double doors" yes balcony}
            {"Enter the small door" yes ::Underworld::Lobby::hub}
            {"Go through the hole" yes tunnel}
        }
    }

    proc balcony {} {
        puts "== Underworld Balcony =="
        puts -nonewline "The room you enter is very large. You find yourself on a small\
        glowing balcony overlooking a vast pool of flames."
        if {[state get talked-to-johnny]} then {
            puts " To the right, Johnny Death stands over his display of souls."
        } else {
            puts " To the right side of the room, an eccentric man with spiked hair that seems\
            to be quite literally flaming is staring down at a glass case full of strange,\
            floating entities."
        }
        prompt {} {
            {"Talk to the man" {![state get talked-to-johnny]} ::Underworld::Johnny::talk}
            {"Talk to Johnny" {[state get talked-to-johnny]} ::Underworld::Johnny::talk}
            {"Leap over the edge" yes ::Underworld::Pits::fireEntry}
            {"Exit toward the stairs" yes staircase}
        }
    }

    proc tunnel {} {
        puts "== Underworld Tunnel =="
        puts "The strange tunnel stretches on for a long while, but it quickly becomes too narrow\
        for you to proceed. There is an elevator and a door that appears to lead to a science lab.\
        The other doors are on the other side of the narrow tunnel and are inaccessible to you."
        prompt {} {
            {"Enter the science lab" yes scienceLab}
            {"Enter the elevator" yes {lift ::Underworld::Elevator::tunnel}}
            {"Go back" yes staircase}
        }
    }

    proc scienceLab {} {
        switch [state get johnny-quest] {
            no - accepted {
                puts "Unfortunately, the door to the science lab appears to be bolted from the inside."
                puts {}
                return tunnel
            }
            default {
                puts "== Underworld Science Lab =="
                if {[state get talked-to-cipher]} then {
                    set cipher "Dr. Cipher is examining some strange contraption."
                } else {
                    set cipher "There is a strange horned man in a lab coat poking and prodding at\
                    a strange contraption."
                }
                puts "The science lab is surprisingly futuristic looking, given the\
                surrounded environment. $cipher"
                prompt {} {
                    {"Talk to the man" {![state get talked-to-cipher]} cipherTalk}
                    {"Talk to Dr. Cipher" {[state get talked-to-cipher]} cipherTalk}
                    {"Go back out" yes tunnel}
                }
            }
        }
    }

    # //// The rest of Johnny Death

    proc lift {back} {
        if {[inv has {Elevator Access Key}] || [inv has {Upgraded Elevator Access Key}]} then {
            puts "== Elevator =="
            puts -nonewline "The elevator is relatively small, only big enough for two or\
            three people."
            if {[inv has {Upgraded Elevator Access Key}]} then {
                puts "As you enter the elevator, all of the buttons on the panel light up."
            } else {
                puts "There are a handful of buttons on the panel, but only a few of them are lit up."
            }
            # //// There will be an outer space option here eventually
            prompt {} {
                {"Go to the underworld" yes tunnel}
                {"Go to the overworld" yes ::City::District::shopping}
                {"Go to outer space" yes ::Empty::place}
            }
        } else {
            puts "The elevator seems to require a key to operate..."
            puts {}
            return $back
        }
    }

    proc cipherTalk {} {
        if {[state get talked-to-cipher]} then {
            puts "\"Heyyyy it's good to see you again! Would you like me to erase your records?\""
            prompt {} {
                {"\"Yes, please.\"" yes cipherErase}
                {"\"Not right now.\"" yes scienceLab}
            }
        } else {
            state put talked-to-cipher yes
            puts "\"Heyyyy you're that girl who's helping ol' Johnny. Or guy, I never have the time\
            to tell the difference.\""
            puts "\"Anyway, I'm Dr. Cipher, and Johnny has told me all about you. Would you like to\
            hear about my latest invention?\""
            prompt {} {
                {"\"Yes.\"" yes {cipherExplain yes}}
                {"\"Not really.\"" yes {cipherExplain no}}
            }
        }
    }

    proc cipherExplain {answer} {
        if {!$answer} then {
            puts "\"Well I want to tell you anyway, so listen up!\""
        }
        puts "\"I call it the Document Transmogrifier! With just the press of a button, I can\
        erase your name and information from every record in every database in the universe!\
        Criminal record? Gone! History of psychological problems? Erased! Every document with your\
        name on it gets shredded. And since you're a friend of Johnny's, you can use it anytime!\""
        prompt {} {
            {"\"Can I use it now?\"" yes cipherErase}
            {"\"Okay. Thanks.\"" yes scienceLab}
        }
    }

    proc cipherErase {} {
        puts "Dr. Cipher presses a big red button, and a loud whirring sound pierces your ears."
        puts "\"It is done!\""
        state put trial-crime no
        puts {}
        return scienceLab
    }

}
