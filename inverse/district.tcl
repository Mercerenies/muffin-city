
namespace eval Inverse::District {

    proc entrance {} {
        puts "=~ City Plaza ~="
        puts "The neon lights of the city are blinding in contract to the dark of the\
        night sky. There is no one out on the street, and the city is eerily quiet."
        # //// The cave
        prompt {} {
            {"Go to the education district" yes education}
            {"Go to the shopping district" yes shopping}
            {"Go to the castle district" yes castle}
            {"Go to the dark cave" yes ::Prison::Forest::reverseCave}
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
        # ////
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Enter the market" yes ::Inverse::Shopping::market}
        }
    }

    proc castle {} {
        puts "=~ Castle District ~="
        # ////
        prompt {} {
            {"Go back to the plaza" yes entrance}
        }
    }

}
