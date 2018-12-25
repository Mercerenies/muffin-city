
namespace eval Prison::North {

    proc hallway {} {
        puts "== Prison Hall - North =="
        if {[state get the-fence] eq {paperclip1}} then {
            state put the-fence shovel
        }
        puts "The opposite end of the hall is not much different than the first. There is a door\
        leading outside up ahead and a few other areas of interest to the left and right."
        prompt {} {
            {"Enter the washroom" yes restroom}
            {"Go outside" yes ::Prison::Exercise::fields}
            {"Enter the dining hall" yes dining}
            {"Walk down the hallway" yes ::Prison::South::hallway}
        }
    }

    proc restroom {} {
        puts "== Prison Washroom =="
        puts -nonewline "Presumably, this is where the prisoners go to shower. The entire\
        place is in disarray, and you would hate to have to clean yourself here."
        if {[state get harry-location] in {no met breakout}} then {
            switch [state get harry-location] {
                no {
                    puts " A shady gentleman with black slicked back hair is leaning against\
                    the wall."
                }
                met - breakout {
                    puts " Harry is leaning against the back wall."
                }
            }
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to the gentleman" {[state get harry-location] eq {no}} harry}
            {"Talk to Harry" {[state get harry-location] in {met breakout}} harry}
            {"Exit the washroom" yes hallway}
        }
    }

    proc harry {} {
        switch [state get harry-location] {
            no {
                puts "\"Hey, my name's Harry. What are you in for?\""
                prompt {} {
                    {"\"Murder.\"" yes harryIntro}
                    {"\"Bank robbery.\"" yes harryIntro}
                    {"\"I'm just here for fun.\"" yes harryIntro}
                }
            }
            met {
                if {[state get butler-game] ni {no cell}} then {
                    puts "\"... ... You seem trustworthy enough.\""
                    prompt {} {
                        {"\"What's up?\"" yes harryPlan}
                        {"\"Nope. Can't trust me.\"" yes restroom}
                    }
                } else {
                    puts "\"Good to see ya again.\""
                    prompt {} {
                        {"\"Later.\"" yes restroom}
                    }
                }
            }
            breakout {
                puts "\"Just cause a scene at the gate, and I'll do the rest.\""
                prompt {} {
                    {"\"Will do.\"" yes restroom}
                }
            }
        }
    }

    proc harryIntro {} {
        puts "\"Interesting... they say I'm an 'arsonist', but I don't worry about\
        fancy titles; I just like burning things down.\""
        state put harry-location met
        prompt {} {
            {"\"Goodbye.\"" yes restroom}
        }
    }

    proc harryPlan {} {
        puts "\"I'm lookin' to get out of here. I've got a plan, but I need your help.\""
        prompt {} {
            {"\"What can I do?\"" yes harryPlan1}
            {"\"A prison break? That's illegal!\"" yes restroom}
        }
    }

    proc harryPlan1 {} {
        puts "\"I know you've been in and out of here a few times. I need you to get yourself\
        arrested and then cause a scene at the gate. If you can distract the guard, then I\
        can get myself out. I'll make it worth your while if it works.\""
        prompt {} {
            {"\"I'm in.\"" yes harryPlan2}
            {"\"Not my style.\"" yes restroom}
        }
    }

    proc harryPlan2 {} {
        puts "\"Great! Do your thing.\""
        state put harry-location breakout
        puts {}
        return restroom
    }

    proc dining {} {
        puts "== Dining Hall =="
        puts "The dining hall consists of a small collection of tables opposite a\
        cafeteria-like buffet. The stand is unfortunately empty, as it is not meal\
        time, but there are a few prisoners socializing in the corner."
        prompt {} {
            {"Talk to the prisoners" yes diningTalk}
            {"Go back to the hall" yes hallway}
        }
    }

    proc diningTalk {} {
        puts "\"Hey! This is a private conversation. Now get lost!\""
        if {[state get city-thug] eq {hunted}} then {
            puts "Just before departing, you recognize one of the prisoners at the table as the man\
            who robbed you."
        }
        prompt {} {
            {"Confront the robber" {[state get city-thug] eq {hunted}} diningConfront}
            {"Leave" yes dining}
        }
    }

    proc diningConfront {} {
        puts "\"Oi! My friend said dis is... oh, it's you. Yeah, dey caught me. Da cops have\
        yer [state get stolen-good] now. But hey, no hard feelings for turnin' me in. I'll get\
        outta here soon enough.\""
        state put city-thug caught
        puts {}
        return dining
    }

}
