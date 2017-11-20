
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
        return -gameover
    }

    proc police {} {
        return -gameover
    }

    proc shadyAlley {} {
        return -gameover
    }

}
