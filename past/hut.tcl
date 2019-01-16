
namespace eval ::Past::Hut {

    proc locked {} {
        if {[state get hut-password] eq {yes}} then {
            return foyer
        }
        puts "== Mysterious Hut - Past =="
        puts "The door to the hut is locked by an electronic lock with\
        a keypad."
        prompt {} {
            {"Guess a random password" {[state get hut-password] eq {no}} lockedFail}
            {"Enter 6872" {[state get hut-password] eq {found}} foyer}
            {"Go back" yes ::Past::District::police}
        }
    }

    proc lockedFail {} {
        puts "You guess a random password. The keypad flashes a red color briefly,\
        and the door does not unlock."
        prompt {} {
            {"Guess another" yes lockedFail1}
            {"Go back" yes ::Past::District::police}
        }
    }

    proc lockedFail1 {} {
        puts "You guess another random password. The keypad flashes red again,\
        but the door does not unlock."
        prompt {} {
            {"Go back" yes ::Past::District::police}
        }
    }

    proc foyer {} {
        puts "== Mysterious Hut Foyer - Past =="
        puts "The inside of the hut is sparsely decorated, with dim lighting and\
        scarce furniture. There is a large rug in the center of the room."
        state put hut-password yes
        prompt {} {
            {"Lift up the rug" yes underRug}
            {"Go outside" yes ::Past::District::police}
        }
    }

    proc underRug {} {
        puts "Under the rug is a trapdoor!"
        prompt {} {
            {"Go down through the trapdoor" yes basement}
            {"Put the rug back" yes foyer}
        }
    }

    proc basement {} {
        puts "== Mysterious Hut Basement - Past =="
        puts "The basement of the hut is incredibly neat and orderly. Several light\
        bulbs hanging from the ceiling provide the only light in the room. An old\
        refrigerator sits in the back corner of the room. On the opposite side, a\
        mime pretending to be in a glass box is standing next to a police officer\
        who is in a literal glass box. A small note is taped to the bottom of the\
        trapdoor."
        prompt {} {
            {"Open the refrigerator" yes fridge}
            {"Read the note" yes note}
            {"Talk to the police officer" yes officer}
            {"Talk to the mime" yes mime}
            {"Go back up" yes foyer}
        }
    }

    proc note {} {
        # //// Does this one give you a different code? Maybe that
        # code takes you somewhere different? Maybe...
        puts "\"In case I ever forget the password to my house, it's 6872.\""
        puts {}
        return basement
    }

    proc fridge {} {
        puts "You open the refrigerator and find nothing of interest, aside from\
        some moldy bread."
        puts {}
        return basement
    }

    proc officer {} {
        puts "\"He's insane! Get out of here! I'll take care of this!\""
        prompt {} {
            {"\"Can I help?\"" yes officerHelp}
            {"\"Goodbye.\"" yes basement}
        }
    }

    proc officerHelp {} {
        puts "\"Just get out of here! I'll be fine. I'm a police officer.\""
        puts {}
        return basement
    }

    proc mime {} {
        puts "The mime continues his glass box act without acknowledging you."
        prompt {} {
            {"\"Let that officer go!\"" yes mimeRelease}
            {"\"I'm leaving now.\"" yes basement}
        }
    }

    proc mimeRelease {} {
        puts "The mime displays a shocked gesture, placing his hands on his cheeks.\
        Then he wags his finger at you while shaking his head."
        prompt {} {
            {"\"I'll fight you!\"" yes mimeShrink}
            {"\"Well okay then. Goodbye.\"" yes basement}
        }
    }

    proc mimeShrink {} {
        puts "The mime points his index finger at you. As he does so, you begin to\
        shrink down. The entire room begins to look larger and larger until you are\
        smaller than the mime's foot. As soon as you stop shrinking, he returns to his\
        glass box miming."
        puts {}
        return ::Tiny::PastHut::basement
    }

}
