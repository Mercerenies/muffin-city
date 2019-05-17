
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
        if {([state get cottage-spirit] eq {evil}) && ([state get butler-game] ni {no cell})} then {
            state put cottage-spirit starlight
        }
        if {[state get reaper-helper] eq {item}} then {
            state put reaper-helper reset
        }
        if {[state get steve-disappeared] eq {gone1}} then {
            state put steve-disappeared resurrected
        }
        if {[state get washroom-coin] eq {visited}} then {
            state put washroom-coin ready
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
        elevator that seems somewhat out of place in the middle of a city block. One\
        particular building appears to have been recently boarded up."
        if {[state get city-thug] eq {stalking}} then {
            return {::City::Robbery::jumped ::City::District::shopping}
        }
        prompt {} {
            {"Enter the market" yes ::City::Shopping::market}
            {"Enter the pawn shop" yes ::City::Shopping::pawnShop}
            {"Enter the elevator" yes {::Underworld::Elevator::lift ::City::District::shopping}}
            {"Investigate the boarded building" yes ::City::Shopping::boarded}
            {"Go back to the plaza" yes entrance}
        }
    }

    proc police {} {
        puts "== Police District =="
        puts -nonewline "The police district is fairly large but unified. There is a\
        large station for the officers and a courthouse that towers over the center\
        of the town."
        if {[state get harry-location] in {no met breakout}} then {
            puts -nonewline " A conspicuous wooden hut sits between the courthouse and the\
            police station."
        } else {
            puts -nonewline " There is a pile of ash and rubble between the courthouse and the\
            police station."
        }
        if {[state get golden-arches]} then {
            puts -nonewline " A glimmering golden arch hovers just above the ground in the distance."
        }
        puts {}
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Go to the police station" yes ::City::Police::station}
            {"Go to the courthouse" yes ::City::Courthouse::entrance}
            {"Approach the hut" {[state get harry-location] in {no met breakout}} ::City::Hut::locked}
            {"Approach the rubble" {[state get harry-location] ni {no met breakout}} ::City::Hut::rubble}
            {"Pass through the arch" {[state get golden-arches]} ::Console::Hall::office}
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
