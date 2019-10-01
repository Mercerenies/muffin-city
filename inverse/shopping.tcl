
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
        puts "A robotic voice responds immediately."
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
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door other
        }
        puts {}
        return ::Underworld::Lobby::other
    }

}
