
namespace eval City::District {

    proc entrance {} {
        puts "== City Plaza =="
        puts "The bright lights of the city shimmer in contrast against the night sky.\
        Most of the shops have closed for the night, but you might find a few people still out\
        and about."
        switch [state get city-thug] {
            stalking {
                puts "... You still feel as though you are being watched."
            }
        }
        if {[state get fire-pit] eq {odd}} then {
            state put fire-pit even
        }
        prompt {} {
            {"Go to the hotel district" yes hotel}
            {"Go to the shopping district" yes shopping}
            {"Go to the police district" yes police}
            {"Go to the incredibly shady alley" yes shadyAlley}
        }
    }

    proc hotel {} {
        puts "== Hotel District =="
        puts "Most of the hotels have \"No Vacancy\" lights on. From what you can tell, there\
        are two that do not."
        if {[state get city-thug] eq {stalking}} then {
            return {::City::Robbery::jumped ::City::District::hotel}
        }
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Enter the Ritzy Inn & Suites" yes ::City::Hotel::ritzyInn}
            {"Enter Shabby Jack's Streetside Motel" yes ::City::Hotel::shabbyJack}
        }
    }

    proc shopping {} {
        puts "== Shopping District =="
        puts "There are a handful of shops here that appear to be open, as well as an\
        elevator that seems somewhat out of place in the middle of a city block."
        if {[state get city-thug] eq {stalking}} then {
            return {::City::Robbery::jumped ::City::District::shopping}
        }
        prompt {} {
            {"Enter the market" yes ::City::Shopping::market}
            {"Enter the pawn shop" yes ::City::Shopping::pawnShop}
            {"Enter the elevator" yes {::Underworld::Elevator::lift ::City::District::shopping}}
            {"Go back to the plaza" yes entrance}
        }
    }

    proc police {} {
        puts "== Police District =="
        puts "The police district is fairly large but unified. There is a large station for\
        the officers and a courthouse that towers over the center of the town."
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Go to the police station" yes ::City::Police::station}
            {"Go to the courthouse" yes ::City::Courthouse::entrance}
        }
    }

    proc shadyAlley {} {
        puts "== Shady Alley =="
        puts -nonewline "You enter the dark alley. This is certainly the sort of place to go if you\
        want to do something criminal. There are several dumpsters containing bags of illicit goods."
        switch [state get city-thug] {
            no {
                puts -nonewline " You have the strangest feeling that you are being watched."
                state put city-thug stalking
            }
            chasing {
                if {![state get sa-coin]} then {
                    puts -nonewline " There is a Silver Coin glimmering on the asphalt."
                }
            }
        }
        puts ""
        prompt {} {
            {"Pick up the coin" {([state get city-thug] eq {chasing}) && ![state get sa-coin]} alleyCoin}
            {"Go back to the plaza" yes entrance}
        }
    }

    proc alleyCoin {} {
        puts "You collect the Silver Coin."
        state put sa-coin yes
        inv add {Silver Coin}
        puts {}
        return shadyAlley
    }

}
