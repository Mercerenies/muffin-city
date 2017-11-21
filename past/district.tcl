
namespace eval Past::District {

    proc entrance {} {
        puts "== City Plaza - Past =="
        puts "The city seems to be mostly dead at this early hour of the morning. Most of\
        the shops have yet to open, and there is a distinctly relaxed nature in the air."
        prompt {} {
            {"Go to the hotel district" yes hotel}
            {"Go to the shopping district" yes shopping}
            {"Go to the police district" yes police}
            {"Go to the incredibly shady alley" yes shadyAlley}
        }
    }

    proc hotel {} {
        puts "== Hotel District - Past =="
        puts "The light of the morning sun illuminates the hotel district. The two hotels\
        you recognize are open now."
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Enter the Ritzy Inn & Suites" yes ::Past::Hotel::ritzyInn}
            {"Enter Shabby Jack's Streetside Motel" yes ::Past::Hotel::shabbyJack}
        }
    }

    proc shopping {} {
        puts "== Shopping District - Past =="
        puts "At this early hour, many of the shops have yet to open. The elevator still\
        looks out of place at this time of day."
        # //// Elevator
        prompt {} {
            {"Enter the market" yes marketClosed}
            {"Enter the pawn shop" yes ::Past::Shopping::pawnShopEntry}
            {"Go back to the plaza" yes entrance}
        }
    }

    proc police {} {
        puts "== Police District - Past =="
        puts "The police district is fairly large but unified. There is a large station for\
        the officers and a courthouse that towers over the center of the town. The courthouse\
        doors appear to be wide open."
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Go to the police station" yes ::Past::Police::station}
            {"Go to the courthouse" yes ::Past::Police::courthouse}
        }
    }

    proc shadyAlley {} {
        puts "== Shady Alley - Past =="
        puts "You enter the alley. It isn't terribly intimidating during the\
        day, as the sunlight ensures that it is well-illuminated."
        # //// Something interesting
        prompt {} {
            {"Go back to the plaza" yes entrance}
        }
    }

    proc marketClosed {} {
        # //// If you have the key (from Todd, probably), you can get in here
        puts "The market has a sign on the door indicating that it is currently closed."
        puts {}
        return shopping
    }

}
