
namespace eval Warehouse::Outside {

    proc north {} {
        puts "== Secret Island - North =="
        puts -nonewline "The path leads around the back of the warehouse. There is nothing of\
        interest here except a few trees."
        if {([state get city-thug] eq {island}) &&
            ([state get attorney-man] in {fed 1 2 done complete})} then {
            return northEncounter
        }
        if {[state get city-thug] eq {island}} then {
            puts -nonewline " The man who robbed you back in the city is sitting on a rock down\
            by the sea."
        }
        switch [state get attorney-man] {
            no - met {}
            talked {
                puts -nonewline " Attorney-Man is lying on the ground, seemingly asleep."
            }
            talked1 {
                puts -nonewline " Attorney-Man is lying on the ground, staring up at\
                the sky."
            }
            fed - 1 - 2 - done - complete {
                puts -nonewline " Attorney-Man is standing up, his arms folded, ready to\
                deliver justice."
            }
        }
        puts {}
        # //// What happens if you've completed all the quests and talk to him (state = done)?
        prompt {} {
            {"Head east" yes east}
            {"Head west" yes west}
            {"Talk to the robber" {[state get city-thug] eq {island}} northTalk}
            {"Talk to Attorney-Man" {[state get attorney-man] ni {no met}} northAttorney}
        }
    }

    proc south {} {
        puts "== Secret Island - South =="
        # //// Unlock warehouse from inside
        puts "The southern end of the island contains the entrance to a massive warehouse."
        prompt {} {
            {"Head west" yes west}
            {"Head east" yes east}
            {"Enter the warehouse" yes enterDoor}
        }
    }

    proc east {} {
        puts "== Secret Island - East =="
        puts -nonewline "This edge of the island contains a small dock. You can\
        see the warehouse behind you, but there is no entrance on this side."
        if {[state get merchant-war] eq {no}} then {
            puts " You notice a message scribbled into the wall\
            of the warehouse."
        } else {
            puts " The message scribbled into the warehouse wall\
            is still there."
        }
        prompt {} {
            {"Head south" yes south}
            {"Head north" yes north}
            {"Approach the dock" yes dock}
            {"Read the message" yes eastMessage}
        }
    }

    proc west {} {
        puts "== Secret Island - West =="
        if {[state get fe-coin] eq {no}} then {
            state put fe-coin exists
        }
        puts "The western edge of the island is deserted, aside from a few gulls flying to\
        and fro. There is a large outhouse-like structure with the words \"Freight Elevator\"\
        written on the front."
        prompt {} {
            {"Head north" yes north}
            {"Head south" yes south}
            {"Enter the freight elevator" yes ::Underworld::Pits::freight}
        }
    }

    proc enterDoor {} {
        # //// It may be bolted the second time (check that state)
        if {[inv has {Rusty Warehouse Key}]} then {
            puts "The Rusty Warehouse Key opens the door."
            puts {}
            return ::Warehouse::Inside::warehouseFloor
        } else {
            puts "The warehouse entrance is bolted shut."
            puts {}
            return south
        }
    }

    proc dock {} {
        puts "== Island Dock =="
        if {[state get captain-boat-place] eq {warehouse}} then {
            puts "The dock is small and mostly deserted. A large ship sits in the bay, and\
            its captain waits at the end of the dock."
        } else {
            puts "The dock is small and deserted. It doesn't look like there have been any ships\
            here in some time."
        }
        prompt {} {
            {"Talk to the captain" {[state get captain-boat-place] eq {warehouse}} captain}
            {"Leave the dock" yes east}
            {"Jump into the water" yes diveIn}
        }
    }

    proc captain {} {
        puts "\"Climb aboard!\""
        prompt {} {
            {"Climb aboard" yes captainSail}
            {"\"Not right now.\"" yes dock}
        }
    }

    proc captainSail {} {
        puts "\"And we're off.\""
        puts "The captain hoists the anchor out of the bay and sets sail."
        puts {}
        puts "Some time later, you arrive in an ethereal plane."
        state put captain-boat-place dream
        puts {}
        return {::Dream::World::pier 1}
    }

    proc diveIn {} {
        if {[inv has {Scuba Suit}]} then {
            puts "You don your Scuba Suit and leap into the water."
            puts {}
            return ::Warehouse::Undersea::undersea
        } else {
            puts "You leap into the water without a second thought."
            if {[state get lobby-door] ne {yes}} then {
                state put lobby-door other
            }
            puts {}
            return ::Underworld::Lobby::other
        }
    }

