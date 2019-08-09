
namespace eval Underworld::Abyss {

    proc firstFloor {} {
        puts "== Abyss - First Floor =="
        puts "The lower floor of the platform is nearer the abyss itself.\
        You cannot see anything in the pitch-black abyss. On the lower\
        floor, there are thousands of disembodied souls wandering around,\
        seemingly with no objective in mind. A set of stairs leads back up\
        to the second floor."
        prompt {} {
            {"Go upstairs" yes secondFloor}
            {"Dive into the abyss" yes void}
        }
    }

    proc secondFloor {} {
        puts "== Abyss - Second Floor =="
        puts "A large circular platform overlooks a deep, possibly\
        bottomless pit. There is a set of stairs leading down toward\
        the pit. All around you, several hundred disembodied souls\
        wander blindly, seemingly unaware of your presence or of the\
        presence of any of the other souls. Behind you, a somewhat narrow\
        tunnel forks in two directions."
        prompt {} {
            {"Head toward the tunnel" yes fork}
            {"Go upstairs" yes thirdFloor}
            {"Go downstairs" yes firstFloor}
        }
    }

    proc thirdFloor {} {
        puts "== Abyss - Third Floor =="
        puts -nonewline "Despite being immediately above the other\
        two floors, the third floor emits a feeling of seclusion, as\
        though it is somehow quieter and calmer than the other two.\
        A handful of disembodied souls wander back and forth, ignoring\
        everything around them. The bottomless pit is still visible from\
        this floor, but it seems very far away. "
        if {[state get talked-to-reaper] eq {yes}} then {
            puts "Overlooking the pit, the Reaper sits emotionless\
            in his throne."
        } else {
            puts "Overlooking the pit, a large throne seats a strange\
            faceless shadow which vaguely occupies the form of a human."
        }
        if {[state get motel-ghost] eq {no}} then {
            state put motel-ghost motel
        }
        prompt {} {
            {"Address the shadow being" {[state get talked-to-reaper] eq {no}} reaper}
            {"Talk to the Reaper" {[state get talked-to-reaper] eq {yes}} reaper}
            {"Go downstairs" yes secondFloor}
        }
    }

    proc reaper {} {
        if {[state get reaper-helper] eq {recovered}} then {
            puts "\"It is good to see you again.\""
            prompt {} {
                {"\"What was in that chest?\"" yes reaperFinished}
                {"\"Goodbye.\"" yes thirdFloor}
            }
        } elseif {[state get talked-to-reaper] eq {yes}} then {
            puts "\"Yes?\""
            prompt {} {
                {"\"Did something fall from above recently?\"" {[state get necro-cipher] eq {beaten}} reaperFall}
                {"\"Can I have the Certificate now?\"" {([state get reaper-helper] in {item reset}) && ([state get reaper-has-item] eq {Necromancy Certificate})} reaperRequest}
                {"\"Can I have the Olive now?\"" {([state get reaper-helper] in {item reset}) && ([state get reaper-has-item] eq {Black Olive})} reaperRequest}
                {"\"What am I looking for?\"" {[state get reaper-helper] eq {accepted}} reaperReminder}
                {"Give him the Cursed Chest" {[inv has {Cursed Chest}]} reaperUnlock}
                {"Ask about Steve" {[state get steve-disappeared] eq {gone}} reaperSteve}
                {"\"Never mind.\"" yes thirdFloor}
            }
        } else {
            state put talked-to-reaper yes
            puts "The shadow speaks without moving, in a deep and somber tone."
            puts "\"I am the Reaper, to whom all souls will one day return. What\
            is it you desire?\""
            prompt {} {
                {"\"Did something fall from above recently?\"" {[state get necro-cipher] eq {beaten}} reaperFall}
                {"\"Nothing.\"" yes thirdFloor}
            }
        }
    }

    proc reaperFall {} {
        puts "\"From above? Yes, I see. Two items have fallen from above. Would\
        you like the Necromancy Certificate or the Black Olive?\""
        prompt {} {
            {"\"Can't I have both?\"" yes reaperBoth}
            {"\"The Certificate.\"" yes reaperCertificate}
            {"\"The Black Olive.\"" yes reaperOlive}
            {"\"Let me think about it.\"" yes thirdFloor}
        }
    }

