
namespace eval Subspace::Taco {

    proc shop {} {
        puts "== Subspace Taco Shop =="
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
                    puts " The Taco Man stands behind the counter, smiling. The strange,\
                    hungry man from outside is sitting at one of the tables."
                } else {
                    puts " The Taco Man stands behind the counter, smiling. Joe the Time-Traveler\
                    is sitting at one of the tables."
                }
            }
        }
        prompt {} {
            {"Talk to the bearded man" {[state get taco-shop] eq {no}} tacoMan}
            {"Talk to the Taco Man" {[state get taco-shop] ne {no}} tacoMan}
            {"Talk to the man at the table" {([state get taco-shop] eq {fed}) && ([state get pawn-shop-pass] eq {no})} joe}
            {"Talk to Joe" {([state get taco-shop] eq {fed}) && ([state get pawn-shop-pass] ne {no})} joe}
            {"Talk to the woman" {[state get prison-guard] eq {cleared}} woman}
            {"Head back outside" yes ::Subspace::Hub::hub}
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
            puts {}
            return shop
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
        puts "The manager takes your Green Olive."
        puts "\"Extraordinary! You've saved us all! Thank you so much! If you ever need a\
        taco made, just say the word and it's yours!\""
        puts {}
        inv remove {Green Olive}
        state put taco-shop olive
        return shop
    }

}
