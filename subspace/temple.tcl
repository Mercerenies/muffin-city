
namespace eval Subspace::Temple {

    proc hill {} {
        puts "== Subspace Hill =="
        puts "The hill is relatively small, and you climb atop it easily. From the top, \
        however, you feel much higher. You can see the hub to the south, containing the \
        shop and the bank. To the north, you can see a large, ornate temple."
        prompt {} {
            {"Head toward the hub" yes ::Subspace::Hub::hub}
            {"Head toward the temple" yes ::Subspace::Temple::outside}
        }
    }

    proc outside {} {
        puts "== Subspace Temple - Outside =="
        puts "The temple appears even larger up close. The enormous front doors are open, \
        inviting all guests to enter freely."
        prompt {} {
            {"Enter the temple" yes altar}
            {"Go back to the hill" yes hill}
        }
    }

    proc altar {} {
        puts "== Subspace Temple - Altar =="
        puts "Within the main room of the temple, there are rows of pews facing a \
        large altar. The candles at the front of the altar are lit, and a young acolyte \
        is standing beside them. Behind him, there is a door leading to a sanctuary."
        prompt {} {
            {"Talk to the acylote" yes ::Empty::place}
            {"Enter the sanctuary" yes sanctuary}
            {"Exit the altar" yes outside}
        }
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