    proc northTalk {} {
        puts "\"Huh?! Ya found me?! Well yer good, I'll give ya that. Here, have yer\
        [state get stolen-good] back and leave me alone!\""
        puts "The robber hands you your [state get stolen-good] and runs off."
        puts {}
        inv add [state get stolen-good]
        state put stolen-good {}
        state put city-thug no
        return north
    }

    proc northAttorney {} {
        switch [state get attorney-man] {
            no - met {}
            talked {
                puts "Attorney-Man jerks awake when you say his name."
                puts "\"Aha! Justice awaits! But... I'm so hungry... I can't\
                enact the trademarked Attorney-Man fist of justice without eating\
                a super special beef 'n' cheese taco first!\""
                state put attorney-man talked1
                prompt {} {
                    {"\"I see...\"" yes north}
                }
            }
            talked1 {
                puts "\"My fist of justice must be fed. A super special beef 'n' cheese\
                taco would do. But where could I possibly get one?\""
                prompt {} {
                    {"Give him a Super Taco" {[inv has {Super Taco}]} northFood}
                    {"\"Good question...\"" yes north}
                }
            }
            fed - 1 - 2 {
                puts "\"Let me know if you know of any cases I could take on.\""
                prompt {} {
                    {"\"You could represent me.\"" {[state get attorney-self] eq {no}} northSelf}
                    {"\"There's a madman raising the dead. Can you stop him?\"" {[state get necro-cipher] in {rising help}} northCrazy}
                    {"\"Okay.\"" yes north}
                }
            }
            done {
                # ////
                return -gameover
            }
            complete {
                # ////
                return -gameover
            }
        }
    }

    proc northSelf {} {
        puts "\"Ah, an excellent idea! I can repay my debt for the taco in the form of\
        true justice! If you are ever in a trial, just give me a call!\""
        state put attorney-self okay
        puts {}
        return north
    }

    proc northFood {} {
        puts "You hand Attorney-Man a Super Taco."
        inv remove {Super Taco}
        state put attorney-man fed
        puts "\"Ahhhh! Perfect! If you ever have anyone in need of a lawyer, let me\
        know!\""
        puts {}
        return north
    }

    proc northEncounter {} {
        puts {}
        puts "Attorney-Man and the robber from the city are both here. Attorney-Man approaches\
        the robber with his usual flamboyant attitude and begins preaching to him about justice."
        puts "\"Okay! Fine! I'll give it back! Ya hear! I'm givin' it back!\""
        puts "The robber tosses your [state get stolen-good] at you."
        puts "You got a [state get stolen-good]!"
        puts "\"Excellent! Justice has been served! Now go confess to your crimes, and\
        Attorney-Man will be there to defend your honor!\""
        puts "The robber runs off."
        inv add [state get stolen-good]
        state put stolen-good {}
        state put city-thug no
        if {[state get attorney-thug] eq {no}} then {
            state put attorney-thug yes
            state put attorney-man [switch [state get attorney-man] {
                fed 1
                1 2
                2 done
            }]
        }
        prompt {} {
            {"\"Thank you.\"" yes north}
        }
    }

    proc northCrazy {} {
        puts "\"Raising the dead? Aha, another case for Attorney-Man! If you can bring this\
        man to justice, I will see to it that he receives the maximum sentence!\""
        prompt {} {
            {"\"Will you help me fight him?\"" yes northCrazy1}
            {"\"I'll do that.\"" yes north}
        }
    }

    proc northCrazy1 {} {
        puts "\"The Attorney-Man fist of justice is not a tool for violence! It is a tool\
        for justice in the courtroom!\""
        prompt {} {
            {"\"Okay.\"" yes north}
        }
    }

    proc eastMessage {} {
        puts "\"I am being enslaved by a sociopath to do his bidding. I have left this\
        message in the hopes that someone can put an end to his madness. If you have\
        the power to save me, then I have left a tool to aid you. Look beneath the\
        largest tree in the forest to find the tool. And please hurry.\""
        if {[state get merchant-war] eq {no}} then {
            state put merchant-war noted
        }
        puts {}
        return east
    }

}
