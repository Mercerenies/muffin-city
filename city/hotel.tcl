
namespace eval City::Hotel {

    proc shabbyJack {} {
        puts "== Shabby Jack's =="
        puts -nonewline "The facility is clearly a low-class establishment, but it has a\
        certain rustic charm to it. There is a hallway leading back with a sign that\
        says \"Guests Only\", and behind a wooden counter there is a man with a nametag\
        reading \"Shabby Jack\"."
        if {[state get hunter-trail] in {no visited}} then {
            puts " A man with a cowboy hat and an assault rifle is sitting on a chair\
            in the corner."
        } else {
            puts {}
        }
        prompt {} {
            {"Talk to Shabby Jack" yes shabbyTalk}
            {"Talk to the armed man" {[state get hunter-trail] in {no visited}} shabbyHunter}
            {"Enter your room" {[inv has {Motel Room Key}]} shabbyRoom}
            {"Leave" yes ::City::District::hotel}
        }
    }

    proc shabbyRoom {} {
        puts "== Shabby Jack's - Bedroom =="
        puts -nonewline "The motel room you've been given is very basic, as expected. There is\
        a small bed, with a desk lamp sitting on a desk adjacent to it. You have a\
        connected restroom with a small shower and nothing more."
        if {[state get motel-ghost] eq {visited}} then {
            puts " There is a strange, ethereal entity hovering silently in the back corner."
        } elseif {[state get motel-ghost] eq {motel}} then {
            puts " The ghost haunting this room hovers silently in the corner."
        } else {
            puts {}
        }
        prompt {} {
            {"Go to sleep" yes {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}}
            {"Talk to the entity" {[state get motel-ghost] eq {visited}} shabbyGhostIntro}
            {"Talk to the ghost" {[state get motel-ghost] eq {motel}} shabbyGhost}
            {"Go back out" yes shabbyJack}
        }
    }

    proc shabbyHunter {} {
        puts "\"I been lookin' for a good huntin' spot. If ya know of a forest nearby, let me\
        know!\""
        prompt {} {
            {"\"There's a forest by the prison.\"" {[state get hunter-trail] eq {visited}} shabbyHunter1}
            {"\"Can I have your hat?\"" {[state get pirate-attack] eq {hat1}} shabbyHat}
            {"\"Okay, I will.\"" yes shabbyJack}
        }
    }

    proc shabbyHunter1 {} {
        puts "\"That sounds great! Thanks!\""
        puts "The hunter storms out of the motel."
        puts {}
        state put hunter-trail forest
        return shabbyJack
    }

    proc shabbyHat {} {
        puts "\"My hat? I like my hat!\""
        puts {}
        return shabbyJack
    }

    proc shabbyTalk {} {
        if {[state get motel-room]} then {
            puts "\"Welcome back. Your room is back in the hall to the left.\""
            prompt {} {
                {"\"Thank you.\"" yes shabbyJack}
            }
        } else {
            puts "\"Welcome to Shabby Jack's Streetside Motel! Do you need somewhere to stay for\
            the night? Just one Silver Coin.\""
            prompt {} {
                {"Give him a Silver Coin" {[inv has {Silver Coin}]} shabbyPay}
                {"Show him your Platinum Card" {[inv has {Platinum Card}]} shabbyNoPay}
                {"\"No thank you.\"" yes shabbyJack}
            }
        }
    }

    proc shabbyPay {} {
        inv remove {Silver Coin}
        inv add {Motel Room Key}
        state put motel-room yes
        puts "\"Wonderful! I'll just take that, and here's your room key. You'll be in the first room\
        on the left.\""
        puts "Shabby Jack takes your Silver Coin and gives you a Motel Room Key."
        puts {}
        return shabbyJack
    }

    proc shabbyNoPay {} {
        puts "\"Sorry, no can do. Cash only, here.\""
        puts {}
        return shabbyJack
    }

    proc shabbyGhostIntro {} {
        puts "\"Hm? You can see me? Does that mean you've met the Reaper?\""
        prompt {} {
            {"\"Yeah, he and I are good friends.\"" yes shabbyGhostIntro1}
            {"\"Yeah, he's creepy.\"" yes shabbyGhostIntro1}
        }
    }

    proc shabbyGhostIntro1 {} {
        puts "\"Ah, I see. I've been here for a long time and nobody else can see me.\""
        prompt {} {
            {"\"What's your story?\"" yes shabbyGhostIntro2}
            {"\"Goodbye, now.\"" yes shabbyRoom}
        }
    }

    proc shabbyGhostIntro2 {} {
        state put motel-ghost motel
        puts "\"I fell into the Reaper's pit some time ago. He told me I have unfinished\
        business and allowed me to come back up here. But no one can see me, so I don't\
        know what my business is.\""
        puts {}
        return shabbyGhost
    }

