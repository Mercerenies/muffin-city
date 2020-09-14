
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
        if {[state get abduction-discovered] eq {met}} then {
            return hotelAbduction
        }
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
        puts "At this early hour, many of the shops have yet to open. A locksmith's shop\
        which was not there later in the day is open, with a large sign reading \"Steve's\
        Smash-a-Lock\" above the door. The elevator still looks out of place at this\
        time of day."
        if {[state get reaper-helper] eq {locksmith}} then {
            state put reaper-helper locksmith1
            state put steve-disappeared gone
        }
        # //// Elevator
        prompt {} {
            {"Enter the market" yes marketClosed}
            {"Enter the pawn shop" yes ::Past::Shopping::pawnShopEntry}
            {"Enter Steve's Smash-a-Lock" yes ::Past::Shopping::locksmithEntry}
            {"Go back to the plaza" yes entrance}
        }
    }

    proc police {} {
        puts "== Police District - Past =="
        puts "The police district is fairly large but unified. There is a large station for\
        the officers and a courthouse that towers over the center of the town. The courthouse\
        doors appear to be wide open. A conspicuous wooden hut sits between the courthouse\
        and the police station."
        prompt {} {
            {"Go back to the plaza" yes entrance}
            {"Go to the police station" yes ::Past::Police::station}
            {"Go to the courthouse" yes ::Past::Police::courthouse}
            {"Approach the hut" yes ::Past::Hut::locked}
        }
    }

    proc shadyAlley {} {
        puts "== Shady Alley - Past =="
        puts -nonewline "You enter the alley. It isn't terribly intimidating during the\
        day, as the sunlight ensures that it is well-illuminated."
        # //// Something interesting
        if {[state get courtroom-key] ne {no}} then {
            puts " The young man from the courtroom is sitting on a crate in the corner."
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to the young man" {[state get courtroom-key] ne {no}} alleyTalk}
            {"Go back to the plaza" yes entrance}
        }
    }

    proc alleyTalk {} {
        switch [state get courtroom-key] {
            has {
                puts "\"'Ey, listen! Hold onto dat key. I don't care what ya do with it; I just\
                don't want dat stuck-up judge havin' it.\""
                state put courtroom-key yes
            }
            yes {
                puts "\"When da sun goes down, dis is my alley. Ya better get lost before den.\""
            }
        }
        puts {}
        return shadyAlley
    }

    proc marketClosed {} {
        # //// If you have the key (from Todd, probably), you can get in here
        puts "The market has a sign on the door indicating that it is currently closed."
        puts {}
        return shopping
    }

    proc hotelAbduction {} {
        puts "The two young women from Shabby Jack's are standing outside talking. You\
        only hear the tail end of the conversation, something about a hidden alcove by\
        a river in a forest. They spot you and run off, before you can stop them."
        state put abduction-discovered yes
        puts {}
        return hotel
    }

}
