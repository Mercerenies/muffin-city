
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
        # //// Janitor's Closet
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
        puts "You take a seat on the bus, which is already mostly filled with\
        other people."
        # //// Right now, we're just skipping this segment, but the
        # person you sit next to will want to have a conversation with
        # you, and that conversation will happen on the way to the
        # school.
        puts {}
        puts "Some time later, the bus pulls into a large gated school,\
        and everyone begins to disembark and head inside."
        prompt {} {
            {"Disembark" yes innerGate}
        }
    }

}
