
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
        puts -nonewline "The lavish room must have cost a fortune. A king-sized\
        bed sits in one corner, next to a large sofa and opposite a large\
        television. A closed door to the side leads, presumably, to a restroom."
        switch [state get merchant-war] {
            crypto1 - deciphered {
                puts " Arthur Miles is sitting on the sofa staring intently at a\
                sheet of paper."
            }
            default {
                puts " Arthur Miles is standing by the door with\
                his arms crossed."
            }
        }
        prompt {} {
            {"Talk to Arthur" yes talking}
            {"Exit the area" yes ::City::Hotel::ritzyHall}
        }
    }

    proc talking {} {
        if {[state get crypto-king] eq {met1}} then {
            return intro
        }
        if {[state get merchant-war] eq {deciphered}} then {
            return deciphered
        }
        puts "\"What do you want\""
        prompt {} {
            {"\"Have you deciphered the note?\"" {[state get merchant-war] eq {crypto1}} notDeciphered}
            {"\"Read me the Cryptic Note again.\"" {[state get merchant-war] ni {no noted warehouse crypto crypto1 deciphered}} cryptic}
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

    proc notDeciphered {} {
        puts "\"Not yet. Now get lost.\""
        puts {}
        return inside
    }

    proc deciphered {} {
        puts "\"I've figured out your note.\""
        prompt {} {
            {"\"What does it say?\"" yes deciphered1}
            {"\"Goodbye.\"" yes inside}
        }
    }

    proc deciphered1 {} {
        puts "\"I'll read it.\""
        puts "\"My good friend,"
        puts "\"You were right. It seems the humans were developing a means of replacing\
        me. Fortunately, I stole the key to all of their research and locked it in my\
        office. I also discovered that they developed a special computer chip that\
        would cause me to self-destruct. So I threw that into outer space, where\
        the humans will never recover it. I appreciate your help in eliminating\
        this threat, and I look forward to hearing about your new project soon."
        puts "\"Sincerely, your evil twin.\""
        puts "\"Huh. Can't say I understand what that's talking about. Sorry, but\
        it looks like your quest is hitting a dead end. There's no way you'll be able\
        to get to space. Anyway, if you need to hear the note again, just talk to me.\""
        state put merchant-war chip
        prompt {} {
            {"\"Thank you.\"" yes inside}
        }
    }

    proc cryptic {} {
        puts "\"Here it is.\""
        puts "\"My good friend,"
        puts "\"You were right. It seems the humans were developing a means of replacing\
        me. Fortunately, I stole the key to all of their research and locked it in my\
        office. I also discovered that they developed a special computer chip that\
        would cause me to self-destruct. So I threw that into outer space, where\
        the humans will never recover it. I appreciate your help in eliminating\
        this threat, and I look forward to hearing about your new project soon."
        puts "\"Sincerely, your evil twin.\""
        # //// What's the "new" project?
        prompt {} {
            {"\"Thanks!\"" yes inside}
        }
    }

}
