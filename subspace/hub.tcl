
namespace eval Subspace::Hub {

    # ///// Need a way out of here

    proc hub {} {
        puts "== Subspace Hub =="
        puts -nonewline "The white void extends indefinitely in all directions. To the north,\
        there is an unnatural storm containing some sort of energy. To the east, there is\
        an enclosed room containing a projector and some other equipment. To the south, there is\
        a taco shop and a bank."
        if {[state get subspace-attic] eq {yes}} then {
            puts -nonewline " A set of stairs hangs down from above, leading to an\
            unusual floating room in the sky."
        }
        switch [state get taco-shop] {
            no - spoken - olive {
                set joe yes
                puts -nonewline " A strange man is sitting in the corner, with his arms wrapped\
                around his knees."
            }
        }
        puts {}
        prompt {} {
            {"Talk to the unusual man" {[state get taco-shop] in {no spoken olive}} hubJoe}
            {"Enter the taco shop" yes tacoShop}
            {"Enter the bank" yes bank}
            {"Go upstairs" {[state get subspace-attic] eq {yes}} attic}
            {"Head toward the storm" yes storm}
            {"Head to the projection room" yes portalRoom}
        }
    }

    proc hubJoe {} {
        puts "\"So hungry...\""
        prompt {} {
            {"\"Why don't you go get a taco?\"" yes hubJoeTaco}
            {"\"I'm sorry.\"" yes hub}
        }
    }

    proc hubJoeTaco {} {
        if {[state get taco-shop] in {no spoken}} then {
            puts "\"The Taco Man won't serve tacos right now... something about\
            not having some ingredients.\""
            puts {}
            return hub
        } else {
            puts "\"Huh? The Taco Man has his olive now? Alright, that's a good idea.\""
            puts "The strange man heads toward the taco shop."
            puts {}
            state put taco-shop fed
            return hub
        }
    }

    proc tacoShop {} {
        puts "== Subspace Taco Shop =="
        puts -nonewline "The pleasant aroma of tacos is a refreshing break from the\
        emptiness of the remainder of subspace."
        switch [state get taco-shop] {
            no {
                puts " An older, bearded man behind the counter is panicking and looking\
                for something."
            }
            spoken {
                puts " The manager is still frantically running about behind the counter."
            }
            olive {
                puts " The manager stands behind the counter, smiling."
            }
            fed {
                if {[state get pawn-shop-pass] eq {no}} then {
                    puts " The manager stands behind the counter, smiling. The strange, hungry man\
                    from outside is sitting at one of the tables."
                } else {
                    puts " The manager stands behind the counter, smiling. Joe the Time-Traveler\
                    is sitting at one of the tables."
                }
            }
        }
        # ////
        prompt {} {
            {"Talk to the bearded man" {[state get taco-shop] eq {no}} tacoMan}
            {"Talk to the Taco Man" {[state get taco-shop] ne {no}} tacoMan}
            {"Talk to the man at the table" {([state get taco-shop] eq {fed}) && (![state get pawn-shop-pass])} tacoJoe}
            {"Talk to Joe" {([state get taco-shop] eq {fed}) && ([state get pawn-shop-pass])} tacoJoe}
            {"Head back outside" yes hub}
        }
    }

    proc tacoJoe {} {
        if {[state get pawn-shop-pass]} then {
            puts "\"Remember, the pawn shop password is 'bowling tournament'. I traveled back in\
            time to tell my past self the password. That's how I ended up here. Hopefully, you'll\
            be able to make more use of the password.\""
            puts {}
            return tacoShop
        } else {
            puts "\"I don't think we've formally been introduced. I'm Joe. Joe the Time-Traveler.\""
            prompt {} {
                {"\"Good to meet you.\"" yes tacoJoe1}
            }
        }
    }

    proc tacoJoe1 {} {
        puts "\"Likewise. Hey, listen, the Taco Man says you helped him get back on his feet.\
        As thanks, I'll give you a little tip. The pawn shop in the shopping district\
        is never really closed. If the door is locked, just tell him the password\
        is 'bowling tournament'. He'll let you in.\""
        state put pawn-shop-pass yes
        puts {}
        return tacoShop
    }

    proc tacoMan {} {
        switch [state get taco-shop] {
            no {
                puts "\"It's a disaster! How could this happen?!\""
                prompt {} {
                    {"\"What's wrong?\"" yes tacoExplain}
                    {"\"Maybe I should come back later...\"" yes tacoShop}
                }
            }
            spoken {
                puts "\"I need an olive! Any olive will do! This entire shop will fail\
                without it!\""
                prompt {} {
                    {"Hand him a Green Olive" {[inv has {Green Olive}]} tacoOlive}
                    {"\"I'm sorry.\"" yes tacoShop}
                }
            }
            olive - fed {
                puts "\"Thank you so much! You saved our shop!\""
                prompt {} {
                    {"\"All in a day's work.\"" yes tacoShop}
                }
            }
        }
    }

    proc tacoExplain {} {
        puts "\"An olive! I had an olive! I lost it! Oh, woe is me! What ever shall I do? I'm\
        the Taco Man! How can I show my face in front of my employees if I can't even find this\
        olive?\""
        state put taco-shop spoken
        prompt {} {
            {"Hand him a Green Olive" {[inv has {Green Olive}]} tacoOlive}
            {"\"I'm sorry.\"" yes tacoShop}
        }
    }

    proc tacoOlive {} {
        puts "The manager takes your Green Olive."
        puts "\"Extraordinary! You've saved us all! Thank you so much! If you ever need a\
        taco made, just say the word and it's yours!\""
        puts {}
        inv remove {Green Olive}
        state put taco-shop olive
        return tacoShop
    }

    proc bank {} {
        puts "== Subspace Bank =="
        puts "The bank is very orderly, with neat rows of seats for waiting\
        customers."
        # ////
        prompt {} {
            {"Head back outside" yes hub}
        }
    }

    proc portalRoom {} {
        puts "== Subspace Projection Room =="
        puts "The projector sits in the middle of the room and appears to currently be\
        inactive."
        # ////
        prompt {} {
            {"Head back to the hub" yes hub}
        }
    }

    proc storm {} {
        puts "== Subspace Storm =="
        puts "The storm rages on in all directions. It would be very easy to get lost in an\
        area like this."
        prompt {} {
            {"Head north" yes hub}
            {"Head west" yes hub}
            {"Head south" yes hub}
            {"Head east" yes hub}
        }
    }

    proc attic {} {
        puts "== Subspace Attic =="
        if {[state get subspace-attic] eq {no}} then {
            puts "You find yourself in a featureless white room. There are stairs leading up through\
            the ceiling, and a set of retracted stairs in the base of the floor. The retracted\
            stairs appear to be expandable if you were to press on them."
        } else {
            puts "You find yourself in a featureless white room. There is a set of stairs leading\
            up through the ceiling and a second set leading down through the floor."
        }
        prompt {} {
            {"Go upstairs" yes ::Underworld::Pits::secretRoom}
            {"Expand the stairs" {[state get subspace-attic] eq {no}} atticExpand}
            {"Go downstairs" {[state get subspace-attic] eq {yes}} hub}
        }
    }

    proc atticExpand {} {
        puts "You push the retracted staircase downward and it expands."
        puts {}
        state put subspace-attic yes
        return attic
    }

}
