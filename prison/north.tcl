
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
                    puts -nonewline " A shady gentleman with black slicked back hair is\
                    leaning against the wall."
                }
                met - breakout {
                    puts -nonewline " Harry is leaning against the back wall."
                }
            }
        }
        switch [state get washroom-coin] {
            no {
                state put washroom-coin visited
            }
            ready {
                puts -nonewline " There is a shining Silver Coin sitting on one of the\
                sinks."
            }
        }
        if {([state get washroom-coin] eq {yes}) &&
            ([state get harry-location] ni {no met breakout}) &&
            ([state get brain-control] eq {no})} then {
            state put brain-control initiated
        }
        if {[state get brain-control] in {washroom washroom1}} then {
            puts -nonewline " A bald man with a goatee is staring at the palm of his hand."
        }
        puts {}
        prompt {} {
            {"Talk to the gentleman" {[state get harry-location] eq {no}} harry}
            {"Talk to Harry" {[state get harry-location] in {met breakout}} harry}
            {"Talk to the bald man" {[state get brain-control] in {washroom washroom1}} restBald}
            {"Take the coin" {[state get washroom-coin] eq {ready}} restCoin}
            {"Exit the washroom" yes toHallway}
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

    proc restCoin {} {
        puts "You got a Silver Coin!"
        state put washroom-coin yes
        inv add {Silver Coin}
        puts {}
        return restroom
    }

    proc restBald {} {
        puts "\"Jewels... gems... so shiny... I want them all...\""
        state put brain-control washroom1
        puts {}
        return restroom
    }

    proc toHallway {} {
        if {[state get brain-control] eq {washroom1}} then {
            return hypnoConfront
        } else {
            return hallway
        }
    }

    proc hypnoConfront {} {
        puts "As you turn to leave, a stout man in a top hat, black mask, and full cloak\
        enters the washroom and blocks your exit."
        puts "\"Ah, it seems I've been caught in the act. Greetings, puppet. You may call\
        me the Mastermind.\""
        prompt {} {
            {"\"And what exactly are you doing here?\"" yes hypnoConfrontAsk}
            {"\"I'm not a puppet.\"" yes hypnoConfrontNoPuppet}
            {"\"Goodbye now.\"" yes hypnoConfrontGoodbye}
        }
    }

    proc hypnoConfrontAsk {} {
        puts "\"Quite simply, I'm practicing my hypnosis abilities. Unfortunately for you,\
        you've already seen too much.\""
        return hypnoTry
    }

    proc hypnoConfrontNoPuppet {} {
        puts "\"Well, not yet. But this provides an excellent opportunity for me\
        to practice my hypnosis abilities.\""
        return hypnoTry
    }

    proc hypnoConfrontGoodbye {} {
        puts "\"I'm afraid I can't let you leave. You've simply seen too much, puppet.\
        I'll have to practice my hypnosis abilities on you.\""
        return hypnoTry
    }

    proc hypnoTry {} {
        puts "The Mastermind reaches into his pocket and withdraws a pendulum, which\
        he swings in front of your face. The bald man immediately starts staring at\
        the pendulum."
        prompt {} {
            {"\"Is... this supposed to be doing anything?\"" yes hypnoNoEffect}
            {"\"Can I leave now?\"" yes hypnoNoEffect}
        }
    }

    proc hypnoNoEffect {} {
        puts "\"Hm... that usually works. Ah, well, plan B then. Midas, take good\
        care of our new friend.\""
        puts "The bald man pulls a small knife out of his belt and thrusts it into\
        your chest."
        state put brain-control hiding
        if {[state get lobby-door] ne {yes}} then {
            state put lobby-door murder
        }
        puts {}
        return ::Underworld::Lobby::murder
    }

    proc dining {} {
        puts "== Dining Hall =="
        puts -nonewline "The dining hall consists of a small collection of tables\
        opposite a cafeteria-like buffet. The stand is unfortunately empty, as it\
        is not meal time, but there are a few prisoners socializing in the corner."
        if {[state get brain-control] eq {no}} then {
            puts " On the other side of the room, a bald man with a goatee is staring\
            at the palm of his hand."
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to the prisoners" yes diningTalk}
            {"Talk to the bald man" {[state get brain-control] eq {no}} diningBald}
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

    proc diningBald {} {
        puts "\"Jewels... gems... so shiny... I want them all...\""
        puts {}
        return dining
    }

}