    proc reaperBoth {} {
        puts "\"All things come in good time, child. Now make your choice.\""
        prompt {} {
            {"\"I'll take the Certificate.\"" yes reaperCertificate}
            {"\"I'd like the Olive.\"" yes reaperOlive}
            {"\"Let me think about it.\"" yes thirdFloor}
        }
    }

    proc reaperCertificate {} {
        puts "\"Very well. I believe this Certificate belongs to Dr. Cipher.\
        Please return it to him promptly.\""
        puts "The shadow reaches out with one of its inhuman arms and hands you\
        Dr. Cipher's Certificate."
        puts "You got the Necromancy Certificate."
        inv add {Necromancy Certificate}
        state put reaper-has-item {Black Olive}
        state put reaper-helper item
        state put necro-cipher item
        puts {}
        return thirdFloor
    }

    proc reaperOlive {} {
        # //// The olive doesn't do anything yet
        puts "\"Very well. The Black Olive fell shortly before the Certificate.\
        I do not know its true owner.\""
        puts "The shadow reaches out with one of its inhuman arms and hands you\
        a Black Olive."
        puts "You got a Black Olive."
        inv add {Black Olive}
        state put reaper-has-item {Necromancy Certificate}
        state put reaper-helper item
        state put necro-cipher item
        puts {}
        return thirdFloor
    }

    proc reaperRequest {} {
        if {([state get reaper-helper] eq {reset}) && ([state get butler-game] ni {no cell cell1 pawn pawn1 shabby})} then {
            puts "\"Hm... yes, I believe I have decided. You may have the\
            [state get reaper-has-item], after you do a small favor for me.\""
            prompt {} {
                {"\"I'm listening.\"" yes reaperRequest1}
                {"\"No thanks.\"" yes thirdFloor}
            }
        } else {
            puts "\"In good time, child. In good time.\""
            puts {}
            return thirdFloor
        }
    }

    proc reaperRequest1 {} {
        puts "\"In the depths of subspace, there is a temple. The Ancient Minister of that\
        temple has had an ongoing rivalry with the underworld for some time now. A few\
        centuries ago, he stole something very dear to me. If you can recover this object,\
        then I will return your [state get reaper-has-item].\""
        prompt {} {
            {"\"What sort of item?\"" yes reaperRequest2}
        }
    }

    proc reaperRequest2 {} {
        puts "\"You will find what you are looking for locked in a black chest, surrounded\
        by a cursed aura that eliminates anyone who touches it. With my blessing, you will\
        have the power to bypass this curse. Find the chest and release the lock on it, and\
        I shall return the [state get reaper-has-item].\""
        prompt {} {
            {"\"Consider it done.\"" yes reaperRequest3}
        }
    }

    proc reaperRequest3 {} {
        state put reaper-helper accepted
        state put reaper-blessing yes
        puts "\"Very well. I anticipate your return.\""
        puts {}
        return thirdFloor
    }

    proc reaperReminder {} {
        puts "\"If you can obtain my stolen treasure from the Ancient Minister, I shall\
        return your [state get reaper-has-item].\""
        puts {}
        return thirdFloor
    }

    proc reaperUnlock {} {
        puts "The Reaper rejects the chest."
        puts "\"You must release the lock on the chest and return to me its contents.\""
        puts {}
        return thirdFloor
    }

    proc reaperSteve {} {
        puts "\"Your friend has fallen victim to the curse of my chest. I can feel her\
        presence. Please, speak to Mr. Death. He can revive your friend.\""
        prompt {} {
            {"\"Mr. Death?\"" yes reaperSteve1}
            {"\"Thank you.\"" yes thirdFloor}
        }
    }

    proc reaperSteve1 {} {
        puts "\"You know him as Johnny. He is the one who can revive your friend.\""
        puts {}
        return thirdFloor
    }

    proc reaperFinished {} {
        puts "\"The Reaper before me was in that chest. The Ancient Minister trapped him\
        within it several centuries ago. Now that he has been released, our two spirits\
        have merged into one.\""
        prompt {} {
            {"\"The Reaper before you?\"" yes reaperBefore}
            {"\"Merged into one?\"" yes reaperMerged}
        }
    }

