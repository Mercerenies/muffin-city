
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
        if {[state get talked-to-acolyte] ne {no}} then {
            puts " and Matthew is standing beside them. Behind him, the door to the\
            sanctuary is open."
        } else {
            puts " and a young acolyte is standing beside them."
        }
        prompt {} {
            {"Talk to the acylote" {[state get talked-to-acolyte] eq {no}} matthew}
            {"Talk to Matthew" {[state get talked-to-acolyte] ne {no}} matthew}
            {"Enter the sanctuary" {[state get talked-to-acolyte] ne {no}} sanctuary}
            {"Exit the altar" yes outside}
        }
    }

    proc matthew {} {
        if {[state get talked-to-acolyte] ne {no}} then {
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
            state put talked-to-acolyte started
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
        puts "The sanctuary is very quiet. In the center of the room, a bearded man is\
        sitting, cross-legged, hovering slightly in the air with his eyes closed."
        prompt {} {
            {"Talk to the Ancient Minister" yes minister}
            {"Exit the sanctuary" yes altar}
        }
    }

    proc minister {} {
        if {[state get talked-to-acolyte] eq {started}} then {
            state put talked-to-acolyte yes
        }
        switch [state get subspace-reason] {
            no {
                puts "The Minister's voice is very hoarse."
                puts "\"I see... purity in your soul... you are clean, my\
                child...\""
                puts "The Minister's eyes open slowly."
                puts "\"Thank you... for coming to see me...\""
                # //// Something happens here, he'll let you explore or something.
                prompt {} {
                    {"\"You are very welcome.\"" yes sanctuary}
                }
            }
            arrest {
                puts "The Minister's voice is very hoarse."
                puts "\"I see... the ways of the paradox... in your soul...\
                You have... confessed your crime to the authorities...\
                in the past... after speaking to them in the present...\
                You must cleanse your soul, my child...\""
                prompt {} {
                    {"\"Thank you.\"" yes sanctuary}
                }
            }
            button {
                puts "The Minister's voice is very hoarse."
                puts "\"I see... the ways of the paradox... in your soul...\
                You have... demolished the time machine... at a time before\
                you attempted to use it in the present...\
                You must cleanse your soul, my child.\""
                prompt {} {
                    {"\"Thank you.\"" yes sanctuary}
                }
            }
        }
    }

}
