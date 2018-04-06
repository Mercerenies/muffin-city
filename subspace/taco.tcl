
namespace eval Subspace::Taco {

    proc shop {} {
        puts "== Subspace Taco Shop =="
        if {[state get necro-cipher] in {rising help}} then {
            set guard {}
            if {[state get prison-guard] eq {cleared}} then {
                if {[state get guard-soul] eq {yes}} then {
                    set guard " The woman guard from the prison is sitting at a table,\
                    seemingly unaware of the chaos unfolding around her."
                } else {
                    set guard " The woman guard from the prison is behind the counter\
                    with the Taco Man."
                }
            }
            set atheena {}
            if {[state get necro-cipher] eq {help}} then {
                set atheena " Atheena has drawn her blade and appears to be ready for\
                combat."
            }
            puts "The once-refreshing taco shop is now filled with an aura of\
            evil, as Joe's accursed chanting summons more dark spirits. The Taco\
            Man, understandably panicked, is standing against the back wall of the\
            shop.$guard$atheena"
            prompt {} {
                {"Talk to the Taco Man" yes panicTaco}
                {"Confront Joe" yes joeConfront}
                {"Talk to Atheena" {[state get necro-cipher] eq {help}} panicAtheena}
                {"Talk to the woman" {[state get prison-guard] eq {cleared}} panicWoman}
                {"Head back outside" yes ::Subspace::Hub::hub}
            }
        } else {
            puts -nonewline "The pleasant aroma of tacos is a refreshing break from the\
            emptiness of the remainder of subspace."
            if {[state get prison-guard] eq {cleared}} then {
                if {[state get guard-soul] eq {yes}} then {
                    puts -nonewline " The woman guard from the prison is sitting at a table,\
                    staring down at the table."
                } else {
                    puts -nonewline " The woman guard from the prison is sitting at a table,\
                    looking rather annoyed."
                }
            }
            switch [state get taco-shop] {
                no {
                    puts " An older, bearded man in a taco costume behind the\
                    counter is panicking and looking for something."
                }
                spoken {
                    puts " The Taco Man is still frantically running about behind the counter."
                }
                olive {
                    puts " The Taco Man stands behind the counter, smiling."
                }
                fed {
                    if {[state get pawn-shop-pass] eq {no}} then {
                        puts " The Taco Man stands behind the counter, smiling.\
                        The strange, hungry man from outside is sitting at one\
                        of the tables."
                    } else {
                        switch [state get necro-cipher] {
                            no {
                                puts " The Taco Man stands behind the counter, smiling.\
                                Joe the Time-Traveler is sitting at one of the tables."
                            }
                            spoken {
                                puts " The Taco Man stands behind the counter, smiling.\
                                Joe the Time-Traveler is sitting at one of the tables. On\
                                the table in front of him is a rolled up white scroll that\
                                you didn't pay any mind before."
                            }
                            found - encouraged {
                                puts " The Taco Man stands behind the counter, smiling.\
                                Joe the Time-Traveller is sitting at one of the tables.\
                                On the table in front of him is his grandfather's\
                                scroll."
                            }
                            beaten {
                                puts " The Taco Man stands behind the counter, smiling."
                            }
                        }
                    }
                }
            }
            prompt {} {
                {"Talk to the bearded man" {[state get taco-shop] eq {no}} tacoMan}
                {"Talk to the Taco Man" {[state get taco-shop] ne {no}} tacoMan}
                {"Talk to the man at the table" {([state get taco-shop] eq {fed}) && ([state get pawn-shop-pass] eq {no})} joe}
                {"Talk to Joe" {([state get taco-shop] eq {fed}) && ([state get pawn-shop-pass] ne {no}) && ([state get necro-cipher] in {no spoken found encouraged})} joe}
                {"Talk to the woman" {[state get prison-guard] eq {cleared}} woman}
                {"Head back outside" yes ::Subspace::Hub::hub}
            }
        }
    }

    proc woman {} {
        if {[state get guard-soul] eq {yes}} then {
            puts "The woman does not make eye contact with you and does not respond\
            as you greet her."
            puts {}
            return shop
        } else {
            puts "\"What do you want?\""
            if {![state get guard-soul] && [inv has {Soul Crystal}]} then {
                puts "... Your Soul Crystal starts vibrating in your pocket."
            }
            prompt {} {
                {"Use the Soul Crystal" {![state get guard-soul] && [inv has {Soul Crystal}]} stealing}
                {"\"Never mind.\"" yes shop}
            }
        }
    }

