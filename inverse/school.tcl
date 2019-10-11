
namespace eval Inverse::School {

    proc innerGate {} {
        puts "=~ School Gate ~="
        # ////
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

}
