
namespace eval Inverse::District {

    proc entrance {} {
        puts "=~ City Plaza ~="
        puts "The neon lights of the city are blinding in contract to the dark of the\
        night sky. There is no one out on the street, and the city is eerily quiet."
        if {[state get topaz-rescue] eq {noticed}} then {
            puts {}
            puts "Someone abruptly grabs you from behind and places a sack over your\
            head. A young male voice speaks from behind."
            puts "\"Don't make a sound. Come with me.\""
            prompt {} {
                {"Cooperate and follow his directions" yes ::Inverse::Hideout::firstEntryCoop}
                {"Remove the sack" yes ::Inverse::Hideout::firstEntryRemoval}
                {"Run blindly away" yes ::Inverse::Hideout::firstEntryFlee}
            }
        } else {
            prompt {} {
                {"Go to the education district" yes education}
                {"Go to the shopping district" yes shopping}
                {"Go to the castle district" yes castle}
                {"Go to the dark cave" yes ::Prison::Forest::reverseCave}
            }
        }
    }

    proc education {} {
        puts "=~ Education District ~="
        # ////
        prompt {} {
            {"Go back to the plaza" yes entrance}
        }
    }

    proc shopping {} {
        puts "=~ Shopping District ~="
        puts "Only one brick-and-mortar shop appears to still be operating:\
        a general market. However, there are several stands and tents beside\
        the street that appear to be operating, as well as a rather\
        unusual elevator shaft sitting off to the side of the street."
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Enter the general market" yes ::Inverse::Shopping::market}
            {"Approach the collector's stand" yes ::Inverse::Shopping::collector}
            {"Approach the accursed tent" yes ::Inverse::Shopping::cursedShop}
            {"Approach the elevator shaft" yes ::Inverse::Shopping::elevator}
        }
    }

    proc castle {} {
        puts "=~ Castle District ~="
        if {[state get drawbridge-down] eq {no}} then {
            puts "Compared to the relative normalcy of the rest of\
            the city, the massive traditional castle stands in stark contrast\
            in the middle of the city. Unfortunately, the castle is surrounded by\
            a large moat, and the drawbridge, seemingly the only viable entrance,\
            is raised."
        } else {
            puts "Compared to the relative normalcy of the rest of\
            the city, the massive traditional castle stands in stark contrast\
            in the middle of the city. The castle is surrounded by a large moat,\
            but the drawbridge seems to be lowered and the front entrance unguarded."
        }
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Enter the castle" {[state get drawbridge-down] eq {yes}} ::Inverse::Castle::entrance}
            {"Dive into the moat" yes moat}
        }
    }

    proc sleepDeath {} {
        puts "You fall asleep easily..."
        puts {}
        puts "...And awaken sometime later in a flaming wasteland."
        puts {}
        puts "=~ Flaming Wasteland ~="
        puts "A large grassy field surrounds you, as far as the eye can see. The\
        horizon is coated in a thick layer of flame and smoke, and all of the trees\
        along the way have long sense been burned to ash and branches. The air is\
        oddly suffocating, as though there is something in it that shouldn't be\
        there."
        prompt {} {
            {"Look for shelter" yes sleepDeath1}
            {"Examine the trees" yes sleepDeath1}
            {"Find a water source" yes sleepDeath1}
        }
    }

    proc sleepDeath1 {} {
        puts "The more you breathe of the strange air, the more it feels wrong."
        puts {}
        puts "After a moment, you pass out."
        puts {}
        return ::Underworld::Pits::mysteryRoom
    }

    proc moat {} {
        puts "You dive into the moat headfirst."
        # //// Does this do something different with the Scuba Suit?
        puts {}
        return ::Underworld::Pits::mysteryRoom
    }

}