    proc reaperBefore {} {
        puts "\"There have been many Reapers throughout time. We Reapers have inhabited\
        this planet far longer than you humans. When one of us becomes weary, another\
        mortal soul steps up to claim his place. Now that the previous Reaper's soul\
        has been recovered, the misdeed of the Ancient Minister has been set right.\""
        prompt {} {
            {"\"What do you mean by merged?\"" yes reaperMerged1}
        }
    }

    proc reaperBefore1 {} {
        puts "\"There have been many Reapers throughout time. We Reapers have inhabited\
        this planet far longer than you humans. When one of us becomes weary, another\
        mortal soul steps up to claim his place. Now that the previous Reaper's soul\
        has been recovered, the misdeed of the Ancient Minister has been set right.\""
        prompt {} {
            {"\"Do you have something for me?\"" yes reaperReward}
        }
    }

    proc reaperMerged {} {
        puts "\"Our souls have combined. You are now speaking to both of the\
        Reapers you know. With our combined life force, we can continue to\
        maintain this realm for millennia to come. You have our gratitude.\""
        prompt {} {
            {"\"Are there several Reapers?\"" yes reaperBefore1}
        }
    }

    proc reaperMerged1 {} {
        puts "\"Our souls have combined. You are now speaking to both of the\
        Reapers you know. With our combined life force, we can continue to\
        maintain this realm for millennia to come. You have our gratitude.\""
        prompt {} {
            {"\"Do you have something for me?\"" yes reaperReward}
        }
    }

    proc reaperReward {} {
        puts "\"Yes, of course. We promised you the [state get reaper-has-item]\
        for your troubles. As per our word, here you go.\""
        puts "You got the [state get reaper-has-item]!"
        inv add [state get reaper-has-item]
        state put reaper-has-item 0
        state put reaper-helper yes
        puts {}
        return thirdFloor
    }

    proc void {} {
        puts "== Abyss - The Void =="
        puts "The void is pitch black. You can see nothing in any direction. Even looking\
        up, you cannot see the platform from which you dove. You are suddenly feeling very\
        drowsy."
        # //// If you have a lantern, then you'll see something
        # (muffin?) down here
        prompt {} {
            {"Go forward" yes voidDirection}
            {"Go backward" yes voidDirection}
            {"Turn the Lantern on" {[inv has {Lantern}]} voidLight}
            {"Go to sleep" yes voidSleep}
        }
    }

    proc voidDirection {} {
        puts "You wander a bit, but you don't manage to get very far before dropping to the\
        ground and falling asleep."
        puts {}
        return {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}
    }

    proc voidSleep {} {
        puts "Giving in to your more primitive instincts, you decide to take a short nap."
        puts {}
        return {::Dream::Transit::awaken ::Dream::Transit::thirdRoom}
    }

    proc voidLight {} {
        if {[state get lantern-muffin] eq {yes}} then {
            puts "Your Lantern reveals very little, only providing you a small amount of\
            light which shows an empty ground around you."
            prompt {} {
                {"Turn the Lantern back off" yes void}
            }
        } else {
            puts "Your Lantern only lights a small area around you, but even that much\
            is enough to reveal a muffin on the floor at your feet."
            prompt {} {
                {"Take the muffin" yes voidMuffin}
                {"Turn the Lantern back off" yes void}
            }
        }
    }

    proc voidMuffin {} {
        puts "You got the Mango Muffin!"
        state put lantern-muffin yes
        muffin add {Mango Muffin}
        puts {}
        return voidLight
    }

    proc fork {} {
        puts "== Underworld Tunnel - Fork =="
        puts "The tunnel branches off in two directions. To the right, you can see\
        Dr. Cipher's lab and the elevator, but the tunnel is too narrow for you to\
        fit through. The path to the left continues for some time, and behind you is\
        the abyss."
        # //// To the left
        prompt {} {
            {"Go left" yes {::Empty::back ::Underworld::Abyss::fork}}
            {"Approach the abyss" yes secondFloor}
        }
    }

}
