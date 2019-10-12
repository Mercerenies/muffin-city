
namespace eval Inverse::School {

    proc innerGate {} {
        puts "=~ School Gate ~="
        # ////
        # //// The bus might still be here
        prompt {} {
            {"Go inside" yes south}
        }
    }

    proc south {} {
        puts "=~ School Hall - South ~="
        # ////
        # //// Janitor's Closet (or equivalent)
        prompt {} {
            {"Walk down the hallway" yes north}
            {"Go to the dorms" yes dorms}
            {"Go outside" yes innerGate}
        }
    }

    proc north {} {
        puts "=~ School Hall - North ~="
        # ////
        prompt {} {
            {"Walk down the hallway" yes south}
            {"Enter the bathroom" yes bathroom}
            {"Go to the cafeteria" yes cafeteria}
            {"Head into the classroom" yes classroom}
        }
    }

    proc dorms {} {
        puts "=~ Dormitories ~="
        # ////
        prompt {} {
            {"Go to sleep in one of the beds" yes ::Inverse::District::sleepDeath}
            {"Go back to the hallway" yes south}
        }
    }

    proc bathroom {} {
        puts "=~ School Bathroom ~="
        # ////
        prompt {} {
            {"Go back to the hallway" yes north}
        }
    }

    proc cafeteria {} {
        puts "=~ Cafeteria ~="
        # ////
        prompt {} {
            {"Back to the hallway" yes north}
        }
    }

    proc classroom {} {
        puts "=~ Classroom ~="
        # ////
        prompt {} {
            {"Back to the hallway" yes north}
        }
    }

    proc bus {} {
        state put school-period first
        if {[state get been-to-school] eq {yes}} then {
            puts "You take a seat on the bus, which is mostly empty. The bus ride is\
            fairly uneventful, and some time later the bus pulls into a large gated\
            school. The other passengers disembark and head inside."
            prompt {} {
                {"Disembark" yes innerGate}
            }
        } else {
            puts "You take a seat on the bus, which is already mostly filled with\
            other people. A moment later, a young woman in a black dress frantically\
            waves the bus down and climbs aboard, taking the seat next to yours. The\
            bus sets off. After a moment, the young woman speaks to you."
            puts "\"First time being reeducated? Sorry, it's just, I don't think\
            I've seen you here before.\""
            state put been-to-school yes
            prompt {} {
                {"\"That's right.\"" yes bus1}
            }
        }
    }

    proc bus1 {} {
        puts "\"That's okay. It's not as bad as it sounds. There's three classes,\
        and at the end they'll give you a grade. If you pass, you get to leave. If\
        you fail, you have to do it all again.\""
        prompt {} {
            {"\"You sound like you've done this before.\"" yes bus2}
        }
    }

    proc bus2 {} {
        puts "\"I've been here a couple of times. You know how it is, your hypnotism starts\
        to slip but you don't want to go see the Mesmerist. The school can really help\
        with that. Gets rid of all of those anti- Robot King thoughts.\""
        prompt {} {
            {"\"Thanks. I'm sure it'll be fun.\"" yes busFun}
            {"\"I'm not actually hypnotized.\"" yes busNo}
        }
    }

    proc busFun {} {
        puts "\"It is! By the way, you can call me Starlight! Silver Starlight! All of\
        my friends do.\""
        prompt {} {
            {"\"Noted, Starlight.\"" yes busDepart}
        }
    }

    proc busNo {} {
        puts "\"Wow, your hypnotism must really be slipping. It's a good thing you came\
        here when you did. Oh, by the way, you can call me Silver Starlight! All of\
        my friends do.\""
        prompt {} {
            {"\"Will do.\"" yes busDepart}
        }
    }

    proc busDepart {} {
        puts "The bus pulls into a large gated campus, and the passengers begin to depart.\
        Starlight rises from her seat and makes a motion to leave."
        puts "\"See you in class!\""
        prompt {} {
            {"Step off the bus" yes innerGate}
        }
    }

}
