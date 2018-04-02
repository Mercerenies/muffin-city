
namespace eval Subspace::Temple {

    proc hill {} {
        puts "== Subspace Hill =="
        puts "The hill is relatively small, and you climb atop it easily. From the top,\
        however, you feel much higher. You can see the hub to the south, containing the\
        shop and the bank. To the north, you can see a large, ornate temple."
        prompt {} {
            {"Head toward the hub" yes ::Subspace::Hub::hub}
            {"Head toward the temple" yes ::Subspace::Temple::outside}
        }
    }

    proc outside {} {
        puts "== Subspace Temple - Outside =="
        puts "The temple appears even larger up close. The enormous front doors are open,\
        inviting all guests to enter freely."
        prompt {} {
            {"Enter the temple" yes altar}
            {"Go back to the hill" yes hill}
        }
    }

    proc altar {} {
        puts "== Subspace Temple - Altar =="
        puts -nonewline "Within the main room of the temple, there are rows of\
        pews facing a large altar. The candles at the front of the altar are\
        lit,"
        if {[state get talked-to-acolyte] eq {yes}} then {
            puts " and Matthew is standing beside them. Behind him, the door to the\
            sanctuary is open."
        } else {
            puts " and a young acolyte is standing beside them."
        }
        prompt {} {
            {"Talk to the acylote" {[state get talked-to-acolyte] eq {no}} matthew}
            {"Talk to Matthew" {[state get talked-to-acolyte] eq {yes}} matthew}
            {"Enter the sanctuary" {[state get talked-to-acolyte] eq {yes}} sanctuary}
            {"Exit the altar" yes outside}
        }
    }

    proc matthew {} {
        if {[state get talked-to-acolyte] eq {yes}} then {
            puts "\"Good day. The Ancient Minister is meditating in his sanctuary.\""
            prompt {} {
                {"\"What does this temple worship?\"" yes matthewStudy}
                {"\"Thank you.\"" yes altar}
            }
        } else {
            puts "\"Good day. My name is Matthew. I am a young study at this temple. If you\
            are interested in conversion, please speak to the Ancient Minister in his\
            sanctuary.\""
            puts "Matthew gestures to an open door behind him."
            state put talked-to-acolyte yes
            prompt {} {
                {"\"What does this temple worship?\"" yes matthewStudy}
                {"\"Thank you.\"" yes altar}
            }
        }
    }

    proc matthewStudy {} {
        puts "\"We preach good faith practices for avoidance and mitigation of temporal\
        paradoxes, as we believe in a future without regular occurrences of world-ending\
        paradoxes.\""
        puts {}
        return altar
    }

    proc sanctuary {} {
        puts "== Subspace Temple - Sanctuary =="
        # /////
        prompt {} {
            {"Talk to the Ancient Minister" yes ::Empty::place}
            {"Exit the sanctuary" yes altar}
        }
    }

}