    proc stealing {} {
        puts "You activate your Soul Crystal, and a floating essence emerges from the guard,\
        not unlike the essences in Johnny Death's display case. You got the Guard's Soul!"
        inv add {Guard's Soul}
        state put guard-soul yes
        puts {}
        return shop
    }

    proc joe {} {
        if {[state get pawn-shop-pass] ne {no}} then {
            puts "\"Remember, the pawn shop password is 'bowling tournament'. I traveled back in\
            time to tell my past self the password. That's how I ended up here. Hopefully, you'll\
            be able to make more use of the password.\""
            prompt {} {
                {"\"What's that scroll?\"" {[state get necro-cipher] eq {spoken}} joeScroll}
                {"\"Can I have that scroll?\"" {[state get necro-cipher] eq {found}} joeScroll2}
                {"\"Give me the Certificate!\"" {[state get necro-cipher] eq {encouraged}} joeForce}
                {"\"Thank you.\"" yes shop}
            }
        } else {
            puts "\"I don't think we've formally been introduced. I'm Joe. Joe the Time-Traveler.\""
            prompt {} {
                {"\"Good to meet you.\"" yes joe1}
            }
        }
    }

    proc joe1 {} {
        puts "\"Likewise. Hey, listen, the Taco Man says you helped him get back on his feet.\
        As thanks, I'll give you a little tip. The pawn shop in the shopping district\
        is never really closed. If the door is locked, just tell him the password\
        is 'bowling tournament'. He'll let you in.\""
        state put pawn-shop-pass has
        puts {}
        return shop
    }

    proc joeScroll {} {
        puts "\"Huh? Oh, this? This is just a silly old scroll. Something my grandfather used\
        to own. I carry it around for good luck.\""
        prompt {} {
            {"\"That's nice.\"" yes shop}
            {"\"It looks like the Necromancy Certificate.\"" yes joeScroll1}
        }
    }

    proc joeScroll1 {} {
        puts "\"Necro-what? No, this is just a family heirloom. Nothing more.\""
        state put necro-cipher found
        prompt {} {
            {"\"Okay...\"" yes shop}
        }
    }

    proc joeScroll2 {} {
        puts "\"I don't know what certificate you're looking for, but this isn't it.\""
        puts {}
        return shop
    }

    proc joeForce {} {
        puts "\"Alright, you're very persistent. Yes, this is Dr. Cipher's Necromancy\
        Certificate. But you don't understand. I stole it to save everyone. Dr. Cipher's\
        evil plans cannot pass.\""
        prompt {} {
            {"\"I don't believe you.\"" yes {joePlot no}}
            {"\"I'll go confront him right away!\"" yes {joePlot yes}}
        }
    }

    proc joePlot {answer} {
        if {$answer} then {
            puts "Joe's voice suddenly becomes more hoarse."
        } else {
            puts "\"Worth a shot, at least.\""
            puts "Joe's voice suddenly becomes more hoarse."
        }
        puts "\"You know too much. It's time.\""
        puts "Joe lays the scroll out before him. The Certificate rises into the air and\
        hovers just in front of him, as a black aura rises from the ground and encircles\
        Joe."
        puts "\"You know, I planned to study this scroll for a few more months. But\
        now that Dr. Cipher knows I'm here, I have no choice. I summon the spirits\
        of the dead!\""
        puts "Joe begins chanting in Latin, and dark, floating entities rise up from\
        the ground."
        puts {}
        state put necro-cipher rising
        return joeConfront
    }

    proc joeConfront {} {
        puts "The spirits of the dead encircle Joe. As you approach, he ceases chanting\
        briefly."
        if {[state get necro-cipher] eq {help}} then {
            puts "\"Atheena! It was only a matter of time before you tried to stop\
            me. Now I can take care of both of you at once.\""
            prompt {} {
                {"\"Let's do this!\"" yes {::Subspace::Necromancy::boss atheena}}
                {"\"Hold on. I'm not ready.\"" yes shop}
            }
        } else {
            puts "\"You think you can stop me?\""
            prompt {} {
                {"\"I'll fight you!\"" yes {::Subspace::Necromancy::boss no}}
                {"\"Goodbye, now.\"" yes shop}
            }
        }
    }

    proc tacoMan {} {
        switch [state get taco-shop] {
            no {
                puts "\"It's a disaster! How could this happen?!\""
                prompt {} {
                    {"\"What's wrong?\"" yes explain}
                    {"\"Maybe I should come back later...\"" yes shop}
                }
            }
            spoken {
                puts "\"I need an olive! Any olive will do! This entire shop will fail\
                without it!\""
                prompt {} {
                    {"Hand him a Green Olive" {[inv has {Green Olive}]} olive}
                    {"\"I'm sorry.\"" yes shop}
                }
            }
            olive - fed {
                puts "\"Thank you so much! You saved our shop!\""
                prompt {} {
                    {"\"Can I get a super special beef 'n' cheese taco?\"" {([state get attorney-man] eq {talked1}) && ![inv has {Super Taco}]} tacoAttorney}
                    {"\"All in a day's work.\"" yes shop}
                }
            }
        }
    }

    proc tacoAttorney {} {
        puts "\"Ah, but of course! You saved our shop! It's the least I can do!\""
        puts "You got a Super Taco!"
        inv add {Super Taco}
        puts {}
        return shop
    }

    proc explain {} {
        puts "\"An olive! I had an olive! I lost it! Oh, woe is me! What ever shall I do? I'm\
        the Taco Man! How can I show my face in front of my employees if I can't even find this\
        olive?\""
        state put taco-shop spoken
        prompt {} {
            {"Hand him a Green Olive" {[inv has {Green Olive}]} olive}
            {"\"I'm sorry.\"" yes shop}
        }
    }

    proc olive {} {
        puts "The Taco Man takes your Green Olive."
        puts "\"Extraordinary! You've saved us all! Thank you so much! If you ever need a\
        taco made, just say the word and it's yours!\""
        puts {}
        inv remove {Green Olive}
        state put taco-shop olive
        return shop
    }

    proc panicTaco {} {
        puts "\"That man is driving away business with his evil spirits! Someone has to do\
        something!\""
        puts {}
        return shop
    }

    proc panicWoman {} {
        if {[state get guard-soul] eq {yes}} then {
            puts "The woman does not make eye contact with you and does not respond\
            as you greet her."
            puts {}
            return shop
        } else {
            puts "\"What is this guy doing?!\""
            puts {}
            return shop
        }
    }

    proc panicAtheena {} {
        puts "\"It is time to face this threat as a team!\""
        puts {}
        return shop
    }

}