    proc shabbyGhost {} {
        puts "\"Where do you think the Reaper meant for me to go?\""
        # //// If he has completed all of his business, a different reaction here
        prompt {} {
            {"\"Prison.\"" {[state get motel-prison] ne {yes}} {shabbyGhost1 prison}}
            {"\"An island.\"" {[state get motel-warehouse] ne {yes}} {shabbyGhost1 warehouse}}
            {"\"Subspace.\"" {[state get motel-subspace] ne {yes}} {shabbyGhost1 subspace}}
            {"\"Just stay here.\"" yes shabbyRoom}
        }
    }

    proc shabbyGhost1 {location} {
        switch $location {
            prison {
                puts "\"Prison? An interesting choice. But if you think that's where\
                I'm meant to be.\""
                puts "The ghost disappears."
                state put motel-ghost prison
                # ////
                puts {}
                return shabbyRoom
            }
            warehouse {
                puts "\"An island? That does sound like a nice change of scenery.\""
                puts "The ghost disappears."
                state put motel-ghost warehouse
                # ////
                puts {}
                return shabbyRoom
            }
            subspace {
                puts "\"Subspace? I'm not even sure what that is... but I'll try.\""
                puts "The ghost disappears."
                # //// The ghost needs to comment on how hard it was
                # to get there when the player sees him in Subspace
                # //// Also, just this in general
                state put motel-ghost subspace
                puts {}
                return shabbyRoom
            }
        }
    }

    proc ritzyInn {} {
        puts "== Ritzy Inn =="
        puts -nonewline "This is obviously a high-class building. There are several people\
        moving to and fro, all of them dressed in the finest garb. Behind a\
        large \"Guest Services\" counter sits a single man. The bronze nameplate\
        in front of him informs you that his name is Carl."
        if {[state get resolved-todd] ne {no}} then {
            puts " Todd is sitting on one of the sofas in the middle of the lobby."
        } else {
            puts {}
        }
        if {[state get crypto-king] eq {ready}} then {
            puts {}
            puts "As you are glancing about, a man in an incredibly flashy white suit shoves you\
            to the side and demands to check into his room, a demand which Carl immediately\
            satisfies. Without a word, the man storms off to his room, obviously in a hurry."
            state put crypto-king met
        }
        prompt {} {
            {"Talk to Carl" yes ritzyTalk}
            {"Talk to Todd" {[state get resolved-todd] ne {no}} ritzyTodd}
            {"Go toward the hallway" yes ritzyHall}
            {"Leave" yes ::City::District::hotel}
        }
    }

    proc ritzyHall {} {
        puts "== Ritzy Inn - Hallway =="
        puts -nonewline "The hallway stretches on for quite a ways, and there appear to be\
        several floors above this one."
        if {[inv has {Ritzy Inn Room Key}]} then {
            puts {}
        } else {
            puts " Unfortunately, you lack the key to any of the rooms."
        }
        prompt {} {
            {"Go to Room 211" {[inv has {Ritzy Inn Room Key}]} ritzyRoom}
            {"Go to Room 128" {[state get crypto-king] ni {no closer ready met}} ::City::Crypto::firstFloor}
            {"Go to the basement" {[state get heard-science] eq {yes}} ::City::Science::mainRoom}
            {"Go back" yes ritzyInn}
        }
    }

    proc ritzyRoom {} {
        puts "== Ritzy Inn - Bedroom =="
        puts "You enter your prestigious room at the Ritzy Inn & Suites. There is a king-sized\
        bed accompanied by a large sofa and a color television. The adjoining restroom has a\
        large bathtub and a double sink."
        prompt {} {
            {"Go to sleep" yes {::Dream::Transit::awaken ::Dream::Transit::firstRoom}}
            {"Exit the room" yes ritzyHall}
        }
    }

    proc ritzyTalk {} {
        if {[state get inn-room]} then {
            puts "\"Welcome back. How may I be of assistance?\""
        } else {
            puts "\"Good evening. We at the Ritzy Inn & Suites strive for the best possible\
            customer service. How may I be of assistance?\""
        }
        if {[state get crypto-king] eq {no}} then {
            state put crypto-king closer
        }
        prompt {} {
            {"\"I would like a room.\"" {![state get inn-room]} ritzyGetRoom}
            {"\"Who was that man in the white suit?\"" {[state get crypto-king] eq {met}} ritzySuit}
            {"\"The Butler sent me.\"" {[state get heard-science] eq {told}} ritzyTalkScience}
            {"\"Never mind.\"" yes ritzyInn}
        }
    }

