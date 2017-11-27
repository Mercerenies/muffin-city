
namespace eval City::Hotel {

    proc shabbyJack {} {
        puts "== Shabby Jack's =="
        puts "The facility is clearly a low-class establishment, but it has a certain rustic charm\
        to it. There is a hallway leading back with a sign that says \"Guests Only\", and behind\
        a wooden counter there is a man with a nametag reading \"Shabby Jack\"."
        prompt {} {
            {"Talk to Shabby Jack" yes shabbyTalk}
            {"Enter your room" {[inv has {Motel Room Key}]} shabbyRoom}
            {"Leave" yes ::City::District::hotel}
        }
    }

    proc shabbyRoom {} {
        puts "== Shabby Jack's - Bedroom =="
        puts "The motel room you've been given is very basic, as expected. There is a small bed, with a\
        desk lamp sitting on a desk adjacent to it. You have a connected restroom with a small shower and\
        nothing more."
        prompt {} {
            {"Go to sleep" yes {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}}
            {"Go back out" yes shabbyJack}
        }
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

    proc ritzyInn {} {
        puts "== Ritzy Inn =="
        puts "This is obviously a high-class building. There are several people moving to and fro,\
        all of them dressed in the finest garb. Behind a large \"Guest Services\" counter sits a\
        single man. The bronze nameplate in front of him informs you that his name is Carl."
        prompt {} {
            {"Talk to Carl" yes ritzyTalk}
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
        prompt {} {
            {"\"I would like a room.\"" {![state get inn-room]} ritzyGetRoom}
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

}
