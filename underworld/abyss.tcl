
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
        # //// Certificate
        if {[state get talked-to-reaper] eq {yes}} then {
            puts "\"Yes?\""
            prompt {} {
                {"\"Did something fall from above recently?\"" {[state get necro-cipher] eq {beaten}} reaperFall}
                {"\"Can I have the Certificate now?\"" {([state get reaper-helper] eq {item}) && ([state get reaper-has-item] eq {Necromancy Certificate})} reaperRequest}
                {"\"Can I have the Olive now?\"" {([state get reaper-helper] eq {item}) && ([state get reaper-has-item] eq {Black Olive})} reaperRequest}
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
        puts "\"In good time, child. In good time.\""
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

    proc fork {} {
        puts "== Underworld Tunnel - Fork =="
        puts "The tunnel branches off in two directions. To the right, you can see\
        Dr. Cipher's lab and the elevator, but the tunnel is too narrow for you to\
        fit through. The path to the left continues for some time, and behind you is\
        the abyss."
        # //// To the left
        prompt {} {
            {"Go left" yes ::Empty::place}
            {"Approach the abyss" yes secondFloor}
        }
    }

}