    proc ritzyTalkScience {} {
        state put heard-science yes
        puts "\"Ah, yes. Of course. I'll open the way for you. Just go down the hall and take the stairs\
        down to the basement.\""
        puts {}
        return ritzyInn
    }

    proc ritzyGetRoom {} {
        puts "\"In that case, I will need a credit card to have on record.\""
        prompt {} {
            {"Hand him your Platinum Card" {[inv has {Platinum Card}]} ritzyGetRoom1}
            {"\"...Never mind.\"" yes ritzyInn}
        }
    }

    proc ritzyGetRoom1 {} {
        inv add {Ritzy Inn Room Key}
        state put inn-room yes
        puts "Carl takes your Platinum Card and swipes it. After a moment, he hands you back your\
        card, along with a digital card key"
        puts "You got the Ritzy Inn Room Key."
        puts "\"Alright, you will be in Room 211, down the hall and up the stairs. Enjoy your stay\""
        puts {}
        return ritzyInn
    }

    proc ritzySuit {} {
        puts "\"That was Arthur Miles, the most famous cryptanalyst the world over. They\
        say there's no code he can't crack.\""
        prompt {} {
            {"\"What room is he staying in?\"" yes ritzySuit1}
        }
    }

    proc ritzySuit1 {} {
        puts "\"He insisted that he be placed in Room 128. I have no idea why, to be honest.\
        He is quite a character, however. If you go to see him, I suggest you brace yourself.\""
        state put crypto-king met1
        prompt {} {
            {"\"Thank you.\"" yes ritzyInn}
        }
    }

    proc ritzyTodd {} {
        switch [state get talked-to-todd] {
            spoken {
                if {[inv has {Fireproof Suit}]} then {
                    puts "\"Is that a Fireproof Suit? I've been looking\
                    for one of those actually. I'll trade you my Scuba\
                    Suit for your Fireproof Suit.\""
                    state put talked-to-todd {Scuba Suit}
                    prompt {} {
                        {"Trade" yes ritzyTrade}
                        {"\"Your family?\"" yes ritzyFamily}
                        {"\"Later.\"" yes ritzyInn}
                    }
                } else {
                    puts "\"Thank you again for your help!\""
                    prompt {} {
                        {"\"Your family?\"" yes ritzyFamily}
                        {"\"Goodbye.\"" yes ritzyInn}
                    }
                }
            }
            {Scuba Suit} {
                if {[inv has {Fireproof Suit}]} then {
                    puts "\"Want to trade? I'll give you my Scuba Suit for your Fireproof Suit.\""
                    prompt {} {
                        {"Trade" yes ritzyTrade}
                        {"\"Your family?\"" yes ritzyFamily}
                        {"\"Later.\"" yes ritzyInn}
                    }
                } else {
                    puts "\"Thank you again for your help!\""
                    prompt {} {
                        {"\"Your family?\"" yes ritzyFamily}
                        {"\"Goodbye.\"" yes ritzyInn}
                    }
                }
            }
            {Fireproof Suit} {
                if {[inv has {Scuba Suit}]} then {
                    puts "\"Want to trade? I'll give you back your Fireproof Suit for the\
                    Scuba Suit.\""
                    prompt {} {
                        {"Trade" yes ritzyTrade}
                        {"\"Your family?\"" yes ritzyFamily}
                        {"\"Later.\"" yes ritzyInn}
                    }
                } else {
                    puts "\"Thank you again for your help!\""
                    prompt {} {
                        {"\"Your family?\"" yes ritzyFamily}
                        {"\"Goodbye.\"" yes ritzyInn}
                    }
                }
            }
        }
    }

    proc ritzyFamily {} {
        puts "\"Still looking. Carl gave me a few names of people to talk to, so I'm\
        just waiting to hear from them right now. If you hear anything, let me know.\""
        puts {}
        return ritzyInn
    }

    proc ritzyTrade {} {
        switch [state get talked-to-todd] {
            {Scuba Suit} {
                puts "\"Excellent!\""
                puts "You give up your Fireproof Suit and take the Scuba Suit."
                inv remove {Fireproof Suit}
                inv add {Scuba Suit}
                state put talked-to-todd {Fireproof Suit}
                puts {}
                return ritzyInn
            }
            {Fireproof Suit} {
                puts "\"Excellent!\""
                puts "You give up your Scuba Suit and take the Fireproof Suit."
                inv remove {Scuba Suit}
                inv add {Fireproof Suit}
                state put talked-to-todd {Scuba Suit}
                puts {}
                return ritzyInn
            }
            default {
                puts {}
                return ritzyInn
            }
        }
    }

}
