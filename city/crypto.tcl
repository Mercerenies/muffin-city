
namespace eval City::Crypto {

    proc firstFloor {} {
        if {[state get crypto-door] eq {yes}} then {
            return inside
        }
        puts "== Ritzy Inn - First Floor =="
        puts "You approach the door to Arthur Miles' room."
        prompt {} {
            {"Knock on the door" yes knock}
            {"Kick the door in" yes kick}
            {"Go back" yes ::City::Hotel::ritzyHall}
        }
    }

    proc knock {} {
        puts "An obviously annoyed voice answers."
        puts "\"What do you want?\""
        prompt {} {
            {"\"I have a note I need decrypted.\"" {[inv has {Cryptic Note}]} note}
            {"\"To be your friend.\"" yes friend}
            {"\"Never mind.\"" yes firstFloor}
        }
    }

    proc kick {} {
        puts "You kick the door, to no avail."
        puts {}
        return firstFloor
    }

    proc friend {} {
        puts "You don't receive any response."
        puts {}
        return firstFloor
    }

    proc note {} {
        state put crypto-door yes
        puts "The door swings open immediately."
        prompt {} {
            {"Enter the room" yes inside}
        }
    }

    proc inside {} {
        puts "== Ritzy Inn - Room 128 =="
        puts "The lavish room must have cost a fortune. A king-sized bed sits\
        in one corner, next to a large sofa and opposite a large television. A closed door to\
        the side leads, presumably, to a restroom. Arthur Miles is standing by the door with\
        his arms crossed."
        prompt {} {
            {"Talk to Arthur" yes talking}
            {"Exit the area" yes ::City::Hotel::ritzyHall}
        }
    }

    proc talking {} {
        if {[state get crypto-king] eq {met1}} then {
            return intro
        }
        puts "\"What do you want\""
        prompt {} {
            {"\"Have you deciphered the note?\"" {[state get merchant-war] in {crypto1}} deciphered}
            {"\"Goodbye.\"" yes inside}
        }
    }

    proc intro {} {
        puts "Upon closer examination, Arthur is far taller than you. His white suit\
        has coattails that run down to his knees, and he glares down at you impatiently,\
        waiting for you to say something."
        prompt {} {
            {"\"Um, hi.\"" yes introHi}
            {"\"You're Arthur Miles?\"" yes introArt}
            {"\"You can decrypt this?\"" yes introDecrypt}
        }
    }

    proc introHi {} {
        puts "\"Let's dispatch with the pleasantries, shall we? My name is Arthur Miles.\
        Do you have something for me?\""
        prompt {} {
            {"Show him the Cryptic Note" yes introDecrypt}
        }
    }

    proc introArt {} {
        puts "\"Let's dispatch with the pleasantries, shall we? Yes, my name is Arthur Miles.\
        Do you have something for me?\""
        prompt {} {
            {"Show him the Cryptic Note" yes introDecrypt}
        }
    }

    proc introDecrypt {} {
        puts "You show him the Cryptic Note."
        puts "\"Yes, I imagine I could figure this out. Now, my standard rate is 10\
        rubies per hour. I'll need a deposit up-front of 20 rubies.\""
        prompt {} {
            {"\"I don't have that currency.\"" yes introNoCurrency}
            {"\"Where can I get rubies?\"" yes introNoCurrency}
            {"\"I think you're stalling.\"" yes introChicken}
        }
    }

    proc introNoCurrency {} {
        puts "\"Not my problem. Get out of my sight.\""
        prompt {} {
            {"\"I think you're stalling.\"" yes introChicken}
            {"\"Goodbye.\"" yes inside}
        }
    }

    proc introChicken {} {
        puts "\"Stalling? What is that supposed to mean?\""
        prompt {} {
            {"\"You can't really decrypt it, so you're using confusing currency to stall.\"" yes introChicken1}
            {"\"Nothing. Never mind.\"" yes inside}
        }
    }

    proc introChicken1 {} {
        puts "\"Rrrghh... I'll show you. Give me that note!\""
        puts "Arthur takes the Cryptic Note."
        inv remove {Cryptic Note}
        state put crypto-king yes
        state put merchant-war crypto1
        puts "\"It'll take me a bit of time. Come back later.\""
        puts {}
        return inside
    }

    proc deciphered {} {
        if {[state get merchant-war] eq {crypto1}} then {
            puts "\"Not yet. Now get lost.\""
            puts {}
            return inside
        } else {
            # ////
            return -gameover
        }
    }

}
