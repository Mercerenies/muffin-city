
namespace eval Prison::North {

    proc hallway {} {
        puts "== Prison Hall - North =="
        puts "The opposite end of the hall is not much different than the first. There is a door\
        leading outside up ahead and a few other areas of interest to the left and right."
        prompt {} {
            {"Enter the washroom" yes restroom}
            {"Go outside" yes ::Prison::Exercise::fields}
            {"Enter the dining hall" yes dining}
            {"Walk down the hallway" yes ::Prison::South::hallway}
        }
    }

    proc restroom {} {
        puts "== Prison Washroom =="
        puts "Presumably, this is where the prisoners go to shower. The entire place is in disarray, and you\
        would hate to have to clean yourself here."
        prompt {} {
            {"Exit the washroom" yes hallway}
        }
    }

    proc dining {} {
        puts "== Dining Hall =="
        puts "The dining hall consists of a small collection of tables opposite a cafeteria-like buffet. The\
        stand is unfortunately empty, as it is not meal time, but there are a few prisoners socializing in\
        the corner."
        prompt {} {
            {"Talk to the prisoners" yes diningTalk}
            {"Go back to the hall" yes hallway}
        }
    }

    proc diningTalk {} {
        puts "\"Hey! This is a private conversation. Now get lost!\""
        if {[state get city-thug] eq {hunted}} then {
            puts "Just before departing, you recognize one of the prisoners at the table as the man\
            who robbed you."
        }
        prompt {} {
            {"Confront the robber" {[state get city-thug] eq {hunted}} diningConfront}
            {"Leave" yes dining}
        }
    }

    proc diningConfront {} {
        puts "\"Oi! My friend said dis is... oh, it's you. Yeah, dey caught me. Da cops have\
        yer [state get stolen-good] now. But hey, no hard feelings for turnin' me in. I'll get\
        outta here soon enough.\""
        state put city-thug caught
        puts {}
        return dining
    }

}
