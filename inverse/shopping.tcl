
namespace eval Inverse::Shopping {

    proc market {} {
        puts "=~ Market ~="
        puts "The market is neatly organized, with shelves full of various\
        objects. Oddly enough, there is no one present to manage the shop,\
        only a single speaker against the back wall and a red button\
        beneath it."
        prompt {} {
            {"Hit the red button" yes marketBot}
            {"Steal everything" yes marketSteal}
            {"Go back outside" yes ::Inverse::District::shopping}
        }
    }

    proc marketBot {} {
        if {[state get met-robot] eq {no}} then {
            puts "A robotic voice responds immediately."
        } else {
            puts "The Robot King's voice greets you immediately."
        }
        puts "\"Greetings! Welcome to the state-approved general market, for\
        all your general marketing needs. What would you like to purchase?\""
        # //// Some items
        prompt {} {
            {"\"Never mind.\"" yes market}
        }
    }

    proc marketSteal {} {
        puts "As soon as you touch anything, a piercing alarm\
        screeches in your ears, and the walls open to reveal\
        several hidden lasers, which instantly vaporize you."
        puts {}
        return ::Underworld::Pits::mysteryRoom
    }

    proc elevator {} {
        puts "=~ Elevator Shaft ~="
        puts "Upon closer inspection, the elevator shaft seems to have\
        been filled with concrete and likely hasn't been used in some\
        time."
        # //// Does anything more interesting happen here?
        prompt {} {
            {"Go back" yes ::Inverse::District::shopping}
        }
    }

    proc collector {} {
        puts "=~ Collector's Stand ~="
        puts "There are various exotic ceramics and works of art on\
        display at the stand, likely all very expensive and valuable\
        in the right hands. The collector himself stands behind them,\
        looking a bit shady and staring at you impatiently."
        prompt {} {
            {"Talk to the collector" yes collectorTalk}
            {"Go back outside" yes ::Inverse::District::shopping}
        }
    }

    proc collectorTalk {} {
        # //// Shower cap?
        puts "\"All hail the Robot King!\""
        puts {}
        if {[state get drawbridge-down] eq {no}} then {
            state put drawbridge-down yes
        }
        return collector
    }

}
