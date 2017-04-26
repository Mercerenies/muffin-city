
namespace eval City::Police {

    proc station {} {
        switch [state get trial-crime] {
            court {
                puts "\"'Ey! It's that suspect! The one who made a mess of the courtroom!\""
                puts "You are grabbed and forced into the courthouse very quickly."
                puts {}
                return ::City::Courthouse::trial
            }
            prison {
                puts "\"'Ey! I know you! You're supposed to be in prison!\""
                puts "You are grabbed and forced into the courthouse very quickly."
                state put trial-reason escape
                puts {}
                return ::City::Courthouse::trial
            }
        }
        puts "== Police Station =="
        puts "Even this late at night, several officers are on duty. A few of them look at you as you enter,\
        but most of them just go about their business."
        prompt {} {
            {"Go back outside" yes ::City::District::police}
            {"\"Did you recover my stuff?\"" {[state get city-thug] eq {caught}} recovered}
            {"\"I'm being followed!\"" {[state get city-thug] eq {stalking}} followed}
            {"\"I was robbed!\"" {[state get city-thug] eq {island}} robbed}
            {"\"I killed a man!\"" yes arrested}
        }
    }

    proc followed {} {
        puts "\"Hm? Right, okay. We'll chase 'im off. Hey, Ricardo, get over here!\""
        puts "\"We'll deal with 'im.\""
        state put city-thug chasing
        puts {}
        return station
    }

    proc robbed {} {
        puts "\"Hm?\""
        puts "You describe the robber to the police."
        puts "\"Oh, yeah. We deal with 'im a lot. We'll get right on that. You're in good hands.\""
        state put city-thug hunted
        puts {}
        return station
    }

    proc arrested {} {
        puts "\"Huh? Really? Hey! We've got a murderer in 'ere!\""
        puts "You are apprehended immediately and forced into the courthouse."
        state put trial-crime court
        state put trial-reason murder
        puts {}
        return ::City::Courthouse::trial
    }

    proc recovered {} {
        puts "\"Oh yeah. We caught that guy just a bit ago!\""
        if {[state get stolen-good] eq {}} then {
            puts "\"Unfortunately, he didn't have anything on him except his ID. We still got him, based on\
            your statement, but your stolen goods weren't on 'im.\""
            state put city-thug no
            puts {}
            return station
        } elseif {[state get thug-card] eq {}} then {
            puts "\"Here you go. Your [state get stolen-good].\""
            puts "You recovered your [state get stolen-good]."
            inv add [state get stolen-good]
            state put city-thug no
            state put stolen-good {}
            puts {}
            return station
        } else {
            puts "\"Right, now which one of these was yours?\""
            puts "The officer presents two objects."
            prompt {} {
                {"\"The [state get stolen-good].\"" yes regularRecover}
                {"\"The [state get thug-card].\"" yes specialRecover}
            }
        }
    }

    proc regularRecover {} {
        puts "\"Alright then. Here you go.\""
        puts "You recovered your [state get stolen-good]."
        inv add [state get stolen-good]
        state put city-thug no
        state put stolen-good {}
        puts {}
        return station
    }

    proc specialRecover {} {
        puts "\"Alright then. Here you go.\""
        puts "You recovered... somebody's [state get thug-card]."
        inv add [state get thug-card]
        state put city-thug no
        state put stolen-good {}
        state put thug-card {}
        puts {}
        return station
    }

}
